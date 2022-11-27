;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname evaluate-boo-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; evaluate-boo-starter.rkt

;_________________________________________________________________________
; 
; Given the following function definition:
; 
; (define (boo x lon)
;   (local [(define (addx n) (+ n x))]
;     (if (zero? x)
;         empty
;         (cons (addx (first lon))
;               (boo (sub1 x) (rest lon)))))) 
;_________________________________________________________________________

;_________________________________________________________________________
; 
; PROBLEM A:
; 
; What is the value of the following expression:
; 
; (boo 2 (list 10 20))
; 
; NOTE: We are not asking you to show the full step-by-step evaluation for 
; this problem, but you may want to sketch it out to help you get these 
; questions right.
;_________________________________________________________________________

(define (boo x lon)
  (local [(define (addx n) (+ n x))]
    (if (zero? x)
        empty
        (cons (addx (first lon))
              (boo (sub1 x) (rest lon))))))

(boo 2 (list 10 20))

(local [(define (addx n) (+ n 2))] ;1
  (if (zero? 2)
      empty
      (cons (addx 10)
            (boo 1 (cons 20 empty)))))

(cons 12 (boo 1 (cons 20 empty)))

(cons 12 (if (zero? 1)
             empty
             (cons 21 ;2
                   (boo (sub1 1) empty))))

(cons 12 (cons 21 (boo 0 empty)))

(cons 12 (cons 21 (local [(define (addx n) (+ n 0))]
                    (if (zero? 0)
                        empty
                        (cons (addx (first empty))
                              (boo -1 (rest empty)))))))

(cons 12 (cons 21 (if (zero? 0)
                      empty
                      (cons (+ (first empty) 0) ;3
                            (boo -1 (rest empty))))))

(cons 12 (cons 21 empty))

;; Therefore, the value of the (boo 2 (list 10 20)) expression is
(list 12 21)

;_________________________________________________________________________
; 
; PROBLEM B:
; 
; How many function definitions are lifted during the evaluation of the 
; expression in part A.
;_________________________________________________________________________

3

;_____________________________________________________________________________
; 
; PROBLEM C:
; 
; Write out the lifted function definition(s). Just the actual lifted function 
; definitions. 
;_____________________________________________________________________________

(define (addx_0 n) (+ n 2))
(define (addx_1 n) (+ n 1))
(define (addx_2 n) (+ n 0))





