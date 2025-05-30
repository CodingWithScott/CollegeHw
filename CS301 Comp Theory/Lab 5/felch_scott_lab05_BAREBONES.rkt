#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Scott Felch
;; W00750298
;; CSCI 301, Fall 2013
;; Lab #4/5
;;
;; Lab 4
;; I will write a procedure to break up a big number into its 
;; its three-digit pieces (use quotient and remainder). Note that if 
;; any slot is a zero, both it and its name are omitted.
;; 
;; Example: 
;; > (number-name 5513345)
;; (five million five hundred thirteen thousand three hundred forty five)
;; 
;; > (number-name (factorial 20))
;; (two quintillion four hundred thirty two quadrillion nine hundred two
;; trillion eight billion one hundred seventy six million six hundred
;;
;; Lab 5 (not yet implemented, builds off Lab 4)
;; This lab has two parts. First, write a procedure name<1000 that
;; converts a number less than 1000 into words. Note that zero 
;; only shows up if the whole number is zero.
;;
;; Then, implement that functionality into Lab 4. 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function that will accept a number smaller than 1000 and print out the word
; version of it. Calls helper functions chunk1, chunk2, and chunk3.
(define (name<1000 num)
  (list (chunk1 num) (chunk2 num)))

; Prints out the word from the 100s place followed by the word "hundred" 
(define (chunk1 num)
  (list (chunk3 (quotient num 100)) 'hundred))
  
; Return the word of 10s place of the number, then calls chunk1 to return word of 
; 1s place, unless between 10-19 then special case to print ten, eleven, twelve, etc. 
(define (chunk2 num)
  (cond ((> (remainder num 100) 90)
         (list 'ninety (chunk3 num)))
        ((> (remainder num 100) 80)
         (cons 'eighty (chunk3 num)))
        ((> (remainder num 100) 70)
         (cons 'seventy (chunk3 num)))
        ((> (remainder num 100) 60)
         (cons 'sixty (chunk3 num)))
        ((> (remainder num 100) 50)
         (cons 'fifty (chunk3 num)))
        ((> (remainder num 100) 40)
         (cons 'fourty (chunk3 num)))
        ((> (remainder num 100) 30)
         (cons 'thirty (chunk3 num)))
        ((> (remainder num 100) 20)
         (cons 'twenty (chunk3 num)))
        ((equal? (remainder num 100) 19)
         'nineteen)
        ((equal? (remainder num 100) 18)
         'eighteen)
        ((equal? (remainder num 100) 17)
         'seventeen)
        ((equal? (remainder num 100) 16)
         'sixteen)
        ((equal? (remainder num 100) 15)
         'fifteen)
        ((equal? (remainder num 100) 14)
         'fourteen)
        ((equal? (remainder num 100) 13)
         'thirteen)
        ((equal? (remainder num 100) 12)
         'twelve)
        ((equal? (remainder num 100) 11)
         'eleven)
        ((equal? (remainder num 100) 10)
         'ten)))
   
; Return the 1s place of the number, unless 1s place is a 0 then return nothing.
(define (chunk3 num)
  (cond ((equal? (remainder num 10) 1)
      'one)
      ((equal? (remainder num 10) 2)
      'two)
      ((equal? (remainder num 10) 3)
      'three)
      ((equal? (remainder num 10) 4)
      'four)
      ((equal? (remainder num 10) 5)
      'five)
      ((equal? (remainder num 10) 6)
      'six)
      ((equal? (remainder num 10) 7)
      'seven)
      ((equal? (remainder num 10) 8)
      'eight)
      ((equal? (remainder num 10) 9)
      'nine)
      ((equal? (remainder num 10) 0)
      '"")))