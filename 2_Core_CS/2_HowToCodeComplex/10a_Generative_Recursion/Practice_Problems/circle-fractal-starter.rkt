;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname circle-fractal-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; circle-fractal-starter.rkt

; 
; PROBLEM :
; 
; Design a function that will create the following fractal:
; 
; 
; 
;
; 
; Each circle is surrounded by circles that are two-fifths smaller. 
; 
; You can build these images using the convenient beside and above functions
; if you make your actual recursive function be one that just produces the
; top leaf shape. You can then rotate that to produce the other three shapes.
; 
; You don't have to use this structure if you are prepared to use more
; complex place-image functions and do some arithmetic. But the approach
; where you use the helper is simpler.
; 
; Include a termination argument for your design.


;; =================
;; Constants:

(define STEP (/ 2 5))
(define TRIVIAL-SIZE 5)

;; =================
;; Functions:

;; Number -> Image
;; produce circle fractal with teh given size (s)
(check-expect (circle-fractal TRIVIAL-SIZE) (circle TRIVIAL-SIZE "outline" "blue"))
(check-expect (circle-fractal (/ TRIVIAL-SIZE STEP))
              (local [(define subcir (circle TRIVIAL-SIZE "outline" "blue"))]
                (beside subcir
                        (above subcir
                               (circle (/ TRIVIAL-SIZE STEP) "outline" "blue")
                               subcir)
                        subcir)))

;(define (circle-fractal s) empty-image) ;stub

(define (circle-fractal s)
  (local [(define (cir-frac s)
            (cond [(<= s TRIVIAL-SIZE) (circle s "outline" "blue")]
                  [else
                   (local [(define sub (* s STEP))]
                     (above (cir-t sub)
                            (beside (cir-l sub)
                                    (circle s "outline" "blue")
                                    (cir-r sub))
                            (cir-b sub)))]
                  ))
          (define (cir-t s)
            (cond [(<= s TRIVIAL-SIZE) (circle s "outline" "blue")]
                  [else
                   (local [(define sub (* s STEP))]
                     (above (cir-t sub)
                            (beside (cir-l sub)
                                    (circle s "outline" "blue")
                                    (cir-r sub))
                            empty-image))]
                  ))
          (define (cir-b s)
            (cond [(<= s TRIVIAL-SIZE) (circle s "outline" "blue")]
                  [else
                   (local [(define sub (* s STEP))]
                     (above empty-image
                            (beside (cir-l sub)
                                    (circle s "outline" "blue")
                                    (cir-r sub))
                            (cir-b sub)))]
                  ))
          (define (cir-l s)
            (cond [(<= s TRIVIAL-SIZE) (circle s "outline" "blue")]
                  [else
                   (local [(define sub (* s STEP))]
                     (beside (cir-l sub)
                             (above (cir-t sub)
                                    (circle s "outline" "blue")
                                    (cir-b sub))
                             empty-image))]
                  ))
          (define (cir-r s)
            (cond [(<= s TRIVIAL-SIZE) (circle s "outline" "blue")]
                  [else
                   (local [(define sub (* s STEP))]
                     (beside empty-image
                             (above (cir-t sub)
                                    (circle s "outline" "blue")
                                    (cir-b sub))
                             (cir-r sub)))]
                  ))]
    (cir-frac s)))


;(circle-fractal (/ (/ TRIVIAL-SIZE STEP) STEP))
;(circle-fractal (/ (/ (/ TRIVIAL-SIZE STEP) STEP) STEP))

#|
 Termination Argument
    trivial case: (<= s TRIVIAL-SIZE)
    reduction step: (* s STEP)
    argument: as long as TRIVIAL-SIZE > 0, STEP is between 0 and 1,
              s will reduced and eventually < TRIVIAL-SIZE
|#



