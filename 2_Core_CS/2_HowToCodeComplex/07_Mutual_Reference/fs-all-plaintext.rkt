(require 2htdp/image)

;; fs-starter.rkt (type comments and examples)
;; fs-v1.rkt (complete data-definition plus function problems)

;; Data definitions:

(define-struct elt (name data subs))
;; Element is (make-elt String Integer ListOfElement)
;; interp. An element in the file system, with name, and EITHER data or subs.
;;         If data is 0, then subs is considered to be list of sub elements.
;;         If data is not 0, then subs is ignored.

;; ListOfElement is one of:
;;  - empty
;;  - (cons Element ListOfElement)
;; interp. A list of file system Elements

(define F1 (make-elt "F1" 1 empty))
(define F2 (make-elt "F2" 2 empty))
(define F3 (make-elt "F3" 3 empty))
(define D4 (make-elt "D4" 0 (list F1 F2)))
(define D5 (make-elt "D5" 0 (list F3)))
(define D6 (make-elt "D6" 0 (list D4 D5)))
#;
(define (fn-for-element e)
  (... (elt-name e)    ;String
       (elt-data e)    ;Integer
       (fn-for-loe (elt-subs e))))
#;
(define (fn-for-loe loe)
  (cond [(empty? loe) (...)]
        [else
         (... (fn-for-element (first loe))
              (fn-for-loe (rest loe)))]))


;; Functions:

;
; PROBLEM
;
; Design a function that consumes Element and produces the sum of all the file data in
; the tree.
;  D6 = 1 + 2 + 3 = 6
;


;; Element -> Integer
;; ListOfElement -> Integer
;; produce the sum af all the data in element (and its subs)
(check-expect (sum-data--element F1) 1)
(check-expect (sum-data--loe empty) 0)
(check-expect (sum-data--element D5) 3)
(check-expect (sum-data--element D4) (+ 1 2))
(check-expect (sum-data--element D6) (+ 1 2 3))

;(define (sum-data--element e) 0) ;stubs
;(define (sum-data--loe loe) 0)

(define (sum-data--element e)
  (if (zero? (elt-data e))
      (sum-data--loe (elt-subs e))
      (elt-data e)
      ))

(define (sum-data--loe loe)
  (cond [(empty? loe) 0]
        [else
         (+ (sum-data--element (first loe))
            (sum-data--loe (rest loe))
            )]
        ))


;
; PROBLEM
;
; Design a function that consumes Element and produces a list of the names of all the elements in
; the tree.
;


;; Element -> ListOfString
;; ListOfElement -> ListOfString
;; produces a list of the names of all the elements (and its subs)
(check-expect (all-names--loe empty) empty)
(check-expect (all-names--element F1) (list "F1"))
(check-expect (all-names--element D5) (list "D5" "F3"))
(check-expect (all-names--loe (list D4 D5)) (append (list "D4" "F1" "F2") (list "D5" "F3")))
(check-expect (all-names--element D4) (list "D4" "F1" "F2"))
(check-expect (all-names--element D6) (list "D6" "D4" "F1" "F2" "D5" "F3"))
(check-expect (all-names--element D6) (cons "D6" (append (list "D4" "F1" "F2") (list "D5" "F3"))))

;(define (all-names--element e) empty) ;stubs
;(define (all-names--loe loe) empty)

;; alternative 1
#;
(define (all-names--element e)
  (if (zero? (elt-data e))
      (append (list (elt-name e))
              (all-names--loe (elt-subs e)))
      (list (elt-name e))
      ))
#;
(define (all-names--loe loe)
  (cond [(empty? loe) empty]
        [else
         (append (all-names--element (first loe))
                 (all-names--loe (rest loe))
                 )]
        ))

;; alternative 2

(define (all-names--element e)
  (cons (elt-name e)
        (all-names--loe (elt-subs e))
        ))

(define (all-names--loe loe)
  (cond [(empty? loe) empty]
        [else
         (append (all-names--element (first loe))
                 (all-names--loe (rest loe))
                 )]
        ))


;
; PROBLEM
;
; Design a function that consumes String and Element and looks for a data element with the given
; name. If it finds that element it produces the data, otherwise it produces false.
;


;; String Element -> Integer or false
;; String ListOfElement -> Integer or false???
;; search the given tree for an element with the given name, produce data if found; false otherwise
(check-expect (find--loe "F1" empty) false)        ;lookin nothing
(check-expect (find--element "F3" F1) false)       ;lookin that no children
(check-expect (find--element "F1" F1) 1)
(check-expect (find--loe "F1" (list F1 F2)) 1)     ;lookin children (list of children)
(check-expect (find--loe "F2" (list F1 F2)) 2)
(check-expect (find--loe "F3" (list F1 F2)) false)
(check-expect (find--element "F3" D4) false)       ;lookin that have children
(check-expect (find--element "F1" D4) 1)
(check-expect (find--element "D6" D6) 0)
(check-expect (find--element "F3" D6) 3)

;(define (find--element n e) false) ;stubs
;(define (find--loe n loe) false)

(define (find--element n e)
  (if (string=? n (elt-name e))
      (elt-data e)
      (find--loe n (elt-subs e))))

(define (find--loe n loe)
  (cond [(empty? loe) false]
        [else
         (if (not (false? (find--element n (first loe))))
             (find--element n (first loe)) ;better using local variable
             (find--loe n (rest loe)))]))


;
; PROBLEM
;
; Design a function that consumes Element and produces a rendering of the tree. For example:
;
; (render-tree D6) should produce something like the following.
;
; .
;
;      D6
;     /  \
;   D4    D5
;  /  \    |
; F1  F2   F3
;
;
; | HINTS:
;   - This function is not very different than the first two functions above.
;   - Keep it simple! Start with a not very fancy rendering like the one above.
;     Once that works you can make it more elaborate if you want to.
;   - And... be sure to USE the recipe. Not just follow it, but let it help you.
;     For example, work out a number of examples BEFORE you try to code the function.
;


(define FONT 24)
(define COLOR "white")
(define SEPARATOR (square 20 "solid" "transparent"))

;; Element -> Image
;; ListOfElement -> Image???
;; produce arbitrary-arity tree image
(check-expect (render-tree--element F1) (text "F1" FONT COLOR))
(check-expect (render-tree--loe empty) empty-image)
(check-expect (render-tree--element D5) (above (text "D5" FONT COLOR)
                                               SEPARATOR
                                               (beside (text "F3" FONT COLOR)
                                                       empty-image)))
(check-expect (render-tree--element D4) (above (text "D4" FONT COLOR)
                                               SEPARATOR
                                               (beside (text "F1" FONT COLOR)
                                                       SEPARATOR
                                                       (text "F2" FONT COLOR))))
(check-expect (render-tree--loe (list F1 F2)) (beside (text "F1" FONT COLOR)
                                                      SEPARATOR
                                                      (text "F2" FONT COLOR)))
(check-expect (render-tree--element D6) (above (text "D6" FONT COLOR)
                                               SEPARATOR
                                               (beside (above (text "D4" FONT COLOR)
                                                              SEPARATOR
                                                              (beside (text "F1" FONT COLOR)
                                                                      SEPARATOR
                                                                      (text "F2" FONT COLOR)))
                                                       SEPARATOR
                                                       (above (text "D5" FONT COLOR)
                                                              SEPARATOR
                                                              (text "F3" FONT COLOR)))))

;(define (render-tree--element e) empty-image) ;stubs
;(define (render-tree--loe loe) empty-image)

;(add-line image x1 y1 x2 y2 pen-or-color)
(define (render-tree--element e)
  (above (text (elt-name e) FONT COLOR)
         (if (not (image=? empty-image (render-tree--loe (elt-subs e))))
             (above SEPARATOR
                    (render-tree--loe (elt-subs e))) ;better using local variable i think
             (render-tree--loe (elt-subs e)))
         ))

(define (render-tree--loe loe)
  (cond [(empty? loe) empty-image]
        [else
         (beside (render-tree--element (first loe))
                 (if (not (image=? (render-tree--loe (rest loe)) empty-image))
                     (beside SEPARATOR
                             (render-tree--loe (rest loe))) ;this also
                     (render-tree--loe (rest loe)))
                 )]
        ))


; .
; (add-line (rectangle 40 40 "solid" "gray")
;           0 40 40 0 "maroon")
; .;[/]
; (add-line (rectangle 80 40 "solid" "gray")
;           0 40 40 0 "maroon")
; .;[/ ]
; (add-line (add-line (rectangle 80 40 "solid" "gray")
;                     0 40 40 0 "maroon") 80 40 40 0 "maroon")
; .;[/\]
; (add-line (add-line SEPARATOR
;                     0 20 20 0 "maroon") 40 20 20 0 "maroon")
; .;[/\]
;
;
;
;
; ACTUALLY CRINGE
; just like render-bst-w-lines-starter.rkt in HtDP1x
