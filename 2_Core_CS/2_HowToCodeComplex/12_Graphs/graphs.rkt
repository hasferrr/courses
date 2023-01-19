;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname graphs) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; graphs-v2.rkt

;___________________________________________________________________________________
; 
; PROBLEM: 
; 
; Imagine you are suddenly transported into a mysterious house, in which all
; you can see is the name of the room you are in, and any doors that lead OUT
; of the room.  One of the things that makes the house so mysterious is that
; the doors only go in one direction. You can't see the doors that lead into
; the room.
; 
; Here are some examples of such a house:
; 
;                                       ┌────┐
;                                       ▼    │
;                               ┌─►A───►B───►C
;                               │  │    │
;                               │  └─┐  └─┐
;                     A────►B   │    ▼    ▼
;           ┌─────┐   ▲     │   │    D───►E───►F
;           ▼     │   │     │   │         │
; A────►B   A────►B   └──C◄─┘   └─────────┘
; 
; In computer science, we refer to such an information structure as a directed
; graph. Like trees, in directed graphs the arrows have direction. But in a
; graph it is  possible to go in circles, as in the second example above. It
; is also possible for two arrows to lead into a single node, as in the fourth
; example.
; 
;    
; Design a data definition to represent such houses. Also provide example data
; for the four houses above.
;___________________________________________________________________________________


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
#;
(define H3
  (shared ((-0- (make-room "A" (list (make-room "B" (list (make-room "C" (list -0-))))))))
    -0-))

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


;; template:
;;  tail recursive encapsulate w/ local, worklist, context-preserving
;;  accumulator with what rooms have we already visited in complete
;;  tail recursive traversal so far
#;
(define (fn-for-house r0)
  (local [(define (fn-for-room r)
            (... (room-name r)
                 (fn-for-lor (room-exits r))
                 ))
          (define (fn-for-lor lor)
            (cond [(empty? lor) (...)]
                  [else
                   (... (fn-for-room (first lor))
                        (fn-for-lor (rest lor))
                        )]))]
    (fn-for-room r0)))


(define (fn-for-house r0)
  ;; todo    is (listof Room); a worklist accumulator
  ;; visited is (listof String); context perserving accumulator, names of rooms already visited
  (local [(define (fn-for-room r todo visited)
            (if (member (room-name r) visited)              ;if room-name in the visited list
                (fn-for-lor todo
                            visited)
                (fn-for-lor (append (room-exits r) todo)
                            (cons (room-name r) visited)))) ;(room-name r) <-- prob useful
          
          (define (fn-for-lor todo visited)
            (cond [(empty? todo) (...)]
                  [else
                   (fn-for-room (first todo)
                                (rest todo)
                                visited)]))]
    
    (fn-for-room r0 empty empty)))


;___________________________________________________________________________________
;
; PROBLEM:
;
; Design a function that consumes a Room and a room name, and produces true
; if it is possible to reach a room with the given name starting at the given
; room. For example:
;
;   (reachable? H1 "A") produces true
;   (reachable? H1 "B") produces true
;   (reachable? H1 "C") produces false
;   (reachable? H4 "F") produces true
;
; But note that if you defined H4F to be the room named F in the H4 house then
; (reachable? H4F "A") would produce false because it is not possible to get
; to A from F in that house.
;___________________________________________________________________________________

;; Room String -> Boolean
;; produce True if it is possible to reach a room with the given name, else False
(check-expect (reachable? H1 "A") true)
(check-expect (reachable? H1 "B") true)
(check-expect (reachable? H1 "C") false)
(check-expect (reachable? (first (room-exits H1)) "A") false)
(check-expect (reachable? H4 "F") true)

;(define (reachable? r rn) false)

(define (reachable? r0 rn)
  ;; todo    is (listof Room); a worklist accumulator
  ;; visited is (listof String); context perserving accumulator, names of rooms already visited
  (local [(define (fn-for-room r todo visited)
            (cond [(string=? rn (room-name r)) true]
                  [(member (room-name r) visited)
                   (fn-for-lor todo
                               visited)]
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

