;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname area-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; area-starter.rkt

 #| 
PROBLEM:

DESIGN a function called area that consumes the length of one side 
of a square and produces the area of the square.

Remember, when we say DESIGN, we mean follow the recipe.

Leave behind commented out versions of the stub and template.
 |# 

 #| The HtDF recipe consists of the following steps:
1. Signature, purpose and stub.
2. Define examples, wrap each in check-expect.
3. Template and inventory.
4. Code the function body.
5. Test and debug until correct |# 

;; Number --> Number
;; menggunakan length of a square, produce area of the square
(check-expect (area 3) 9)
(check-expect (area 2.4) (* 2.4 2.4)) ;example

;(define (area s) 0) ;stub

;(define (area s)    ;template
;  (... s))

(define (area s)
  (* s s))


