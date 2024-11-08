;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname decreasing-image-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; decreasing-image-starter.rkt

 #| PROBLEM:
 
Design a function called decreasing-image that consumes a Natural n and
produces an image of all the numbers from n to 0 side by side. 

So (decreasing-image 3) should produce #(struct:object:image% ... ...) |# 

;; Natural -> Image
;; produces an image of all the numbers from n to 0 side by side
(check-expect (decreasing-image 0) (text "0" 20 "black"))
(check-expect (decreasing-image 1) (beside (text "1 " 20 "black")
                                           (text "0"  20 "black")))
(check-expect (decreasing-image 2) (beside (text "2 " 20 "black")
                                           (text "1 " 20 "black")
                                           (text "0"  20 "black")))

;(define (decreasing-image n) (square 0 "solid" "black")) ;stub

(define (decreasing-image n)
  (cond [(zero? n) (text (number->string 0) 20 "black")]
        [else
         (beside (text (string-append (number->string n) " ") 20 "black")
                 (decreasing-image (sub1 n))
                 )]
        )
  )





