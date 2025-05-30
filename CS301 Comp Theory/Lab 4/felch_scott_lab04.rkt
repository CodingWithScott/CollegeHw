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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Original function the user calls, will then call internal guts procedure
; using the number inputted by user and an initial list of number-words which
; will be decremented.
(define (number-name num)
  (num-guts num  '(list " tredecillion "
         " duodecillion " 
         " undecillion "
         " decillion "
         " nonillion "
         " octillion "
         " septillion "
         " sextillion "
         " quintillion " 
         " quadrillion "
         " trillion " 
         " billion " 
         " million " 
         " thousand "
         " hundred ")))

; Constructs list to output to screen list of number-words (being depleted) and list of words to output (being
; constructed). Will call (most-significant) to add the first 1-3 digits of the 
; number to the list I'm building, then add the top of the list of the number-words, 
; and then divide num by 1000 and call itself to keep doing this, until number-words 
; list and num are depleted. 


; Num-guts accepts the number being decremented and the list of digits/words being built up
(define (num-guts num num-words) ; Can take out num-words if I just have a big if statement for every iteration
  (cond ((equal? num (most-significant num)) ; If num contains nothing left but the 1-3 most significant bits then
                                             ; just print out the list that's been built and you're done. 
    (display (most-significant num) (car num-words) (num-guts (/ num 1000) (cdr num-words))))
    ; Else keep constructing the list with the first 1-3 digits, the front of the number-words list, and 
    ; recursively call num-guts by dividing num by 1000 to keep breaking it down.
    (else (cons ((most-significant num) (car num-words) (num-guts (/ num 1000)) (cdr num-words))))))




                                   
; Pseduo code-ish, doesn't work yet. Returns the first 1-3 digits of num, so that can 
; divided by 1000 by the calling function.
(define (most-significant num)
  (cond 
    ((<= num 100)                            ; Base case: If 0 <= num <= 100 then just return the number.
     num
    ((> num 100)                             ; Else: if number is >100 then break off 3 least significant digits,
      (most-significant(modulo num 100)))))) ; recursive call to do it again until get only first 1-3 digits
                                             ; remaining.
    