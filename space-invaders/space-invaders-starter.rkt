;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; The Game Space Invaders

;; Constants:
;; ==========

;; empty scene information
(define WIDTH  300)
(define HEIGHT 500)
(define BACKGROUND (empty-scene WIDTH HEIGHT))

;; speed of moving bodies in the game
(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

;; moving bodies information
(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer
(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body
(define TANK-HEIGHT/2 (/ (image-height TANK) 2))
(define MISSILE (ellipse 5 15 "solid" "red"))

;; other
(define HIT-RANGE 10)
(define INVADE-RATE 100)

;; Data Definitions:
;; =================

;; game
(define-struct game (invaders missiles tank))
;; Game is (make-game  (listof Invader) (listof Missile) Tank)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position
 
#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom (game-missiles s))
       (fn-for-tank (game-tank s))))

;; tank
(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left

#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dir t)))

;; invader
(define-struct invader (x y dx))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         the invader along x by dx pixels per clock tick

(define I1 (make-invader 150 100 12))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -10))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) 10)) ;> landed, moving right
(define I4 (make-invader WIDTH (+ HEIGHT 10) -10)) ;> landed, moving right

#;
(define (fn-for-invader invader)
  (...
   (invader-x invader)(invader-y invader)(invader-dx invader)))

;; missile
(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                                ;not hit U1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))   ;exactly hit U1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))   ;> hit U1

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))

(define G0 (make-game empty empty T0))
(define G1 (make-game empty empty T1))
(define G2 (make-game (list I1) (list M1) T1))
(define G3 (make-game (list I1 I2) (list M1 M2) T1))

;; Functions
;; =========
(define (main g)
  (big-bang g
    (on-tick next-game)        ;; Game -> Game
    (to-draw render-game)      ;; Game -> Game
    (on-key change-activity)   ;; Game KeyEvent -> Game
    (stop-when game-over)))    ;; Game -> MTS

;; Produces Game with its new position
;; Game -> Game
(check-expect (next-game G0)
              (make-game
               (next-invaders (game-invaders G0))
               (next-missiles (game-missiles G0))
               (game-tank G0)))

(check-expect (next-game G1)
              (make-game
               (next-invaders (game-invaders G1))
               (next-missiles (game-missiles G1))
               (game-tank G1)))

;; (define (next-game G0) G0) ;stub

;; Template taken from game function
(define (next-game g)
  (make-game
   (next-invaders (game-invaders g))
   (next-missiles (game-missiles g))
   (game-tank g)))

;; Produces list of invaders with new x and y position
;; ListOfInvaders -> ListOfInvaders
(check-expect (next-invaders (list I1)) 
              (list (make-invader
                     (+ (invader-x I1) INVADER-X-SPEED) 
                     (+ (invader-y I1) INVADER-Y-SPEED) (invader-dx I1)) empty))

(check-expect (next-invaders (list I1 I2 I4))
              (list (make-invader
                     (+ (invader-x I1) INVADER-X-SPEED) 
                     (+ (invader-y I1) INVADER-Y-SPEED) (invader-dx I1)) empty))
                    
;; (define (next-invaders loi) loi) ;stub
(define (next-invaders loi)
  (cond [(empty? loi) empty]
        [else
         (cons (render-invader (first loi))
                (next-invaders (rest loi)))]))

;; Renders invader
;; Invader -> Invader
(check-expect (render-invader I1)
              (make-invader (+ (invader-x I1) INVADER-X-SPEED) (+ (invader-y I1) INVADER-Y-SPEED) 12))
(check-expect (render-invader I2) empty)
(check-expect (render-invader (make-invader WIDTH 150 -10))
              (make-invader (+ WIDTH (- INVADER-X-SPEED)) (+ 150 INVADER-Y-SPEED) -10)) 

;; (define (render-invader i) i) ;stub

;; (define I4 (make-invader WIDTH (+ HEIGHT 10) -10)) ;> landed, moving right

;; Template took from invader
(define (render-invader i)
  (cond[(>= (invader-y i) HEIGHT) empty]
       [(< (invader-x i) WIDTH) (make-invader (+ (invader-x i) INVADER-X-SPEED) (+ (invader-y i) INVADER-Y-SPEED) (invader-dx i))]       
       [(>= (invader-x i) WIDTH) (make-invader (+ (invader-x i) (- INVADER-X-SPEED)) (+ (invader-y i) INVADER-Y-SPEED) (invader-dx i))]))

;; Produces list of missiles with new y position
;; ListOfMissiles -> ListOfMissiles
;; !!!
(define (next-missiles lom) lom) ;stub

;; Produces images within the game type
;; Game -> Game 
;; !!!
(define (render-game g) g) ;stub

;; Changes activity based on the key input
;; Game KeyEvent -> Game
;; !!!
(define (change-activity g) g)

;; Stops the game when the invader reaches the end
;; Game -> MTS
;; !!!
(define (game-over g) g) 