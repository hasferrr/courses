;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname replicate-elm-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; replicate-elm-starter.rkt

; 
; PROBLEM:
; 
; Design a function that consumes a list of elements and a natural n, and produces 
; a list where each element is replicated n times. 
; 
; (replicate-elm (list "a" "b" "c") 2) should produce (list "a" "a" "b" "b" "c" "c")
; 

;; (listof X) Natural -> (listof X)
;; produces a list where each element is replicated n times
(check-expect (replicate-elm empty 9) empty)
(check-expect (replicate-elm (list "a" "b" "c") 0) empty)
(check-expect (replicate-elm (list "a" "b" "c") 1) (list "a" "b" "c"))
(check-expect (replicate-elm (list "a" "b" "c") 2) (list "a" "a" "b" "b" "c" "c"))
(check-expect (replicate-elm (list "a" "b" "c") 3) (list "a" "a" "a" "b" "b" "b" "c" "c" "c"))

(define (replicate-elm lox0 n)
  ;; acc is Natural; number that indicate (first lox) is replicated
  ;; rsf is (listof X); result replicate so far
  ;; (replicate-elm (list "a" "b" "c") 2)               ;top level call
  ;; (replicate-elm (list "a" "b" "c") 1 empty)         ;local
  ;; (replicate-elm (list "a" "b" "c") 2 (list "a")
  ;; (replicate-elm (list     "b" "c") 1 (list "a" "a")
  ;; (replicate-elm (list     "b" "c") 2 (list "a" "a" "b")
  ;; (replicate-elm (list         "c") 1 (list "a" "a" "b" "b")
  ;; (replicate-elm (list         "c") 2 (list "a" "a" "b" "b" "c" "c")
  (local [(define (replicate-elm-n<=1 lox)
            (cond [(empty? lox) empty]
                  [(zero? n) empty]
                  [(= n 1) lox]
                  [else (replicate-elm lox 1 empty)]))
            
          (define (replicate-elm lox acc rsf)
            (cond [(empty? lox) rsf]
                  [else
                   (if (= acc n)
                       (replicate-elm (rest lox)
                                      1
                                      (append rsf
                                              (list (first lox))))
                       (replicate-elm lox
                                      (add1 acc)
                                      (append rsf
                                              (list (first lox)))))]))]

    (replicate-elm-n<=1 lox0)))

