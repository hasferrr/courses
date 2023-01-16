;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname skipn-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; skipn-starter.rkt

; 
; PROBLEM:
; 
; Design a function that consumes a list of elements lox and a natural number
; n and produces the list formed by including the first element of lox, then 
; skipping the next n elements, including an element, skipping the next n 
; and so on.
; 
;  (skipn (list "a" "b" "c" "d" "e" "f") 2) should produce (list "a" "d")
; 

;; (listof X) Natural -> (listof X)
;; produce list consisting of only the (1st), (1st + n), (1st + n + n)... elements of lox
(check-expect (skipn empty 0) empty)
(check-expect (skipn (list "a" "b" "c" "d" "e" "f") 0) (list "a" "b" "c" "d" "e" "f"))
(check-expect (skipn (list "a" "b" "c" "d" "e" "f") 1) (list "a" "c" "e"))
(check-expect (skipn (list "a" "b" "c" "d" "e" "f") 2) (list "a" "d"))
(check-expect (skipn (list  1   2   3   4   5   6 ) 3) (list  1   5))

;(define (skipn lox n) empty) ;stub

(define (skipn lox0 n)
  ;; acc: Natural[0,n]; the number of elements to skip before including the next one
  ;; (skipn (list "a" "b" "c" "d" "e" "f") 0) -> include
  ;; (skipn (list     "b" "c" "d" "e" "f") 2)
  ;; (skipn (list         "c" "d" "e" "f") 1)
  ;; (skipn (list             "d" "e" "f") 0) -> include
  ;; (skipn (list                 "e" "f") 2)
  ;; (skipn (list                     "f") 1)
  (local [(define (skipn lox acc)
            (cond [(empty? lox) empty]
                  [else
                   (if (= acc 0)
                       (cons (first lox)
                             (skipn (rest lox)
                                    n))
                       (skipn (rest lox)
                              (- acc 1))
                       )]
                  ))]
    (skipn lox0 0)))

#;
(define (skipn lox0 n)
  ;; acc: Natural[0,n]; the number of elements to skip before including the next one
  ;; (skipn (list "a" "b" "c" "d" "e" "f") 2) -> include
  ;; (skipn (list     "b" "c" "d" "e" "f") 0)
  ;; (skipn (list         "c" "d" "e" "f") 1)
  ;; (skipn (list             "d" "e" "f") 2) -> include
  ;; (skipn (list                 "e" "f") 0)
  ;; (skipn (list                     "f") 1)
  (local [(define (skipn lox acc)
            (cond [(empty? lox) empty]
                  [else
                   (if (= acc n)
                       (cons (first lox)
                             (skipn (rest lox)
                                    0))
                       (skipn (rest lox)
                              (+ acc 1))
                       )]
                  ))]
    (skipn lox0 n)))

#;
(define (skipn lox n)
  (cond [(empty? lox) (... n)]
        [else
         (... n
              (first lox)
              (skipn (rest lox)
                     (... n)))]))






