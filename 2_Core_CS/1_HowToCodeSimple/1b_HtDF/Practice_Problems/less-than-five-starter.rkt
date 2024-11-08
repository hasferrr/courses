;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname less-than-five-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; less-than-five-starter.rkt

 #| 
PROBLEM:

DESIGN function that consumes a string and determines whether its length is
less than 5.  Follow the HtDF recipe and leave behind commented out versions 
of the stub and template.
 |# 

;; String -> Boolean
;; produce true if string length is less than 5

;examples
(check-expect (is_less_5 "aa") true)
(check-expect (is_less_5 "12345") false)
(check-expect (is_less_5 "more than 5 chars") false)
(check-expect (is_less_5 "") false)

;(define (is_less_5 str) false) ;stub

;(define (is_less_5 str) ;temp
;  (... str))

(define (is_less_5 str)
  (< (string-length str) 5)
)


