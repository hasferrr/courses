;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname same-house-as-parent) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

;; same-house-as-parent-v1.rkt

;__________________________________________________________________________________
; 
; PROBLEM:
; 
; In the Harry Potter movies, it is very important which of the four houses a
; wizard is placed in when they are at Hogwarts. This is so important that in 
; most families multiple generations of wizards are all placed in the same family. 
; 
; Design a representation of wizard family trees that includes, for each wizard,
; their name, the house they were placed in at Hogwarts and their children. We
; encourage you to get real information for wizard families from: 
;    http://harrypotter.wikia.com/wiki/Main_Page   ---> DONT DO THIS, WASTE TIME
; 
; The reason we do this is that designing programs often involves collection
; domain information from a variety of sources and representing it in the program
; as constants of some form. So this problem illustrates a fairly common scenario.
; 
; That said, for reasons having to do entirely with making things fit on the
; screen in later videos, we are going to use the following wizard family tree,
; in which wizards and houses both have 1 letter names. (Sigh)
; 
;__________________________________________________________________________________

;; Data definitions:

(define-struct wiz (name house kids))
;; Wizard is (make-wiz String String (listof Wizard))
;; interp. A wizard, with name, house and list of children.

(define Wa (make-wiz "A" "S" empty))
(define Wb (make-wiz "B" "G" empty))
(define Wc (make-wiz "C" "R" empty))
(define Wd (make-wiz "D" "H" empty))
(define We (make-wiz "E" "R" empty))
(define Wf (make-wiz "F" "R" (list Wb)))
(define Wg (make-wiz "G" "S" (list Wa)))
(define Wh (make-wiz "H" "S" (list Wc Wd)))
(define Wi (make-wiz "I" "H" empty))
(define Wj (make-wiz "J" "R" (list We Wf Wg)))
(define Wk (make-wiz "K" "G" (list Wh Wi Wj)))


#; ;template, arb-arity-tree, encapsulated w/ local
(define (fn-for-wiz w)
  (local [(define (fn-for-wiz w)
            (... (wiz-name w)
                 (wiz-house w)
                 (fn-for-low (wiz-kids w))))
          
          (define (fn-for-low low)
            (cond [(empty? low) (...)]
                  [else
                   (... (fn-for-wiz (first low))
                        (fn-for-low (rest low)))]))]
    
    (fn-for-wiz w)))



;__________________________________________________________________________________

;; Functions:

;__________________________________________________________________________________
; 
; PROBLEM:
; 
; Design a function that consumes a wizard and produces the names of every 
; wizard in the tree that was placed in the same house as their immediate
; parent.
;__________________________________________________________________________________

;; Wizard -> (listof String)
;; produces the names of every wizard in the tree that
;; was placed in the SAME HOUSE as their immediate parent
(check-expect (same-house-as-parent Wa) empty)
(check-expect (same-house-as-parent Wh) empty)
(check-expect (same-house-as-parent Wg) (list "A"))
(check-expect (same-house-as-parent Wk) (list "E" "F" "A"))

;(define (same-house-as-parent w) empty) ;stub

;Use template from Wizard, with lost context accumulator

#;
(define (same-house-as-parent w)
  ;; parent-house is String; name house of the wizard's immediate parent house
  ;; (same-house-as-parent Wk)
  ;; (fn-for-wiz Wk "")
  ;; (fn-for-wiz Wh "G")
  ;; (fn-for-wiz Wc "S")
  ;; (fn-for-wiz Wd "S")
  ;; (fn-for-wiz Wi "G")
  ;; (fn-for-wiz Wj "G")
  ;; (fn-for-wiz We "R")
  ;; (fn-for-wiz Wf "R")
  ;; (fn-for-wiz Wg "R")
  ;; ...
  (local [(define (fn-for-wiz w parent-house)
            (if (string=? parent-house (wiz-house w))
                (cons (wiz-name w)
                      (fn-for-low (wiz-kids w)
                                  (wiz-house w)))
                (fn-for-low (wiz-kids w)
                            (wiz-house w))
                ))
          
          (define (fn-for-low low parent-house)
            (cond [(empty? low) empty]
                  [else
                   (append (fn-for-wiz (first low) parent-house)
                           (fn-for-low (rest low) parent-house)
                           )]))]
    
    (fn-for-wiz w "")))



;__________________________________________________________________________________
; 
; PROBLEM:
; 
; Design a new function definition for same-house-as-parent that is tail 
; recursive. You will need a worklist accumulator.
; 
;__________________________________________________________________________________

; template from: Wizard (arb-arity-tree, encapsulated w/ local)
;                added worklist accumulator (todo) for tail recursion
;                added result so far (rsf) accumulator for tail recursion
;                added worklist entry (wle) compound data for worklist accumulator

(define (same-house-as-parent w)
  (local [(define-struct wle (w ph))
          ;; wle is (make-wle Wizard String)
          ;; interp. worklist entry (wle) for worklist accumulator

          (define (fn-for-wiz w ph todo rsf)
            (fn-for-low (append (map
                                 (λ (k) (make-wle k (wiz-house w)))  ;Wizard -> wle
                                 (wiz-kids w))   
                                todo)
                        (if (string=? (wiz-house w) ph)
                            (append rsf (list (wiz-name w)))
                            rsf)))
          
          (define (fn-for-low todo rsf)
            (cond [(empty? todo) rsf]
                  [else
                   (fn-for-wiz (wle-w (first todo))   ;(listof wle) -> Wizard
                               (wle-ph (first todo))  ;(listof wle) -> String ;parent house
                               (rest todo)            ;(listof wle)
                               rsf                    ;(listof String)
                               )]))]

    (fn-for-wiz w "" empty empty)))



;__________________________________________________________________________________
; 
; PROBLEM:
; 
; Design a function that consumes a wizard and produces the number of wizards 
; in that tree (including the root). Your function should be tail recursive.
;__________________________________________________________________________________

;; Wizard -> Natural
;; produce the number of wizards in that tree including the root
(check-expect (count Wa) 1)
(check-expect (count Wh) 3)
(check-expect (count Wj) 6)
(check-expect (count Wk) 11)

;(define (count w) 0) ;stub

;<use template from Wizard, add an accumulator for tail recursion>

(define (count w)
  ;; rsf is Natural; the number of wizards seen so far
  ;; todo is (listof Wizard); the Wizards we need to visit with fn-for-wiz
  ;; (count Wk)
  ;; (fn-for-wiz Wk empty 0)
  ;; (fn-for-low (list Wh Wi Wj) 1)
  ;; (fn-for-wiz Wh (list Wi Wj) 1)
  ;; (fn-for-low (list    Wi Wj Wc Wd) 2)
  ;; (fn-for-wiz Wi 2)
  ;; (fn-for-low (list       Wj Wc Wd) 3)
  ;; (fn-for-wiz Wj 3)
  ;; (fn-for-low (list          Wc Wd We Wf Wg) 4)
  ;; ...
  (local [(define (fn-for-wiz w todo rsf)
            (fn-for-low (append todo (wiz-kids w))
                        (+ rsf 1)))
          
          (define (fn-for-low low todo)
            (cond [(empty? low) todo]
                  [else
                   (fn-for-wiz (first low) (rest low) todo)
                   ]))]
    
    (fn-for-wiz w empty 0)))


