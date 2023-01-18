;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname sum-odds-tr-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; sum-odds-tr-starter.rkt

; 
; PROBLEM:
; 
; Consider the following function that consumes a list of numbers and produces the sum of 
; all the odd numbers in the list.
; 
; Use an accumulator to design a tail-recursive version of sum-odds.
; 


;; (listof Number) -> Number
;; produce sum of all odd numbers of lon
(check-expect (sum-odds empty) 0) 
(check-expect (sum-odds (list 1 2 5 6 11)) 17) 
#;
(define (sum-odds lon)
  (cond [(empty? lon) 0]
        [else
         (if (odd? (first lon))
             (+ (first lon)
                (sum-odds (rest lon)))
             (sum-odds (rest lon)))]))

(define (sum-odds lon0)
  ;; rsf is Number; sum of all odd numbers seen so far
  (local [(define (sum-odds lon rsf)
            (cond [(empty? lon) rsf]
                  [else
                   (if (odd? (first lon))
                       (sum-odds (rest lon)
                                 (+ (first lon) rsf))
                       (sum-odds (rest lon)
                                 rsf)
                       )]))]
    (sum-odds lon0 0)))




