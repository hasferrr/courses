;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname accumulators-quiz) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;_____________________________________________________________________________________
;
;  PROBLEM 1:
;  
;  Assuming the use of at least one accumulator, design a function that consumes a
;  list of strings, and produces the length of the longest string in the list. 
;_____________________________________________________________________________________

;; (listof String) -> Natural
;; produces the length of the longest string in the list
(check-expect (longest empty) 0)
(check-expect (longest (list "1" "a")) 1)
(check-expect (longest (list "12" "abc")) 3)
(check-expect (longest (list "1" "ab" "abc")) 3)
(check-expect (longest (list "123" "654321" "qwert")) 6)

;(define (longest los) 0)

(define (longest los0)
  ;; result is Natural; length of the longest list of strings seen so far
  ;; (longest (list "123" "654321" "qwert"))
  ;; (longest (list "123" "654321" "qwert") 0)
  ;; (longest (list       "654321" "qwert") 3)
  ;; (longest (list                "qwert") 6)
  ;; (longest (list                       ) 6)
  (local [(define (longest los result)
            (cond [(empty? los) result]
                  [else
                   (local [(define len (string-length (first los)))]
                     (if (> len result)
                         (longest (rest los) len)
                         (longest (rest los) result)
                         ))]))]
    (longest los0 0)))


;_____________________________________________________________________________________
;
;  PROBLEM 2:
;  
;  The Fibbonacci Sequence https://en.wikipedia.org/wiki/Fibonacci_number is 
;  the sequence 0, 1, 1, 2, 3, 5, 8, 13,... where the nth element is equal to 
;  n-2 + n-1. 
;  
;  Design a function that given a list of numbers at least two elements long, 
;  determines if the list obeys the fibonacci rule, n-2 + n-1 = n, for every 
;  element in the list. The sequence does not have to start at zero, so for 
;  example, the sequence 4, 5, 9, 14, 23 would follow the rule. 
;_____________________________________________________________________________________

;; (listof Numbers) -> Boolean
;; produce true if the list obeys the fibonacci rule (n-2 + n-1 = n)
;; (does not have to start at zero)
;; Assume: list of numbers at least two elements long
;; Assume: allow random number in 1st and 2nd element
(check-expect (is-fibbonacci? (list 0 1)) true)
(check-expect (is-fibbonacci? (list 0 1 1 2 3 5 8 13)) true)
(check-expect (is-fibbonacci? (list 4 5 9 14 23)) true)
(check-expect (is-fibbonacci? (list 0 1 1 2 3 6 8 13)) false)

;(define (is-fibbonacci? lon) false)

(define (is-fibbonacci? lon0)
  ;; n-2 is Natural; value of element at position - 2 in the list
  ;; n-1 is Natural; value of element at position - 2 in the list
  ;; pos is Natural; position of the element in the list start at 1
  (local [(define (is-fibbonacci? lon n-2 n-1 pos)
            (cond [(empty? lon) true]
                  [else
                   (if (>= pos 3)
                       (if (= (first lon) (+ n-2 n-1))
                           (is-fibbonacci? (rest lon)
                                           n-1
                                           (first lon)
                                           (add1 pos))
                           false)
                       (is-fibbonacci? (rest lon)
                                       n-2
                                       n-1
                                       (add1 pos)))
                   ]))]
    (is-fibbonacci? lon0 (first lon0) (first (rest lon0)) 1)))


;_____________________________________________________________________________________
;
;  PROBLEM 3:
;  
;  Refactor the function below to make it tail recursive.  
;_____________________________________________________________________________________


;; Natural -> Natural
;; produces the factorial of the given number
(check-expect (fact 0) 1)
(check-expect (fact 3) 6)
(check-expect (fact 5) 120)

#;
(define (fact n)
  (cond [(zero? n) 1]
        [else 
         (* n (fact (sub1 n)))]))

(define (fact n0)
  (local [(define (fact n total)
            (cond [(zero? n) total]
                  [else 
                   (fact (sub1 n) (* n total))]))]
    (fact n0 1)))


;_____________________________________________________________________________________
;
;  PROBLEM 4:
;  
;  Recall the data definition for Region from the Abstraction Quiz. Use a worklist 
;  accumulator to design a tail recursive function that counts the number of regions 
;  within and including a given region. 
;  So (count-regions CANADA) should produce 7
;_____________________________________________________________________________________

(define-struct region (name type subregions))
;; Region is (make-region String Type (listof Region))
;; interp. a geographical region

;; Type is one of:
;; - "Continent"
;; - "Country"
;; - "Province"
;; - "State"
;; - "City"
;; interp. categories of geographical regions

(define VANCOUVER (make-region "Vancouver" "City" empty))
(define VICTORIA (make-region "Victoria" "City" empty))
(define BC (make-region "British Columbia" "Province" (list VANCOUVER VICTORIA)))
(define CALGARY (make-region "Calgary" "City" empty))
(define EDMONTON (make-region "Edmonton" "City" empty))
(define ALBERTA (make-region "Alberta" "Province" (list CALGARY EDMONTON)))
(define CANADA (make-region "Canada" "Country" (list BC ALBERTA)))

#;
(define (fn-for-region r)
  (local [(define (fn-for-region r)
            (... (region-name r)
                 (fn-for-type (region-type r))
                 (fn-for-lor (region-subregions r))))
          
          (define (fn-for-type t)
            (cond [(string=? t "Continent") (...)]
                  [(string=? t "Country") (...)]
                  [(string=? t "Province") (...)]
                  [(string=? t "State") (...)]
                  [(string=? t "City") (...)]))
          
          (define (fn-for-lor lor)
            (cond [(empty? lor) (...)]
                  [else 
                   (... (fn-for-region (first lor))
                        (fn-for-lor (rest lor)))]))]
    (fn-for-region r)))



;; Region -> Natural
;; produce (counts) the number of regions within and including a given region.
(check-expect (count-regions CANADA) 7)
(check-expect (count-regions VICTORIA) 1)

;(define (count-regions r) 0)

(define (count-regions r)
  ;; rsf  is         Natural; the numbers of how many regions seen so far
  ;; todo is (listof Region); region needs to visit to fn-for-region
  (local [(define (fn-for-region r todo rsf)
            (fn-for-lor (append todo (region-subregions r))
                        (add1 rsf)))
          
          (define (fn-for-lor lor rsf)
            (cond [(empty? lor) rsf]
                  [else 
                   (fn-for-region (first lor)
                                  (rest lor)
                                  rsf)
                   ]))]
    (fn-for-region r empty 0)))


