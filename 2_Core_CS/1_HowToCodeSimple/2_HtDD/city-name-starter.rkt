;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname city-name-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; city-name-starter.rkt

 #| 
PROBLEM:

Imagine that you are designing a program that, among other things, 
has information about the names of cities in its problem domain.

Design a data definition to represent the name of a city. 
    |# 

 #| a data definition consists of four or five elements:

1. A possible "structure definition" (not until compound data)
2. A "type comment" that defines a new type name and describes how to form data of that type.
3. An "interpretation" that describes the correspondence between information and data.
4. One or more "examples" of the data.
5. A "template" for a 1 argument function operating on data of this type.

In the first weeks of the course we also ask you to include a list of the
template rules used to form the template. |# 

 #| INFORMATION -> DATA

Vancouver -> "Vancouver"

Boston -> "Boston" |# 

;; CityName is String
;; interp. the name of a city

(define CN1 "Boston")         ;examples
(define CN2 "Vancouver")

#;
(define (fn-for-city-name cn) ;template
  (... cn))

;; Template rules used:
;; - atomic non-distinct: String



