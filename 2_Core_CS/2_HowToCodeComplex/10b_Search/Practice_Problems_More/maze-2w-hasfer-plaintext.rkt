;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname maze-2w-hasfer-plaintext) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require racket/list) ;gets list-ref, take and drop

;
; In this problem set you will design a program to check whether a given simple maze is
; solvable.  Note that you are operating on VERY SIMPLE mazes, specifically:
;
;    - all of your mazes will be square
;    - the maze always starts in the upper left corner and ends in the lower right corner
;    - at each move, you can only move down or right
;
; Design a representation for mazes, and then design a function that consumes a maze and
; produces true if the maze is solvable, false otherwise.
;
; Solvable means that it is possible to start at the upper left, and make it all the way to
; the lower right.  Your final path can only move down or right one square at a time. BUT, it
; is permissible to backtrack if you reach a dead end.
;
; For example, the first three mazes below are solvable.  Note that the fourth is not solvable
; because it would require moving left. In this solver you only need to support moving down
; and right! Moving in all four directions introduces complications we are not yet ready for.
;
;     .    .    .    .
;
;
; Your function will of course have a number of helpers. Use everything you have learned so far
; this term to design this program.
;
; One big hint. Remember that we avoid using an image based representation of information unless
; we have to. So the above are RENDERINGs of mazes. You should design a data definition that
; represents such mazes, but don't use images as your representation.
;
; For extra fun, once you are done, design a function that consumes a maze and produces a
; rendering of it, similar to the above images.
;



;; Solve simple square mazes

;___________________________________________________

;; Constants:

(define F false)
(define T true)
(define P "path")

;___________________________________________________

;; Data definitions:

;; Maze is one of:
;; - true
;; - false
;; - "path"
;; interp. a maze is a list of 25 (5x5) Booleans or "path"
;; - True means a way that can move down or right through
;; - False means cannot move through in this path
;; - "path" is path moving through the maze

(define MF (list F F F F F   ;not solvable
                 F F F F F
                 F F F F F
                 F F F F F
                 F F F F F))

(define MT (list T T T T T
                 T T T T T
                 T T T T T
                 T T T T T
                 T T T T T))

(define M1 (list T F F F F
                 T T F T T
                 F T F F F
                 T T F F F
                 T T T T T))

(define M1b (list P F F F F
                  P T F T T
                  F T F F F
                  T T F F F
                  T T T T T)) ;otw, go to right

(define M1c (list P F F F F
                  P P F T T
                  F P F F F
                  T T F F F
                  T T T T T)) ;otw, go to down

(define M1d (list P F F F F
                  P P F T T
                  F P F F F
                  T P F F F
                  T P T T T)) ;otw, go to right

(define M1s (list P F F F F
                  P P F T T
                  F P F F F
                  T P F F F
                  T P P P P)) ;reach the end (solved)

(define M2 (list T T T T T
                 T F F F T
                 T F F F T
                 T F F F T
                 T F F F T))

(define M2b (list P T T T T
                  T F F F T
                  T F F F T
                  T F F F T
                  T F F F T)) ;go to right or down

(define M3 (list T T T T T
                 T F F F F
                 T F F F F
                 T F F F F
                 T T T T T))

(define M4 (list T T T T T   ;not solvable
                 T F F F T
                 T F T T T
                 T F T F F
                 F F T T T))


;; Pos is Number
;; interp. an index of the Maze

;___________________________________________________

;; Functions:

;; Maze -> Boolean
;; produces true if the maze is solvable, false otherwise
(check-expect (solvable? MF) false)
(check-expect (solvable? M4) false)
(check-expect (solvable? MT) true)
(check-expect (solvable? M1) true)
(check-expect (solvable? M2) true)
(check-expect (solvable? M3) true)

;(define (solve mz) false)

(define (solvable? mz)
  (local [(define (solvable?--mz mz) ;MZ -> Bool
            (cond [(last-path? mz) true]
                  [else (solvable?--lomz (next-path mz))])) ;-> (listof Maze)

          (define (solvable?--lomz lomz) ;(loMZ) --> Bool
            (cond [(empty? lomz) false]
                  [else
                   (if (not (false? (solvable?--mz (first lomz))))
                       true
                       (solvable?--lomz (rest lomz))
                       )]
                  ))]

    (solvable?--mz mz)))


;; Maze -> Boolean
;; produce true if the "path" reach the bottom right corner of the maze (end of the list)
(check-expect (last-path? M1) false)
(check-expect (last-path? M1b) false)
(check-expect (last-path? M1s) true)

;(define (last-path? mz) false)

(define (last-path? mz)
  (string? (list-ref mz (- (length mz) 1))))


;; Maze -> (listof Maze)
;; produce the next move or path in the maze

(check-expect (next-path M1) (list (cons P (rest M1))))
(check-expect (next-path M1b) (list (list P F F F F
                                          P P F T T
                                          F T F F F
                                          T T F F F
                                          T T T T T)))
(check-expect (next-path M1c) (list (list P F F F F
                                          P P F T T
                                          F P F F F
                                          T P F F F
                                          T T T T T)))
(check-expect (next-path M2b) (list (list P P T T T
                                          T F F F T
                                          T F F F T
                                          T F F F T
                                          T F F F T)
                                    (list P T T T T
                                          P F F F T
                                          T F F F T
                                          T F F F T
                                          T F F F T)))

;(define (next-path mz) empty)

(define (next-path mz)
  (move-path (find-tail mz) mz))


;; Maze -> (listof Number)
;; produce index(s) of the next path (possible moves) in the maze
(check-expect (find-tail empty) empty)
(check-expect (find-tail MF) empty)
(check-expect (find-tail MT) empty)
(check-expect (find-tail M1) empty)
(check-expect (find-tail M2) empty)
(check-expect (find-tail M1b) (list 6))
(check-expect (find-tail M1c) (list 16))
(check-expect (find-tail M1d) (list 22))
(check-expect (find-tail M2b) (list 1 5))

(define (find-tail mz)
  (local [(define (find-tail--mz mz index)
            (cond [(empty? mz) empty]
                  [(not (string? (first mz))) empty]
                  [else
                   (if  (and (not (string? (list-ref mz (+ index 1))))
                             (if (not (>= index 20))
                                 (not (string? (list-ref mz (+ index 5))))
                                 true))
                        (append (if (not (false? (list-ref mz (+ index 1)))) ;;if no next path detected
                                    (list (+ index 1))
                                    empty)
                                (if (not (>= index 20))
                                    (if (not (false? (list-ref mz (+ index 5))))
                                        (list (+ index 5))
                                        empty)
                                    empty))
                        (append (if (string? (list-ref mz (+ index 1))) ;;if at least 1 path detected
                                    (find-tail--mz mz (+ index 1))
                                    empty)
                                (if (not (>= index 20))
                                    (if (string? (list-ref mz (+ index 5)))
                                        (find-tail--mz mz (+ index 5))
                                        empty)
                                    empty))
                        )]
                  ))]

    (find-tail--mz mz 0)))



;; (listof Number) Maze -> (listof Maze)
;; produce the next path of the maze (moving path)

; LON       Maze |   empty     (cons F rest)         (cons T rest)        (cons P rest)
;________________|______________________________________________________________________
;                |
;     empty      |   empty         empty           (cons P (rest mz))         empty
;                |
;  (cons Number  |    XXX       keep false       change T to P according       XXX
;      LON)      |             (cons F rest)          to the Number

(check-expect (move-path empty empty) empty)
(check-expect (move-path empty MF) empty)
(check-expect (move-path empty MT) (list (cons P (rest MT))))
(check-expect (move-path empty M1) (list (cons P (rest M1))))
(check-expect (move-path empty M2) (list (cons P (rest M2))))
(check-expect (move-path (list 6)   M1b) (list (list P F F F F
                                                     P P F T T
                                                     F T F F F
                                                     T T F F F
                                                     T T T T T)))
(check-expect (move-path (list 16)  M1c) (list (list P F F F F
                                                     P P F T T
                                                     F P F F F
                                                     T P F F F
                                                     T T T T T)))
(check-expect (move-path (list 22)  M1d) (list (list P F F F F
                                                     P P F T T
                                                     F P F F F
                                                     T P F F F
                                                     T P P T T)))
(check-expect (move-path (list 1 5) M2b) (list (list P P T T T
                                                     T F F F T
                                                     T F F F T
                                                     T F F F T
                                                     T F F F T)
                                               (list P T T T T
                                                     P F F F T
                                                     T F F F T
                                                     T F F F T
                                                     T F F F T)))

;(define (move-path lon mz) empty)

(define (move-path lon mz)
  (cond [(and (empty? lon)
              (not (empty? mz))
              (not (false? (first mz)))
              (not (string? (first mz)))) (list (cons P (rest mz)))]
        [(empty? lon) empty]
        [else
         (local [(define (generate-next-path-maze lon)  ; LON mz -> (listof Maze)
                   (cond [(empty? lon) empty]
                         [else
                          (cons (cond [(not (false? (list-ref mz (first lon)))) ;if true, replace that true to P
                                       (fill-square mz (first lon) P)]
                                      [else mz]) ;if false, go ahead
                                (generate-next-path-maze (rest lon))
                                )]
                         ))]
           (generate-next-path-maze lon))]
        ))


;; Maze Index Value -> Maze
;; produce new maze with value at given index
;; copy from sudoku-starter.rkt
(check-expect (fill-square (list 99 88 77) 0 "changed")
              (list "changed" 88 77))

(define (fill-square mz index val)
  (append (take mz index)
          (list val)
          (drop mz (add1 index))))
