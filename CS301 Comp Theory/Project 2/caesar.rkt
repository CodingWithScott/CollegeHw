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

(require (planet williams/science/histogram)) ; Histogram package
(require (planet williams/science/histogram-graphics))  ; Print out histograms. Why is this not included in above???

(define cipher-ht (make-hash)) ; Hash table I'll be using for encrypted text

(define cipher-histo (make-histogram-with-ranges-uniform 26 1 26)) ; Make a histogram with 26 bins (for A-Z)
                                                            ; numbered 1-26
(define alphabet (string->list "ABCDEFGHIJKLMNOPQRSTUVWXYZ"))

; Initialize hash table with values for A-Z, counter set to 0 for each.
(define (init-table ht list)
  (cond ((empty? list) "Table initialized.")  ; If list is empty do nothing, otherwise 
        (else              ; set hash-table entry to 0 for curr letter and recurse 
                           ; call with rest of list.
           (hash-set! ht (car list) 0)
           (init-table ht (cdr list)))))

; Return total number of chars in a hash table
(define (total-chars ht)
  (foldl + 0 (map (lambda (letter) 
                (hash-ref ht letter)) 
                  alphabet)))

; Print out hash table in alphabetical order. (Otherwise Racket does some other
; weird order by default.)
(define (print-table-in-order ht list)
  (cond ((empty? list) "Table printed.")
        (else
           (display (car list)) (display ":  ") (display (hash-ref ht (car list))) (newline)
           (print-table-in-order ht (cdr list)))))

; Make exact copy of file (this is just Matthews' code)
;(define (make-copy inputname outputname)
; (let ((infile (open-input-file inputname))
;      (outfile (open-output-file outputname
;                                 #:mode 'text 
;                                 #:exists 'replace)))
;  (let loop ((next-char (read-char infile)))
;    (when (not (eof-object? next-char))
;      (write-char next-char outfile)
;      (loop (read-char infile))))
;  (close-input-port infile)
;  (close-output-port outfile)))

; Make clean copy of file by stripping out whitespace, numbers and symbols
(define (make-clean-copy inputname outputname)
 (let ((infile (open-input-file inputname))
      (outfile (open-output-file outputname
                                 #:mode 'text 
                                 #:exists 'replace)))
  (let loop ((next-char (read-char infile)))
    (when (not (eof-object? next-char))
      (when (char-alphabetic? next-char)
        (write-char next-char outfile))
      (loop (read-char infile))))
  (close-input-port infile)
  (close-output-port outfile)))

; Fill the hash table using data from cleaned text file
(define (fill-table filename ht)
  (let ((infile (open-input-file filename)))
  (let loop ((next-char (read-char infile)))
    (when (not (eof-object? next-char))
      (when (char-alphabetic? next-char)
          (hash-set! ht next-char (+ (hash-ref ht next-char) 1)))
      (loop (read-char infile))))
  (close-input-port infile)))

; Fill data into histogram from hash table, same logic as fill-table
; Input: histogram to be filled, hash table to read from, letters A-Z, bin number of histo to fill
(define (fill-histogram histo ht list bin)
  (cond ((empty? list) "Histogram filled.")  
        (else 
           (histogram-accumulate! histo bin (hash-ref ht (car list)))
           (fill-histogram histo ht (cdr list) (+ bin 1)))))

; Undo the cipher shift of original file, output to a new text file
; TODO: If the letter is in teh first 6 letters of alphabet, need to 
(define (make-decrypt-copy inputname outputname)
   (let ((infile (open-input-file inputname))
      (outfile (open-output-file outputname
                                 #:mode 'text 
                                 #:exists 'replace)))
  (let loop ((next-char (read-char infile)))
    (when (not (eof-object? next-char))
      (define curr-char next-char)
      (cond ((char-alphabetic? curr-char)
          (cond ((<= (char->integer curr-char) 70)
               
              (write-char (integer->char (+ (+ (char->integer curr-char) -6) 26)) outfile))
            (else
              
              (write-char (integer->char (+ (char->integer curr-char) -6)) outfile))))
        (else
           
           (write-char curr-char outfile)))
      (loop (read-char infile)))
  (close-input-port infile)
  (close-output-port outfile))
  (display "Decrypted text file created.") (newline)))

; Use the shift I found from histogram (appears to be a shift of +6)

(make-clean-copy "enciphered.txt" "encipheredclean.txt")
(init-table cipher-ht alphabet)
(fill-table "encipheredclean.txt" cipher-ht)
(fill-histogram cipher-histo cipher-ht alphabet 1)
(histogram-plot cipher-histo "Enciphered text letter frequency")

; Histogram appears to indicate a shift of +6, so decryption step will
; be a shift of -6. 
(make-decrypt-copy "enciphered.txt" "deciphered.txt")

; TODO 1: (in report, not in program) use the histogram to determine the cypher shift
;    I think it's a shift of 4
; TODO 2: Use the cypher shift to write deciphered text to output file