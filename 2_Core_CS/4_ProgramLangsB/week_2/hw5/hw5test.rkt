
#lang racket
;; Programming Languages Homework 5 Simple Test
;; Save this file to the same directory as your homework file
;; These are basic tests. Passing these tests does not guarantee that your code will pass the actual homework grader

;; Be sure to put your homework file in the same folder as this test file.
;; Uncomment the line below and, if necessary, change the filename
(require "hw5.rkt")

(require rackunit)

(define tests
  (test-suite
   "Sample tests for Assignment 5"

   ; ================= PROBLEM 1 =================
   
   ;; check racketlist to mupllist with normal list
   (check-equal? (racketlist->mupllist null)
                 (aunit)
                 "racketlist->mupllist test")
   (check-equal? (racketlist->mupllist (list (int 99)))
                 (apair (int 99) (aunit))
                 "racketlist->mupllist test")
   (check-equal? (racketlist->mupllist (list (int 3) (int 4)))
                 (apair (int 3) (apair (int 4) (aunit)))
                 "racketlist->mupllist test")
   

   ;; check mupllist to racketlist with normal list
   (check-equal? (mupllist->racketlist (aunit))
                 null
                 "racketlist->mupllist test")
   (check-equal? (mupllist->racketlist (apair (int 99) (aunit)))
                 (list (int 99))
                 "racketlist->mupllist test")
   (check-equal? (mupllist->racketlist (apair (int 3) (apair (int 4) (aunit))))
                 (list (int 3) (int 4))
                 "racketlist->mupllist test")

   
   ; ================= PROBLEM 2 =================
   
   ;; check expect
   (check-equal? (eval-exp (int 3))
                 (int 3) "INT")
   (check-equal? (eval-under-env (int 3) null)
                 (int 3) "INT")

   
   (check-equal? (eval-under-env (var "one") (list (cons "one" (int 1))))
                 (int 1) "VAR")
   (check-equal? (eval-under-env (var "one") (list (cons "hhe" (int 999))
                                                   (cons "one"  (int 1))
                                                   (cons "wkw" (int 888))))
                 (int 1) "VAR")

   
   (check-equal? (eval-exp (add (int 4) (int 3)))
                 (int 7) "ADD")
   (check-equal? (eval-under-env (add (int 4) (int 3)) null)
                 (int 7) "ADD")

   

   (check-equal? (eval-under-env (fun "fun_name" "a" (int 1)) null)
                 (closure null (fun "fun_name" "a" (int 1)))
                 "FUN")



   ;; tests if ifgreater returns (int 2)
   (check-equal? (eval-exp (ifgreater (int 3) (int 4) (int 3) (int 2)))
                 (int 2)
                 "ifgreater test")
   (check-equal? (eval-exp (ifgreater (add (int 9)
                                           (int 7))
                                      (int 4)
                                      (int 3) (int 2)))
                 (int 3)
                 "ifgreater test")
   (check-equal? (eval-exp (ifgreater (add (int 1)
                                           (int 2))
                                      (add (int 2)
                                           (int 1))
                                      (int 3) (int 2)))
                 (int 2)
                 "ifgreater test")
   (check-equal? (eval-exp (ifgreater (add (add (int 1) (int 3))
                                           (add (int 4) (int 2)))
                                      (int 7)
                                      (int 3) (int 2)))
                 (int 3)
                 "ifgreater test")


   ;; mlet test
   (check-equal? (eval-exp (mlet "x"
                                 (int 1)
                                 (add (int 5) (var "x"))))
                 (int 6)
                 "mlet test")
   (check-equal? (eval-under-env (mlet "x"
                                       (int 1)
                                       (add (int 5) (var "x")))
                                 (list (cons "x" (int 99))))
                 (int 6)
                 "mlet test")
   (check-equal? (eval-under-env (mlet "x"
                                       (int 1)
                                       (add (var "y") (var "x")))
                                 (list (cons "y" (int 99))))
                 (int 100)
                 "mlet test")


   ;; call test
   (check-equal? (eval-exp (call (closure '()
                                          (fun #f
                                               "x"
                                               (add (var "x") (int 7))))
                                 (int 1)))
                 (int 8) "call test")
   (check-equal? (eval-exp (call (closure (list (cons "y" (int 7)))
                                          (fun #f
                                               "x"
                                               (add (var "x") (var "y"))))
                                 (int 1)))
                 (int 8) "call test")
   (check-equal? (eval-under-env (call (closure (list (cons "y" (int 7)))
                                                (fun #f
                                                     "x"
                                                     (add (var "x") (var "y"))))
                                       (int 1))
                                 (list (cons "y" (int 999)))) ;irrelevant
                 (int 8) "call test")
   (check-equal? (eval-exp (call (closure null
                                          (fun "sum-list"
                                               "lst"
                                               (ifaunit (var "lst")
                                                        (int 0)
                                                        (add (fst (var "lst"))
                                                             (call (var "sum-list")
                                                                   (snd (var "lst")))
                                                             ))))
                                 (apair (int 2) (apair (int 5) (apair (int 7) (aunit))))))
                 (int 14) "RECURSIONNNNNNN call test")
   (check-equal? (eval-exp (call (closure null
                                          (fun "count-list-element"
                                               "lst"
                                               (ifaunit (var "lst")
                                                        (int 0)
                                                        (add (int 1)
                                                             (call (var "count-list-element")
                                                                   (snd (var "lst")))
                                                             ))))
                                 (apair (int 2) (apair (int 5) (apair (int 7) (aunit))))))
                 (int 3) "RECURSIONNNNNNN call test")


   ;; pair test
   (check-equal? (eval-exp (apair (int 1) (add (int 2)(int 2))))
                 (apair (int 1) (int 4))
                 "pair test")
   (check-equal? (eval-exp (fst (apair (int 1) (int 2))))
                 (int 1)
                 "fst test")
   (check-equal? (eval-exp (snd (apair (int 1) (int 2))))
                 (int 2)
                 "snd test")
   
   (check-equal? (eval-exp (fst (ifgreater (int 1)
                                           (int 0)
                                           (apair (int 1) (int 2))
                                           (aunit)
                                           )))
                 (int 1)
                 "fst test")
   (check-equal? (eval-exp (snd (ifgreater (int 1)
                                           (int 0)
                                           (apair (int 1) (int 2))
                                           (aunit)
                                           )))
                 (int 2)
                 "snd test")
   
   (check-equal? (eval-under-env (fst (var "pr"))
                                 (list (cons "pr" (apair (int 1) (int 2)))))
                 (int 1)
                 "fst test")
   (check-equal? (eval-under-env (snd (var "pr"))
                                 (list (cons "pr" (apair (int 1) (int 2)))))
                 (int 2)
                 "snd test")

   


   ;; isaunit test
   (check-equal? (eval-exp (isaunit (closure '() (fun #f "x" (aunit)))))
                 (int 0) "isaunit test")
   (check-equal? (eval-exp (isaunit (aunit)))
                 (int 1) "isaunit test")
   (check-equal? (eval-exp (isaunit (ifgreater (int 1) (int 0) (apair (int 1) (int 2)) (aunit) )))
                 (int 0) "isaunit test")
   (check-equal? (eval-exp (isaunit (ifgreater (int 1) (int 999) (apair (int 1) (int 2)) (aunit) )))
                 (int 1) "isaunit test")


   ; ================= PROBLEM 3 =================
   
   ;; ifaunit test
   (check-equal? (eval-exp (ifaunit (int 1) (int 2) (int 3))) (int 3) "ifaunit test")
   (check-equal? (eval-exp (ifaunit (aunit) (int 2) (int 3))) (int 2) "ifaunit test")
   (check-equal? (eval-exp (ifaunit (ifgreater (int 99) (int 1) (aunit) (int 0)) (int 2) (int 3))) (int 2) "ifaunit test")


   ;; mlet* test
   (check-equal? (eval-exp (mlet* null
                                  (int 10)))
                 (int 10) "mlet* test")
   (check-equal? (eval-exp (mlet* (list (cons "x" (int 10)))
                                  (var "x")))
                 (int 10) "mlet* test")
   (check-equal? (eval-exp (mlet* (list (cons "x" (int 10))
                                        (cons "y" (int 20))
                                        (cons "z" (int -40)))
                                  (add (add (var "x") (var "y")) (var "z"))))
                 (eval-exp (add (add (int 10) (int 20)) (int -40)))
                 "mlet* test")


   ;; ifeq test
   (check-equal? (eval-exp (ifeq (int 1) (int 2) (int 3) (int 4)))
                 (int 4) "ifeq test")
   (check-equal? (eval-exp (ifeq (int 1) (int 1) (int 3) (int 4)))
                 (int 3) "ifeq test")
   (check-equal? (eval-under-env (ifeq (add (add (var "x") (int 94)) (int 4))
                                       (ifgreater (int 1) (int 0) (int 100) (int 0))
                                       (add (var "y") (add (int 2) (int 1)))
                                       (int 4))
                                 (list (cons "x" (int 2))
                                       (cons "y" (int 0))))
                 (int 3) "ifeq test")

   
   ; ================= PROBLEM 4 =================
   

   ;; mupl-map test
   (check-equal? (eval-exp (call (call mupl-map (fun #f "x" (add (var "x") (int 7))))
                                 (apair (int 1) (aunit)))) 
                 (apair (int 8) (aunit))
                 "mupl-map test")
   (check-equal? (eval-exp (call (call mupl-map (fun #f "x" (add (var "x") (int 7))))
                                 (apair (int 1) (apair (int 2) (apair (int 3) (aunit)))))) 
                 (apair (int 8) (apair (int 9) (apair (int 10) (aunit))))
                 "mupl-map test")


   ;; problems 1, 2, and 4 combined test
   (check-equal? (mupllist->racketlist
                  (eval-exp (call (call mupl-mapAddN (int 7))
                                  (racketlist->mupllist 
                                   (list (int 3) (int 4) (int 9))))))
                 (list (int 10) (int 11) (int 16))
                 "combined test")
   
   ))

(require rackunit/text-ui)

;; runs the test
(run-tests tests)
