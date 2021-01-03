;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ufo-landing) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;constants
(define WIDTH 300)
(define HEIGHT 600)
(define MTSCN (rectangle WIDTH HEIGHT "solid" "dark blue"))
(define UFO (overlay (circle 10 "solid" "green")
	 (rectangle 40 4 "solid" "green")))
(define UFO-CENTER-TO-TOP (- HEIGHT (/ (image-height UFO) 2)))
(define CTR-X (/ WIDTH 2))

;functions
(define (picture-of-ufo h)
  (cond
    [(<= h UFO-CENTER-TO-TOP)
     (place-image UFO CTR-X h MTSCN)]
    [(> h UFO-CENTER-TO-TOP)
     (place-image UFO CTR-X UFO-CENTER-TO-TOP MTSCN)]))

(picture-of-ufo 200)