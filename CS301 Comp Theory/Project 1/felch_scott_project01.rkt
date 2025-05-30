; Scotty Felch
; 8 November 2013
; CSCI 301
; Project 1: Ngrams
; This program reads in an entire novel and then outputs ngrams of it, producing a semi-legible
; bunch of nonsense that's kind of funny, like a Mad Lib. 

#lang racket
(require "readword.rkt")                       ; Import Dr Matthews' package that reads a word at a time
(define infile (open-input-file "animalfarm.txt"))   ; Open text file for input
(define ht (make-hash))                        ; Hash table I'll be building up

; Helper function to return the Nth element of a list. Believe it or not, Scheme doesn't have this built in.
(define list-ref
  (lambda (ls n)
    (if (= n 0)
        (car ls)
        (list-ref (cdr ls) (- n 1)))))

;; Both of these to-list and to-string helper functions were supposed to help deal with the print method
;; constantly complaining about having lists intead of strings or strings instead of lists but didn't really
;; fix anything.

;; to-string : Input -> Listof[Letters]
;; convert the input from a list of 1 element to just the element
(define (to-string v)
  (cond [(list? v) (car v)]
        [else v]))

; Initiates first call to fill-table, after which fill-table recursively calls itself
(define (start)
  (fill-table (append (list (read-word infile)) (list (read-word infile))) (list (read-word infile))))

; Fills the hash table. Accepts a key (list of 2 words) and value (3rd word following these 2 words),
; recursively calls itself until it reads in "false" for value.
(define (fill-table key value)
  (cond ((eq? (car value) #f) "done filling table")  ; If value is false, you've reached end of the book, just exit.
        (else                                        ; else enter the next cond block
         (cond ((hash-has-key? ht key)  ; If the key already exists in table then set the value
                                        ; to be the existing list of values appended with curr value
                (hash-set! ht key (append (hash-ref ht key) value))
                (fill-table (append (cdr key) value) (list (read-word infile))))
               (else                    ; Else if the key doesn't exist in the table then make the new entry
                (hash-set! ht key value)
                (fill-table (append (cdr key) value) (list (read-word infile))))))))

; Initiates printing out Ngrams. Accepts # of ngrams user wants to make. Prints out 1st ngram of book, then calls helper function.
(define (startprint num)
  (define words (open-input-file "animalfarm.txt"))          ; This is super janky and ghetto but I'm opening another copy of input file
  ; for input in this section.
  (define key1  (read-word words))                                              ; Store first word in book, first part of key
  (define key2  (read-word words))                                              ; Store second word in book, second part of key
  (define value (list-ref (hash-ref ht (list key1 key2))
                          (random (length (hash-ref ht (list key1 key2))))))    ; Store first value, a randomly selected entry from
  ; the list pulled from hash table.
  (print key2 value (- num 1)))                                  ; Print using key2 and value as key, decrement counter.


; Recursive print procedure that doesn't work. No matter what I do I get invalid keys, either of the form having lists where there
; should be strings, or strings where they should be lists, or empty lists instead of strings. No matter what changes I make I just
; get different combinations thereof.
(define (print key1 key2 counter)
  (cond ((eq? counter 0) (newline)); If counter has reached 0 then have printed all the ngrams necessary, so quit.
        (else
         (display (to-string key1))
         (display " ")
         (define value (hash-ref ht (list (to-string key1) (to-string key2))))
         (define nvalue (list-ref value (random (length value))))
         (print key2 nvalue (- counter 1)))))

(start)             ; Populate hash table from book
(startprint 50)     ; Start printing Ngrams from the hash table