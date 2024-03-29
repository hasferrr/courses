;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname cat-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; cat-starter.rkt

 #| 
PROBLEM:

Use the How to Design Worlds recipe to design an interactive
program in which a cat starts at the left edge of the display 
and then walks across the screen to the right. When the cat
reaches the right edge it should just keep going right off 
the screen.

Once your design is complete revise it to add a new feature,
which is that pressing the space key should cause the cat to
go back to the left edge of the screen. When you do this, go
all the way back to your domain analysis and incorporate the
new feature.

To help you get started, here is a picture of a cat, which we
have taken from the 2nd edition of the How to Design Programs 
book on which this course is based.

"Image removed"
 |# 

 #| World program design is divided into two phases, each of which has sub-parts:
1. Domain analysis (use a piece of paper!)
    (a) "Sketch" program scenarios
    (b) Identify "constant" information
    (c) Identify "changing" information
    (d) Identify "big-bang options"
2. Build the actual program
    (a) "Constants" (based on item 1b above)
    (b) "Data definitions" using How To Design Data (HTDD) (based on item 1c above)
(c) "Functions" using How To Design Functions (HtDF)
        i. "main" first (based on item 1c, item 1d and item 2b above)
        ii. "wish list" entries for big-bang handlers
    (d) Work through "wish list until done" |# 

(require 2htdp/image)
(require 2htdp/universe)

;; A cat that walk from left to right across the screen

 #| picture from lecture video
"Image removed" |# 

;; =================
;; Constants:

(define WIDTH 600)
(define HEIGHT 400)

(define CENTER-Y (/ HEIGHT 2))

(define MTS (empty-scene WIDTH HEIGHT "midnight blue")) ;background

(define CAT-IMG "Image removed")


;; =================
;; Data definitions:

;; Cat is Number
;; interp. x-coordinate of the cat in screen coordinates

(define C1 0)
(define C2 (/ WIDTH 2))
(define C3 WIDTH)
#;
(define (fn-for-cat c)
  (... c))

;; Template rules used:
;; - atomic non-distinct: Number


;; =================
;; Functions:

;; Cat -> Cat
;; start the world with (main 0)
;; 
(define (main c)
  (big-bang c                         ; Cat
            (on-tick advance-cat)     ; Cat -> Cat
            (to-draw render)))        ; Cat -> Image


;; Cat -> Cat
;; produce the next cat, by advancing it 1px to right
(check-expect (advance-cat 5) 6)

;(define (advance-cat c) 0) ;stub

;<use template from Cat>

(define (advance-cat c)
  (+ 1 c))


;; Cat -> Image
;; render the cat image at appropriate place on MTS (background image)
(check-expect (render 5) (place-image CAT-IMG 5 CENTER-Y MTS))
(check-expect (render 6) (place-image CAT-IMG 6 CENTER-Y MTS))

;(define (render c) MTS) ;stub

;<use template from Cat>

(define (render c)
  (place-image CAT-IMG c CENTER-Y MTS))



