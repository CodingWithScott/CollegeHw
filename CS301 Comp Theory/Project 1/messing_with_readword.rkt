#lang racket

(require "readword.rkt" )

;; to-list : Input -> Listof[Number]
;; convert the input to a list if necessary
(define (to-list v)
  (cond [(string? v) (list v)]
        [else v]))

(define (test)
  (define ls '())
  (call-with-input-file "animalfarm.txt"
    (lambda (file)
      (let loop ((i 0) (word (read-word file)))
        (when word
          (when (= 0 (modulo i 10)) (newline))
          (display word) (display " ")
          ;(append (to-list word) ls)
          (loop (+ i 1) (read-word file))))))
  

  
  (display ls))

(define (test2)
  (define ls '())
  (call-with-input-file "animalfarm.txt"
    (lambda (file)
      (let loop ((i 0) (word (read-word file)))
        (when word
          (when (= 0 (modulo i 10)) (newline))
          (append (to-list (read-word file))))
          (loop (+ i 1) (read-word file))))))


(define (start)
  (append (list (read-word infile) (read-word infile))))


(newline) (display "Test 1:") (newline)
(test)
(newline) (display "Test 2:") (newline)
(test2)

; Trying to make a recursive function that reads through input text file to make a list of every word.
; Base case will return an empty list, recurse case will take curr word and append to list and then 
; call itself again with rest of list.
;(define (makebiglist ls)
;  (call-with-input-file "animalfarm.txt"
;    (lambda (file)
      