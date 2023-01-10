;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname triangle-solitaire-hasfer-2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; triangle-solitaire-starter.rkt

; 
; PROBLEM:
; 
; The game of trianguar peg solitaire is described at a number of web sites,
; including http://www.mathsisfun.com/games/triangle-peg-solitaire/#. 
; 
; We would like you to DESIGN A PROGRAM to solve triangular peg solitaire
; boards. Your program should include a FUNCTION called solve that consumes
; a board and produces a solution for it, or false if the board is not
; solvable. Read the rest of this problem box VERY CAREFULLY, it contains
; both hints and additional constraints on your solution.
; 
; The key elements of the game are:
; 
;   - there is a BOARD with 15 cells, each of which can either
;     be empty or contain a peg (empty or full).
;     
;   - a potential JUMP whenever there are 3 holes in a row
;   
;   - a VALID JUMP  whenever FORM and OVER positions contain a
;     peg (are full) and the TO position is empty
;     
;   - the game starts with a board that has a single empty
;     position
;     
;   - the game ends when there is only one peg left - a single
;     full cell
;     
; Here is one sample sequence of play, in which the player miraculously does
; not make a single incorrect move. (A move they have to backtrack from.) No
; one is actually that lucky!
;
;      _           O           O           _           _    
;     O O         _ O         _ O         _ _         O _   
;    O O O       _ O O       O _ _       O _ O       _ _ O  
;   O O O O     O O O O     O O O O     O O O O     _ O O O 
;  O O O O O   O O O O O   O O O O O   O O O O O   O O O O O
; 
;      _           _           _           _           _
;     O O         O O         _ O         _ _         _ _
;    _ _ _       _ O O       _ _ O       _ _ _       _ _ O
;   _ O O _     _ _ _ _     _ _ O _     _ _ O O     _ _ O _
;  O O O O O   O _ _ O O   O _ _ O O   O _ _ O O   O _ _ O _
; 
;      _           _           _
;     _ _         _ _         _ _
;    _ _ _       _ _ _       _ _ _
;   _ _ _ _     _ _ _ _     _ _ _ _
;  O _ O O _   O O _ _ _   _ _ O _ _


;____________________________________________________________________

;; Data definition:

;; Board is (listof Boolean) of length 15
;; interp.
;; - true  means peg in the hole
;; - false means empty hole

;; Position is Natural[0,14]
;; interp. 0 based indexes number into a board

(define-struct jump (from over to))
;; Jump is (make-jump Position Position Position)
;; interp.
;;  a jump on the board, with the from, to and
;;  jumped over positions

(define POSITIONS
  ;; (list        0
  ;;            1   2
  ;;          3   4   5
  ;;        6   7   8   9
  ;;      10  11  12  13  14 ))
  (list 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14))

(define MTB (build-list 15 (lambda (p) false)))
(define BD1 (build-list 15 (lambda (p) (not (= p 0))) )) ;top spot open
(define BD2 (build-list 15 (lambda (p) (not (= p 4)))))  ;center spot open

(define BD3 (build-list 15 (lambda (p) (or (= p 13)
                                           (= p 14)))))  ;almost solved
(define BD4 (build-list 15 (lambda (p) (or (= p 0)       
                                           (= p 3)))))   ;unsolvable (pos 3 and 0 have pegs)

(define BD1a (build-list 15                              ;possible next board
                         (lambda (p)                     ;after BD1
                           (not (or (= p 1)              ;pos 1 and 3 have pegs
                                    (= p 3))))))
(define BD1b (build-list 15                              ;possible next board
                         (lambda (p)                     ;after BD1
                           (not (or (= p 2)              ;pos 2 and 5 have pegs
                                    (= p 5))))))

(define BD1s (build-list 15 (lambda (p) (= p 12))))      ;solutions
(define BD2s (build-list 15 (lambda (p) (= p 12))))
(define BD3s (build-list 15 (lambda (p) (= p 12))))


;; The raw possible jumps given the shape of the board. 
;; For a given board these are only valid if the FROM and
;; OVER are full and the TO is empty.
(define JUMPS
  (list
   (make-jump  0 1  3) (make-jump  0  2  5)
   (make-jump  1 3  6) (make-jump  1  4  8)
   (make-jump  2 4  7) (make-jump  2  5  9)
   (make-jump  3 1  0) (make-jump  3  4  5) (make-jump  3  6 10) (make-jump  3  7 12)
   (make-jump  4 7 11) (make-jump  4  8 13)
   (make-jump  5 2  0) (make-jump  5  4  3) (make-jump  5  8 12) (make-jump  5  9 14)
   (make-jump  6 3  1) (make-jump  6  7  8)
   (make-jump  7 4  2) (make-jump  7  8  9)
   (make-jump  8 4  1) (make-jump  8  7  6)
   (make-jump  9 5  2) (make-jump  9  8  7)
   (make-jump 10 6  3) (make-jump 10 11 12)
   (make-jump 11 7  4) (make-jump 11 12 13)
   (make-jump 12 7  3) (make-jump 12  8  5) (make-jump 12 11 10) (make-jump 12 13 14)
   (make-jump 13 8  4) (make-jump 13 12 11)
   (make-jump 14 9  5) (make-jump 14 13 12)))

;____________________________________________________________________

;; Functions:

;; Board -> (listof Board) or false
;; If bd is solvable, produce list of boards to solution (step by step), otherwise produce false.
(check-expect (solve MTB) false)
(check-expect (solve BD4) false)
(check-expect (solve BD3) (list BD3 BD3s))
(check-expect (solve BD3s) (list BD3s))
(check-expect (solve BD1)
              (local [(define T true)
                      (define F false)]
                (list
                 (list F T T T T T T T T T T T T T T)
                 (list T F T F T T T T T T T T T T T)
                 (list T F T T F F T T T T T T T T T)
                 (list F F F T F T T T T T T T T T T)
                 (list F T F F F T F T T T T T T T T)
                 (list F T T F F F F T T F T T T T T)
                 (list F T T F T F F F T F T F T T T)
                 (list F T T F T T F F F F T F F T T)
                 (list F F T F F T F F T F T F F T T)
                 (list F F F F F F F F T T T F F T T)
                 (list F F F F F T F F T F T F F T F)
                 (list F F F F F F F F F F T F T T F)
                 (list F F F F F F F F F F T T F F F)
                 (list F F F F F F F F F F F F T F F))))

;(define (solve bd) false)

(define (solve bd)
  (local [(define (solve--bd bd)                                 ;bd -> lobd|false
            (cond [(solved? bd) (list bd)]
                  [else
                   (local [(define solution (solve--lobd (next-possible-board bd)))]
                     (if (not (false? solution))
                         (cons bd solution)
                         false
                         ))]
                  ))

          (define (solve--lobd lobd)                             ;lobd -> lobd|false
            (cond [(empty? lobd) false]
                  [else
                   (local [(define try (solve--bd (first lobd)))]
                     (if (not (false? try))
                         try
                         (solve--lobd (rest lobd))
                         ))]
                  ))]

    (solve--bd bd)))




;; Board -> Boolean
;; produce true, if given board only have one peg left
(check-expect (solved? BD1s) true)
(check-expect (solved? BD1) false)
(check-expect (solved? BD1a) false)
(check-expect (solved? BD1b) false)
(check-expect (solved? BD2) false)
(check-expect (solved? BD3) false)
(check-expect (solved? BD4) false)
;(define (solved? bd) false)
(define (solved? bd)
  (cond [(empty? bd) false]
        [else
         (local [(define (not-contain-true? bd)
                   (cond [(empty? bd) true]
                         [else
                          (if (not (false? (first bd)))
                              false
                              (not-contain-true? (rest bd)))]))]
           (if (not (false? (first bd)))
               (not-contain-true? (rest bd))
               (solved? (rest bd))
               ))]
        ))




;; Board -> (listof Board)
;; produce the next boards in the (listof Board) which is the next possible board after peg jumping
(check-expect (next-possible-board BD1) (list BD1a BD1b))
;(define (next-possible-board bd) empty)
(define (next-possible-board bd)
  (next-jump (find-possible-jump bd) bd))


;; Board -> (listof Jump)
;; produce list of the possible valid Jump in the board
(check-expect (find-possible-jump empty) empty)
(check-expect (find-possible-jump BD4) empty)
(check-expect (find-possible-jump BD1) (list (make-jump  3  1  0)
                                             (make-jump  5  2  0)))
(check-expect (find-possible-jump BD2) (list (make-jump 11  7  4)
                                             (make-jump 13  8  4)))
(check-expect (find-possible-jump BD3) (list (make-jump 14 13 12)))

;(define (find-possible-jump bd) empty)

(define (find-possible-jump bd)
  (local [(define (valid-jump loj)                           ; (listof Jump) -> (listof Jump)
            (filter can-jump? loj))
          
          (define (can-jump? j)                              ; Jump -> Boolean
            (and (not (false? (get-cell bd (jump-from j))))
                 (not (false? (get-cell bd (jump-over j))))
                 (false?      (get-cell bd (jump-to j)))))]
    
    (valid-jump JUMPS)))


;; (listof Jump) Board -> (listof Board)
;; produce list of the next board after the peg jumping, only jump from the given (listof Jump) in the given board
; _______________________________________________________________________
; |                |                                                     |
; |vLOJv   Board>> |   empty       (cons T|F rest)                       |
; |________________|_____________________________________________________|
; |                |                                                     |
; |     empty      |   empty(bd)   empty(board with no possible jump)    |
; |                |                                                     |
; |                |                                                     |
; |  (cons Jump    |    XXX        change: FROM,OVER pos to False;       |
; |     rest)      |               TO pos to True (from given LOJ and    |
; |                |               do the same thing in the rest of LOJ) |
; |________________|_____________________________________________________|

(check-expect (next-jump empty empty) empty)
(check-expect (next-jump (list (make-jump  3 1  0)
                               (make-jump  5 2  0)) BD1) (list BD1a BD1b))
(check-expect (next-jump (list (make-jump 14 13 12)) BD3) (list BD3s))

;(define (next-jump loj bd) empty)

(define (next-jump loj bd)
  (cond [(empty? bd) empty]
        [(empty? loj) empty]
        [else (produce-next-board loj bd)]))

(define (produce-next-board loj bd)
  (cond [(empty? loj) empty]
        [else
         (cons (set-cell (set-cell (set-cell bd
                                             (jump-from (first loj))
                                             false)
                                   (jump-over (first loj))
                                   false)
                         (jump-to (first loj))
                         true)
               (produce-next-board (rest loj) bd))]))

;_________________________________________

;; Board Position -> Boolean
;; produce contents of position p on bd
(check-expect (get-cell BD1 0) false)
(check-expect (get-cell BD1 3) true)

;(define (get-cell bd pos)

(define (get-cell bd pos)
  (cond [(empty? bd) -1]
        [else
         (if  (= pos 0)
              (first bd)
              (get-cell (rest bd) (- pos 1))
              )]
        ))


;; Board Position Boolean -> Board
;; produce new board with val at position pos

(check-expect (set-cell BD1 3 false)
              (build-list 15 
                          (lambda (p) 
                            (not (or (= p 0)  
                                     (= p 3))))))
(check-expect (set-cell BD1 5 false)
              (build-list 15 
                          (lambda (p) 
                            (not (or (= p 0)  
                                     (= p 5))))))
(check-expect (set-cell BD1 0 true)
              (build-list 15 
                          (lambda (p) true)))

(check-expect (set-cell MTB 5 true) 
              (build-list 15 (lambda (p) (= p 5))))
(check-expect (set-cell MTB 5 false) 
              (build-list 15 (lambda (p) false)))
(check-expect (set-cell BD2 12 false) 
              (build-list 15 (lambda (p) (not (or (= p 4)
                                                  (= p 12))))))

;(define (set-cell bd pos val) empty)

(define (set-cell bd pos val)
  (cond [(empty? bd) empty]
        [else
         (if  (= pos 0)
              (cons val (rest bd))
              (cons (first bd) (set-cell (rest bd) (- pos 1) val))
              )]
        ))
