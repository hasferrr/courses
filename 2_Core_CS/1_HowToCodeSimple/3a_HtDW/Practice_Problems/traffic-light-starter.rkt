;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname traffic-light-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; traffic-light-starter.rkt

 #| 
PROBLEM:

Design an animation of a traffic light. 

Your program should show a traffic light that is red, then green, 
then yellow, then red etc. For this program, your changing world 
state data definition should be an enumeration.

Here is what your program might look like if the initial world 
state was the red traffic light:
#(struct:object:image% ... ...)
Next:
#(struct:object:image% ... ...)
Next:
#(struct:object:image% ... ...)
Next is red, and so on.

To make your lights change at a reasonable speed, you can use the 
rate option to on-tick. If you say, for example, (on-tick next-color 1) 
then big-bang will wait 1 second between calls to next-color.

Remember to follow the HtDW recipe! Be sure to do a proper domain 
analysis before starting to work on the code file.

Note: If you want to design a slightly simpler version of the program,
you can modify it to display a single circle that changes color, rather
than three stacked circles. 
 |# 


;; An animation of a traffic light that can change the color (Red, Green, Yellow)

 #|                                                      
"constant"
SIDE
MIDDLE POSITION
MTS
RED
YELLOW
GREEN

"changing"
TrafficLight

"bigbang"
on-tick
to-draw
 |# 

;; =================
;; Constants:
(define SIDE 500)
(define MIDDLE (/ SIDE 2))

(define MTS (empty-scene SIDE SIDE "gray"))

(define RED #(struct:object:image% ... ...))
(define YELLOW #(struct:object:image% ... ...))
(define GREEN #(struct:object:image% ... ...))


;; =================
;; Data definitions:

;; TrafficLight is one of:
;; - "red"
;; - "yellow"
;; - "green"
;; interp. the color of a traffic light

;;<examples are redundant for enumeration>
#;
(define (fn-for-traffic-light tl)
  (cond [(string=? tl "red") (...)]
        [(string=? tl "yellow") (...)]
        [else (...)]
        )
  )

;; Template rules used:
;; - atomic distinct: "red"
;; - atomic distinct: "yellow"
;; - atomic distinct: "green"


;; =================
;; Functions:

;; TrafficLight -> TrafficLight
;; start the world with (main "red")
;; 
(define (main tl)
  (big-bang tl                   ; TrafficLight
    (on-tick next-color 1)       ; TrafficLight -> TrafficLight
    (to-draw render)             ; TrafficLight -> Image
    )
  )



;; TrafficLight -> TrafficLight
;; produce the next color of the traffic light (red to green, green to yellow, yellow to red)
(check-expect (next-color "red") "green")
(check-expect (next-color "green") "yellow")
(check-expect (next-color "yellow") "red")

;(define (next-color tl) "red") ;stub

;<template from TrafficLight>
(define (next-color tl)
  (cond [(string=? tl "red") "green"]
        [(string=? tl "yellow") "red"]
        [else "yellow"]
        )
  )



;; TrafficLight -> Image
;; render traffic light based on color
(check-expect (render "red") (place-image RED MIDDLE MIDDLE MTS))
(check-expect (render "yellow") (place-image YELLOW MIDDLE MIDDLE MTS))
(check-expect (render "green") (place-image GREEN MIDDLE MIDDLE MTS))

;(define (render tl) MTS) ;stub

;<template from TrafficLight>
(define (render tl)
  (cond [(string=? tl "red") (place-image RED MIDDLE MIDDLE MTS)]
        [(string=? tl "yellow") (place-image YELLOW MIDDLE MIDDLE MTS)]
        [else (place-image GREEN MIDDLE MIDDLE MTS)]
        )
  )



(main "red")


