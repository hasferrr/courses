;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname alternative-tuition-graph-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; alternative-tuition-graph-starter.rkt

 #| 
Consider the following alternative type comment for Eva's school tuition 
information program. Note that this is just a single type, with no reference, 
but it captures all the same information as the two types solution in the 
videos.

(define-struct school (name tuition next))
;; School is one of:
;;  - false
;;  - (make-school String Natural School)
;; interp. an arbitrary number of schools, where for each school we have its
;;         name and its tuition in USD

(A) Confirm for yourself that this is a well-formed self-referential data 
definition.

ya, ini adalah well-formed self-referential data definition because the School will
referenced to other School sejumlah tidak diketahui (karena merupakan arbritary
data)

have base case and recursion case

(B) Complete the "data definition" making sure to define all the same examples as 
    for ListOfSchool in the videos.

(C) Design the chart "function" that consumes School. Save yourself time by 
    simply copying the tests over from the original version of chart.

(D) Compare the two versions of chart. Which do you prefer? Why?

i prefer this one because hanya perlu membuat data definition satu kali dan tidak
menulis ulang kode make-chart untuk kedua kalinya, serta lebih mirip seperti linked
list
 |# 

(require 2htdp/image)
(require 2htdp/universe)

;; ==================================
;; Constants:
(define FONT-SIZE 24)
(define FONT-COLOR "black")
(define BAR-WIDTH 30)
(define BAR-COLOR "lightblue")



;; ==================================
;; Data definition

(define-struct school (name tuition next))
;; School is one of:
;;  - false
;;  - (make-school String Natural School)
;; interp. an arbitrary number of schools, where for each school we have its
;;         name and its tuition in USD

(define S0 false)
(define S1 (make-school "UGM" 200 S0))
(define S2 (make-school "UI" 250 S1))
#;
(define (fn-for-school s)
  (cond [(false? s) (...)]
        [else (... (school-name s)                 ;String
                   (school-tuition s)              ;Natural
                   (fn-for-school (school-next s)) ;School
                   )]
        )
  )


;; Template rules used:
;; - one of: 2 cases
;; - atomic distinct: false
;; - compound: 3 fields
;; - atomic non-distinct: (school-name s) is String
;; - atomic non-distinct: (school-tuition s) is String
;; - self-reference: (school-next s) is School




;; =============================
;; Function:

;#(struct:object:image% ... ...)

;; School -> Image
;; produce bar chart showing name and tuitions of consumed schools
(check-expect (chart false) (square 0 "solid" "white"))

(check-expect (chart (make-school "UGM" 200 false))
              (beside/align "bottom"
                            (overlay/align "center" "bottom"
                                           (rotate 90 (text "UGM" FONT-SIZE FONT-COLOR))
                                           (rectangle BAR-WIDTH 200 "outline" "black")
                                           (rectangle BAR-WIDTH 200 "solid"   BAR-COLOR)
                                           )
                            (square 0 "solid" "white")
                            )
              )

(check-expect (chart (make-school "UI" 250 (make-school "UGM" 200 false)))
              (beside/align "bottom"
                            (overlay/align "center" "bottom"
                                           (rotate 90 (text "UI" FONT-SIZE FONT-COLOR))
                                           (rectangle BAR-WIDTH 250 "outline" "black")
                                           (rectangle BAR-WIDTH 250 "solid"   BAR-COLOR)
                                           )
                            (overlay/align "center" "bottom"
                                           (rotate 90 (text "UGM" FONT-SIZE FONT-COLOR))
                                           (rectangle BAR-WIDTH 200 "outline" "black")
                                           (rectangle BAR-WIDTH 200 "solid"   BAR-COLOR)
                                           )
                            (square 0 "solid" "white")
                            )
              )

;(define (chart s) (square 0 "solid" "white")) ;stub

;Use Template from School

(define (chart s)
  (cond [(false? s) (square 0 "solid" "white")]
        [else (beside/align "bottom"
                            (overlay/align "center" "bottom"
                                           (rotate 90 (text (school-name s) FONT-SIZE FONT-COLOR))
                                           (rectangle BAR-WIDTH (school-tuition s) "outline" "black")
                                           (rectangle BAR-WIDTH (school-tuition s) "solid"   BAR-COLOR)
                                           )
                            (chart (school-next s))
                            )]
        )
  )







