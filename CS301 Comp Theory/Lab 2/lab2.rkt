; Scotty Felch, Brandon Taylor
; 15 April 2014
; CSCI 301
; Lab 2, truth tables and stuffs
#lang racket

(define (permutations size)
  (let ((elements (list #t #f)))
    (if (zero? size)
        '(())
        (append-map (lambda (p)
                      (map (lambda (e) (cons e p)) elements))
                    (permutations (sub1 size))))))

; P -> Q
(define (implies p q)
  (or (not p) q))

; P -> (Q -> R)
(define (wff1 p q r)
  (implies p (implies q r)))

; Q -> (P -> R)
(define (wff2 p q r)
  (implies q (implies p r)))

; R -> (Q -> P)
(define (wff3 p q r)
  (implies r (implies q p)))

; ~(P -> Q)
(define (wff4 p q)
  (not (implies p q)))
         
; P ^ ~Q
(define (wff5 p q)
  (and p (not q)))

;P v (Q ^ R)
(define (wff6 p q r)
  (or p (and q r)))

;P ^ (Q v R)
(define (wff7 p q r)
  (and p (or q r)))

;(P v Q) v (R v S)
(define (wff8 p q r s)
  (or (or p q) (or r s)))

;(P v Q) ^ (R v S)
(define (wff9 p q r s)
  (and (or p q) (or r s)))

; Big ass truth table, WOAH!!
(define (truth-table wff)
  (map (lambda (x)
         (apply wff x))
       (permutations (procedure-arity wff))))
 
; Do these WFFs have identical truth tables?
(define (equivalent? wff1 wff2)
  (equal? (truth-table wff1) (truth-table wff2)))


(print "(truth-table wff1)") (newline)
(truth-table wff1)


#|(newline)
(truth-table wff2)
(truth-table wff3)
|#