;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname largest-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; largest-starter.rkt

;; =================
;; Data definitions:

 #| 
Remember the data definition for a list of numbers we designed in Lecture 5f:
(if this data definition does not look familiar, please review the lecture)
 |# 

;; ListOfNumber is one of:
;;  - empty
;;  - (cons Number ListOfNumber)
;; interp. a list of numbers
(define LON1 empty)
(define LON2 (cons 60 (cons 42 empty)))
#;
(define (fn-for-lon lon)
  (cond [(empty? lon) (...)]
        [else
         (... (first lon)
              (fn-for-lon (rest lon)))]))

;; Template rules used:
;;  - one of: 2 cases
;;  - atomic distinct: empty
;;  - compound: (cons Number ListOfNumber)
;;  - self-reference: (rest lon) is ListOfNumber

;; =================
;; Functions:

 #| 
PROBLEM:

Design a function that "consumes" a list of numbers and "produces" the largest number 
in the list. You may "assume that" all numbers in the list are greater than 0. If
the list is empty, produce 0.
 |# 

;; ListOfNumber -> Number
;; produces the largest number in the list. If the list is empty, produce 0
(check-expect (lagerst-number empty) 0)
(check-expect (lagerst-number (cons 2 empty)) 2)
(check-expect (lagerst-number (cons 4 (cons 3 empty))) 4)
(check-expect (lagerst-number (cons 5 (cons 5 empty))) 5)
(check-expect (lagerst-number (cons 40 (cons 30 (cons 20 empty)))) 40)
(check-expect (lagerst-number (cons 20 (cons 40 (cons 30 empty)))) 40)
(check-expect (lagerst-number (cons 20 (cons 30 (cons 40 empty)))) 40)
(check-expect (lagerst-number (cons 30 (cons 20 (cons 40 empty)))) 40)

;(define (lagerst-number lon) 0) ;stub

;Use Template from ListOfNumber

(define (lagerst-number lon)
  (cond [(empty? lon) 0]
        [else
          (if  (>= (first lon) (lagerst-number (rest lon)))
               (first lon)
               (lagerst-number (rest lon))
          )]
  )
)


