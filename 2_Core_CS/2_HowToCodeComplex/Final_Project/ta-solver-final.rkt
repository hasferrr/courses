;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname ta-solver-final) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; ta-solver-starter.rkt
;; by HasFer

;__________________________________________________________________________________________________
;
;  PROBLEM 1:
;
;  Consider a social network similar to Twitter called Chirper. Each user has a name, a note about
;  whether or not they are a verified user, and follows some number of people.
;
;  Design a data definition for Chirper, including a template that is tail recursive and avoids
;  cycles.
;
;  Then design a function called most-followers which determines which user in a Chirper Network is
;  followed by the most people.
;__________________________________________________________________________________________________

;; DATA DEFINITIONS :

(define-struct user (name verified? follows))
;; User is (make-user String Boolean (listof User))
;; interp. user is an user in the Chirper social network
;; - name      is user's name
;; - verified? is True if they are a verified user, False otherwise
;; - follows   is list of users who this user follows

(define C0 (make-user "A" false empty))
(define C1 (make-user "A" false (list (make-user "B" true empty))))
(define C2 (shared ((-A- (make-user "A" false (list -B-)))
                    (-B- (make-user "B" false (list -C-)))
                    (-C- (make-user "C" false (list -A-))))
             -A-))
(define C3 (shared ((-A- (make-user "A" false (list -C- -E-)))
                    (-B- (make-user "B" false (list -C- -F-)))
                    (-C- (make-user "C" false (list -B- -D- -F-)))
                    (-D- (make-user "D" false (list -B-)))
                    (-E- (make-user "E" false (list -B- -F-)))
                    (-F- (make-user "F" false (list -A- -B- -D-))))
             -A-))
(define C4
  (shared ((-A- (make-user "A" false (list -B- -D-)))
           (-B- (make-user "B" false (list -C- -E-)))
           (-C- (make-user "C" false (list -B-)))
           (-D- (make-user "D" false (list -E-)))
           (-E- (make-user "E" false (list -F- -A-)))
           (-F- (make-user "F" false (list))))
    -A-))

;; Template tail recursive with:
;;  - worklist accumulator
;;  - context perserving accumulator

(define (fn-for-user u0)
  ;; todo    is (listof User)  ; a worklist accumulator
  ;; visited is (listof String); context perserving accumulator; user's name already visited to fn-for-user
  
  (local [(define (fn-for-user u todo visited)
            ;; might useful: (user-name u)
            ;;               (user-verified? u)
            (cond [(member? (user-name u) visited)
                   (fn-for-lou todo
                               visited)]
                  [else
                   (fn-for-lou (append (user-follows u) todo)
                               (cons (user-name u) visited))]))

          (define (fn-for-lou todo visited)
            (cond [(empty? todo) ...]
                  [else
                   (fn-for-user (first todo)
                                (rest todo)
                                visited)]))]
    
    (fn-for-user u0 empty empty)))

;_____________________

;; FUNCTIONS :

;; User -> User
;; produce user who have most followers in a Chirper Network
(check-expect (most-followers C0) C0)
(check-expect (most-followers C1) (make-user "B" true empty))
(check-expect (most-followers C2) C2)
(check-expect (most-followers C3) (first (user-follows (first (user-follows C3)))))
(check-expect (most-followers C4) (first (user-follows C4)))

;(define (most-followers u) u)

(define (most-followers u0)
  ;; todo    is (listof User)  ; a worklist accumulator
  ;; visited is (listof String); context perserving accumulator; user's name already visited to fn-for-user
  ;; louf    is (listof u-foll); list of user and their followers

  (local [(define-struct u-foll (user followers))
          ;; U-foll is (make-u-foll User Natural)
          ;; interp. user's name and how many followers that user have

          (define (fn-for-user u todo visited louf)
            (cond [(member? (user-name u) visited)
                   (fn-for-lou todo
                               visited
                               (add-to-louf u louf))]
                  [else
                   (fn-for-lou (append (user-follows u) todo)
                               (cons (user-name u) visited)
                               (add-to-louf u louf))]))

          (define (fn-for-lou todo visited louf)
            (cond [(empty? todo) (most-foll louf)]
                  [else
                   (fn-for-user (first todo)
                                (rest todo)
                                visited
                                louf)]))

          ;; Helpers:

          ;; User (listof U-foll) -> (listof U-foll)
          ;; produce louf after counting incoming followers
          (define (add-to-louf u louf0)
            ;; prev-louf is (listof U-foll); previous louf
            (local [(define (add-to-louf louf prev-louf)
                      (cond [(empty? louf) (append prev-louf (list (make-u-foll u 1)))]
                            [else
                             (if (string=? (user-name u)
                                           (user-name (u-foll-user (first louf))))
                                 (append prev-louf
                                         (list (make-u-foll u
                                                            (add1 (u-foll-followers (first louf)))))
                                         (rest louf))
                                 (add-to-louf (rest louf)
                                              (append prev-louf (list (first louf)))))]))]
              (add-to-louf louf0 empty)))

          
          ;; (listof U-foll) -> User
          ;; produce user with the most followers
          (define (most-foll louf0)
            ;; rsf is U-foll; user with the most followers seen so far
            (local [(define (most-foll louf rsf)
                      (cond [(empty? louf) (u-foll-user rsf)]
                            [else
                             (if (> (u-foll-followers (first louf))
                                    (u-foll-followers rsf))
                                 (most-foll (rest louf) (first louf))
                                 (most-foll (rest louf) rsf))]))]
              (most-foll louf0 (first louf0))))]


    (fn-for-user u0 empty empty (list (make-u-foll u0 -1)))))





;__________________________________________________________________________________________________
;
;  PROBLEM 2:
;
;  In UBC's version of How to Code, there are often more than 800 students taking
;  the course in any given semester, meaning there are often over 40 Teaching Assistants.
;
;  Designing a schedule for them by hand is hard work - luckily we've learned enough now to write
;  a program to do it for us!
;
;  Below are some data definitions for a simplified version of a TA schedule. There are some
;  number of slots that must be filled, each represented by a natural number. Each TA is
;  available for some of these slots, and has a maximum number of shifts they can work.
;
;  Design a search program that consumes a list of TAs and a list of Slots, and produces one
;  valid schedule where each Slot is assigned to a TA, and no TA is working more than their
;  maximum shifts. If no such schedules exist, produce false.
;
;  You should supplement the given check-expects and remember to follow the recipe!
;__________________________________________________________________________________________________


;; DATA DEFINITIONS:


;(1)
;; Slot is Natural
;; interp. each TA slot has a number, is the same length, and none overlap


;(2)
(define-struct ta (name max avail))
;; TA is (make-ta String Natural (listof Slot))
;; interp. the TA's name, number of slots they can work, and slots they're available for

(define SOBA (make-ta "Soba" 2 (list 1 3)))
(define UDON (make-ta "Udon" 1 (list 3 4)))
(define RAMEN (make-ta "Ramen" 1 (list 2)))
(define NOODLE-TAs (list SOBA UDON RAMEN))

#;
(define (fn-for-ta ta)
  (... (ta-name ta)
       (ta-max ta)
       (fn-for-lon (ta-avail ta))))


;(3)
(define-struct assignment (ta slot))
;; Assignment is (make-assignment TA Slot)
;; interp. the TA is assigned to work the slot


;(4)
;; Schedule is (listof Assignment)



;_____________________
;_____________________


;; FUNCTIONS :


;; (listof TA) (listof Slot) -> Schedule or false
;; produce valid schedule given TAs and Slots; false if impossible
(check-expect (solve empty empty) empty)
(check-expect (solve empty (list 1 2)) false)
(check-expect (solve (list SOBA) empty) empty)

(check-expect (solve (list SOBA) (list 1)) (list (make-assignment SOBA 1)))
(check-expect (solve (list SOBA) (list 2)) false)
(check-expect (solve (list SOBA) (list 1 3)) (list (make-assignment SOBA 3)
                                                   (make-assignment SOBA 1)))

(check-expect (solve NOODLE-TAs (list 1 2 3 4))
              (list
               (make-assignment UDON 4)
               (make-assignment SOBA 3)
               (make-assignment RAMEN 2)
               (make-assignment SOBA 1)))

(check-expect (solve NOODLE-TAs (list 1 2 3 4 5)) false)


;; === Additional check-expect ===

(define ERIKA   (make-ta "Erika"  1 (list 1 3)))
(define RYAN    (make-ta "Ryan"   1 (list 1)))
(define REECE   (make-ta "Reece"  1 (list 5 6)))
(define GORDON  (make-ta "Gordon" 2 (list 2 3)))
(define DAVID   (make-ta "David"  2 (list 2)))
(define KATIE   (make-ta "Katie"  1 (list 4 6)))
(define ERIN    (make-ta "Erin"   1 (list 4)))

(define STILL-POSSIBLE-TAs (list ERIKA RYAN REECE GORDON DAVID KATIE ERIN))

(check-expect (solve STILL-POSSIBLE-TAs (list 1 2 3 4 5 6))
              (list (make-assignment KATIE  6)
                    (make-assignment REECE  5)
                    (make-assignment ERIN   4)
                    (make-assignment GORDON 3)
                    (make-assignment GORDON 2)
                    (make-assignment ERIKA  1)))

; 1ST Possible Schedule
; ---------------------
;        6  NONE -> THEN PRODUCE FALSE
; REECE  5
; KATIE  4
; GORDON 3
; GORDON 2
; ERIKA  1

; 2ND Possible Schedule
; ---------------------
; KATIE  6
; REECE  5
; ERIN   4  <--- important
; GORDON 3
; GORDON 2
; ERIKA  1




;(define (solve tas slots) empty) ;stub



;; Template rules used:
;; - arbitrary arity tree
;; - generative recursion
;; - backtracking search
;; - context perceiving accumulator

(define (solve tas slots)
  ;; reordered? is Boolean; true if loTA has been reordered once, false otherwise
  
  (local [(define (solve--ta tas slots reordered?)
            (cond [(not (false? reordered?)) (schedule-tas tas slots)]
                  [else
                   (solve--lota (next-order tas) slots true)
                   ]))
          
          (define (solve--lota tas slots reordered?)
            (cond [(empty? tas) false]
                  [else
                   (local [(define try (solve--ta (first tas) slots reordered?))]
                     (if (not (false? try))
                         try
                         (solve--lota (rest tas) slots reordered?))
                     )]))]
    
    (solve--ta tas slots false)))




;_____________________
;_____________________


;; HELPERS 1 :


;; (listof TA) -> (listof (listof TA))
;; produce next permutation order of given TA
(check-expect (next-order (string->list "ABC"))
              (list (string->list "ABC")
                    (string->list "ACB")
                    (string->list "BAC")
                    (string->list "BCA")
                    (string->list "CAB")
                    (string->list "CBA")))

;(define (next-order tas) (list tas))

(define (next-order tas)
  (no-duplicate-inside (list-permutation tas)))




;(1)
;; (listof TA) -> (listof (listof TA))
;; produce next permutation order of given TA
(check-expect (list-permutation (string->list "AB") )
              (list (string->list "AA")
                    (string->list "AB")
                    (string->list "BA")
                    (string->list "BB")))
(check-expect (list-permutation (string->list "ABC") )
              (list
               (string->list "AAA")
               (string->list "AAB")
               (string->list "AAC")
               (string->list "ABA")
               (string->list "ABB")
               (string->list "ABC")
               (string->list "ACA")
               (string->list "ACB")
               (string->list "ACC")
               (string->list "BAA")
               (string->list "BAB")
               (string->list "BAC")
               (string->list "BBA")
               (string->list "BBB")
               (string->list "BBC")
               (string->list "BCA")
               (string->list "BCB")
               (string->list "BCC")
               (string->list "CAA")
               (string->list "CAB")
               (string->list "CAC")
               (string->list "CBA")
               (string->list "CBB")
               (string->list "CBC")
               (string->list "CCA")
               (string->list "CCB")
               (string->list "CCC")))

;(define (list-permutation tas) (list tas)) ;stub

;; Template rules used:
;; - arbitrary arity tree
;; - generative recursion
;; - context perceiving accumulator

(define (list-permutation tas0)
  (local [(define (list-permutation--one tas)
            (cond [(= (length tas)
                      (length tas0)) (list tas)]
                  [else
                   (list-permutation--many (next-permutation tas tas0))]))
          
          (define (list-permutation--many lotas)
            (cond [(empty? lotas) empty]
                  [else
                   (append (list-permutation--one (first lotas))
                           (list-permutation--many (rest lotas))
                           )]))]
    
    (list-permutation--one empty)))


;; (listof X) (listof Y) -> (listof Z)
;; produce a list; append every element in Y to X
(check-expect (next-permutation empty (string->list "ABC"))
              (list (string->list "A")
                    (string->list "B")
                    (string->list "C")))
(check-expect (next-permutation (string->list "A") (string->list "ABC"))
              (list (string->list "AA")
                    (string->list "AB")
                    (string->list "AC")))

;(define (next-permutation x loy) empty)

(define (next-permutation x loy)
  (cond [(empty? loy) empty]
        [else
         (cons (append x (list (first loy)))
               (next-permutation x (rest loy)))]))




;(2)
;; (listof (listof TA)) -> (listof (listof TA))
;; No TA appear twice inside
(check-expect (no-duplicate-inside (list (string->list "ABC")
                                         (string->list "BBC")
                                         (string->list "ACB")
                                         (string->list "CAA")))
              (list (string->list "ABC")
                    (string->list "ACB")))

;(define (no-duplicate lotas) lotas) ;stub

(define (no-duplicate-inside lotas0)
  ;; rsf (listof (listof TA)) is no duplicate result seen so far
  (local [(define (no-duplicate-inside lotas rsf)
            (cond [(empty? lotas) rsf]
                  [else
                   (if (no-dupl? (first lotas))
                       (no-duplicate-inside (rest lotas) (append rsf
                                                                 (list (first lotas))))
                       (no-duplicate-inside (rest lotas) rsf)
                       )]))
           
          (define (no-dupl? tas)
            (cond [(empty? tas) true]
                  [else
                   (if (member (first tas) (rest tas))
                       false
                       (no-dupl? (rest tas))
                       )]))]
    
    (no-duplicate-inside lotas0 empty)))



;_____________________
;_____________________


;; HELPERS 2 :


;; (listof TA) (listof Slot) -> Schedule or false
;; produce valid schedule given TAs and Slots; false if impossible
(check-expect (schedule-tas empty empty) empty)
(check-expect (schedule-tas empty (list 1 2)) false)
(check-expect (schedule-tas (list SOBA) empty) empty)

(check-expect (schedule-tas (list SOBA) (list 1)) (list (make-assignment SOBA 1)))
(check-expect (schedule-tas (list SOBA) (list 2)) false)
(check-expect (schedule-tas (list SOBA) (list 1 3)) (list (make-assignment SOBA 3)
                                                          (make-assignment SOBA 1)))

(check-expect (schedule-tas NOODLE-TAs (list 1 2 3 4))
              (list
               (make-assignment UDON 4)
               (make-assignment SOBA 3)
               (make-assignment RAMEN 2)
               (make-assignment SOBA 1)))

(check-expect (schedule-tas NOODLE-TAs (list 1 2 3 4 5)) false)

;(define (schedule-tas tas slots) empty) ;stub

; _______________________________________________________________
; |                        |                                    |
; |  loTA        loSlot -> |    empty      (cons Slot loSlot)   |
; |________________________|____________________________________|
; |                        |                                    |
; |         empty          |    empty             false         |
; |                        |                                    |
; |     (cons TA loTA)     |    empty                           |
; |________________________|____________________________________|

;; Template rules used:
;; - structural recursion encapsuled in local
;; - tail recursive with context perserving accumulator

(define (schedule-tas tas0 slots0)
  ;; rsf        is Schedule   ; TA and Slot assigned seen so far
  ;; amortz-tas is (listof TA); amortized listof TA (after max number of slots they can work (ta-max) subtracted)
  
  (local [(define (schedule-tas tas slots rsf amortz-tas)
            (cond [(empty? slots) rsf]
                  [(empty? tas) false]
                  [else
                   (if (and (member (first slots) (ta-avail (first tas)))
                            (can-work? (first tas) amortz-tas))
                       (schedule-tas tas0
                                     (rest slots)
                                     (cons (make-assignment (first tas)
                                                            (first slots)) rsf)
                                     (subtract-max-ta (first tas) amortz-tas))
                       (schedule-tas-next (rest tas)
                                          slots
                                          rsf
                                          amortz-tas
                                          ))]))

          (define (schedule-tas-next tas slots rsf amortz-tas)
            (cond [(empty? tas) false]
                  [else
                   (schedule-tas tas
                                 slots
                                 rsf
                                 amortz-tas
                                 )]))
          
          ;; Helpers:         

          ;; TA (listof TA) -> (listof TA)
          ;; subtract (ta-max) by 1 (means TA has been assigned to schedule)
          (define (subtract-max-ta ta tas)
            (cond [(empty? tas) empty]
                  [else
                   (if (string=? (ta-name (first tas))
                                 (ta-name ta))
                       (cons (make-ta (ta-name (first tas))
                                      (sub1 (ta-max (first tas)))
                                      (ta-avail (first tas)))
                             (rest tas))
                       (cons (first tas) (subtract-max-ta ta (rest tas)))
                       )]))

          
          ;; TA (listof TA) -> Boolean
          ;; produce true if (ta-max) is more than zero, otherwise false
          (define (can-work? ta tas)
            (cond [(empty? tas) false]
                  [else
                   (if (string=? (ta-name (first tas))
                                 (ta-name ta))
                       (> (ta-max (first tas)) 0)
                       (can-work? ta (rest tas))
                       )]))]
    
    (schedule-tas tas0 slots0 empty tas0)))


