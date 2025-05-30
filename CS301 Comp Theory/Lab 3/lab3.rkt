; Scotty Felch
; 25 April 2014
; CSCI 301
; Lab 3
#lang racket

; Note: This implemntation doesn't require a seq-iter because I'm not passing a list every time.
; End result is same. May rewrite it later to incorporate seq-iter if necessary.
(define (seq lower upper)
  (if (equal? lower upper) (list upper)
      (cons lower (seq (+ 1 lower) upper))))

; n = upper bound, i = current iteration
(define (find-primes n)
  (define (find-primes-iter i n the_list)
    (if (> i (sqrt n))
        the_list
        
         (find-primes-iter (+ i 1) n (filter (lambda (x) (or(not(zero?(remainder x i)))
                                                            (= x i))) the_list))))
  (find-primes-iter 2 n (seq 1 n)))

(find-primes 42)