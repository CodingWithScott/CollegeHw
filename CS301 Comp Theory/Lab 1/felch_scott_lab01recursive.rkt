#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSCI 301
;; Fall 2013
;;
;; Lab #1
;;
;; Scott Felch
;; W00750298
;;
;; The purpose of this program is to
;; show I know how to write, run, and
;; submit a Scheme program.
;; 
;; It will print out my name n times using a recursive procedure.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(display "Hello Scott, you genius!")
(newline)
(display "I wish I dressed as wonderfully as you!")
(newline)
(display "Let's write a program now.")
(newline)
(display "Please enter how many times you'd like your name to be displayed.")

(define n 0)                              ; How many times to print the name, called "n", 
                                          ; assigned value 0 by default

(define (printName n)
      (if (> n 1)                        ; Conditional check, is this the last iteration?
          (begin                          ; Do this if true, everything in "begin" statement
            (displayln "Scott Felch")     ; Print my name then call recursive call with n-1
            (printName (- n 1)))
          (display "Scott Felch")))       ; Do this if false, just print name
  
          
          


;      (if (eqv? numTimes 0) (display "Scott Felch") (printName(- numTimes 1)))