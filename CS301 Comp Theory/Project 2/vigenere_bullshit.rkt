#lang racket
(define (fill-table filename ht)
  ;(display input) (newline)
  (define end (string-length ciphertext))
  (display "Substring:  ")(display (substring input 0 5)) (newline)
  ;(cond ((hash-has-key? wordlocs key)
  ;       (hash-set! wordlocs key (append (hash-ref wordlocs key) (list (location)))
  ;       (fill-table (substring ciphertext 6 length) (+ location 5)))
  ;     (else
  ;       (hash-set! wordlocs key location)
  ;       (fill-table (substring ciphertext 6 length) (+ location 5)))))
  (cond ((empty? input) "done filling table")
        ;(define key (substring input 0 5))
        (display "Substring:  ")(display (substring input 0 5)) (newline)
        ;(display "key: ") (display key) (newline)
        (display "poop")
        (hash-set! wordlocs (substring input 0 5) location)
        (display (hash-ref wordlocs (substring input 0 5)))
        (hash-ref wordlocs (substring input 0 5))
        (fill-table (substring ciphertext 5 end) (+ location 5))))
        ;))




#lang racket
(define (fill-table filename ht)
  ;(display input) (newline)
  (define end (string-length ciphertext))
  (display "Substring:  ")(display (substring input 0 5)) (newline)
  ;(cond ((hash-has-key? wordlocs key)
  ;       (hash-set! wordlocs key (append (hash-ref wordlocs key) (list (location)))
  ;       (fill-table (substring ciphertext 6 length) (+ location 5)))
  ;     (else
  ;       (hash-set! wordlocs key location)
  ;       (fill-table (substring ciphertext 6 length) (+ location 5)))))
  (cond ((empty? input) "done filling table")
        ;(define key (substring input 0 5))
        (display "Substring:  ")(display (substring input 0 5)) (newline)
        ;(display "key: ") (display key) (newline)
        (display "poop")
        (hash-set! wordlocs (substring input 0 5) location)
        (display (hash-ref wordlocs (substring input 0 5)))
        (hash-ref wordlocs (substring input 0 5))
        (fill-table (substring ciphertext 5 end) (+ location 5))))
        ;))


; Build hash table from input file.
(define (fill-table filename ht charlist position)
  (let ((infile (open-input-file filename)))
    (let loop ((next-char (read-char infile)))
      (cond ((equal? (length charlist) 5)
             (hash-set! ht (list->string charlist) position)
             (fill-table filename ht (append (cdr charlist) (next-char)) (+ position 1)))
        (else
             (append charlist (read-char infile))
             (fill-table filename ht charlist (+ position 1))))
    (close-input-port infile))))