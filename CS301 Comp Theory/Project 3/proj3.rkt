#lang racket
;; Scotty Felch
;; 6 June 2014
;; CSCI 301
;; Project 3
;;
;; ABSTRACT: This program will accept a regular grammar as input and then give you information about it.

;; Grammars are defined as list of lists. They are structured as follows...
;;     (define (grammar1 '((list of terminals)
;;                         (list of variables)
;;                         ((name of variable) (rule1) (rule2) ... (ruleN)))                  <-- is this an extra set of parans on the outside??
;;                         specified start symbol)))
;; Alternatively, here's an example mapping   S -> aS | epsilon...
;;     (define (grammar1 '((a)
;;                         (S)
;;                         ((S (a S) ()))
;;                         S)))

(define grammar1 '((a)
                   (S)
                   ((S (a S) ()))
                   S))

;; Helper function I stole from Proj2
(define (contains? x S)
  (cond ((null? S) #f)
        ((equal? x (car S)) #t)
        (else (contains? x (cdr S)))))

;; Eat a grammar, then poop the terminals, variables, set of rules, or start symbol.
;; #1
(define (get-terminals G)
  (car G))
;; #2
(define (get-variables G)
  (car (cdr G)))
;; #3
(define (get-rules G)
  (car (cdr (cdr G))))
;; #4
(define (get-start-symbol G)
  (car (cdr (cdr (cdr G)))))

(define R (get-rules grammar1))

;; #5
;; Eat a grammar (G), poop a bool whether or not it's formal, a CFG, regular, or non-recursive.
;; Grammar is formal if:
;;    1. terms ^ variables => empty set
;;    2. S is contained in V
(define (is-formal-grammar? G)
  (if (and (no-overlap (get-terminals G) (get-variables G)) (contains? (get-start-symbol G) (get-variables G)))
      #t
      #f))
   ;; #5 helper
   (define (no-overlap terms vars)
     (cond 
       ((null? terms) #t)
       ((contains? (car terms) vars) #f)
       (else (no-overlap (cdr terms) vars))))

;; #6
;; Poop true if the left side of each rule consists of a single variable in V.
;; algorithm: Iterate over all of (get-rules), check if length is 1 and if contents 
;;            are contained in (get-vars).
(define (is-context-free-grammar? G)
  (context-free-helper (get-rules G) (get-variables G)))

   (define (context-free-helper rules variables)
     (cond 
       ((null? rules) #t)
       (else (if (contains? (caar rules) variables) 
                 (context-free-helper (cdr rules) variables)
                 #f))))
                     
;; #7
;; Poop true if G is CFG, and also every rule takes form: 
;; epsilon    OR     terminal-VARIABLE    OR      terminal      
;; algorithm: 
(define (is-regular-grammar? G)
  (and (is-context-free-grammar? G) 
       (or (regular-form1 (get-rules G))))); (regular-form2 (get-rules G)) (regular-form3 (get-rules G)))))

   (define (regular-form1 rules)
       (cond
         ((null? (cdr (car rules)))
          #t)
         (else
           #f)))
   
   ;; NOTES:
   ;; 1. If reached end of list of rules and no fails up to this point, then it's regular.
   ;; 2. If curr rule of curr rule is a terminal, keep looking.
   ;; 3. If curr char of curr rule is a variable, check if it's the final char in the rule.
   ;;    If it's the final char, it's fine. If there's a terminal or another variable after it
   ;;    then this is not regular.
   (define (regular-form2 rules G)
     (cond
       ((null? (car rules)) ;; 1
        #t)
       ((contains? (car (car rules)) (get-terminals G))  ;; 2
                   (regular-form2 (cdr rules) G))
       
       
       
       (contains? (car (cdr rules)) (get-variables G))   ;; 3
                  (cond ((null? (cdr rules)) #t)
                        (not (null? (cdr rules)) #f))))
                        
   
   (define (regular-form3 rules)
     (display "poop3"))
   
       
     
             
   

;; #8
(define (is-non-recursive-grammar? G)
  ; No variable should ever be contained in any of the rules tuples following it
  (display "is-non-recursive-grammar"))

; Accepts a context-free grammar (G), and number of strings to produce (N).
; Returns a list of random strings of terminals which are in the language.
;; #9 (extra credit)
(define (generate-random-strings G N)
  (display '"generate ")
  (display N)
  (display'" strings"))

(display "Terminals:    ") (get-terminals grammar1)
(display "Variables:    ") (get-variables grammar1)
(display "Rules:        ") (get-rules grammar1)
(display "Start:        ") (get-start-symbol grammar1)
(regular-form1 (get-rules grammar1))

;(display "is grammar1 formal?") (newline)
;(is-formal-grammar? grammar1) (newline)
;(display "is grammar1 context-free?") (newline)
;(is-context-free-grammar? grammar1) (newline)
;(display "is grammar1 regular?") (newline)
;(is-regular-grammar? grammar1)

