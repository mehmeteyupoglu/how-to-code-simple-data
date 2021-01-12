;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname flying-rocket) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; Constants:
;; =========

(define WIDTH 500)
(define HEIGHT (/ WIDTH 2))
(define MTS (empty-scene WIDTH HEIGHT))
(define ROCKET (rectangle 10 50 "solid" "black"))
(define SPEED 10)

;; Data Definitions:
;; =================

(define-struct flying-rocket (x y r))
;; FlyingRocket is (make Number Number Number)
;;                  x is the horizontal position of the rocket
;;                  y is the vertical position of the rocket
;;                  r is the rotation of the rocket

(define FR1 (make-flying-rocket 0 0 0))
(define FR2 (make-flying-rocket 20 50 20))
(define FR3 (make-flying-rocket 50 100 20))

#;
(define (fn-for-fr f)
  (... (flying-rocket-x f)     ;Number
       (flying-rocket-y f)     ;Number
       (flying-rocket-r f)))   ;Number

;; Template rules used:
;;  - compound: 3 fields used
;;  - x  -> Number
;;  - y  -> Number
;;  - r  -> Number

;; Functions:
;; ==========

(define (main f)
  (big-bang f
    (on-tick next-rocket)     ; FlyingRocket -> FlyingRocket
    (to-draw render-rocket))) ; FlyingRocket -> Image

;; FlyingRocket -> FlyingRocket
;; Produces the next flying rocket with updated x y r values
(check-expect (next-rocket (make-flying-rocket 0 0 20))
              (make-flying-rocket (+ 0 SPEED) (- 0 SPEED SPEED) (modulo (+ 20 SPEED) 360)))
(check-expect (next-rocket (make-flying-rocket 20 500 30))
              (make-flying-rocket (+ 20 SPEED) (- 500 SPEED SPEED) (modulo (+ 30 SPEED) 360))) 
               
;;(define (next-rocket f) f) ;stub


;; Took template from FlyingRocket

(define (next-rocket f)
  (make-flying-rocket
   (+ (flying-rocket-x f) SPEED)    
   (+ (flying-rocket-y f) SPEED SPEED)     ;Number
   (+ (flying-rocket-r f) SPEED)))         ;Number


;; FlyingRocket -> Image
;; Create images based on the flying rocket information
(check-expect (render-rocket (make-rocket 0 0 0))
              (place-image (rotate 0 ROCKET) 0 0 MTS))
(check-expect (render-rocket (make-rocket 250 500 0))
              (place-image (rotate 0 ROCKET) 250 500 MTS))
(check-expect (render-rocket (make-rocket 50 300 50))
              (place-image (rotate 50 ROCKET) 50 300 MTS))

(define (render-rocket f)
  (place-image
   (rotate (flying-rocket-r f) ROCKET)
   (/ WIDTH 2) HEIGHT MTS))


;; (define (render-rocket f) MTS) ;stub
    
