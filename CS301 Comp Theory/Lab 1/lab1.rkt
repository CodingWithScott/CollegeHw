;Scotty Felch, Kyle Beckhorn
; Wednesday 9 April 2014, Spring 2014
; CSCI 301, Brian Hutchinson
; Lab 1
#lang slideshow

(define c (circle 10))

(define (pyramid size)
  (vc-append (circle size)
  (hc-append (circle size) (circle size))))


(define (nested-pyramids size shape count)
  (if (= count 1)
      (pyramid size)
      (vc-append (nested-pyramids size shape (- count 1))
                 (hc-append (nested-pyramids size shape (- count 1))
                            (nested-pyramids size shape (- count 1))))))



(pyramid 10)
(nested-pyramids 10 circle 1)
(nested-pyramids 10 circle 2)
(nested-pyramids 10 circle 3)
(nested-pyramids 10 circle 4)
(nested-pyramids 10 circle 5)