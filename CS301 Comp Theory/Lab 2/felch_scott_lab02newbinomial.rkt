#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSCI 301
;; Fall 2013
;;
;; Lab #2
;;
;; Scott Felch
;; W00750298
;;
;; Program 1
;; The purpose of this program is to compute a binomial using a more 
;; efficient algorithm than simply n!/(k!(n-k)!). It's a super exciting
;; algorithm, see how it works below.
;;
;; Also, once that's been completed, it will print out individual rows
;; of Pascal's Triangle or Pascal's entire triangle up to a specified 
;; row number.
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Crappy slow factorial function
(define (factorial n)
  (if (= 0 n) 1
      (* n (factorial (- n 1)))))

; Crappy slow binomial function
(define (binom-slow n k)
  (/ (factorial n)
     (* (factorial k)
        (factorial (- n k)))))

; New and improved factorial function 
(define newfact (lambda (n k)         ; Begin definition of the recurse factorial procedure
    (if (= k n) 1                     ; Base case, if k=n then return 1
        (* n (newfact (- n 1) k)))))  ; Recursive case, multiply n * (factorial from n-1 to k)

; New and improved binomial function
(define (newbinom n k)        ; Start the program accepting initial values for n and k.
    (if (> k (- n k)) 1       ; If k > (n-k) then format is n
        (/ (newfact n k)       
           (newfact (- n k) 0)))
        (/ (newfact n (- n k))
           (newfact k 0)))
                  
; An example of how to do a nested for loop from Rosetta Code. 
; http://rosettacode.org/wiki/Loop/For#Racket
(define (forloop)
  (for ([i (in-range 1 6)]) 
    (for ([j i]) (display "*")) (newline)))
  
; Loop that will take row number of Pascal's triangle and display it.
; This is done by calling the binom function using args (counter, row) = (n, k).
(define (pascal row binom-funct)            
  (for ([counter (in-range 0 (+ 1 row))])    ; counter is going from 0 to row+1
    (display (binom-funct row counter))      ; Display result of function and a space
    (display " ")))          
    
; Loop that will print out each subsequent row of Pascal's triangle
; using the above loop.
(define (pascal-triangle row binom-funct)
  (for ([counter (in-range 0 (+ 1 row))])
    (pascal counter binom-funct) (newline)))
    
  (begin)   ; DO IT!!!!!!
