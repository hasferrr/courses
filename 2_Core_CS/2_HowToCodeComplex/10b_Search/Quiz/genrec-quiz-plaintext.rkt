(require 2htdp/image)

;  PROBLEM 1:
;
;  In the lecture videos we designed a function to make a Sierpinski triangle fractal.
;
;  Here is another geometric fractal that is made of circles rather than triangles:
;
;  .
;
;  Design a function to create this circle fractal of size n and colour c.
;


(define CUT-OFF 5)
(define CLR "grey")

;; Natural String -> Image
;; produce a circle fractal of size n and colour c
(check-expect (circle-fractal CUT-OFF CLR)
              (circle CUT-OFF "outline" CLR))
(check-expect (circle-fractal (* CUT-OFF 2) CLR)
              (overlay (circle (* CUT-OFF 2) "outline" CLR)
                       (beside (circle CUT-OFF "outline" CLR)
                               (circle CUT-OFF "outline" CLR))))
(check-expect (circle-fractal (* CUT-OFF 4) CLR)
              (local [(define sub (circle-fractal (* CUT-OFF 2) CLR))]
                (overlay (circle (* CUT-OFF 4) "outline" CLR)
                         (beside sub
                                 sub))))

;(define (circle-fractal n c) empty-image)

(define (circle-fractal n c)
  (cond [(<= n CUT-OFF) (circle n "outline" CLR)]
        [else
         (local [(define sub (circle-fractal (/ n 2) CLR))]
           (overlay (circle n "outline" CLR)
                    (beside sub
                            sub)))]
        ))





;  PROBLEM 2:
;
;  Below you will find some data definitions for a tic-tac-toe solver.
;
;  In this problem we want you to design a function that produces all
;  possible filled boards that are reachable from the current board.
;
;  In actual tic-tac-toe, O and X alternate playing. For this problem
;  you can disregard that. You can also assume that the players keep
;  placing Xs and Os after someone has won. This means that boards that
;  are completely filled with X, for example, are valid.
;
;  Note: As we are looking for all possible boards, rather than a winning
;  board, your function will look slightly different than the solve function
;  you saw for Sudoku in the videos, or the one for tic-tac-toe in the
;  lecture questions.
;


;; Value is one of:
;; - false
;; - "X"
;; - "O"
;; interp. a square is either empty (represented by false) or has and "X" or an "O"

(define (fn-for-value v)
  (cond [(false? v) (...)]
        [(string=? v "X") (...)]
        [(string=? v "O") (...)]))

;; Board is (listof Value)
;; a board is a list of 9 Values
(define B0 (list false false false
                 false false false
                 false false false))

(define B1 (list false "X"   "O"   ; a partly finished board
                 "O"   "X"   "O"
                 false false "X"))

(define B2 (list "X"  "X"  "O"     ; a board where X will win
                 "O"  "X"  "O"
                 "X" false "X"))

(define B3 (list "X" "O" "X"       ; a board where Y will win
                 "O" "O" false
                 "X" "X" false))

(define BX (list "X" "X" "X"
                 "X" "X" "X"
                 "X" "X" "X"))

(define (fn-for-board b)
  (cond [(empty? b) (...)]
        [else
         (... (fn-for-value (first b))
              (fn-for-board (rest b)))]))

; ______________________________________________________________________

;; Functions:

;; Board -> (ListOf Board)
;; produces all possible filled boards that are reachable from the current board
;; Assume: Board has not been filled yet
(define solvedB2 (list (list "X"  "X"  "O"
                             "O"  "X"  "O"
                             "X"   "X"  "X")
                       (list "X"  "X"  "O"
                             "O"  "X"  "O"
                             "X"   "O"  "X")))
(define solvedB3 (list (list "X" "O" "X"
                             "O" "O"  "X"
                             "X" "X"  "X")
                       (list "X" "O" "X"
                             "O" "O"  "X"
                             "X" "X"  "O")
                       (list "X" "O" "X"
                             "O" "O"  "O"
                             "X" "X"  "X")
                       (list "X" "O" "X"
                             "O" "O"  "O"
                             "X" "X"  "O")))
(check-expect (solve BX) (list BX))
(check-expect (solve B2) solvedB2)
(check-expect (solve B3) solvedB3)

;(define (solve bd) empty)

(define (solve bd)
  (local [(define (solve--bd bd)
            (cond [(full? bd) (list bd)]
                  [else
                   (solve--lobd (next-board bd))] ;(listof (Board "X") (Board "O"))
                  ))
          (define (solve--lobd lobd)
            (cond [(empty? lobd) empty]
                  [else
                   (append (solve--bd (first lobd))
                           (solve--lobd (rest lobd))
                           )]
                  ))]
    (solve--bd bd)))


;; Board -> Boolean
;; produce true if board is full (all Value is not false), otherwise false
(check-expect (full? BX) true)
(check-expect (full? B0) false)
(check-expect (full? B1) false)

;(define (full? bd) false)

(define (full? bd)
  (local [(define (not-false? v)
            (not (false? v)))]
    (andmap not-false? bd)))


;; Board -> (listof Board)
;; produce listof 2 Board in which replacing first false Value with "X" in 1st Board and "O" in 2nd Board
(check-expect (next-board (list false)) (list (list "X")
                                              (list "O")))
(check-expect (next-board B1) (list (list  "X"   "X"   "O"
                                           "O"   "X"   "O"
                                           false false "X")
                                    (list  "O"   "X"   "O"
                                           "O"   "X"   "O"
                                           false false "X")))
(check-expect (next-board B2) (list (list "X"  "X"  "O"
                                          "O"  "X"  "O"
                                          "X"   "X" "X")
                                    (list "X"  "X"  "O"
                                          "O"  "X"  "O"
                                          "X"   "O" "X")))

;(define (next-board bd) empty)

(define (next-board bd)
  (fill-with-X-O (find-false-index bd) bd))


;; Board -> Number
;; produce the index number of the first false
;; Assume: Board contains at least 1 false value
(check-expect (find-false-index (list false)) 0)
(check-expect (find-false-index B2) 7)

(define (find-false-index bd)
  (cond [(empty? bd) -1]
        [else
         (if (false? (first bd))
             0
             (+ 1 (find-false-index (rest bd)))
             )]
        ))


;; Number Board -> (list Board)
;; produce list of 2 boards, with false in the number index replaced with "X" and "O"
(check-expect (fill-with-X-O 0 (list false)) (list (list "X")
                                                   (list "O")))
(check-expect (fill-with-X-O 7 B2) (list (list "X"  "X"  "O"
                                               "O"  "X"  "O"
                                               "X"   "X" "X")
                                         (list "X"  "X"  "O"
                                               "O"  "X"  "O"
                                               "X"   "O" "X")))

;(define (fill-with-X-O num bd) bd)

(define (fill-with-X-O num bd)
  (local [(define (fill-now num bd str)
            (cond [(zero? num) (cons str (rest bd))]
                  [else
                   (cons (first bd)
                         (fill-now (- num 1) (rest bd) str)
                         )]
                  ))]
    (list (fill-now num bd "X")
          (fill-now num bd "O"))))


;  PROBLEM 3:
;
;  Now adapt your solution to filter out the boards that are impossible if
;  X and O are alternating turns. You can continue to assume that they keep
;  filling the board after someone has won though.
;
;  You can assume X plays first, so all valid boards will have 5 Xs and 4 Os.
;
;  NOTE: make sure you keep a copy of your solution from problem 2 to answer
;  the questions on edX.
;


;; (listof Board) -> (listof Board)
;; produce listof valid boards in which a board will have 5 Xs and 4 Os
(check-expect (keep-valid-lobd solvedB2) (list (list "X"  "X"  "O"
                                                     "O"  "X"  "O"
                                                     "X"   "O"  "X")))
(check-expect (keep-valid-lobd solvedB3) (list (list "X" "O" "X"
                                                     "O" "O"  "X"
                                                     "X" "X"  "O")
                                               (list "X" "O" "X"
                                                     "O" "O"  "O"
                                                     "X" "X"  "X")))

;(define (keep-valid-lobd lobd) empty)

(define (keep-valid-lobd lobd)
  (local [(define (valid? bd)
            (and (= (count bd "X") 5)
                 (= (count bd "O") 4)))
          (define (count bd str)
            (cond [(empty? bd) 0]
                  [else
                   (+ (if (string=? (first bd) str)
                          1
                          0)
                      (count (rest bd) str)
                      )]
                  ))]
    (filter valid? lobd)))


