;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname graphs-v2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; graphs-v2.rkt

; 
; PROBLEM: 
; 
; Imagine you are suddenly transported into a mysterious house, in which all
; you can see is the name of the room you are in, and any doors that lead OUT
; of the room.  One of the things that makes the house so mysterious is that
; the doors only go in one direction. You can't see the doors that lead into
; the room.
; 
; Here are some examples of such a house:
; 
;                                       ┌────┐
;                                       ▼    │
;                               ┌─►A───►B───►C
;                               │  │    │
;                               │  └─┐  └─┐
;                     A────►B   │    ▼    ▼
;           ┌─────┐   ▲     │   │    D───►E───►F
;           ▼     │   │     │   │         │
; A────►B   A────►B   └──C◄─┘   └─────────┘
; 
; In computer science, we refer to such an information structure as a directed
; graph. Like trees, in directed graphs the arrows have direction. But in a
; graph it is  possible to go in circles, as in the second example above. It
; is also possible for two arrows to lead into a single node, as in the fourth
; example.
; 
;    
; Design a data definition to represent such houses. Also provide example data
; for the four houses above.
; 

