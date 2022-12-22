;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |fractals-starter - plaintext|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)

;; fractals-starter.rkt

; 
; PROBLEM: 
; 
; Design a function that consumes a number and produces a Sierpinski
; triangle of that size. Your function should use generative recursion.
; 
; One way to draw a Sierpinski triangle is to:
; 
;  - start with an equilateral triangle with side length s
;  
;      .
;      
;  - inside that triangle are "three" more Sierpinski triangles
;      .
;      
;  - and inside each of those... and so on
;  
; So that you end up with something that looks like this:
;    
; 
;    
; 
; .
;    
; Note that in the 2nd picture above the inner triangles are drawn in 
; black and slightly smaller just to make them clear. In the real
; Sierpinski triangle they should be in the same color and of side
; length s/2. Also note that the "center upside down triangle is not
; an explicit triangle", it is simply formed from the other triangles.
; 
; .
; 


(define CUTOFF 5)

;; Number -> Image
;; produce a Sierpinski triangle of the given size (size)
(check-expect (stri CUTOFF) (triangle CUTOFF "outline" "red"))
(check-expect (stri (* CUTOFF 2))
              (overlay (triangle (* CUTOFF 2) "outline" "red")
                       (local [(define subtri (triangle CUTOFF "outline" "red"))]
                         (above subtri
                                (beside subtri subtri)
                                ))
                       ))

;(define (stri size) empty-image) ;stub

;<use template from Generative Recursion>
#;
(define (genrec-fn d)
  (cond [(trivial? d) (trivial-answer d)]
        [else
         (... d
              (genrec-fn (next-problem d)))]))

; 
; PROBLEM:
; 
; Base case: (<= size CUTOFF)
; 
; Reduction step: (/ size 2)
; 
; Argument that repeated application of reduction step will eventually 
; reach the base case:
; 
; As long as the CUTOFF > 0 AND size starts >= 0 repeated division by 2
; will eventually be less than CUTOFF
; 

(define (stri size)
  (cond [(<= size CUTOFF) (triangle size "outline" "red")]
        [else
         (overlay (triangle size "outline" "red")
                  (local [(define subtri (stri (/ size 2)))]
                    (above subtri
                           (beside subtri subtri)))
                  )]
        ))


; 
; PROBLEM:
; 
; Design a function to produce a Sierpinski carpet of size s.
; 
; Here is an example of a larger Sierpinski carpet.
; 
; .
; 


;; Number -> Image
;; produce a Sierpinski carpet of the given size (s)
(check-expect (scarpet CUTOFF) (square CUTOFF "outline" "red"))
(check-expect (scarpet (* CUTOFF 3))
              (overlay (square (* CUTOFF 3) "outline" "red")
                       (local [(define subsq (square CUTOFF "outline" "red"))
                               (define 3subsq (beside subsq subsq subsq))
                               (define 2subsq (beside subsq
                                                      (square CUTOFF "outline" "transparent")
                                                      subsq))]
                         (above 3subsq
                                2subsq
                                3subsq))))

;(define (scarpet s) empty-image) ;stub

; 
; PROBLEM:
; 
; Base case: (<= s CUTOFF)
; 
; Reduction step: (/ s 3)
; 
; Argument that repeated application of reduction step will eventually 
; reach the base case:
; 
; As long as the CUTOFF > 0 AND s starts >= 0 repeated division by 3
; will eventually be less than CUTOFF
; 

(define (scarpet s)
  (cond [(<= s CUTOFF) (square s "outline" "red")]
        [else
         (overlay (square s "outline" "red")
                  (local [(define subsq (scarpet (/ s 3)))
                          (define 3subsq (beside subsq subsq subsq))
                          (define 2subsq (beside subsq
                                                 (square (/ s 3) "outline" "transparent")
                                                 subsq))]
                    (above 3subsq
                           2subsq
                           3subsq))
                  )]
        ))


(stri 100)
(scarpet 100)
