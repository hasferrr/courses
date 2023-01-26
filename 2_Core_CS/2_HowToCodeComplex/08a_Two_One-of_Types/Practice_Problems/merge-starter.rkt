;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname merge-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; merge-starter.rkt

;Problem:
;
;Design the function merge. It consumes two lists of numbers, which it assumes are 
;each sorted in ascending order. It produces a single list of all the numbers, 
;also sorted in ascending order. 
;
;Your solution should explicitly show the cross product of type comments table, 
;filled in with the values in each case. Your final function should have a cond 
;with 3 cases. You can do this simplification using the cross product table by 
;recognizing that there are subtly equal answers. 
;
;Hint: Think carefully about the values of both lists. You might see a way to 
;change a cell content so that 2 cells have the same value.



;                      lon2 | empty |   (cons Number LON)
;      ---------------------|-------|----------------------- 
;              empty        |       |         lon2
; lon1 ---------------------| lon1  |----------------------- 
;        (cons Number LON)  |       |
;      ---------------------|-------|-----------------------
;
; (if (first lon1 < first lon2)
;   (cons (first lon1) (merge (rest lon1) lon2) )
;   (cons (first lon2) (merge (rest lon2) lon1) )
; )


;; ListOfNumbers ListOfNumbers -> ListOfNumbers
;; produces a single list of all the numbers, also sorted in ascending order
(check-expect (merge empty empty) empty)
(check-expect (merge empty (list 2)) (list 2))

(check-expect (merge (list 1) (list 2)) (list 1 2))
(check-expect (merge (list 2) (list 1)) (list 1 2))

(check-expect (merge (list 1) (list 4 5)) (list 1 4 5))
(check-expect (merge (list 1 2) (list 3)) (list 1 2 3))

(check-expect (merge (list 1 3) (list 2 4)) (list 1 2 3 4))
(check-expect (merge (list 5 7) (list 1 9)) (list 1 5 7 9))

;(define (merge lon1 lon2) empty) ;stub

(define (merge lon1 lon2)
  (cond [(empty? lon2) lon1]
        [(empty? lon1) lon2]
        [else
         (if  (< (first lon1) (first lon2))
              (cons (first lon1) (merge (rest lon1) lon2))
              (cons (first lon2) (merge (rest lon2) lon1))
              )]
        ))


