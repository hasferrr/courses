;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname average-tr-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; average-starter.rkt

; 
; PROBLEM:
; 
; Design a function called average that consumes (listof Number) and produces the
; average of the numbers in the list.
; 

;; (listof Number) -> Natural
;; produce average of the numbers in the list
;; Assume: (listof Number) contains at leats 1 number
(check-expect (average (list 1)) 1)
(check-expect (average (list 9)) 9)
(check-expect (average (list 4 6)) 5)
(check-expect (average (list 1 2 3)) 2)
(check-expect (average (list 1 3 7)) (/ (+ 1 3 7) 3))

;(define (average lon) 0)

(define (average lon0)
  ;; total is sum of number in the list so far
  ;; n     is how many number in the list so far
  (local [(define (average lon total n)
            (cond [(empty? lon) (/ total n)]
                  [else
                   (average (rest lon)
                            (+ (first lon) total)
                            (add1 n))
                   ]))]
    (average lon0 0 0)))


