;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname max-exits-to-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; max-exits-to-starter.rkt

; 
; PROBLEM:
; 
; Using the following data definition, design a function that produces the room to which the greatest 
; number of other rooms have exits (in the case of a tie you can produce any of the rooms in the tie).
; 


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
;; produces the room to which the greatest number of other rooms have exits
(check-expect (max-exits-to H1) H1)
(check-expect (max-exits-to H2) (first (room-exits H2)))
(check-expect (max-exits-to (shared ((-A- (make-room "A" (list -B-)))
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
                -B-))
(check-expect (max-exits-to (shared ((-A- (make-room "A" (list -B- -C- -D-)))
                                     (-B- (make-room "B" (list -E-)))
                                     (-C- (make-room "C" (list)))
                                     (-D- (make-room "D" (list -A-)))
                                     (-E- (make-room "E" (list -A-)))
                                     )
                              -A-))
              (shared ((-A- (make-room "A" (list -B- -C- -D-)))
                       (-B- (make-room "B" (list -E-)))
                       (-C- (make-room "C" (list)))
                       (-D- (make-room "D" (list -A-)))
                       (-E- (make-room "E" (list -A-)))
                       )
                -E-))
(check-expect (max-exits-to H4) 
              (shared ((-A- (make-room "A" (list -B- -D-)))
                       (-B- (make-room "B" (list -C- -E-)))
                       (-C- (make-room "C" (list -B-)))
                       (-D- (make-room "D" (list -E-)))
                       (-E- (make-room "E" (list -F- -A-)))
                       (-F- (make-room "F" (list))))
                -E-))

;(define (max-exits-to r) r)


;; Template from Room w/ additional accumulators

(define (max-exits-to r0)
  ;; todo          is (listof r-p)   ; a worklist accumulator
  ;; visited       is (listof String); context preserving accumulator, names of rooms already visited
  ;; room-sf       is r-p            ; room with their parent room with the most exits seen so far
  ;; max-exits-sf  is Natural        ; number of exits room with the most exits seen so far
  ;; pr            is Room           ; parent of the current room with the most exits seen so far
  ;; get-parent-r0 is Room           ; first parent of r0
  
  (local [(define-struct r-p (cr pr))
          ;; R-P is (make-r-p Room Room)
          ;; interp cr is current room
          ;;        pr is parent room

          (define (fn-for-room r todo visited room-sf max-exits-sf pr get-parent-r0)
            
            (local [(define check-parent (if (and (member r0 (room-exits r))
                                                  (not (member r0 (room-exits get-parent-r0))))
                                             r
                                             get-parent-r0))
                    (define merge-worklist (append (map (λ (cr) (make-r-p cr r)) (room-exits r)) todo))]
              
              (cond [(member (room-name r) visited)
                     (fn-for-lor todo
                                 visited
                                 room-sf
                                 max-exits-sf
                                 check-parent
                                 )]
                  
                    [(> (length (room-exits r)) max-exits-sf)
                     (fn-for-lor merge-worklist
                                 (cons (room-name r) visited)
                                 (make-r-p r pr)             ;r -> set r to r-p with parent
                                 (length (room-exits r))
                                 check-parent
                                 )]
                  
                    [else
                     (fn-for-lor merge-worklist
                                 (cons (room-name r) visited)
                                 room-sf
                                 max-exits-sf
                                 check-parent
                                 )])))
          
          (define (fn-for-lor todo visited room-sf max-exits-sf get-parent-r0)
            (cond [(empty? todo) (if (string=? (room-name (r-p-pr room-sf))
                                               (room-name (r-p-cr room-sf)))
                                     get-parent-r0
                                     (r-p-pr room-sf))]      ;get the parent
                  [else
                   (fn-for-room (r-p-cr (first todo))        ;; r-p -> cr
                                (rest todo)
                                visited
                                room-sf
                                max-exits-sf
                                (r-p-pr (first todo))        ;; r-p -> pr
                                get-parent-r0
                                )]))]
    
    (fn-for-room r0 empty empty (make-r-p r0 r0) (length (room-exits r0)) r0 r0)))


