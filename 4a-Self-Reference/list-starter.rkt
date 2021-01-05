;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

empty ;; create list with this

(define L1 (cons "Flames" empty))                  ; a list of 1 element
(define L2 (const "Leafs" (cons "flames" empty)))  ; a list of 2 elements
(define L3 (cons (square 10 "solid" "blue")
      (cons (triangle 20 "solid" "green")
            empty)))                               

;; list values use cons notation

(cons (string-append "C" "anucks") empty)

(cons 10 (const 9 (cons 10 empty)))   ; a list of 3 elements


cons   =>  a two argument constructor
first  =>  selects the first element of a list
rest   =>  selects the rest of the elements in a list

(first L1)
(first L2)
(first L3)

(rest L1)
(rest L2)
(rest L3)

(first (rest L2))        ;; Gives the second element in the list
(first (rest (rest L2))) ;; Gives the third element in the list


;; (empty) produces true if argument is the empty list
(empty? empty)
(empty? L1) 
