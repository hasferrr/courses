
;; --------------------------
;; hp-family-tree-starter.rkt

; In this problem set you will represent information about descendant family 
; trees from Harry Potter and design functions that operate on those trees.
; 
; To make your task much easier we suggest two things:
;   - you only need a DESCENDANT family tree
;   - read through this entire problem set carefully to see what information 
;     the functions below are going to need. Design your data definitions to
;     only represent that information.
;   - you can find all the information you need by looking at the individual 
;     character pages like the one we point you to for Arthur Weasley.
; 


; PROBLEM 1:
; 
; Design a data definition that represents a family tree from the Harry Potter 
; wiki, which contains all necessary information for the other problems.  You 
; will use this data definition throughout the rest of the homework.
; 


; PROBLEM 2: 
; 
; Define a constant named ARTHUR that represents the descendant family tree for 
; Arthur Weasley. You can find all the infomation you need by starting 
; at: http://harrypotter.wikia.com/wiki/Arthur_Weasley ;who cares;
; 
; You must include all of Arthur's children and these grandchildren: Lily, 
; Victoire, Albus, James.
; 
; 
; Note that on the Potter wiki you will find a lot of information. But for some 
; people some of the information may be missing. Enter that information with a 
; special value of "" (the empty string) meaning it is not present. Don't forget
; this special value when writing your interp. ;who cares;
; 


;; Data definition:

(define-struct wiz (name wand patronus kids))
;; Wizard is (make-wiz String String String ListOfPerson)
;; interp. a wizard family tree
;;         name is person name
;;         wand is the wood their primary wand is made of ("" if unknown)
;;         patronus is mantra sihir ("" if unknown)
;;         kids is list of their kids

;; ListOfPerson is one of:
;; - empty
;; - (cons Person ListOfPerson)
;; interp. a list of person

(define ARTHUR
  (make-wiz "Arthur" "" "Weasel"
            (list (make-wiz "Bill" "" ""       
                            (list (make-wiz "Victoire"  "" "" empty)
                                  (make-wiz "Dominique" "" "" empty)
                                  (make-wiz "Louis"     "" "" empty)))

                  (make-wiz "Charlie" "ash" "" empty)

                  (make-wiz "Percy" "" ""      
                            (list (make-wiz "Molly" "" "" empty)
                                  (make-wiz "Lucy"  "" "" empty)))

                  (make-wiz "Fred" "" "" empty)

                  (make-wiz "George" "" "" 
                            (list (make-wiz "Fred" "" "" empty)
                                  (make-wiz "Roxanne"  "" "" empty)))

                  (make-wiz "Ron" "ash" "Jack Russell Terrier" 
                            (list (make-wiz "Rose" "" "" empty)
                                  (make-wiz "Hugo" "" "" empty)))

                  (make-wiz "Ginny" "" "horse" 
                            (list (make-wiz "James" "" "" empty)
                                  (make-wiz "Albus" "" "" empty)
                                  (make-wiz "Lily"  "" "" empty))))))

#;
(define (fn-for-wiz w)
  (... (wiz-name w)     ;String
       (wiz-wand w)     ;String
       (wiz-patronus w) ;String
       (fn-for-low (wiz-kids w))
       ))
#;
(define (fn-for-low low)
  (cond [(empty? low) (...)]
        [else (... (fn-for-wiz (first low))
                   (fn-for-low (rest low))
                   )]
        ))

;; Pair is one of:
;; - empty
;; - (cons ListOfString Pair)
;; interp. a list of (list of String(s)) that contais wiz-name and wiz-patronus

;; ListOfString is one of:
;; - empty
;; - (cons String ListOfString)
;; interp. a list of String

(define P0 empty)
(define LOS0 empty)
(define LOS1 (list "Arthur" "Weasel"))
(define P1 (list LOS1))
(define LOS2 (list "Bill" ""))
(define LOS3 (list "Victoire" ""))
(define P2 (list LOS1 LOS2 LOS3))
#;
(define (fn-for-pair p)
  (cond [(empty? p) (...)]
        [else
         (... (fn-for-los (first p))
              (fn-for-pair (rest p))
              )]
        ))
#;
(define (fn-for-los los)
  (cond [(empty? los) (...)]
        [else
         (... (first los) ;string
              (fn-for-los (rest los))
              )]
        ))


; PROBLEM 3:
; 
; Design a function that produces a pair list (i.e. list of two-element lists)
; of every "person" in the tree and his or her "patronus". For example, assuming 
; that HARRY is a tree representing Harry Potter and that he has no children
; (even though we know he does) the result would be: (list (list "Harry" "Stag")).
; 
; You must use ARTHUR as one of your examples.
; 


;; Functions:

;; Wizard -> Pair
;; ListOfWizard -> Pair
;; produce two-element lists of name and patronus of Wizard and its kids (ListOfWizard)
(check-expect (patroni--low empty) empty)

(check-expect (patroni--wiz (make-wiz "name" "" "patroni" empty))
              (list (list "name" "patroni")))

(check-expect (patroni--wiz (make-wiz "a" "" "p1" (list (make-wiz "b" "" "p2" empty))))
              (cons (list "a" "p1")
                    (cons (list "b" "p2")
                          empty)))

(check-expect (patroni--low (list (make-wiz "James" "" "" empty)
                                  (make-wiz "Albus" "" "" empty)))
              (list (list "James" "")
                    (list "Albus" "")))

(check-expect (patroni--wiz ARTHUR)
              (list (list "Arthur" "Weasel")
                    (list "Bill" "")
                    (list "Victoire" "")
                    (list "Dominique" "")
                    (list "Louis" "")
                    (list "Charlie" "")
                    (list "Percy" "")
                    (list "Molly" "")
                    (list "Lucy" "")
                    (list "Fred" "")
                    (list "George" "")
                    (list "Fred" "")
                    (list "Roxanne" "")
                    (list "Ron" "Jack Russell Terrier")
                    (list "Rose" "")
                    (list "Hugo" "")
                    (list "Ginny" "horse")
                    (list "James" "")
                    (list "Albus" "")
                    (list "Lily" "")
                    ))

;(define (patroni--wiz w) empty) ;stubs
;(define (patroni--low low) empty)

(define (patroni--wiz w)
  (cons (list (wiz-name w)
              (wiz-patronus w))
        (patroni--low (wiz-kids w))
        ))

(define (patroni--low low)
  (cond [(empty? low) empty]
        [else
         (append (patroni--wiz (first low))
                 (patroni--low (rest low))
                 )]
        ))


; PROBLEM 4:
; 
; Design a function that produces the names of every person in a given tree 
; whose wands are made of a given material. 
; 
; You must use ARTHUR as one of your examples.
; 


;; String Wizard -> ListOfString
;; String ListOfWizard -> ListOfString???
;; produces the names of every person in a given tree whose wands are made of a given material
(check-expect (has-wand?--low "" empty) empty)

(check-expect (has-wand?--wiz "abcd" (make-wiz "a" "wand" "" empty))
              empty)          ;not found
(check-expect (has-wand?--wiz "wand" (make-wiz "a" "wand" "" empty))
              (list "a"))     ;found
(check-expect (has-wand?--wiz "wand" (make-wiz "a" "wand" "" (list (make-wiz "b" "wand" "" empty))))
              (list "a" "b")) ;found,found
(check-expect (has-wand?--wiz "wand" (make-wiz "a" "" "" (list (make-wiz "b" "wand" "" empty))))
              (list "b"))     ;not found,found

(check-expect (has-wand?--low "abcd" (list (make-wiz "a" "wand" "" empty)))
              empty)
(check-expect (has-wand?--low "wand" (list (make-wiz "a" "wand" "" empty)))
              (cons "a" empty))
(check-expect (has-wand?--low "wand" (list (make-wiz "a" "wand" "" empty)
                                                  (make-wiz "b" "wand" "" empty)))
              (cons "a" (cons "b" empty)))

(check-expect (has-wand?--wiz "ash" ARTHUR)
              (list "Charlie" "Ron"))
(check-expect (has-wand?--wiz "" ARTHUR)
              (list "Arthur"
                    "Bill"
                    "Victoire"
                    "Dominique"
                    "Louis"
                    "Percy"
                    "Molly"
                    "Lucy"
                    "Fred"
                    "George"
                    "Fred"
                    "Roxanne"
                    "Rose"
                    "Hugo"
                    "Ginny"
                    "James"
                    "Albus"
                    "Lily"))

;(define (has-wand?--wiz s w) empty)   ;stubs
;(define (has-wand?--low s low) empty)

(define (has-wand?--wiz s w)
  (if (string=? s (wiz-wand w))
      (cons (wiz-name w) (has-wand?--low s (wiz-kids w)))
      (has-wand?--low s (wiz-kids w))
      ))

(define (has-wand?--low s low)
  (cond [(empty? low) empty]
        [else
         (append (has-wand?--wiz s (first low)) ;los
                 (has-wand?--low s (rest low)) ;los
                 )]
        ))

