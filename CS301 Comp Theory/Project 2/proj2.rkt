#lang racket

;; Useful helper functions
; x=element, S=set
(define (contains? x S)
  (cond ((null? S) false)
        ((equal? x (car S)) true)
        (else (contains? x (cdr S)))))

(define (implies P Q)
  (or (not P) Q))

;; Universe definitions
(define A '(hutchinson hearne fizzano 241 301 474 493 dennis doris spruce redwood rose))
(define altA (list 1 2 3))

;; Relation definitions
(define is-faculty '((hutchinson) (hearne) (fizzano)))
(define is-course '((301) (241) (474) (493)))
(define is-student '((dennis) (doris)))

; (a,b,c) means faculty member a teaches course b to student c
(define teaches-to '((hutchinson 301 dennis) (hutchinson 241 doris) (hearne 301 doris) (hearne 493 dennis) (fizzano 474 doris))) 
(define is-person '((hutchinson) (hearne) (fizzano) (dennis) (doris)))
(define is-tree '((spruce) (redwood)))
(define is-plant '((spruce) (redwood) (rose)))
(define taller-than '((redwood spruce) (redwood doris) (redwood dennis) (spruce doris) (spruce dennis) (dennis doris)))

; altR matches altA (useful for testing binary relations)
(define altR (list (list 1 2) (list 1 3) (list 2 2) (list 3 3) (list 3 1) (list 1 1) (list 2 3)))

;; Predicate definitions
(define (is-faculty? x)
  (contains? (list x) is-faculty))

(define (is-course? x)
  (contains? (list x) is-course))

(define (is-student? x)
  (contains? (list x) is-student))

(define (teaches-to? prof course student)
  (contains? (list prof course student) teaches-to))

(define (is-person? x)
	(contains? (list x) is-person))

(define (is-tree? x)
  (contains? (list x) is-tree))

(define (is-plant? x)
  (contains? (list x) is-plant))

(define (taller-than? x y)
	(contains? (list x y) taller-than))


;;;;;;;;;;;;;;;;;;; Begin stuff we wrote ;;;;;;;;;;;;;;;;;;;;
(define (permutations A s) 
    (if (zero? s)
        '(())
        (append-map (lambda (p)
                      (map (lambda (e) (cons e p)) A))
                    (permutations A (sub1 s)))))

(define (package-help x P)
  (cond
    ((null? P) '())
    ((equal? x (car (car P))) (cons (car P) (package-help x (cdr P))))
    (else (package-help x (cdr P)))))
    

(define (package A P)
  (cond
    ( (null? A) '())
    (else (filter (lambda (x) (not (null? x)))  (cons (package-help (car A) P) (package (cdr A) P))))))

(define (predhelp A quant perms)
  (if (null? perms)
      #f
      (predhelphelp A quant perms)))

(define (predhelphelp A quant perms)
  (if (< (length quant) 2)
      (if (equal? (car quant) 'exists) ;base case
          (if (>= (length perms) 1)
              #t
              #f)
          (if (= (length perms) (length A))
              #t
              #f))
      (if (equal? (car quant) 'exists);not base
          (ormap (lambda (z) (predhelphelp A (cdr quant) z )) (map (lambda (y) (package A (map (lambda (x) (cdr x)) y))) perms))
          (andmap (lambda (z) (predhelphelp A (cdr quant) z)) (map (lambda (y) (package A (map (lambda (x) (cdr x)) y))) perms)))))
 ;(map (lambda (y) (package A (map (lambda (x) (cdr x)) y))) perms) makes lists of the 2nd element of a list.
          
(define (predicate-logic A quant func)
   (predhelp A quant (package A (filter (lambda (x) (apply func x)) (permutations A (length quant))))))    

(define (predicate-logic2 A quant func R)
  (predhelp A quant (package A (filter (lambda (x) (apply func x)) R))))
  
;(predicate-logic altA (list 'forall) (lambda (x) (even? (car x))))

(define (wff1)
  (predicate-logic A (list 'forall) 
                   (lambda (x) (implies (is-tree? x) (is-plant? x)))))

(define (wff2)
        (predicate-logic A (list 'exists 'forall)
                         (lambda (x y) (implies (is-plant? y) (and (is-tree? x) (not (taller-than? y x)))))))

(define (wff3)
  (predicate-logic A (list 'exists 'exists)
                   (lambda (x y) (and (is-tree? x) (not (is-tree? y)) (taller-than? y x)))))

(define (wff4)
  (predicate-logic A (list 'forall)
                   (lambda (x) (implies (is-student? x) (is-person? x)))))

(define (wff5)
  (predicate-logic A (list 'exists)
                   (lambda (x) (and (is-faculty? x) (is-student? x)))))

(define (wff6)
  (predicate-logic A (list 'exists 'exists 'exists)
                   (lambda (x y z) (and (is-faculty? x) (is-student? y) (is-course? z) (teaches-to? x z y)))))


;;;;;;;;;; Rewriting binary relation properties to utilize pred-logic ;;;;;;;;;
; Assume set = A = (1 2 3) for these example comments
; there is (1,1) (2,2) (3,3) in relation 
(define (reflexive? A R)
  (predicate-logic A (list 'forall)
                   (lambda (x) (contains? (list x x) R))))

; there is not (1,1) (2,2) or (3,3) in relation
(define (irreflexive? A R)
  (predicate-logic A (list 'forall)
                   (lambda (x) (not (contains? (list x x) R)))))

; if there is (1,2) (2,3) in relation, then there's (2,1) (3,2)
(define (symmetric? A R)
  (predicate-logic A (list 'forall)
                   (lambda (x) (contains? (list (cdr R) (car R)) R))))

; if there is (1,2) (2,3) in relation, then there's NOT (2,1) or (3,2)
(define (anti-symmetric? A R)
  (predicate-logic A (list 'forall)
                   (lambda (x) (not (contains? (list (cdr R) (car R)) R)))))

; if there is (1,2) (2,3) in relation, then there's (1,3)
(define (transitive? A R)
  (predicate-logic A (list 'forall 'forall 'forall)
                   (lambda (x y z) (implies (and (contains? (list x y) R) (contains? (list y z) R)) (contains? (list x z) R)))))

; every single node connects to every other node
(define (total? A R)
  (predicate-logic A (list 'forall 'forall)
                   (lambda (x y) (or (contains? (list x y) R) (contains? (list y x) R)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         