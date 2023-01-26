
;; prefix-equal-starter.rkt

; PROBLEM: design a function that consumes two lists of strings and produces true
; if the first list is a prefix of the second. Prefix means that the elements of
; the first list match the elements of the second list 1 for 1, and the second list
; is at least as long as the first.
;
; For reference, the ListOfString data definition is provided below.

;; =================
;; Data Definitions:

;; ListOfString is one of:
;; - empty
;; - (cons String ListOfString)
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

;; ==========
;; Functions:

;; ListOfString ListOfString -> Boolean
;; produce true if lsta is a prefix of lstb
(check-expect (prefix=? empty empty) true)
(check-expect (prefix=? (list "x") empty) false)
(check-expect (prefix=? empty (list "x")) true)

(check-expect (prefix=? (list "x") (list "x")) true)
(check-expect (prefix=? (list "x") (list "y")) false)
(check-expect (prefix=? (list "x" "y") (list "x" "y")) true)
(check-expect (prefix=? (list "x" "x") (list "x" "y")) false)
(check-expect (prefix=? (list "x") (list "x" "y")) true)
(check-expect (prefix=? (list "x" "y" "z") (list "x" "y")) false)

;(define (prefix=? lsta lstb) false) ;stub

;(define (prefix=? lsta lstb)
;  (cond [(empty? lsta) true]
;        [(empty? lstb) false]
;        [else
;         (... (first lsta)
;              (prefix=? (rest lsta) ...)
;              (first lstb)
;              (prefix=? ... (rest lstb))
;              )]
;        ))

(define (prefix=? lsta lstb)
  (cond [(empty? lsta) true]
        [(empty? lstb) false]
        [else
         (and (string=? (first lsta)
                        (first lstb))
              (prefix=? (rest lsta) (rest lstb))
              )]
        ))


