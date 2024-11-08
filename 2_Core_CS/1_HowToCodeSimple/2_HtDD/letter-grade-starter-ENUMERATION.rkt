;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname letter-grade-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; letter-grade-starter.rkt

 #| 
PROBLEM:

As part of designing a system to keep track of student grades, you
are asked to design a data definition to represent the letter grade 
in a course, which is one of A, B or C.
   |# 

 #| A data definition consists of four or five elements:
1. A possible "structure definition" (not until compound data)
2. A "type comment" that defines a new type name and describes how to form data of that type.
3. An "interpretation" that describes the correspondence between information and data.
4. One or more "examples" of the data.
5. A "template" for a 1 argument function operating on data of this type. |# 

;; LetterGrade is one of:
;; - "A"
;; - "B"
;; - "C"
;; interp. the letter grade in a course

;; <examples are redundant for enumerations>

#;
(define (fn-for-letter-grade lg)
  (cond [(string=? lg "A") (...)]
        [(string=? lg "B") (...)]
        [(string=? lg "C") (...)]
  )
)

;; Template rules used:
;; - one of: 3 cases
;; - atomic distinct: "A"
;; - atomic distinct: "B"
;; - atomic distinct: "C"


