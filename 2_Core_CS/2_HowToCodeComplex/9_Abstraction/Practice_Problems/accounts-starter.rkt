;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname accounts-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; accounts-starter.rkt

(define-struct node (id name bal l r))
;; Accounts is one of:
;;  - false
;;  - (make-node Natural String Integer Accounts Accounts)
;;
;; interp. a collection of bank accounts
;; - false represents an empty collection of accounts.
;; - (make-node id name bal l r) is a non-empty collection of accounts such that:
;;    - id       is an account identification number (and BST key)
;;    - name     is the account holder's name
;;    - bal      is the account balance in dollars CAD 
;;    - l and r  are further collections of accounts
;;
;; INVARIANT: for a given node:
;;     id is > all ids in its l(eft)  child
;;     id is < all ids in its r(ight) child
;;     the same id never appears twice in the collection

(define ACT0 false)
(define ACT1 (make-node 1 "Mr. Rogers"  22 false false))
(define ACT4 (make-node 4 "Mrs. Doubtfire"  -3
                        false
                        (make-node 7 "Mr. Natural" 13 false false)))
(define ACT3 (make-node 3 "Miss Marple"  600 ACT1 ACT4))
(define ACT42 
  (make-node 42 "Mr. Mom" -79
             (make-node 27 "Mr. Selatcia" 40 
                        (make-node 14 "Mr. Impossible" -9 false false)
                        false)
             (make-node 50 "Miss 604"  16 false false)))
(define ACT10 (make-node 10 "Dr. No" 84 ACT3 ACT42))

#;
(define (fn-for-act act)
  (cond [(false? act) (...)]
        [else
         (... (node-id act)
              (node-name act)
              (node-bal act)
              (fn-for-act (node-l act))
              (fn-for-act (node-r act)))]))

;____________________________________________________________________________
;
; PROBLEM 1:
; 
; Design an abstract function (including signature, purpose, and tests) 
; to simplify the remove-debtors and remove-profs functions defined below.
; 
; Now re-define the original remove-debtors and remove-profs functions 
; to use your abstract function. Remember, the signature and tests should 
; not change from the original functions.
;____________________________________________________________________________


; ======================== Abstract function ========================

;; (Accounts -> Boolean) Accounts -> Accounts
;; remove account node if fn1 (given function) is true

(check-expect (local [(define (fn1 act) (positive? (node-bal act)) )]
                (remove-act fn1 (make-node 1 "name" 30 false false)))
              false)

(check-expect (local [(define (fn1 act) (negative? (node-bal act)) )]
                (remove-act fn1 (make-node 1 "Mr. Rogers" 22 false false)))
              (make-node 1 "Mr. Rogers" 22 false false))

(check-expect (local [(define (fn1 act) (negative? (node-bal act)) )]
                (remove-act fn1 (make-node 27 "Mr. Selatcia" 40
                                           (make-node 14 "Mr. Impossible" -9 false false)
                                           false)))
              (make-node 27 "Mr. Selatcia" 40 false false))

(check-expect (local [(define (fn1 act) (has-prefix? "Prof." (node-name act)))]
                (remove-act fn1 (make-node 67 "Mrs. Dash" 3000
                                           (make-node 9 "Prof. Booty" -60 false false)
                                           false)))
              (make-node 67 "Mrs. Dash" 3000 false false))

(check-expect (local [(define (fn1 act) (has-prefix? "Prof." (node-name act)))]
                (remove-act fn1 (make-node 97 "Prof. X" 7
                                           false 
                                           (make-node 112 "Ms. Magazine" 467 false false))))
              (make-node 112 "Ms. Magazine" 467 false false))


(define (remove-act fn1 act)
  (cond [(false? act) false]
        [else
         (if (fn1 act)
             (join (remove-act fn1 (node-l act))
                   (remove-act fn1 (node-r act)))
             (make-node (node-id act)
                        (node-name act)
                        (node-bal act)
                        (remove-act fn1 (node-l act))
                        (remove-act fn1 (node-r act))))]))

; ===================================================================

;; Accounts -> Accounts
;; remove all accounts with a negative balance
(check-expect (remove-debtors (make-node 1 "Mr. Rogers" 22 false false)) 
              (make-node 1 "Mr. Rogers" 22 false false))

(check-expect (remove-debtors (make-node 14 "Mr. Impossible" -9 false false))
              false)

(check-expect (remove-debtors
               (make-node 27 "Mr. Selatcia" 40
                          (make-node 14 "Mr. Impossible" -9 false false)
                          false))
              (make-node 27 "Mr. Selatcia" 40 false false))

(check-expect (remove-debtors 
               (make-node 4 "Mrs. Doubtfire" -3
                          false 
                          (make-node 7 "Mr. Natural" 13 false false)))
              (make-node 7 "Mr. Natural" 13 false false))


(define (remove-debtors act) (local [(define (fn1 act)
                                       (negative? (node-bal act)))]
                               (remove-act fn1 act)))

; ========================

;; Accounts -> Accounts
;; Remove all professors' accounts.  
(check-expect (remove-profs (make-node 27 "Mr. Smith" 100000 false false)) 
              (make-node 27 "Mr. Smith" 100000 false false))
(check-expect (remove-profs (make-node 44 "Prof. Longhair" 2 false false)) false)
(check-expect (remove-profs (make-node 67 "Mrs. Dash" 3000
                                       (make-node 9 "Prof. Booty" -60 false false)
                                       false))
              (make-node 67 "Mrs. Dash" 3000 false false))
(check-expect (remove-profs 
               (make-node 97 "Prof. X" 7
                          false 
                          (make-node 112 "Ms. Magazine" 467 false false)))
              (make-node 112 "Ms. Magazine" 467 false false))


(define (remove-profs act) (local [(define (fn1 act)
                                     (has-prefix? "Prof." (node-name act)))]
                             (remove-act fn1 act)))


; ========================
; ========================

;; String String -> Boolean
;; Determine whether pre is a prefix of str.
(check-expect (has-prefix? "" "rock") true)
(check-expect (has-prefix? "rock" "rockabilly") true)
(check-expect (has-prefix? "blues" "rhythm and blues") false)

(define (has-prefix? pre str)
  (string=? pre (substring str 0 (string-length pre))))

;; Accounts Accounts -> Accounts
;; Combine two Accounts's into one
;; ASSUMPTION: all ids in act1 are less than the ids in act2
(check-expect (join ACT42 false) ACT42)
(check-expect (join false ACT42) ACT42)
(check-expect (join ACT1 ACT4) 
              (make-node 4 "Mrs. Doubtfire" -3
                         ACT1
                         (make-node 7 "Mr. Natural" 13 false false)))
(check-expect (join ACT3 ACT42) 
              (make-node 42 "Mr. Mom" -79
                         (make-node 27 "Mr. Selatcia" 40
                                    (make-node 14 "Mr. Impossible" -9
                                               ACT3
                                               false)
                                    false)
                         (make-node 50 "Miss 604" 16 false false)))

(define (join act1 act2)
  (cond [(false? act2) act1]
        [else
         (make-node (node-id act2) 
                    (node-name act2)
                    (node-bal act2)
                    (join act1 (node-l act2))
                    (node-r act2))]))

;_________________________________________________________________________________
;
; PROBLEM 2:
; 
; Using your new abstract function, design a function that removes from a given
; BST any account where the name of the account holder has an odd number (ganjil)
; of characters.  Call it remove-odd-characters.
;_________________________________________________________________________________

;; Account -> Account
;; Remove accounts where the holder's name has an odd (ganjil) number of characters
(check-expect (remove-odd-characters false) false)
(check-expect (remove-odd-characters (make-node 1 "1234" 22 false false))
              (make-node 1 "1234" 22 false false))
(check-expect (remove-odd-characters (make-node 1 "12345" 22 false false))
              false)
(check-expect (remove-odd-characters (make-node 1 "1234567" 22 (make-node 1 "1234" 22 false false) false))
              (make-node 1 "1234" 22 false false))

;(define (remove-odd-characters act) false) ;stub

(define (remove-odd-characters act)
  (local [(define (fn1 act)
            (not (zero? (modulo (string-length (node-name act)) 2))))]
    (remove-act fn1 act)))


;_________________________________________________________________________________
;
; Problem 3:
; 
; Design an abstract fold function for Accounts called fold-act. 
; 
; Use fold-act to design a function called charge-fee that decrements
; the balance of every account in a given collection by the monthly fee of 3 CAD.
;_________________________________________________________________________________

;; (Natural String Integer X X -> Accounts) X Accounts -> X
;; abstract fold function for Accounts

(define (fold-act fn b act)
  (cond [(false? act) b]
        [else
         (fn (node-id act)
             (node-name act)
             (node-bal act)
             (fold-act fn b (node-l act))
             (fold-act fn b (node-r act)))]))

;; Account -> Account
;; decrements the balance of every account by 3
(check-expect (charge-fee false) false)
(check-expect (charge-fee (make-node 1 "a" 60 false false))
              (make-node 1 "a" 57 false false))
(check-expect (charge-fee (make-node 1 "a" 60 (make-node 2 "b" 2 false false) false))
              (make-node 1 "a" 57 (make-node 2 "b" -1 false false) false))

;(define (charge-fee act) false) ;stub

(define (charge-fee act) (local [(define (charge n s int l r)
                                   (make-node n s (- int 3) l r))]
                           (fold-act charge false act)))

;_________________________________________________________________________________
;
; PROBLEM 4:
; 
; Suppose you needed to design a function to look up an account based on its ID.
; Would it be better to design the function using fold-act, or to design the
; function using the fn-for-acts template?  Briefly justify your answer.
;_________________________________________________________________________________

#|
better using fn-for-acts and use backtracking search
meanwhile fold-act used to operate the node, and every node although
desired ID has been found
|#



