;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname rocket-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; rocket-starter.rkt

;; =================
;; Data definitions:

 #| 
PROBLEM A:

You are designing a program to track a rocket's journey as it descends 
100 kilometers to Earth. You are only interested in the descent from 
100 kilometers to touchdown. Once the rocket has landed it is done.

Design a data definition to represent the rocket's remaining descent. 
Call it RocketDescent.
 |# 

 #| A data definition consists of four or five elements:
1. A possible "structure definition" (not until compound data)
2. A "type comment" that defines a new type name and describes how to form data of that type.
3. An "interpretation" that describes the correspondence between information and data.
4. One or more "examples" of the data.
5. A "template" for a 1 argument function operating on data of this type. |# 

;; RocketDescent is one of:
;; - Natural[1,100]
;; - "landed"

;; interp.
;;  Number[1,100] means the rocket distance from earth in kilometer
;;  "landed"      means the rocket has landed and it is done

(define RD1 50)
(define RD2 "landed")

#;
(define (fn-for-rocket-descent rd)
  (cond [(and (number?) (>= rd 1) (<= rd 100)) (... rd)]
        [else (...)]
        )
  )

;; Template rules used:
;; - one of: 2 cases
;; - atomic non-distinct: Natural[1,100]
;; - atomic distinct: "landed"

;; =================
;; Functions:

 #| 
PROBLEM B:

Design a function that will output the rocket's remaining descent distance 
in a short string that can be broadcast on Twitter. 
When the descent is over, the message should be "The rocket has landed!".
Call your function rocket-descent-to-msg.
 |# 

;; RocketDescent -> String
;; produce rocket's remaining descent distance in a short string that can be broadcast on Twitter
(check-expect (rocket-descent-to-msg 1) (string-append "Remaining distance is " "1" " kilometer"))
(check-expect (rocket-descent-to-msg 50) (string-append "Remaining distance are " "50" " kilometers"))
(check-expect (rocket-descent-to-msg "landed") "The rocket has landed!")

;(define (rocket-descent-to-msg rd) "") ;stub

; <Template from RocketDescent>

(define (rocket-descent-to-msg rd)
  (cond [(and (number? rd) (= rd 1)) (string-append "Remaining distance is " (number->string rd) " kilometer")]
        [(number? rd) (string-append "Remaining distance are " (number->string rd) " kilometers")]
        [else "The rocket has landed!"]
        )
  )


