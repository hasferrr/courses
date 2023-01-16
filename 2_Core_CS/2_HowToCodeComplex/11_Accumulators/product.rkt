;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname product) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Functions:

;; (list Number) -> Number
;; produce product of all elements in lon
(check-expect (product empty) 0)
(check-expect (product (list 2 4 5)) 40)

;(define (product lon) 0)

(define (product lon0)
  ;; acc: Number; the product of the elements seen so far
  ;; (product (list 2 4 5))
  ;; (product (list 2 4 5)  1)
  ;; (product (list   4 5)  2)
  ;; (product (list     5)  8)
  ;; (product (list      ) 40)
  (local [(define (product lon acc)
            (cond [(empty? lon) acc]
                  [else
                   (product (rest lon)
                            (* acc
                               (first lon))
                            )]
                  ))]
    (if (not (empty? lon0)) (product lon0 1) 0)))




