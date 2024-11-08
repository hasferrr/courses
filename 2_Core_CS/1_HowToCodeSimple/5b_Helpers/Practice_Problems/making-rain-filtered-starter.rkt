;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname making-rain-filtered-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; making-rain-filtered-starter.rkt

 #| 
PROBLEM:

Design a simple interactive animation of rain falling down a screen. Wherever we "click",
a rain drop should be "created" and as time goes by it should fall. Over time the drops
will reach the bottom of the screen and '"fall off"'. You should "filter" these excess
drops out of the world state - otherwise your program is continuing to tick and
and draw them long after they are invisible.

In your design pay particular attention to the helper rules. In our solution we use
these rules to split out helpers:
  - function composition
  - reference
  - knowledge domain shift
  
  
NOTE: This is a fairly long problem.  While you should be getting more comfortable with 
world problems there is still a fair amount of work to do here. Our solution has 9
functions including main. If you find it is taking you too long then jump ahead to the
next homework problem and finish this later.

 |# 

;; Make it rain where we want it to.

;; ===================================================
;; Constants:

(define WIDTH  500)
(define HEIGHT 500)

(define SPEED 1)

(define DROP (ellipse 4 8 "solid" "blue"))

(define MTS (rectangle WIDTH HEIGHT "solid" "light blue"))




;; ===================================================
;; Data definitions:


(define-struct drop (x y))
;; Drop is (make-drop Integer Integer)
;; interp. A raindrop on the screen, with x and y coordinates.

(define D1 (make-drop 10 30))

#;
(define (fn-for-drop d)
  (... (drop-x d) 
       (drop-y d)))

;; Template Rules used:
;; - compound: 2 fields




;; ListOfDrop is one of:
;;  - empty
;;  - (cons Drop ListOfDrop)
;; interp. a list of drops

(define LOD1 empty)
(define LOD2 (cons (make-drop 10 20) (cons (make-drop 3 6) empty)))

#;
(define (fn-for-lod lod)
  (cond [(empty? lod) (...)]
        [else
         (... (fn-for-drop (first lod))
              (fn-for-lod (rest lod)))]))

;; Template Rules used:
;; - one-of: 2 cases
;; - atomic distinct: empty
;; - compound: (cons Drop ListOfDrop)
;; - reference: (first lod) is Drop
;; - self reference: (rest lod) is ListOfDrop




;; ===================================================
;; Functions:


;; ListOfDrop -> ListOfDrop
;; start rain program by evaluating (main empty)
(define (main lod)
  (big-bang lod
    (on-mouse  handle-mouse)   ; ListOfDrop Integer Integer MouseEvent -> ListOfDrop
    (on-tick   next-drops)     ; ListOfDrop -> ListOfDrop
    (to-draw   render-drops)   ; ListOfDrop -> Image
    )
  )

;; ===================================================

;; ListOfDrop Integer Integer MouseEvent -> ListOfDrop
;; if mevt is "button-down" add a new drop at that position
(check-expect (handle-mouse empty                         50 100 "button-down")
              (cons (make-drop 50 100)
                    empty))
(check-expect (handle-mouse (cons (make-drop 5 6) empty) 100 200 "button-down")
              (cons (make-drop 100 200)
                    (cons (make-drop 5 6)
                          empty)))

;(define (handle-mouse lod x y mevt) empty) ; stub

;Template from MouseEvent

(define (handle-mouse lod x y mevt)
  (cond [(mouse=? mevt "button-down") (cons (make-drop x y) lod)]
        [else lod]))

;; ===================================================

;; ListOfDrop -> ListOfDrop
;; produce filtered AND ticked list of drops that the drops turun ke bawah setiap tick
(check-expect (next-drops (cons (make-drop 5 6)
                                empty))
              (cons (make-drop 5 (+ 6 SPEED))
                    empty))
(check-expect (next-drops (cons (make-drop 100 200)
                                (cons (make-drop 5 6)
                                      empty)))
              (cons (make-drop 100 (+ 200 SPEED))
                    (cons (make-drop 5 (+ 6 SPEED))
                          empty)))
(check-expect (next-drops (cons (make-drop 100 (+ 1 HEIGHT))
                                (cons (make-drop 30 40)
                                      empty)))
              (cons (make-drop 30 (+ 40 SPEED))
                    empty))

;(define (next-drops lod) empty) ; stub

;Use function compotition

(define (next-drops lod)
  (filter-drop (listofdrop lod))
  )

;; ===================================================
;; ===================================================

;; ListOfDrop -> ListOfDrop
;; produce list of sorted drop (menghapus drop di luar screen)
(check-expect (filter-drop empty) empty)
(check-expect (filter-drop (cons (make-drop 100 200)
                                 (cons (make-drop 5 6)
                                       empty)))
              (cons (make-drop 100 200)
                    (cons (make-drop 5 6)
                          empty)))
(check-expect (filter-drop (cons (make-drop 100 (+ 1 HEIGHT))
                                 (cons (make-drop 30 40)
                                       empty)))
              (cons (make-drop 30 40)
                    empty))
(check-expect (filter-drop (cons (make-drop 200 200)
                                 (cons (make-drop 100 (+ 1 HEIGHT))
                                       (cons (make-drop 50 50)
                                             empty))))
              (cons (make-drop 200 200)
                    (cons (make-drop 50 50)
                          empty)))

;(define (filter-drop lod) lod) ;stub

;Template use from ListOfDrop

(define (filter-drop lod)
  (cond [(empty? lod) empty]
        [else
         (if (bigger-than-height (first lod))
             (filter-drop (rest lod))
             (cons (first lod) (filter-drop (rest lod)))
             )]
        )
  )

;; ===================================================
;; ===================================================
;; ===================================================

;; Drop -> Boolean
;; produce true if drop-y > HEIGHT
(check-expect (bigger-than-height (make-drop 10 10)) false)
(check-expect (bigger-than-height (make-drop 20 HEIGHT)) false)
(check-expect (bigger-than-height (make-drop 30 (+ 1 HEIGHT))) true)

;(define (bigger-than-height d) false) ;stub

;Template use from Drop

(define (bigger-than-height d)
  (> (drop-y d) HEIGHT))

;; ===================================================
;; ===================================================

;; ListOfDrop -> ListOfDrop
;; produce list of unsorted drop (drop di luar screen BELUM TERHAPUS)
(check-expect (listofdrop empty) empty)
(check-expect (listofdrop (cons (make-drop 5 6)
                                empty))
              (cons (make-drop 5 (+ 6 SPEED))
                    empty))
(check-expect (listofdrop (cons (make-drop 100 200)
                                (cons (make-drop 5 6)
                                      empty)))
              (cons (make-drop 100 (+ 200 SPEED))
                    (cons (make-drop 5 (+ 6 SPEED))
                          empty)))

;(define (listofdrop lod) lod) ;stub

;Template from ListOfDrop

(define (listofdrop lod)
  (cond [(empty? lod) empty]
        [else
         (cons (fall-drop (first lod))
               (listofdrop (rest lod))
               )]
        )
  )

;; ===================================================
;; ===================================================
;; ===================================================

;; Drop -> Drop
;; add drop-y by SPEED
(check-expect (fall-drop (make-drop 100 200))
              (make-drop 100 (+ 200 SPEED)))

;(define (fall-drop d) d) ;stub

;Template from Drop

(define (fall-drop d)
  (make-drop (drop-x d)
             (+ (drop-y d) SPEED)))


;; ===================================================

;; ListOfDrop -> Image
;; Render the drops onto MTS ;(place-image IMG x y MTS)
(check-expect (render-drops empty) MTS)
(check-expect (render-drops (cons (make-drop 100 200)
                                  empty))
              (place-image DROP 100 200
                           MTS))
(check-expect (render-drops (cons (make-drop 5 6)
                                  (cons (make-drop 100 200)
                                        empty)))
              (place-image DROP 5 6
                           (place-image DROP 100 200
                                        MTS)))

;(define (render-drops lod) MTS) ; stub

;Template from ListOfDrop

(define (render-drops lod)
  (cond [(empty? lod) MTS]
        [else
         (place-image DROP (drop-x (first lod)) (drop-y (first lod))
                      (render-drops (rest lod))
                      )]
        )
  )



