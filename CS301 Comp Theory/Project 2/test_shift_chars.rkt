#lang racket
(define (make-clean-copy inputname outputname)
 (let ((infile (open-input-file inputname))
      (outfile (open-output-file outputname
                                 #:mode 'text 
                                 #:exists 'replace)))
  (let loop ((next-char (read-char infile)))
    (when (not (eof-object? next-char))
      (when (char-alphabetic? next-char)
        (write-char (integer->char (+ (char->integer next-char) 5)) outfile))
        ;(write-char next-char outfile))
      (loop (read-char infile))))
  (close-input-port infile)
  (close-output-port outfile)))


(define (make-shift-copy inputname outputname)
 (let ((infile (open-input-file inputname))
      (outfile (open-output-file outputname
                                 #:mode 'text 
                                 #:exists 'replace)))
  (let loop ((next-char (read-char infile)))
    (when (not (eof-object? next-char))
      (define curr_char next-char)
      (when (char-alphabetic? curr_char)
        ;(display curr_char)
        ;(display (char->integer curr_char))
        (display (integer->char (+ (char->integer curr_char) 5)))
        ;(define shift_char ()
        ;(write-char curr_char outfile))
      (loop (read-char infile))))
  (close-input-port infile)
  (close-output-port outfile))))

; Undo the cipher shift of original file, output to a new text file. 
; I think it's skipping over whitespace and I don't know how to make
; it not do that.
(define (make-decrypt-copy inputname outputname)
   (let ((infile (open-input-file inputname))
      (outfile (open-output-file outputname
                                 #:mode 'text 
                                 #:exists 'replace)))
  (let loop ((next-char (read-char infile)))
    (when (not (eof-object? next-char))
      ;(define curr_char next-char)
      (cond (char-alphabetic? next-char)
           (write-char (integer->char (+ (char->integer next-char) 5)) outfile)
        (else
           (write-char next-char outfile)))
      (loop (read-char infile))
  (close-input-port infile)
  (close-output-port outfile)))))

;(make-clean-copy "test.txt" "testclean.txt")
;(make-shift-copy "enciphered.txt" "testenciphered.txt")
(make-decrypt-copy "enciphered.txt" "testenciphered.txt")