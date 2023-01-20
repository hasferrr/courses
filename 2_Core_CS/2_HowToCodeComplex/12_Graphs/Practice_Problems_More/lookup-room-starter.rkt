;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname lookup-room-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; lookup-room-starter.rkt

; 
; PROBLEM:
; 
; Using the following data definition, design a function that consumes a room and a room 
; name and tries to find a room with the given name starting at the given room.
; 

;__________________________________________________________________

;; Data Definitions: 

(define-struct room (name exits))
;; Room is (make-room String (listof Room))
;; interp. the room's name, and list of room that exits lead to


; A────►B
(define H1 (make-room "A" (list (make-room "B" empty))))


; ┌─────┐
; ▼     │
; A────►B
(define H2
  (shared ((-0- (make-room "A" (list (make-room "B" (list -0-)))))) -0-))
;(room-name H2)                  ;A
;(length (room-exits H2))        ;1
;(map room-name (room-exits H2)) ;(list "B")


; A────►B
; ▲     │
; │     │
; └──C◄─┘
(define H3
  (shared ((-A- (make-room "A" (list -B-)))
           (-B- (make-room "B" (list -C-)))
           (-C- (make-room "C" (list -A-)))) -A-))


;         ┌────┐
;         ▼    │
; ┌─►A───►B───►C
; │  │    │
; │  └─┐  └─┐
; │    ▼    ▼
; │    D───►E───►F
; │         │
; └─────────┘
(define H4
  (shared ((-A- (make-room "A" (list -B- -D-)))
           (-B- (make-room "B" (list -C- -E-)))
           (-C- (make-room "C" (list -B-)))
           (-D- (make-room "D" (list -E-)))
           (-E- (make-room "E" (list -F- -A-)))
           (-F- (make-room "F" (list))))
    -A-))

;; template: structural recursion, encapsulate w/ local, tail-recursive w/ worklist, 
;;           context-preserving accumulator what rooms have we already visited

(define (fn-for-house r0)
  ;; todo is (listof Room); a worklist accumulator
  ;; visited is (listof String); context preserving accumulator, names of rooms already visited
  (local [(define (fn-for-room r todo visited) 
            (if (member (room-name r) visited)
                (fn-for-lor todo visited)
                (fn-for-lor (append (room-exits r) todo)
                            (cons (room-name r) visited)))) ; (... (room-name r))
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) (...)]
                  [else
                   (fn-for-room (first todo) 
                                (rest todo)
                                visited)]))]
    (fn-for-room r0 empty empty))) 


;__________________________________________________________________

;; Functions:

;; Room String -> Boolean
;; produce true if the room (r) contains the given room name (s)
(check-expect (lookup-room H1 "A") H1)
(check-expect (lookup-room H1 "Z") false)
(check-expect (lookup-room H3 "C") (shared ((-A- (make-room "A" (list -B-)))
                                            (-B- (make-room "B" (list -C-)))
                                            (-C- (make-room "C" (list -A-)))) -C-))
(check-expect (lookup-room H3 "Z") false)
(check-expect (lookup-room H4 "A") H4)
(check-expect (lookup-room H4 "C") (shared ((-A- (make-room "A" (list -B- -D-)))
                                            (-B- (make-room "B" (list -C- -E-)))
                                            (-C- (make-room "C" (list -B-)))
                                            (-D- (make-room "D" (list -E-)))
                                            (-E- (make-room "E" (list -F- -A-)))
                                            (-F- (make-room "F" (list))))
                                     -C-))
(check-expect (lookup-room H4 "F") (shared ((-A- (make-room "A" (list -B- -D-)))
                                            (-B- (make-room "B" (list -C- -E-)))
                                            (-C- (make-room "C" (list -B-)))
                                            (-D- (make-room "D" (list -E-)))
                                            (-E- (make-room "E" (list -F- -A-)))
                                            (-F- (make-room "F" (list))))
                                     -F-))
(check-expect (lookup-room H4 "Z") false)

;(define (lookup-room r s) false)

(define (lookup-room r0 s)
  ;; todo is (listof Room); a worklist accumulator
  ;; visited is (listof String); context preserving accumulator, names of rooms already visited
  (local [(define (fn-for-room r todo visited) 
            (cond [(member (room-name r) visited)
                   (fn-for-lor todo visited)]
                  [(string=? s (room-name r)) r]
                  [else
                   (fn-for-lor (append (room-exits r) todo)
                               (cons (room-name r) visited))]))
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) false]
                  [else
                   (fn-for-room (first todo) 
                                (rest todo)
                                visited)]))]
    (fn-for-room r0 empty empty)))

