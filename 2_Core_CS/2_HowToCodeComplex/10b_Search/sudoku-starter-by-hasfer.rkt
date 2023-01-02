;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname sudoku-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require racket/list) ;gets list-ref, take and drop
        
;; sudoku-starter.rkt

;;
;; Brute force Sudoku solver
;;
;; In Sudoku, the board is a 9x9 grid of SQUARES.
;; There are 9 ROWS and 9 COLUMNS, there are also 9
;; 3x3 BOXES.  Rows, columns and boxes are all UNITs.
;; So there are 27 units.
;;
;; The idea of the game is to fill each square with
;; a Natural[1, 9] such that no unit contains a duplicate
;; number.
;;

;; =================
;; Data definitions:


;; Val is Natural[1, 9]


;; Board is (listof Val|false) that is 81 elements long
;; interp.
;;  - Visually a board is a 9x9 array of squares, where each square
;;    has a row and column number (r, c).
;;  - But we represent it as a
;;    single flat list, in which the rows are layed out one after
;;    another in a linear fashion.
;;  - (See interp. of Pos below for how
;;    we convert back and forth between (r, c) and position in a board.)


;; Pos is Natural[0, 80]
;; interp.
;;  the position of a square on the board, for a given p, then
;; Is 7 a quotient?
;;
;;   So for example 15 divided by 2 is 7 with a remainder of 1.
;;   Here, 7 is the quotient and 1 is the remainder.
;;   meaning that Pos 15 are Row 7 and Column 1
;;  
;;    - the row    is (quotient p 9)
;;    - the column is (remainder p 9)


;; Convert 0-based row and column to Pos
#;(define (r-c->pos r c) (+ (* r 9) c))  ;helpful for writing tests


;; Unit is (listof Pos) of length 9
;; interp. 
;;  The position of every square in a unit. There are
;;  27 of these for the 9 rows, 9 columns and 9 boxes.

;; ROW is row Number[0,8] in the board
;; COL is column Number[0,8] in the board

;; =================
;; Constants:

(define ALL-VALS (list 1 2 3 4 5 6 7 8 9))

(define B false) ;B stands for blank


(define BD1 
  (list B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B))

(define BD2 
  (list 1 2 3 4 5 6 7 8 9 
        B B B B B B B B B 
        B B B B B B B B B 
        B B B B B B B B B 
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B))

(define BD3 
  (list 1 B B B B B B B B
        2 B B B B B B B B
        3 B B B B B B B B
        4 B B B B B B B B
        5 B B B B B B B B
        6 B B B B B B B B
        7 B B B B B B B B
        8 B B B B B B B B
        9 B B B B B B B B))

(define BD4                ;easy
  (list 2 7 4 B 9 1 B B 5
        1 B B 5 B B B 9 B
        6 B B B B 3 2 8 B
        B B 1 9 B B B B 8
        B B 5 1 B B 6 B B
        7 B B B 8 B B B 3
        4 B 2 B B B B B 9
        B B B B B B B 7 B
        8 B B 3 4 9 B B B))

(define BD4s               ;solution to 4
  (list 2 7 4 8 9 1 3 6 5
        1 3 8 5 2 6 4 9 7
        6 5 9 4 7 3 2 8 1
        3 2 1 9 6 4 7 5 8
        9 8 5 1 3 7 6 4 2
        7 4 6 2 8 5 9 1 3
        4 6 2 7 5 8 1 3 9
        5 9 3 6 1 2 8 7 4
        8 1 7 3 4 9 5 2 6))

(define BD5                ;hard
  (list 5 B B B B 4 B 7 B
        B 1 B B 5 B 6 B B
        B B 4 9 B B B B B
        B 9 B B B 7 5 B B
        1 8 B 2 B B B B B 
        B B B B B 6 B B B 
        B B 3 B B B B B 8
        B 6 B B 8 B B B 9
        B B 8 B 7 B B 3 1))

(define BD5s               ;solution to 5
  (list 5 3 9 1 6 4 8 7 2
        8 1 2 7 5 3 6 9 4
        6 7 4 9 2 8 3 1 5
        2 9 6 4 1 7 5 8 3
        1 8 7 2 3 5 9 4 6
        3 4 5 8 9 6 1 2 7
        9 2 3 5 4 1 7 6 8
        7 6 1 3 8 2 4 5 9
        4 5 8 6 7 9 2 3 1))

(define BD6                ;hardest ever? (Dr Arto Inkala)
  (list B B 5 3 B B B B B 
        8 B B B B B B 2 B
        B 7 B B 1 B 5 B B 
        4 B B B B 5 3 B B
        B 1 B B 7 B B B 6
        B B 3 2 B B B 8 B
        B 6 B 5 B B B B 9
        B B 4 B B B B 3 B
        B B B B B 9 7 B B))

(define BD7                 ; no solution 
  (list 1 2 3 4 5 6 7 8 B 
        B B B B B B B B 2 
        B B B B B B B B 3 
        B B B B B B B B 4 
        B B B B B B B B 5
        B B B B B B B B 6
        B B B B B B B B 7
        B B B B B B B B 8
        B B B B B B B B 9))




;; Positions of all the rows, columns and boxes:

(define ROWS
  (list (list  0  1  2  3  4  5  6  7  8)
        (list  9 10 11 12 13 14 15 16 17)
        (list 18 19 20 21 22 23 24 25 26)
        (list 27 28 29 30 31 32 33 34 35)
        (list 36 37 38 39 40 41 42 43 44)
        (list 45 46 47 48 49 50 51 52 53)
        (list 54 55 56 57 58 59 60 61 62)
        (list 63 64 65 66 67 68 69 70 71)
        (list 72 73 74 75 76 77 78 79 80)))

(define COLS
  (list (list 0  9 18 27 36 45 54 63 72)
        (list 1 10 19 28 37 46 55 64 73)
        (list 2 11 20 29 38 47 56 65 74)
        (list 3 12 21 30 39 48 57 66 75)
        (list 4 13 22 31 40 49 58 67 76)
        (list 5 14 23 32 41 50 59 68 77)
        (list 6 15 24 33 42 51 60 69 78)
        (list 7 16 25 34 43 52 61 70 79)
        (list 8 17 26 35 44 53 62 71 80)))

(define BOXES
  (list (list  0  1  2  9 10 11 18 19 20)
        (list  3  4  5 12 13 14 21 22 23)
        (list  6  7  8 15 16 17 24 25 26)
        (list 27 28 29 36 37 38 45 46 47)
        (list 30 31 32 39 40 41 48 49 50)
        (list 33 34 35 42 43 44 51 52 53)
        (list 54 55 56 63 64 65 72 73 74)
        (list 57 58 59 66 67 68 75 76 77)
        (list 60 61 62 69 70 71 78 79 80)))

(define UNITS (append ROWS COLS BOXES))




;; =================
;; Functions:

;; Board -> Board or false
;; produce a solution for bd (Board), false if bd is unsolvable
;; Assume: bd is valid
(check-expect (solve BD4) BD4s)
(check-expect (solve BD5) BD5s)
(check-expect (solve BD7) false)

;(define (solve bd) false) ;stub

(define (solve bd)
  (local [;Arbitrary-arity tree (MR) of board

          ;; Board -> Board or false
          ;; Board -> Board or false
          ;; produce board if solved, false otherwise
          
          (define (solve--bd bd)
            (cond [(solved? bd) bd]
                  [else
                   (solve--lobd (next-boards bd) ;lobd
                                )]
                  ))

          (define (solve--lobd lobd)
            (cond [(empty? lobd) false]
                  [else
                   (local [(define try (solve--bd (first lobd)))]
                     (if (not (false? try))
                         try
                         (solve--lobd (rest lobd))
                         )
                     )]
                  ))
          ]
    (solve--bd bd)))

;_____________________________________________________________
;_____________________________________________________________

;; Board -> Boolean
;; produce: true if board is solved; false if unsolvable
;; Assume: board is valid, so it is solved if it FULL
(check-expect (solved? BD1) false)
(check-expect (solved? BD2) false)
(check-expect (solved? BD4s) true)

;(define (solved? bd) false) ;stub
#;
(define (solved? bd)
  (cond [(empty? bd) true]
        [else
         (if (number? (first bd))
             (solved? (rest bd))
             false
             )]
        ))

(define (solved? bd)
  (andmap number? bd))


;; Board -> (Listof Board)
;; produce LIST OF valid next BOARDs from given board:
;; - finds empty square
;; - fills it with Natural[1,9]
;; - and keep only valid boards
(check-expect (next-boards (cons 1 (rest BD1)))
              (list (cons 1 (cons 2 (rest (rest BD1))))
                    (cons 1 (cons 3 (rest (rest BD1))))
                    (cons 1 (cons 4 (rest (rest BD1))))
                    (cons 1 (cons 5 (rest (rest BD1))))
                    (cons 1 (cons 6 (rest (rest BD1))))
                    (cons 1 (cons 7 (rest (rest BD1))))
                    (cons 1 (cons 8 (rest (rest BD1))))
                    (cons 1 (cons 9 (rest (rest BD1))))
                    ))

;(define (next-boards bd) empty) ;stub

(define (next-boards bd)
  (keep-only-valid (fill-with-1-9 (find-blank bd)
                                  bd)))
;_____________________________________________________________
;_____________________________________________________________
;_____________________________________________________________

;; Board -> Pos
;; produce the position of the first blank square
;; Assume: board has at least 1 blank square
(check-expect (find-blank BD1) 0)
(check-expect (find-blank (cons 1 (rest BD1))) 1)
(check-expect (find-blank BD4) 3)
(check-expect (find-blank BD6) 0)

;(define (find-blank bd) 0) ;stub

(define (find-blank bd)
  (cond [(empty? bd) (error "The board didnt have a blank square")]
        [else
         (if  (false? (first bd))  ;Val|false
              0
              (+ 1 (find-blank (rest bd)))
              )]
        ))


;; Pos Board -> (ListOf Board)
;; produce 9 boards, with blank in the pos filled with Natural[1,9]
(check-expect (fill-with-1-9 0 BD1)
              (list (cons 1 (rest BD1))
                    (cons 2 (rest BD1))
                    (cons 3 (rest BD1))
                    (cons 4 (rest BD1))
                    (cons 5 (rest BD1))
                    (cons 6 (rest BD1))
                    (cons 7 (rest BD1))
                    (cons 8 (rest BD1))
                    (cons 9 (rest BD1))
                    ))

;(define (fill-with-1-9 p bd) empty) ;stub
#;
(define (fill-with-1-9 p bd)
  (local [(define (fill-with-1-9-with-count p bd count)
            (cond [(> count 9) empty]
                  [else
                   (cons (fill-square bd p count)
                         (fill-with-1-9-with-count p bd (+ count 1))
                         )]
                  ))]
    (fill-with-1-9-with-count p bd 1)))

(define (fill-with-1-9 p bd)
  (local [(define (build-one n)
            (fill-square bd p (+ n 1)))]
    (build-list 9 build-one)))


;; (ListOf Board) -> (ListOf Board)
;; produce list of only valid boards
(check-expect (keep-only-valid (list (cons 1 (cons 1 (rest (rest BD1)))))) empty)

;(define (keep-only-valid lobd) empty) ;stub

(define (keep-only-valid lobd)
  (filter valid-board? lobd))
;_____________________________________________________________
;_____________________________________________________________
;_____________________________________________________________
;_____________________________________________________________

;; Board -> Boolean
;; produce true if number no unit appear twice in the board (in row, column, and box)
(check-expect (valid-board? empty) true)
(check-expect (valid-board? BD1) true)
(check-expect (valid-board? BD2) true)
(check-expect (valid-board? BD3) true)
(check-expect (valid-board? BD4) true)
(check-expect (valid-board? (cons 1 (cons 1 (rest (rest BD1))))) false)
(check-expect (valid-board? (cons 2 (rest BD2))) false)
(check-expect (valid-board? (fill-square BD4 1 6)) false)

;(define (valid-board? bd) false) ;stub

(define (valid-board? bd)
  (local [(define (check-one bd pos)
            (cond [(empty? bd) true]
                  [else
                   (and (if (not (false? (first bd)))
                            (no-duplicate? pos)
                            true)
                        (check-one (rest bd) (+ pos 1))
                        )]
                  ))


          (define (no-duplicate? pos)
            (and (no-dup-in-row? pos 0 8 bd)
                 (no-dup-in-col? pos 0 8 bd)
                 (no-dup-in-box? pos bd)
                 ))]

    (check-one bd 0)))

;_____________________________________________________________
;_____________________________________________________________
;_____________________________________________________________
;_____________________________________________________________

;; Pos Number Number Board -> Bool
;; TRUE if no duplicate in row (Number[0,8]) in the BOARD, otherwise FALSE
;; same row, iterating through over column[0,8]
(check-expect (no-dup-in-row?  0 0 8 BD1) true)
(check-expect (no-dup-in-row?  4 0 8 BD2) true)
(check-expect (no-dup-in-col? 56 0 8 BD4s) true)
(check-expect (no-dup-in-col? 30 0 8 BD4) true)
(check-expect (no-dup-in-row?  3 0 8 (fill-square BD4 3 5)) false)

;(define (no-dup-in-row? pos) false)

(define (no-dup-in-row? pos count max BOARD)
  (cond [(> count max) true]
        [else
         (and (local [(define try (read-square BOARD pos))
                      (define row (get-row pos))]
                (if (not (false? try))
                    (if (not (= pos (r-c->pos row count)))
                        (not (same-value? try row count BOARD))
                        true)
                    true))
              (no-dup-in-row? pos (+ count 1) max BOARD)
              )]
        ))



;; Pos Number Number Board -> Bool
;; TRUE if no duplicate in COLUMN (Number[0,8]) in the BOARD, otherwise FALSE
;; same COL, iterating through over ROW[0,8]
(check-expect (no-dup-in-col?  0 0 8 BD1) true)
(check-expect (no-dup-in-col?  9 0 8 BD3) true)
(check-expect (no-dup-in-col? 45 0 8 BD4s) true)
(check-expect (no-dup-in-col? 30 0 8 BD4) true)
(check-expect (no-dup-in-col? 20 0 8 (fill-square BD4 20 2)) false)

;(define (no-dup-in-col? pos) false)

(define (no-dup-in-col? pos count max BOARD)
  (cond [(> count max) true]
        [else
         (and (local [(define try (read-square BOARD pos))
                      (define col (get-col pos))]
                (if (not (false? try))
                    (if (not (= pos (r-c->pos count col)))
                        (not (same-value? try count col BOARD))
                        true)
                    true))
              (no-dup-in-col? pos (+ count 1) max BOARD)
              )]
        ))


;; Pos Board -> Bool
;; TRUE if no duplicate in BOX in the BOARD, otherwise FALSE
(check-expect (no-dup-in-box?  0 BD1) true)
(check-expect (no-dup-in-box?  1 BD4) true)
(check-expect (no-dup-in-box? 40 BD4) true)
(check-expect (no-dup-in-box? 53 BD4) true)
(check-expect (no-dup-in-box? 53 BD4s) true)
(check-expect (no-dup-in-box? 53 (fill-square BD4  33 3)) false)
(check-expect (no-dup-in-box? 53 (fill-square BD4  34 3)) false)
(check-expect (no-dup-in-box? 53 (fill-square BD4  35 3)) false)
(check-expect (no-dup-in-box? 53 (fill-square BD4  42 3)) false)
(check-expect (no-dup-in-box? 53 (fill-square BD4  43 3)) false)
(check-expect (no-dup-in-box? 53 (fill-square BD4  44 3)) false)
(check-expect (no-dup-in-box? 53 (fill-square BD4  51 3)) false)
(check-expect (no-dup-in-box? 53 (fill-square BD4  52 3)) false)
(check-expect (no-dup-in-box? 16 (fill-square BD4   6 9)) false)
(check-expect (no-dup-in-box? 16 (fill-square BD4   7 9)) false)
(check-expect (no-dup-in-box? 16 (fill-square BD4   8 9)) false)
(check-expect (no-dup-in-box? 16 (fill-square BD4  15 9)) false)
(check-expect (no-dup-in-box? 16 (fill-square BD4  17 9)) false)
(check-expect (no-dup-in-box? 16 (fill-square BD4  24 9)) false)
(check-expect (no-dup-in-box? 16 (fill-square BD4  25 9)) false)
(check-expect (no-dup-in-box? 16 (fill-square BD4  26 9)) false)
(check-expect (no-dup-in-box?  1 (fill-square BD4s  0 7)) false)
(check-expect (no-dup-in-box?  1 (fill-square BD4s 20 7)) false)

;(define (no-dup-in-box? pos BOARD) false)

(define (no-dup-in-box? pos BOARD)
  (local [(define BOX (get-box pos))
          (define FROW (get-first-row-from-box BOX))
          (define FCOL (get-first-col-from-box BOX))

          (define (row-iter pos count-row)
            (cond [(> count-row (+ FROW 2)) true]
                  [else
                   (and (col-iter count-row FCOL)
                        (row-iter pos (+ count-row 1))
                        )]
                  ))

          (define (col-iter row_fixed count-col)
            (cond [(> count-col (+ FCOL 2)) true]
                  [else
                   (and (if (not (false? (read-square BOARD pos)))
                            (if (not (= pos (r-c->pos row_fixed count-col)))
                                (not (same-value? (read-square BOARD pos) row_fixed count-col BOARD))
                                true)
                            true)
                        (col-iter row_fixed (+ count-col 1))
                        )]
                  ))
          ]
    (row-iter pos FROW)))


;; Val Number Number Board -> Boolean
;; true if Val is equal to Val in given Row Col in BOARD
(check-expect (same-value? 0 0 0 BD1) false)
(check-expect (same-value? 4 0 2 BD4) true)
(check-expect (same-value? 6 8 8 BD4s) true)
(check-expect (same-value? 9 7 7 BD4s) false)

;(define (same-value? value row column BOARD) false)

(define (same-value? value row column BOARD)
  (local [(define try (read-square BOARD (r-c->pos row column)))]
    (if (not (false? try))
        (= value try)
        false)))


;_____________________________________________________________

;; Pos -> Row
;; produce Row from given Pos
(check-expect (get-row 0) 0)
(check-expect (get-row 1) 0)
(check-expect (get-row 5) 0)
(check-expect (get-row 9) 1)
(check-expect (get-row 60) 6)
(check-expect (get-row 79) 8)
(check-expect (get-row 80) 8)
;(define (get-row pos) 0) ;stub
(define (get-row pos)
  (floor (/ pos 9)))


;; Pos -> Col
;; produce Column from given Pos
(check-expect (get-col 0) 0)
(check-expect (get-col 1) 1)
(check-expect (get-col 5) 5)
(check-expect (get-col 9) 0)
(check-expect (get-col 60) 6)
(check-expect (get-col 79) 7)
(check-expect (get-col 80) 8)
;(define (get-col pos) 0) ;stub
(define (get-col pos)
  (remainder pos 9))

;_____________________________________________________________

;; Pos -> Box
;; produce Box from given Pos
; 0 1 2
; 3 4 5
; 6 7 8
(check-expect (get-box  0) 0)
(check-expect (get-box 19) 0)
(check-expect (get-box 23) 1)
(check-expect (get-box 26) 2)
(check-expect (get-box 38) 3)
(check-expect (get-box 40) 4)
(check-expect (get-box 33) 5)
(check-expect (get-box 73) 6)
(check-expect (get-box 77) 7)
(check-expect (get-box 80) 8)
;(define (get-box pos) 0)
(define (get-box pos)
  (local [(define row (get-row pos))
          (define col (get-col pos))]
    
    (cond [(< row 3) (cond [(< col 3) 0]
                           [(< col 6) 1]
                           [(< col 9) 2])]
          [(< row 6) (cond [(< col 3) 3]
                           [(< col 6) 4]
                           [(< col 9) 5])]
          [(< row 9) (cond [(< col 3) 6]
                           [(< col 6) 7]
                           [(< col 9) 8])])))

;; Box -> Col
;; produce the first column from given box
(check-expect (get-first-col-from-box 0) 0)
(check-expect (get-first-col-from-box 3) 0)
(check-expect (get-first-col-from-box 6) 0)
(check-expect (get-first-col-from-box 1) 3)
(check-expect (get-first-col-from-box 4) 3)
(check-expect (get-first-col-from-box 7) 3)
(check-expect (get-first-col-from-box 2) 6)
(check-expect (get-first-col-from-box 5) 6)
(check-expect (get-first-col-from-box 8) 6)
;(define (get-first-col-from-box box) 0)
(define (get-first-col-from-box box)
  (cond [(= (modulo box 3) 0) 0]
        [(= (modulo box 3) 1) 3]
        [(= (modulo box 3) 2) 6]
        ))

;; Box -> Row
;; produce the first column from given box
(check-expect (get-first-row-from-box 0) 0)
(check-expect (get-first-row-from-box 1) 0)
(check-expect (get-first-row-from-box 2) 0)
(check-expect (get-first-row-from-box 3) 3)
(check-expect (get-first-row-from-box 4) 3)
(check-expect (get-first-row-from-box 5) 3)
(check-expect (get-first-row-from-box 6) 6)
(check-expect (get-first-row-from-box 7) 6)
(check-expect (get-first-row-from-box 8) 6)
;(define (get-first-row-from-box box) 0)
(define (get-first-row-from-box box)
  (cond [(< box 3) 0]
        [(< box 6) 3]
        [(< box 9) 6]
        ))


;_____________________________________________________________


;; ROW COL -> POS
;; Convert 0-based row and column to Pos
(define (r-c->pos r c) (+ (* r 9) c))  ;helpful for writing tests

;; Board Pos -> Val or false
;; Produce value at given position on board.
(check-expect (read-square BD2 (r-c->pos 0 5)) 6)
(check-expect (read-square BD3 (r-c->pos 7 0)) 8)

(define (read-square bd p)
  (list-ref bd p))               


;; Board Pos Val -> Board
;; produce new board with val at given position
(check-expect (fill-square BD1 (r-c->pos 0 0) 1)
              (cons 1 (rest BD1)))

(define (fill-square bd p nv)
  (append (take bd p)
          (list nv)
          (drop bd (add1 p))))





;____________________________________________________________________
; 
; We could have coded read-square and fill-square 'from scratch'
; by using the functions operating on 2 one-of data rule. If we 
; had, the function definitions would look like this:
; 
; 
; ;____________________________________________________________________
; ;
; ; Function on 2 complex data: Board and Pos.
; ; We can assume that p is <= (length bd).
; ; 
; ;               empty     (cons Val-or-False Board)
; ;  0             XXX         (first bd)
; ;  
; ;  (add1 p)      XXX         <natural recursion>
; ;____________________________________________________________________
; 
; (define (read-square bd p)  
;   (cond [(zero? p) (first bd)]
;         [else
;          (read-square (rest bd) (sub1 p))]))
; 
; 
; 
; ;____________________________________________________________________
; ;
; ; Function on 2 complex data, Board and Pos.
; ; We can assume that p is <= (length bd).
; ; 
; ;               empty     (cons Val-or-False Board)
; ;  0             XXX         (cons nv (rest bd))
; ;  
; ;  (add1 p)      XXX         (cons (first bd) <natural recursion>)
; ;____________________________________________________________________
;  
; (define (fill-square bd p nv)  
;   (cond [(zero? p) (cons nv (rest bd))]
;         [else
;          (cons (first bd)
;                (fill-square (rest bd) (sub1 p) nv))]))
; 
;____________________________________________________________________
