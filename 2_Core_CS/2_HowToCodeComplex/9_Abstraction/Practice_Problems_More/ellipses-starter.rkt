;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ellipses-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; ellipses-starter.rkt

;; =================
;; Constants:

(define BLANK (square 0 "outline" "white"))

;; =================
;; Functions:

; 
; PROBLEM A:
; 
; Use build-list to write an expression (an expression, not a function) to 
; produce a list of 20 ellipses ranging in width from 0 to 19.
; 
; NOTE: Assuming n refers to a number, the expression 
; (ellipse n (* 2 n) "solid" "blue") will produce an ellipse twice as tall 
; as it is wide.
; 


(build-list 20 identity)

; 
; PROBLEM B:
; 
; Write an expression using one of the other built-in abstract functions
; to put the ellipses beside each other in a single image like this: 
; 
; .
; 
; HINT: If you are unsure how to proceed, first do part A, and then design a 
; traditional function operating on lists to do the job. Then think about 
; which abstract list function to use based on that.
; 


(define list-of-ellipses-img (local [(define (create-ellipses n)
                                               (ellipse n (* 2 n) "solid" "blue"))]
                                       (map create-ellipses (build-list 20 identity))))
(foldr beside empty-image list-of-ellipses-img)

; 
; PROBLEM C:
; 
; By just using a different built in list function write an expression 
; to put the ellipses beside each other in a single image like this:
; 
; .
; 


(foldl beside empty-image list-of-ellipses-img)
