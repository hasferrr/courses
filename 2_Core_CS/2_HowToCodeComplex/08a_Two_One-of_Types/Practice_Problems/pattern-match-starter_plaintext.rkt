
;; pattern-match-starter.rkt

; Problem:
;
; It is often useful to be able to tell whether the first part of a sequence of
; characters matches a given pattern. In this problem you will design a (somewhat
; limited) way of doing this.
;
; Assume the following type comments and examples:


;; =================
;; Data Definitions:

;; 1String is String
;; interp. these are strings only 1 character long
(define 1SA "x")
(define 1SB "2")

;; Pattern is one of:
;;  - empty
;;  - (cons "A" Pattern)
;;  - (cons "N" Pattern)
;; interp.
;;   A pattern describing certain ListOf1String.
;;  "A" means the corresponding letter must be alphabetic.
;;  "N" means it must be numeric.  For example:
;;      (list "A" "N" "A" "N" "A" "N")
;;   describes Canadian postal codes like:
;;      (list "V" "6" "T" "1" "Z" "4")
(define PATTERN1 (list "A" "N" "A" "N" "A" "N"))

;; ListOf1String is one of:
;;  - empty
;;  - (cons 1String ListOf1String)
;; interp. a list of strings each 1 long
(define LOS1 (list "V" "6" "T" "1" "Z" "4"))

;
; Now design a function that consumes Pattern and ListOf1String and produces true
; if the pattern matches the ListOf1String. For example,
;
; (pattern-match? (list "A" "N" "A" "N" "A" "N")
;                 (list "V" "6" "T" "1" "Z" "4"))
;
; should produce true. If the ListOf1String is longer than the pattern, but the
; first part matches the whole pattern produce true. If the ListOf1String is
; shorter than the Pattern you should produce false.
;
; Treat this as the design of a function operating on 2 complex data. After your
; signature and purpose, you should write out a cross product of type comments
; table. You should reduce the number of cases in your cond to 4 using the table,
; and you should also simplify the cond questions using the table.
;
; You should use the following helper functions in your solution:
;


;; ==========
;; Functions:

;; 1String -> Boolean
;; produce true if 1s is alphabetic/numeric
(check-expect (alphabetic? " ") false)
(check-expect (alphabetic? "1") false)
(check-expect (alphabetic? "a") true)
(check-expect (numeric? " ") false)
(check-expect (numeric? "1") true)
(check-expect (numeric? "a") false)

(define (alphabetic? 1s) (char-alphabetic? (string-ref 1s 0)))
(define (numeric?    1s) (char-numeric?    (string-ref 1s 0)))

; .


;; ==========

;; Pattern ListOf1String -> Boolean
;; produce true if the pattern matches the ListOf1String
(check-expect (pattern-match? empty empty) true)
(check-expect (pattern-match? empty (list "a" "2")) true)
(check-expect (pattern-match? empty (list "a" "2")) true)
(check-expect (pattern-match? (list "A") empty) false)
(check-expect (pattern-match? (list "N" "A") empty) false)

(check-expect (pattern-match? (list "A") (list "c")) true)
(check-expect (pattern-match? (list "A") (list "3")) false)

(check-expect (pattern-match? (list "N") (list "c")) false)
(check-expect (pattern-match? (list "N") (list "3")) true)

(check-expect (pattern-match? (list "A" "N") (list "d" "4")) true)
(check-expect (pattern-match? (list "A" "N") (list "d" "e")) false)
(check-expect (pattern-match? (list "A" "N") (list "d" "4" "f")) true)
(check-expect (pattern-match? (list "A" "N") (list "d" "e" "f")) false)

;(define (pattern-match? p lo1s) false) ;stub

(define (pattern-match? p lo1s)
  (cond [(empty? p) true]
        [(empty? lo1s) false]
        [(string=? (first p) "A") (and (alphabetic? (first lo1s))
                                       (pattern-match? (rest p) (rest lo1s))
                                       )]
        [(string=? (first p) "N") (and (numeric? (first lo1s))
                                       (pattern-match? (rest p) (rest lo1s))
                                       )]
        ))
