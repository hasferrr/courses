;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname render-roster-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; render-roster-starter.rkt

 #| Problem:

You are running a dodgeball tournament and are given a list of all
of the players in a particular game as well as their team numbers.  
You need to build a game roster like the one shown below. We've given
you some ''constants'' and data definitions for "Player", "ListOfPlayer" 
and "ListOfString" to work with. 

While you're working on these problems, make sure to keep your 
helper rules in mind and use helper functions when necessary.

#(struct:object:image% ... ...)
 |# 

(require 2htdp/image)

;; Constants
;; ---------

(define CELL-WIDTH 200)
(define CELL-HEIGHT 30)

(define TEXT-SIZE 20)
(define TEXT-COLOR "grey") ;default given value: "black"

;; Data Definitions
;; ----------------


(define-struct player (name team))
;; Player is (make-player String Natural[1,2])
;; interp. a dodgeball player. 
;;   (make-player s t) represents the player named s 
;;   who plays on team t
;; 
(define P0 (make-player "Samael" 1))
(define P1 (make-player "Georgia" 2))
(define P3 (make-player "C" 1))
(define P4 (make-player "D" 2))
#;
(define (fn-for-player p)
  (... (player-name p)
       (player-team p)
       ))


;; ListOfPlayer is one of:
;; - empty
;; - (cons Player ListOfPlayer)
;; interp.  A list of players.
(define LOP0 empty)                     ;; no players
(define LOP2 (cons P0 (cons P1 empty))) ;; two players
#;
(define (fn-for-lop lop)
  (cond [(empty? lop) (...)]
        [else
         (... (fn-for-player (first lop))
              (fn-for-lop (rest lop))
              )]
        ))


;; ListOfString is one of:
;; - empty
;; - (cons String ListOfString)
;; interp. a list of strings
(define LOS0 empty)
(define LOS2 (cons "Samael" (cons "Georgia" empty)))
#;
(define (fn-for-los los)
  (cond [(empty? los) (...)]
        [else
         (... (first los)
              (fn-for-los (rest los))
              )]
        ))

;; Functions
;; ---------

 #| PROBLEM 1: 

Design a function called "select-players" that consumes a list 
of players and a team t (Natural[1,2]) and produces a list of 
players that are on team t. |# 

; ---------
;; ListOfPlayers Natural[1,2] -> ListOfPlayers
;; produces a list of players that are on team 1 or 2 based given number
(check-expect (select-players  empty 1)  empty)
(check-expect (select-players  empty 2)  empty)
(check-expect (select-players  (cons P0 (cons P1 empty)) 1)  (cons P0 empty))
(check-expect (select-players  (cons P0 (cons P1 empty)) 2)  (cons P1 empty))
(check-expect (select-players  (cons P3 (cons P0 (cons P1 empty))) 1)  (cons P3 (cons P0 empty)))
(check-expect (select-players  (cons P4 (cons P0 (cons P1 empty))) 2)  (cons P4 (cons P1 empty)))
;
;(define (select-players lop t) lop) ;stub
;Use template from ListOfPlayers
;
(define (select-players lop t)
  (cond [(empty? lop) empty]
        [else
         (if (is-desired-team? (first lop) t)
             (cons (first lop) (select-players (rest lop) t))
             (select-players (rest lop) t)
             )]
        ))
; ---------
; ---------
;; Player Natural[1,2] -> Boolean
;; produce true if player-team is same as given Natural[1,2]
(check-expect (is-desired-team? (make-player "A" 1) 1) true)
(check-expect (is-desired-team? (make-player "A" 1) 2) false)
(check-expect (is-desired-team? (make-player "B" 2) 1) false)
(check-expect (is-desired-team? (make-player "B" 2) 2) true)
;
;(define (is-desired-team? p t) false) ;stub
;
;Use template from Player
(define (is-desired-team? p t)
  (= (player-team p) t))


 #| PROBLEM 2:  

Complete the design of render-roster. We've started you off with 
the signature, purpose, stub and examples. You'll need to use
the function that you designed in Problem 1.

Note that we've also given you a full function design for render-los
and its helper, render-cell. You will need to use these functions
when solving this problem.

#(struct:object:image% ... ...) |# 

; ---------
;; ListOfPlayer -> Image
;; Render a game roster from the given list of players
;; Render daftar game dari daftar pemain yang diberikan

(check-expect (render-roster empty)
              (beside/align 
               "top"
               (overlay
                (text "Team 1" TEXT-SIZE TEXT-COLOR)
                (rectangle CELL-WIDTH CELL-HEIGHT "outline" TEXT-COLOR))
               (overlay
                (text "Team 2" TEXT-SIZE TEXT-COLOR)
                (rectangle CELL-WIDTH CELL-HEIGHT "outline" TEXT-COLOR))))
                
(check-expect (render-roster LOP2)
              (beside/align 
               "top"
               (above
                (overlay
                 (text "Team 1" TEXT-SIZE TEXT-COLOR)
                 (rectangle CELL-WIDTH CELL-HEIGHT "outline" TEXT-COLOR))
                (overlay
                 (text "Samael" TEXT-SIZE TEXT-COLOR)
                 (rectangle CELL-WIDTH CELL-HEIGHT "outline" TEXT-COLOR)))
               (above
                (overlay
                 (text "Team 2" TEXT-SIZE TEXT-COLOR)
                 (rectangle CELL-WIDTH CELL-HEIGHT "outline" TEXT-COLOR))
                (overlay
                 (text "Georgia" TEXT-SIZE TEXT-COLOR)
                 (rectangle CELL-WIDTH CELL-HEIGHT "outline" TEXT-COLOR)))))


;(define (render-roster lop) empty-image) ; stub

;Use function composition

(define (render-roster lop)
  (beside/align "top"
                (heading (render-los (get-list-of-name (select-players lop 1))) 1)
                (heading (render-los (get-list-of-name (select-players lop 2))) 2)
                ))

; ---------
;; Image Natural -> Image
;; add heading on top of given table
(check-expect (heading (overlay
                        (text "Samael" TEXT-SIZE TEXT-COLOR)
                        (rectangle CELL-WIDTH CELL-HEIGHT "outline" TEXT-COLOR)) 1)
              (above
               (overlay
                (text "Team 1" TEXT-SIZE TEXT-COLOR)
                (rectangle CELL-WIDTH CELL-HEIGHT "outline" TEXT-COLOR))
               (overlay
                (text "Samael" TEXT-SIZE TEXT-COLOR)
                (rectangle CELL-WIDTH CELL-HEIGHT "outline" TEXT-COLOR)))
              )

;(define (heading i n) i) ;stub

(define (heading i n)
  (above (render-cell (string-append "Team " (number->string n)))
         i))



; ---------
; ---------
;; ListOfPlayer -> ListOfString
;; produce ListOfString of player-name from ListOfPlayer
(check-expect (get-list-of-name LOP0) LOS0)
(check-expect (get-list-of-name LOP2) LOS2)

;(define (get-list-of-name lop) LOS0) ;stub

;Use template from ListOfPlayer

(define (get-list-of-name lop)
  (cond [(empty? lop) empty]
        [else
         (cons (get-name (first lop))
               (get-list-of-name (rest lop))
               )]
        ))

; ---------
; ---------
; ---------
; Player -> String
; produce player-name of given Player
(check-expect (get-name P0) "Samael")
(check-expect (get-name P1) "Georgia")

;(define (get-name p) "") ;stub

;Use template from Player

(define (get-name p)
  (player-name p))

; ---------
;; ListOfString -> Image
;; Render a list of strings as a column of cells (per team/ke bawah).
(check-expect (render-los empty) empty-image)
(check-expect (render-los (cons "Samael" empty))
              (above 
               (overlay
                (text "Samael" TEXT-SIZE TEXT-COLOR)
                (rectangle CELL-WIDTH CELL-HEIGHT "outline" TEXT-COLOR))
               empty-image))
(check-expect (render-los (cons "Samael" (cons "John" empty)))
              (above
               (overlay
                (text "Samael" TEXT-SIZE TEXT-COLOR)
                (rectangle CELL-WIDTH CELL-HEIGHT "outline" TEXT-COLOR))
               (overlay
                (text "John" TEXT-SIZE TEXT-COLOR)
                (rectangle CELL-WIDTH CELL-HEIGHT "outline" TEXT-COLOR))))

;(define (render-los lon) empty-image) ; stub

;; Took Template from ListOfString
(define (render-los los)
  (cond [(empty? los) empty-image]
        [else
         (above (render-cell (first los))
                (render-los (rest los)))]))


; ---------
; ---------
;; String -> Image
;; Render a cell of the game table
(check-expect (render-cell "Team 1") 
              (overlay
               (text "Team 1" TEXT-SIZE TEXT-COLOR)
               (rectangle CELL-WIDTH CELL-HEIGHT "outline" TEXT-COLOR)))

;(define (render-cell s) empty-image) ; stub

;; Template for String
(define (render-cell s)
  (overlay
   (text s TEXT-SIZE TEXT-COLOR)
   (rectangle CELL-WIDTH CELL-HEIGHT "outline" TEXT-COLOR)))
  




