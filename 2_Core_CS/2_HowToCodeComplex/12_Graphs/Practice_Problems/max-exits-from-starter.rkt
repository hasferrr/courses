;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname max-exits-from-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; max-exits-from-starter.rkt

; 
; PROBLEM:
; 
; Using the following data definition, design a function that produces the room with the most exits 
; (in the case of a tie you can produce any of the rooms in the tie).
;


;; Data Definitions: 

(define-struct room (name exits))
;; Room is (make-room String (listof Room))
;; interp. the room's name, and list of rooms that the exits lead to

; A────►B
(define H1 (make-room "A" (list (make-room "B" empty))))

; ┌─────┐
; ▼     │
; A────►B
(define H2 
  (shared ((-0- (make-room "A" (list (make-room "B" (list -0-))))))
    -0-)) 
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
           (-C- (make-room "C" (list -A-))))
    -A-))
           


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




;; Room -> Room
;; produce the room with the most exits
(check-expect (max-exits-from H1) H1)
(check-expect (max-exits-from H2) H2)
(check-expect (max-exits-from (shared ((-A- (make-room "A" (list -B-)))
                                       (-B- (make-room "B" (list -C- -D-)))
                                       (-C- (make-room "C" (list -A-)))
                                       (-D- (make-room "D" (list -E- -F- -G-)))
                                       (-E- (make-room "E" (list -A-)))
                                       (-F- (make-room "F" (list)))
                                       (-G- (make-room "G" (list -C-))))
                                -A-))
              (shared ((-A- (make-room "A" (list -B-)))
                       (-B- (make-room "B" (list -C- -D-)))
                       (-C- (make-room "C" (list -A-)))
                       (-D- (make-room "D" (list -E- -F- -G-)))
                       (-E- (make-room "E" (list -A-)))
                       (-F- (make-room "F" (list)))
                       (-G- (make-room "G" (list -C-))))
                -D-))

;(define (max-exits-from r) r)

;; Template from Room
(define (max-exits-from r0)
  ;; todo         is (listof Room)  ; a worklist accumulator
  ;; visited      is (listof String); context preserving accumulator, names of rooms already visited
  ;; room-sf      is Room           ; room with the most exits seen so far
  ;; max-exits-sf is Natural        ; number of exits room with the most exits seen so far
  (local [(define (fn-for-room r todo visited room-sf max-exits-sf)
            (cond [(member (room-name r) visited)
                   (fn-for-lor todo visited room-sf max-exits-sf)]
                  [(> (length (room-exits r)) max-exits-sf)
                   (fn-for-lor (append (room-exits r) todo)
                               (cons (room-name r) visited)
                               r
                               (length (room-exits r))
                               )]
                  [else
                   (fn-for-lor (append (room-exits r) todo)
                               (cons (room-name r) visited)
                               room-sf
                               max-exits-sf
                               )]))
          (define (fn-for-lor todo visited room-sf max-exits-sf)
            (cond [(empty? todo) room-sf]
                  [else
                   (fn-for-room (first todo) 
                                (rest todo)
                                visited
                                room-sf
                                max-exits-sf)]))]
    (fn-for-room r0 empty empty r0 (length (room-exits r0)))))

