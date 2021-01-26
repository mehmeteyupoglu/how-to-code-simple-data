;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname list-abbreviations) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define L1 (list "a" "b"))
(define L2 (list "d" "e" "f"))

(append L1 L2)

(append (cons 1 (cons 4 empty)) (list "b" "c"))