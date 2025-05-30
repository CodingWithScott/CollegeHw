;; Scott Felch
;; 22 November 2013
;; CSCI 301
;; Project 2, Part 1: Caesar Cyphers
;;
;; This program will perform frequency analysis on a cypher input text file
;; in order to attempt to figure out what the cypher being used is.
;; To do this I'll make a hash table using an input char as the key and the 
;; contents of the hash table will be a counter. 

#lang racket
(require (planet williams/science/histogram))           ; Histogram package
(require (planet williams/science/histogram-graphics))  ; Print out histograms. Why is this not included in above???

(define ht (make-hash))
(define h (make-histogram-with-ranges-uniform 26 1 26)) ; Make a new histogram with 26 bins (for A-Z)

; Initialize hash table with values for A-Z, counter set to 0 for each.
(define alphabet (string->list "ABCDEFGHIJKLMNOPQRSTUVWXYZ"))

(define (init-table list)
  (cond ((empty? list) "Table initialized.")  ; If list is empty do nothing, otherwise 
        (else              ; set hash-table entry to 0 for curr letter and recurse 
                           ; call with rest of list.
           (hash-set! ht (car list) 0)
           (init-table (cdr list)))))

(init-table alphabet)
(histogram-increment! h 15)
(histogram-plot h "oh hey!")