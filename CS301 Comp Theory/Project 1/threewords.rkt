#lang racket
(require "readword.rkt")  ; Import Dr Matthews' package that reads a word at a time

(define infile (open-input-file "words.txt"))

(define ht (make-hash))

(define (testbools key)
  (cond ((boolean? key)
         (display "#false"))
     (else
         (display "it's a list"))))

(define (test)
  (testbools (read-word infile)))


(define (disp-conts input)
  (cond ((boolean? input) "false")                        ; If input is a list enter next if statement
                  ; If it's not empty, display front of list and recurse call with rest of lis
         (else                                ; If input is not a list just display input
          (cond ((equal? input 5)
                (display "you entered 5"))
                ((equal? input 6)
                 (display "you entered 6"))))))
         