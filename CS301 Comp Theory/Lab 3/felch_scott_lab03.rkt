#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSCI 301
;; Fall 2013
;;
;; Lab #3
;;
;; Scott Felch
;; W00750298
;;
;; The purpose of this program is to check if a number is perfect by 
;; generating all the proper positive divisors of the number, then
;; adding up all the numbers in that list, and checking for equality.
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Main part of program. Check for Perfect Number status by computing if sum(divisorlist) == n.
(define (checkperfection n)
  (if (equal? n (sum(makelist n (- n 1))))                     ; Condition check. 
                                                               ; Make the list, start with 
                                                               ; possible_divisor == n-1
    (display "You found a perfect number!!")                   ; If true, do this
    (display "Not perfect. Bummer... Euclid is crying.")))     ; Else, do this

; Step 1: Make a list of positive divisors. Accept a start 
; number (will be n-1 at beginning of program, decrements down from there) 
; and check if (n % possible_divisor) returns true.
(define (makelist n possible_divisor)
 (if (< possible_divisor 1)                  ; Base case, don't need to check negative divisors.
     '()                                     ; If possible_divisor is still valid, continue to make list.
     (if (divisible n possible_divisor)
      (cons possible_divisor (makelist n (- possible_divisor 1))) ; If divisible then add to list
      (makelist n (- possible_divisor 1)))))                      ; Else don't do anything

; Step 2: Accept the integer and a number which may be a divisor of 
; it, return true/false.
(define (divisible n possible_divisor)
  (if (equal? (modulo n possible_divisor) 0) 
      #t   ; Return true if evenly divides
      #f)) ; Else return false

; Helper function for summing the list. Same source as above.
; Blatantly plagiarized from a Racket tuturial at: 
; http://courses.cs.washington.edu/courses/cse341/12au/racket/basics.html
(define (sum xs)
  (if (null? xs) 
      0
      (+ (car xs) (sum (cdr xs)))))