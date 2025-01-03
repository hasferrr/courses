;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname quidditch-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; quidditch-starter.rkt

 #| 
PROBLEM:

Imagine that you are designing a program that will keep track of
your favorite Quidditch teams. (http://iqasport.org/).

Design a data definition to represent a list of Quidditch teams. 
    |# 

 #| ;Information: 
UBC
MCGILL
no name







 |#   #| ;Data:        
"UBC"
"MCGILL"
"no name"

empty

(cons "UBC"
      (cons "MCGILL"
            (cons "no name"
                  empty)))
 |# 

;; ListOfString is one of:
;; - empty
;; - (cons String ListOfString)
;; interp. a list of string
(define LOS1 empty)
(define LOS2 (cons "MCGILL" empty))
(define LOS3 (cons "UBC" (cons "MCGILL" empty)))

(define (fn-for-los los)
  (cond [(empty? los) (...)]
        [else (... (first los)              ;String
                   (fn-for-los (rest los))) ;ListOfString
              ]
        ))

;; Templates rules used:
;; - one of: 2 cases
;; - atomic distinct: empty
;; - compound: (cons String ListOfString)




 #| 
PROBLEM:

We want to know whether your list of favorite Quidditch teams includes
UBC! Design a function that consumes ListOfString and produces true if 
the list includes "UBC".
 |# 

;; ListOfString -> Boolean
;; produces true if the list includes "UBC", otherwise produce false
(check-expect (include-ubc? empty) false)
(check-expect (include-ubc? (cons "MCGILL" empty)) false)

(check-expect (include-ubc? (cons "UBC" empty)) true)
(check-expect (include-ubc? (cons "PASS" (cons "UBC" empty))) true)

;(define (include-ubc? los) false) ;stub

;Use template from ListOfString

(define (include-ubc? los)
  (cond [(empty? los) false]
        [(string=? (first los) "UBC")
         true]
        [else (include-ubc? (rest los))]
  )
)


