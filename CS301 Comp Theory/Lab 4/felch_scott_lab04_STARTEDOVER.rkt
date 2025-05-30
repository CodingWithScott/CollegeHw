#lang racket

;; Started over fresh Fri evening


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
  (display (make-big-list (make-num-list num)  
             (list "" "thousand" "million" "billion" "trillion" "quadrillion" "quintillion" "sextillion" "septillion" "octillion" "nonillion" 
              "decillion" "undecillion" "duodecillion" "tredecillion"))))

; Helper function that will THEORETICALLY display the contents of individual items of a list instead
; of puking out nightmares of parans and periods everywhere. 
; In actuality though it doesn't work, still prints things just as badly as original. 
(define (disp-conts input)
  (cond ((list? input)                        ; If input is a list enter next if statement
         (cond ((empty? input) "")                  ; If it's an empty list then just do nothing
             (display (car input))                  ; If it's not empty, display front of list and recurse call with rest of list
             (disp-conts (cdr input))
         (else                                ; If input is not a list just display input
          (display input))))))
         
; Take num and break it up into chunks of 3, and put in a list. Ex: 123456789 becomes
; 789 456 123. Arguments is the initial number.
(define (make-num-list num)
  ; Base case: if num is under 1000 then nothing to do but append that to front of list
  (cond ((< num 1000)
         ;(append num num-list)
         (list num))
  ; Recurse case: if num is over 1000 then append last 3 digits to num-list, and call 
  ; make-num-list again with the remaining chunks of num.
         ((>= num 1000)
         (append (list (remainder num 1000)) (make-num-list (quotient num 1000))))))

; Combine num-list and word-list into the big list of words, big-list.
(define (make-big-list num-list word-list)
  ; If num-list has been depleted, return big-list and that's it.
  (cond ((empty? num-list)
         '())
         (else
         ; Otherwise add on the front of the num-list, the front of the word-list, and 
         ; recurse call of make-big-list with the remaining chunks of num-list and 
         ; word-list. 
         (list (make-big-list (cdr num-list) (cdr word-list)) (car num-list) (car word-list)))))