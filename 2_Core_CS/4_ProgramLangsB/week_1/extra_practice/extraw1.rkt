
#lang racket
(provide (all-defined-out))


;; Helper functions
(define ones (lambda () (cons 1 ones)))
(define nats
  (letrec ([f (lambda (x) (cons x (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))
(define powers-of-two
  (letrec ([f (lambda (x) (cons x (lambda () (f (* x 2)))))])
    (lambda () (f 2))))


;; Stream -> Pair
;; fibonacci stream
(define (fibonacci)
  ;; acc is pair of the previous elements; (n-2, n-1)
  (local [(define (f acc)
            (define 1st (car acc))
            (define 2nd (cdr acc))
            (define sum (+ 1st 2nd))
            (cons sum (lambda () (f (cons 2nd sum)))))]
    (cons 0 (lambda () (f (cons 1 0))))))

;check
(printf "fibonacci\n")
(= (car(fibonacci)) 0)                                    ;init
(= (car((cdr(fibonacci)))) 1)                             ;1 (1 0)
(= (car((cdr((cdr(fibonacci)))))) 1)                      ;1 (0 1)
(= (car((cdr((cdr((cdr(fibonacci)))))))) 2)               ;2 (1 1)
(= (car((cdr((cdr((cdr((cdr(fibonacci)))))))))) 3)        ;3 (1 2)
(= (car((cdr((cdr((cdr((cdr((cdr(fibonacci)))))))))))) 5) ;5 (2 3)


;; Function Stream -> Pair
;; applies f to the values of s in succession until f evaluates to #f
(define (stream-until f s)
  (local [(define res (s))]
    (if (f (car res))
        (stream-until f (cdr res))
        res)))

;check
(printf "stream-until\n")
(= (car (stream-until (lambda (x) (= x 0))
                      ones))
   1)
(= (car (stream-until (lambda (x) (< x 5))
                      nats))
   5)
(= (car (stream-until (lambda (x) (< x 1025))
                      powers-of-two))
   2048)


;; Function Stream -> Stream
;; applies f to the values of s in succession until f evaluates to #f
(define (stream-map f s)
  (local [(define res (s))]
    (cons (f (car res)) (cdr res))))

;check
(printf "stream-map\n")
(string=? (car (stream-map number->string ones))
          "1")
(= (car (stream-map (lambda (x) (* x 10))
                    (cdr (nats))))
   20)


;; Stream Stream -> Stream
;; produces the pairs that result from the other two streams
(define (stream-zip s1 s2)
  (local [(define res1 (s1))
          (define res2 (s2))]
    (cons (cons (car res1)
                (car res2))
          (lambda () (stream-zip (cdr res1)
                                 (cdr res2))))))

;check
(printf "stream-zip\n")
(equal? (car (stream-zip ones nats))
        (cons 1 1))
(equal? (car (stream-zip ones (cdr(nats))))
        (cons 1 2))
(equal? (car (stream-zip (cdr((cdr((cdr((cdr((cdr(fibonacci)))))))))) fibonacci))
        (cons 5 0))


;; (listof Stream) -> Stream
;; produces a new stream that takes one element from each stream in sequence
(define (interleave lost)
  (local [(define (f lost newlost)
            (cond [(null? lost) (f newlost null)]
                  [else
                   (define res ((car lost)))
                   (cons (car res)
                         (lambda () (f (cdr lost)
                                       (append newlost (list (cdr res))))))]))]
    (lambda () (f lost null))))

