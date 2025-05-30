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

; Original function the user calls, will then call internal guts procedure
; using the number inputted by user and an initial list of number-words which
; will be decremented.
(define (number-name num)
  (display (make-big-list (make-num-list num)  
             (list "" "thousand" "million" "billion" "trillion" "quadrillion" "quintillion" "sextillion" "septillion" "octillion" "nonillion" 
              "decillion" "undecillion" "duodecillion" "tredecillion"))))

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
         (append (list (remainder num 1000) (make-num-list (quotient num 1000)))))))


; Combine num-list and word-list into the big list of words, big-list.
(define (make-big-list num-list word-list)
  ; If num-list has been depleted, return big-list and that's it.
  (cond ((empty? num-list)
         '())
         (else
         ; Otherwise add on the front of the num-list, the front of the word-list, and 
         ; recurse call of make-big-list with the remaining chunks of num-list and 
         ; word-list. 
         (list (make-big-list (cdr num-list) (cdr word-list)) (name<1000 (car num-list)) (car word-list)))))



; Function that will accept a number smaller than 1000 and print out the word
; version of it. Calls helper functions chunk1, chunk2, and chunk3.
(define (name<1000 num)
  (list (chunk1 num) (chunk2 num)))

; Prints out the word from the 100s place followed by the word "hundred" 
(define (chunk1 num)
  (if (equal? (quotient num 100) 0)    ; If number is <100 just display num
      (list (chunk3 (quotient num 100)))
  (list (chunk3 (quotient num 100)) 'hundred))) ; Else append "hundred" on the end
  
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