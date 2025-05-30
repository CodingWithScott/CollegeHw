;; Scott Felch
;; 22 November 2013
;; CSCI 301
;; Project 2, Part 2: Vigenere Cyphers
;;
;; This program will perform a combination of frequency analysis and 
;; character shifting to figure out what passphrase is being used for
;; an input text encoded in the viginere cypher, and then once the 
;; passphrase is determined use that to decode from the cipher to plaintext.

#lang racket

(define ciphertext (file->string "vigenereclean.txt"))
(define wordlocs (make-hash)) ; Hash table to hold string indeces locations
(define subhash1 (make-hash)) ; Hash table to hold every 6 chars in the ciphertext, offset = 0 (0, 6,12,18,...)
(define subhash2 (make-hash)) ; Hash table to hold every 6 chars in the ciphertext, offset = 1 (1, 7,13,19,...)
(define subhash3 (make-hash)) ; Hash table to hold every 6 chars in the ciphertext, offset = 2 (2, 8,14,20,...)
(define subhash4 (make-hash)) ; Hash table to hold every 6 chars in the ciphertext, offset = 3 (3, 9,15,21,...)
(define subhash5 (make-hash)) ; Hash table to hold every 6 chars in the ciphertext, offset = 4 (4,10,16,22,...)
(define subhash6 (make-hash)) ; Hash table to hold every 6 chars in the ciphertext, offset = 5 (5,11,17,23,...)

; Build hash table from string that contains entire cleaned input file
; While it's building it checks all the position differences for a remainder
; after dividing by 3. I tried all numbers from 2 to 19 and 6 was the largest
; number that produced a large number of 0s, which leads me to believe the 
; keyword is 3 chars long.
(define (fill-position-table ht charlist position)
  (define restoflist (substring charlist 1 (string-length charlist)))
  ;(display "key:  ") (display key) (newline)
  (cond ((< (string-length charlist) 5) (newline))  ; If list entered is <5 then EOF is reached
     (else                                        ; else enter the next cond block
       (define key (substring charlist 0 5))
       (cond ((hash-has-key? ht key)  ; If the key already exists in table then set the value
                                        ; to be the existing list of values appended with curr value
                (display (remainder (- position (car (hash-ref ht key))) 6)) 
                ;(display (- position (car (hash-ref ht key)))) (newline)
                (hash-set! ht key (append (hash-ref ht key) (list position)))
                (fill-position-table ht restoflist (+ position 1)))
               (else                    ; Else if the key doesn't exist in the table then make the new entry
                (hash-set! ht key (list position))
                (fill-position-table ht restoflist (+ position 1)))))))


;  ht is subhash table to work with
;  charlist is the entire ciphertext
;  position is the index of charlist being looked at
;;;;; every 6 characters 
(define (fill-subhash ht charlist position)
  (cond ((equal? (modulo position 6) 0)
         
         
         
         (else
           (fill-subhash ht 
         
  

(fill-position-table wordlocs ciphertext 0)
(newline) (newline) (newline) 
(display (build-list ciphertext '()))