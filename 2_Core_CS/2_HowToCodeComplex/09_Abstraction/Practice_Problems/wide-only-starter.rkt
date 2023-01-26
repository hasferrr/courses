;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname wide-only-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; wide-only-starter.rkt

; 
; PROBLEM:
; 
; Use the built in version of filter to design a function called wide-only 
; that consumes a list of images and produces a list containing only those 
; images that are wider than they are tall.
; 

(define SOLID "solid")
(define COLOR "white")

;; (listof Image) -> (listof Image)
;; produces a list containing only those images that are wider than they are tall
(check-expect (wider-only empty) empty)
(check-expect (wider-only (list (rectangle 50 10 SOLID COLOR)))
              (list (rectangle 50 10 SOLID COLOR)))
(check-expect (wider-only (list (rectangle 50 10 SOLID COLOR)
                                (rectangle 20 80 SOLID COLOR)
                                (rectangle 40 20 SOLID COLOR)))
              (list (rectangle 50 10 SOLID COLOR)
                    (rectangle 40 20 SOLID COLOR)))

;(define (wider-only loi) empty) ;stub

(define (wider-only loi) (local [(define (wider? i) (> (image-width i)
                                                       (image-height i)))]
                           (filter wider? loi)))


