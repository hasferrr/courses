;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname dropn-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; dropn-starter.rkt

; 
; PROBLEM:
; 
; Design a function that consumes a list of elements lox and a natural number
; n and produces the list formed by dropping every nth element from lox.
; 
; (dropn (list 1 2 3 4 5 6 7) 2) should produce (list 1 2 4 5 7)
; 

;; (listof X) Natural -> (listof X)
;; produces the list formed by dropping every nth element from lox
(check-expect (dropn empty 0) empty)
(check-expect (dropn (list 1 2 3 4 5 6 7) 0) empty)
(check-expect (dropn (list 1 2 3 4 5 6 7) 2) (list 1 2 4 5 7))

;(define (dropn lox n) empty)

(define (dropn lox0 n)
  ;; acc is Natural; current possition of list
  ;;  top level call:
  ;; (dropn (list 1 2 3 4 5 6 7) 2)
  ;;  local:
  ;; (dropn (list 1 2 3 4 5 6 7) 0)
  ;; (dropn (list   2 3 4 5 6 7) 1)
  ;; (dropn (list     3 4 5 6 7) 2) ;drop
  ;; (dropn (list       4 5 6 7) 0)
  ;; (dropn (list         5 6 7) 1)
  ;; (dropn (list           6 7) 2) ;drop
  ;; ...
  (local [(define (dropn lox acc)
            (cond [(empty? lox) empty]
                  [else
                   (if (= acc n)
                       (dropn (rest lox) 0)
                       (cons (first lox) (dropn (rest lox) (add1 acc)))
                       )]))]
    (dropn lox0 0)))


