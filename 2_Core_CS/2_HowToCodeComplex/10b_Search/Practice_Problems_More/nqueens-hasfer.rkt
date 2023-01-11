;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname nqueens-hasfer) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; nqueens-starter.rkt

;_________________________________________________________________________________
;
; This project involves the design of a program to solve the n queens puzzle.
; 
; This starter file explains the problem and provides a few hints you can use
; to help with the solution.
; 
; The key to solving this problem is to follow the recipes! It is a challenging
; problem, but if you understand how the recipes lead to the design of a Sudoku
; solve then you can follow the recipes to get to the design for this program.
;   
; 
; The n queens problem consists of finding a way to place n chess queens
; on a n by n chess board while making sure that none of the queens attack each
; other. 
; 
; The BOARD consists of n^2 individual SQUARES arranged in 4 rows of 4 columns.
; The colour of the squares does not matter. Each square can either be empty
; or can contain a queen.
; 
; A POSITION on the board refers to a specific square.
; 
; A queen ATTACKS every square in its row, its column, and both of its diagonals.
; 
; A board is VALID if none of the queens placed on it attack each other.
; 
; A valid board is SOLVED if it contains n queens.
; 
; 
; There are many strategies for solving nqueens, but you should use the following:
;   
;   - Use a backtracking search over a generated arb-arity tree that
;     is trying to add 1 queen at a time to the board. If you find a
;     valid board with 4 queens produce that result.
; 
;   - You should design a function that consumes a natural - N - and
;     tries to find a solution.
;     
;     
;     
; NOTE 1: You can tell whether two queens are on the same diagonal by comparing
; the slope of the line between them. If one queen is at row and column (r1, c1)
; and another queen is at row and column (r2, c2) then the slope of the line
; between them is: (/ (- r2 r1) (- c2 c1)).  If that slope is 1 or -1 then the
; queens are on the same diagonal.
;_________________________________________________________________________________


;; Data Definitions:

;; Position is Natural[0, (- (sqr N) 1)]:
;; interp. position in the board
;;  - N             is number of queen
;;  - (sqr N)       is number of squares in the board
;;  - (- (sqr N) 1) is maximum number of position in the board
;;    because Position start on number 0
(define P0 0)
(define P4 (- (sqr 4) 1))

;; Board is (listof Position):
;; interp. the Postition of the queens that have been placed on the board
;;         up to N elements long
(define BD0 empty)           ;no queens placed
(define BD1 (list 0))        ;one queen in upper left corner
(define BD4 (list 14 8 7 1)) ;a solution to 4x4 puzzle 

;_________________________________________

;; Functions:

;; Number -> Board or false
;; produce first found solution for n queens of size N; or false if none exists
(check-expect (nqueens 1) (list 0))
(check-expect (nqueens 2) false)
(check-expect (nqueens 3) false)
(check-expect (nqueens 4) (list 14 8 7 1))
(check-expect (nqueens 5) (list 23 16 14 7 0))
(check-expect (nqueens 6) (list 34 26 18 17 9 1))
(check-expect (nqueens 7) (list 47 38 29 27 18 9 0))
(check-expect (nqueens 8) (list 59 49 46 34 29 23 12 0))

;(define (nqueens n) false)

(define (nqueens N)
  (local [(define (solve--bd bd)
            (cond [(all-queens-placed? N bd) bd]
                  [else
                   (solve--lobd (next-board N bd))]))

          (define (solve--lobd lobd)
            (cond [(empty? lobd) false]
                  [else
                   (local [(define try (solve--bd (first lobd)))]
                     (if (not (false? try))
                         try
                         (solve--lobd (rest lobd))))]))]
    (solve--bd empty)))


;; Number Board -> Boolean
;; produce true if length of the list (board) is equal to N
(check-expect (all-queens-placed? 1 empty) false)
(check-expect (all-queens-placed? 1 (list 0)) true)
(check-expect (all-queens-placed? 4 (list 14 8 7)) false)
(check-expect (all-queens-placed? 4 (list 14 8 7 1)) true)

;(define (all-queens-placed? N bd) false)

(define (all-queens-placed? N bd)
  (= N (length bd)))


;; Number Board -> (listof Board)
;; produce the next valid board (place queens on the squares 0 to (- (sqr N) 1)
;; and then keep only the valid board)
(check-expect (next-board 1 empty) (list (list 0)))
(check-expect (next-board 4 (list 4 2)) (list (list 11 4 2)
                                              (list 13 4 2)
                                              (list 15 4 2)))
(check-expect (next-board 4 (list 11 4 2)) (list (list 13 11 4 2)))

;(define (next-board N bd) empty)

(define (next-board N bd)
  (keep-only-valid N (place-queens N bd)))


;; Number Board -> (listof Board)
;; produce list of appended value 0 to (- (sqr N) 1) to Board
;; but not contains same value in the board
(check-expect (place-queens 1 empty) (list (list 0)))
(check-expect (place-queens 4 empty) (list (list 0) (list 1)
                                           (list 2) (list 3)
                                           (list 4) (list 5)
                                           (list 6) (list 7)
                                           (list 8) (list 9)
                                           (list 10) (list 11)
                                           (list 12) (list 13)
                                           (list 14) (list 15)))
(check-expect (place-queens 4 (list 4 2)) (list (list 0 4 2)
                                                (list 1 4 2)
                                                (list 3 4 2)
                                                (list 5 4 2)
                                                (list 6 4 2)
                                                (list 7 4 2)
                                                (list 8 4 2)
                                                (list 9 4 2)
                                                (list 10 4 2)
                                                (list 11 4 2)
                                                (list 12 4 2)
                                                (list 13 4 2)
                                                (list 14 4 2)
                                                (list 15 4 2)))

;(define (place-queens N bd) empty)

(define (place-queens N bd)
  (local [(define max (- (sqr N) 1))

          (define (build-lobd n)
            (cond [(> n max) empty]
                  [else
                   (if (contains? n bd)
                       (build-lobd (+ n 1))
                       (cons (cons n bd)
                             (build-lobd (+ n 1))))]))

          (define (contains? n bd)
            (cond [(empty? bd) false]
                  [else
                   (if (= n (first bd))
                       true
                       (contains? n (rest bd)))]))]
    
    (build-lobd 0)))


;; Number (listof Board) -> (listof Board)
;; produce LOBD that not contains queens attacking each other
;; queens not in the same row, column, and diagonal in the Board
(check-expect (keep-only-valid 1 (list (list 0))) (list (list 0)))
(check-expect (keep-only-valid 4 (list (list 0 4 2)
                                       (list 1 4 2)
                                       (list 3 4 2)
                                       (list 5 4 2)
                                       (list 6 4 2)
                                       (list 7 4 2)
                                       (list 8 4 2)
                                       (list 9 4 2)
                                       (list 10 4 2)
                                       (list 11 4 2)
                                       (list 12 4 2)
                                       (list 13 4 2)
                                       (list 14 4 2)
                                       (list 15 4 2)))
              (list (list 11 4 2)
                    (list 13 4 2)
                    (list 15 4 2)))

;(define (keep-only-valid N lobd) empty)

(define (keep-only-valid N lobd)
  (local [;; Board -> Boolean
          ;; produce true if (first bd) is not attacking every element in (rest bd)
          (define (valid-board? bd)
            (not (rest-attacking-the-first-bd? (first bd) (rest bd))))

          ;; Pos Board -> Boolean
          ;; produce true if n not attacking every element in bd
          (define (rest-attacking-the-first-bd? pos bd)
            (cond [(empty? bd) false]
                  [else
                   (if (attacking? pos (first bd))
                       true
                       (rest-attacking-the-first-bd? pos (rest bd)))]))

          ;; Pos Pos -> Boolean
          ;; produce true if pos1 in the same row, col, OR diagonal to pos2, else false
          (define (attacking? pos1 pos2)
            (local [(define row1 (get-row pos1))
                    (define row2 (get-row pos2))
                    (define col1 (get-col pos1))
                    (define col2 (get-col pos2))]
              (or (= row1 row2)
                  (= col1 col2)
                  (if (not (= col1 col2))
                      (local [(define slope (get-slope row1 row2 col1 col2))]
                        (or (= slope 1)
                            (= slope -1)))
                      true))))

          ;; Number Number Number Number -> Number
          ;; produce slope or gradient
          (define (get-slope y1 y2 x1 x2)
            (/ (- y2 y1) (- x2 x1)))

          ;; Pos -> Number
          ;; produce row from given Pos and NxN board (quotinent)
          (define (get-row pos)
            (floor (/ pos N)))

          ;; Pos -> Number
          ;; produce column from given Pos and NxN board (remainder)
          (define (get-col pos)
            (remainder pos N))]
    
    (filter valid-board? lobd)))

