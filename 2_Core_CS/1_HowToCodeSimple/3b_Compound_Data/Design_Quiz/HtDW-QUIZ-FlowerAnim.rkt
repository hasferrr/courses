;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname HtDW-QUIZ-FlowerAnim) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

 #| This project will have 3 phases:
- In step one, you will design a solution to a given problem.
- In step two, you will watch an assessment tutorial video (found in the next tab).
- In step three, you will do a self-assessment of your solution.
 |# 

 #| PROBLEM:

Design a World Program "with Compound Data". You can be as creative as you like,
but keep it simple. Above all, "follow the recipes!" You must also stay within
the scope of the first part of the course. Do not use language features we
have not seen in the videos. 

If you need inspiration, you can choose to "create a program that" allows you
to click on a spot on the screen to create a flower, which then grows over time.
If you click again the first flower is replaced by a new one at the new position.

You should do all your design work in DrRacket. Following the step-by-step recipe
in DrRacket will help you be sure that you have a quality solution.
 |# 

 #| For this quiz you will be asked to design a world program using the HtDW and other recipes.
Your solution will be assessed according to the following rubric:

 1. Is the program safe?
    The program file should be set to beginning student language and there should be
    no require declarations other than (require 2htdp/image) and (require 2htdp/universe).
    If the program is in a language other than BSL, then it gets 0 points for the rest
    of the rubric.

 2. Is the program "commit ready"?
    The file should be neat and tidy, no tests or code should be commented out other than
    stubs and templates and all scratch work should be removed.

 3. Are all "HtDW elements" complete and do they have high internal quality?
    All HtDW elements should be present, well formed, and have high internal quality.
    The file must include Constants, Data Definitions and Functions. The Constants section
    must be complete, there must be a main function that is correct and operates on a
    compound type. The main function must have all necessary big-bang options, and for each
    option, the handler must be present in the file. 

 4. Are all "HtDD elements" complete and do they have high internal quality?
    Examine the Data Definition for the world state. All elements of HtDD must be present
    and have high internal quality. This includes a structure definition, type comment,
    interpretation, examples and the template.

 5. Are all "HtDF elements" complete and do they have high internal quality?
    Choose either the to-draw, on-key or on-mouse handler. All elements of HtDF must be
    present and have high internal quality. This includes the Signature, Purpose, Stub,
    Examples/Tests, Template and the Function Body.

 6. Does the design satisfy the problem requirements?
    The program must be a World Program, operate on Compound Data, and be within the scope
    of the course.
 |# 

(require 2htdp/image)
(require 2htdp/universe)

;; My world program that create a flower then grows over time when you click on a spot
;;   on the screen. If you click again the first flower is replaced by a new one at the
;;   new position

;; =================
;; Constants:
(define WIDTH 600)
(define HEIGHT 400)
(define MTS (empty-scene WIDTH HEIGHT "white"))
(define GROW-MULT 3)
(define MAX-SIZE 200)
(define COLOR "mediumpurple")

;; =================
;; Data definitions:

(define-struct imgstar (x y size))
;; Imgstar is (make-star Number Number Number)
;; interp. (make-star x y size)
;;      x is x coordinate of star image on the mts
;;      y is y coordinate of star image on the mts
;;      size is size of the star image

(define S0 (make-imgstar 0 0 0))
(define S1 (make-imgstar 200 100 40))
(define S2 (make-imgstar 0 0 60))
(define S3 (make-imgstar 300 200 1))

#;
(define (fn-for-imgstar s)
  (... (imgstar-x s)    ;Number
       (imgstar-y s)    ;Number
       (imgstar-size s) ;Number
       )
  )

;; Template rules used:
;; - Compound: 3 fields


;; =================
;; Functions:

;; Imgstar -> Imgstar
;; start the world with (main S0)
;; 
(define (main s)
  (big-bang s                    ; Imgstar
    (on-tick  grow)              ; Imgstar -> Imgstar
    (to-draw  render)            ; Imgstar -> Image
    (on-mouse handle-mouse)      ; Imgstar Integer Integer MouseEvent -> Imgstar
    (on-key   handle-key)        ; Imgstar KeyEvent -> Imgstar
    )
  )



;; Imgstar -> Imgstar
;; increase/growing size the star by adding GROW-MULT to imgstar-size until reach 200 if imgstar-size is greater than 0, otherwise the star wont grow
(check-expect (grow (make-imgstar 200 100 40)) (make-imgstar 200 100 (+ 40 GROW-MULT))
              ) ; increase size
(check-expect (grow (make-imgstar 40 50 (- MAX-SIZE GROW-MULT))) (make-imgstar 40 50 MAX-SIZE)
              ) ; when new size reaches max-size
(check-expect (grow (make-imgstar 90 20 (+ 1 (- MAX-SIZE GROW-MULT)))) (make-imgstar 90 20 MAX-SIZE)
              ) ; when new size reaches over max-size, force to max-size
(check-expect (grow (make-imgstar 333 222 0)) (make-imgstar 333 222 0)
              ) ; keep new size = 0 when old size = 0

;(define (grow s) s) ;stub

;Use template from Imgstar

(define (grow s)
  (cond [(= (imgstar-size s) 0)
         s]
        [(> (+ (imgstar-size s) GROW-MULT) MAX-SIZE)
         (make-imgstar (imgstar-x s) (imgstar-y s) MAX-SIZE)]
        [else
         (make-imgstar (imgstar-x s) (imgstar-y s) (+ (imgstar-size s) GROW-MULT))]
        )
  )



;; Imgstar -> Image
;; render star image
(check-expect (render (make-imgstar 200 100 40))
              (place-image (star 40 "solid" COLOR) 200 100 MTS))
              
;(define (render s) MTS) ;stub

;Use template from Imgstar
(define (render s)
  (place-image (star (imgstar-size s) "solid" COLOR) (imgstar-x s) (imgstar-y s) MTS))



;; Imgstar Integer Integer MouseEvent -> Imgstar
;; If click ON THE star, replace the star with new star. else, create new star on that location
(check-expect (handle-mouse (make-imgstar 200 100 30) 220 120 "button-down")
              (make-imgstar 200 100 1)) ; click on the star
(check-expect (handle-mouse (make-imgstar 200 100 30) 180 80 "button-down")
              (make-imgstar 200 100 1)) ; click on the star

(check-expect (handle-mouse (make-imgstar 300 200 40) 340 240 "button-down")
              (make-imgstar 300 200 1)) ; click on the edge

(check-expect (handle-mouse (make-imgstar 400 300 50) 460 360 "button-down")
              (make-imgstar 460 360 1)) ; click outside
(check-expect (handle-mouse (make-imgstar 400 300 50) 400 360 "button-down")
              (make-imgstar 400 360 1)) ; click outside
(check-expect (handle-mouse (make-imgstar 400 300 50) 460 300 "button-down")
              (make-imgstar 460 300 1)) ; click outside

(check-expect (handle-mouse (make-imgstar 400 300 50) 340 240 "button-down")
              (make-imgstar 340 240 1)) ; click outside
(check-expect (handle-mouse (make-imgstar 400 300 50) 400 240 "button-down")
              (make-imgstar 400 240 1)) ; click outside
(check-expect (handle-mouse (make-imgstar 400 300 50) 340 300 "button-down")
              (make-imgstar 340 300 1)) ; click outside

;(define (handle-mouse s x y ke) s) ;stub

;Use template from MouseEvent

(define (handle-mouse s x y me)
        (cond
              ;click the star
              [(and
                   (<= x (+ (imgstar-size s) (imgstar-x s)))
                   (<= y (+ (imgstar-size s) (imgstar-y s)))
                   (>= x (- (imgstar-x s) (imgstar-size s)))
                   (>= y (- (imgstar-y s) (imgstar-size s)))
                   (mouse=? me "button-down")
               )
               (make-imgstar (imgstar-x s) (imgstar-y s) 1)
              ]
              ;click outside
              [(mouse=? me "button-down")
               (make-imgstar x y 1)
              ]
              ;doesnt click
              [else
               (make-imgstar (imgstar-x s) (imgstar-y s) (imgstar-size s))
              ]
        )
)



;; Imgstar KeyEvent -> Imgstar
;; delete all star if " " or space butten pressed
(check-expect (handle-key (make-imgstar 400 300 50) " ")
              (make-imgstar 400 300 0))
(check-expect (handle-key (make-imgstar 401 301 51) "a")
              (make-imgstar 401 301 51))
(check-expect (handle-key (make-imgstar 402 302 0) " ")
              (make-imgstar 402 302 0))

;(define (handle-key s ke) s) ;stub

;Use template from KeyHandler

(define (handle-key s ke)
        (cond [(key=? ke " ") (make-imgstar (imgstar-x s) (imgstar-y s) 0)]
              [else s]
        )
)


