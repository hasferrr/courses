;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname count-odd-even-tr-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; count-odd-even-starter.rkt

; PROBLEM:
; 
; Previously we have written functions to count the number of elements in a list. In this 
; problem we want a function that produces separate counts of the number of odd and even 
; numbers in a list, and we only want to traverse the list once to produce that result.
; 
; Design a tail recursive function that produces the Counts for a given list of numbers.
; Your function should produce Counts, as defined by the data definition below.
; 
; There are two ways to code this function, one with 2 accumulators and one with a single
; accumulator. You should provide both solutions.
; 


(define-struct counts (odds evens))
;; Counts is (make-counts Natural Natural)
;; interp. describes the number of even and odd numbers in a list

(define C1 (make-counts 0 0)) ;describes an empty list
(define C2 (make-counts 3 2)) ;describes (list 1 2 3 4 5))


;; (listof Numbers) -> Counts
;; produce separate counts of the number of odd and even numbers in a list
(check-expect (count-odd-even empty) C1)
(check-expect (count-odd-even (list 1 2 3 4 5)) C2)
(check-expect (count-odd-even (list 1 3 5 7 9)) (make-counts 5 0)) ;all odd/ganjil
(check-expect (count-odd-even (list 2 4 6 8 0)) (make-counts 0 5)) ;all even/genap

;(define (count-odd-even lon) C1)
#;
(define (count-odd-even lon0)
  ;; count-odd  is Number; how many odd numbers seen so far
  ;; count-even is Number; how many even numbers seen so far
  (local [(define (count-odd-even lon count-odd count-even)
            (cond [(empty? lon) (make-counts count-odd count-even)]
                  [else
                   (if (odd? (first lon))
                       (count-odd-even (rest lon)
                                       (add1 count-odd)
                                       count-even)
                       (count-odd-even (rest lon)
                                       count-odd
                                       (add1 count-even)))]))]
    (count-odd-even lon0 0 0)))


(define (count-odd-even lon0)
  ;; acc is Counts; how many odd and even numbers in the Counts seen so far
  (local [(define (count-odd-even lon acc)
            (cond [(empty? lon) acc]
                  [else
                   (if (odd? (first lon))
                       (count-odd-even (rest lon)
                                       (make-counts (add1 (counts-odds acc))
                                                    (counts-evens acc)))
                       (count-odd-even (rest lon)
                                       (make-counts (counts-odds acc)
                                                    (add1 (counts-evens acc))))
                       )]))]
    (count-odd-even lon0 (make-counts 0 0))))


