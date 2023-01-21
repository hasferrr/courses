;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname merge-sort) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; merge sort

;; (listof Number) -> (listof Number)
;; produce sorted list in ascending order using merge sort
(check-expect (merge-sort empty) empty)
(check-expect (merge-sort (list 2)) (list 2))
(check-expect (merge-sort (list 2 3)) (list 2 3))
(check-expect (merge-sort (list 6 3)) (list 3 6))
(check-expect (merge-sort (list 6 5 3 1 8 7 2 4)) (list 1 2 3 4 5 6 7 8))

;(define (merge-sort lon) lon)

;; template according to generative recorsion

(define (merge-sort lon)
  (cond [(empty? lon) empty]
        [(empty? (rest lon)) lon]
        [else
         (merge (merge-sort (take lon (quotient (length lon) 2)))
                (merge-sort (drop lon (quotient (length lon) 2)))
                )]))


;; (listof Number) (listof Number) -> (listof Number)
;; produces merge 2 lists into 1 list in by comparing the first element of those lon
(check-expect (merge empty empty) empty)
(check-expect (merge (list 2) empty) (list 2))
(check-expect (merge empty (list 3)) (list 3))
(check-expect (merge (list 4) (list 3)) (list 3 4))
(check-expect (merge (list 5 6) (list 7 8)) (list 5 6 7 8))
(check-expect (merge (list 3 7) (list 6 1)) (list 3 6 1 7))

(define (merge lon1 lon2)
  (cond [(empty? lon1) lon2]
        [(empty? lon2) lon1]
        [else
         (if (< (first lon1) (first lon2))
             (cons (first lon1) (merge (rest lon1) lon2))
             (cons (first lon2 )(merge lon1 (rest lon2)))
             )]))


;; (listof Number) Natural -> (listof Number)
;; produce only list 0 to n element of the list
(check-expect (take empty 2) empty)
(check-expect (take (list 6 5 3 1 8 7 2 4) 4) (list 6 5 3 1))
(check-expect (take (list 6 5 3 1 8 7 2) 3) (list 6 5 3))

;(define (take lon n) empty)

(define (take lon0 n)
  (local [(define (take lon count)
            (cond [(empty? lon) empty]
                  [else
                   (if (<= count n)
                       (cons (first lon) (take (rest lon) (add1 count)))
                       empty
                       )]))]
    (take lon0 1)))


;; (listof Number) Natural -> (listof Number)
;; produce list no contains 0 to n element of the list
(check-expect (drop empty 2) empty)
(check-expect (drop (list 6 5 3 1 8 7 2 4) 4) (list 8 7 2 4))
(check-expect (drop (list 6 5 3 1 8 7 2) 3) (list 1 8 7 2))

;(define (drop lon n) empty)

(define (drop lon0 n)
  (local [(define (drop lon count)
            (cond [(empty? lon) empty]
                  [else
                   (if (< count n)
                       (drop (rest lon) (add1 count))
                       (rest lon)
                       )]))]
    (drop lon0 1)))
