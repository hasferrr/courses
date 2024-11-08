;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname yell-all-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; yell-all-starter.rkt

;; =================
;; Data definitions:

 #| 
Remember the data definition for a list of strings we designed in Lecture 5c:
(if this data definition does not look familiar, please review the lecture)
 |# 

;; ListOfString is one of: 
;;  - empty
;;  - (cons String ListOfString)
;; interp. a list of strings

(define LS0 empty) 
(define LS1 (cons "a" empty))
(define LS2 (cons "a" (cons "b" empty)))
(define LS3 (cons "c" (cons "b" (cons "a" empty))))

#;
(define (fn-for-los los) 
  (cond [(empty? los) (...)]
        [else
         (... (first los)
              (fn-for-los (rest los)))]))

;; Template rules used: 
;; - one of: 2 cases
;; - atomic distinct: empty
;; - compound: (cons String ListOfString)
;; - self-reference: (rest los) is ListOfString

;; =================
;; Functions:

 #| 
PROBLEM:

Design a function that consumes a list of strings and "yells" each word by 
adding "!" to the end of each string.
 |# 

;; ListOfString -> ListOfString
;; produce the same ListOfString but adding "!" to the end of each string
(check-expect (yells empty) empty)
(check-expect (yells (cons "a" empty)) (cons "a!" empty))
(check-expect (yells (cons "efg" (cons "abc" empty))) (cons "efg!" (cons "abc!" empty)))

;(define (yells los) LS1) ;stub

; Use template from ListOfString

(define (yells los) 
  (cond [(empty? los) empty]
        [else
         (cons (string-append (first los) "!")
               (yells (rest los))
         )]))












