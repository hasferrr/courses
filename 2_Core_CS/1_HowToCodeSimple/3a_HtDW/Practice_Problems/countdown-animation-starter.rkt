;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname countdown-animation-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; countdown-animation starter.rkt

 #| 
PROBLEM:

Design an animation of a simple countdown. 

Your program should display a simple countdown, that starts at ten, and
decreases by one each clock tick until it reaches zero, and stays there.

To make your countdown progress at a reasonable speed, you can use the 
rate option to on-tick. If you say, for example, 
(on-tick advance-countdown 1) then big-bang will wait 1 second between 
calls to advance-countdown.

Remember to follow the HtDW recipe! Be sure to do a proper domain 
analysis before starting to work on the code file.

Once you are finished the simple version of the program, you can improve
it by reseting the countdown to ten when you press the spacebar.
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


;; An animation of a simple countdown that starts at 10 decreases (per second) until it reaches 0

 #| "Image removed" |# 


;; ==================================
;; Constant

(define SISI 500)
(define MIDDLE (/ SISI 2))

(define TEXT-SIZE 100)
(define TEXT-COLOR "black") 

(define MTS (empty-scene SISI SISI "gray")) ;background



;; ==================================
;; Data definitions

;; Countdown is Number[0,10]
;; interp. number of countdown progress
(define C10 10)  ;start
(define C5  5)   ;middle
(define C0  0)   ;end of countdown
#;
(define (fn-for-countdown c)
  (... c))

;; Template rules used:
;; - atomic non-distinct: Number[0,10]




;; ==================================
;; Function

;; Countdown -> Countdown
;; start the world with (main 10)

(define (main c)
  (big-bang c                              ; Countdown
          (on-tick   tock-countdown 1)     ; Countdown -> Countdown
          (to-draw   render-countdown)     ; Countdown -> Image
          (on-key    handle-key)           ; Countdown KeyEvent -> Countdown
    )
  )




;; Countdown -> Countdown
;; decrease countdown number by 1 if countdown not 0, else still 0
(check-expect (tock-countdown 10) 9)
(check-expect (tock-countdown 5) 4)
(check-expect (tock-countdown 0) 0)

;(define (tock-countdown c) ...) ;stub

;<template from Countdown>

(define (tock-countdown c)
  (cond [(= c 0) 0]
        [else    (- c 1)]
        )
  )



;; Countdown -> Image
;; render countdown number as image 
(check-expect (render-countdown 10) (place-image (text "10" TEXT-SIZE TEXT-COLOR) MIDDLE MIDDLE MTS))
(check-expect (render-countdown 5) (place-image (text "5" TEXT-SIZE TEXT-COLOR) MIDDLE MIDDLE MTS))
(check-expect (render-countdown 0) (place-image (text "0" TEXT-SIZE TEXT-COLOR) MIDDLE MIDDLE MTS))

;(define (render-countdown c) MTS) ;stub

;<template from Countdown>

(define (render-countdown c)
  (place-image (text (number->string c) TEXT-SIZE TEXT-COLOR) MIDDLE MIDDLE MTS)
  )



;; Countdown KeyEvent -> Countdown
;; reset countdown from 10 when space is pressed
(check-expect (handle-key 10 " ") 10)
(check-expect (handle-key 5 " ") 10)
(check-expect (handle-key 0 " ") 10)
(check-expect (handle-key 10 "a") 10)
(check-expect (handle-key 5 "a") 5)
(check-expect (handle-key 0 "a") 0)

;(define (handle-key c ke) 10) ;stub

(define (handle-key c ke)
  (cond [(key=? ke " ") 10]
        [else           c]
        )
  )



