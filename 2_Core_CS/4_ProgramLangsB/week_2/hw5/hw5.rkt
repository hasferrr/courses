;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)              ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)              ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)              ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call; funexp is closure; actual is body
(struct mlet (var e body) #:transparent)          ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent)          ;; make a new pair
(struct fst  (e)    #:transparent)                ;; get first part of a pair
(struct snd  (e)    #:transparent)                ;; get second part of a pair
(struct aunit ()    #:transparent)                ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent)                ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs but /is/ a MUPL value;
;; it is what functions evaluate to
(struct closure (env fun) #:transparent)


;; Problem 1

(define (racketlist->mupllist lst)
  (cond [(null? lst) (aunit)]
        [#t
         (apair (car lst)
                (racketlist->mupllist (cdr lst)))]))

(define (mupllist->racketlist mupllst)
  (cond [(aunit? mupllst) null]
        [#t
         (cons (apair-e1 mupllst)
               (mupllist->racketlist (apair-e2 mupllst)))]))



;; Problem 2

;; lookup a variable in an environment
;; Do NOT change this function
;; - env is [List  (cons "varname" (int num)  (cons "var1" (int 1))  (cons "var2" (int 2))
;; - str is "string"
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond [(var? e) 
         (envlookup env (var-string e))]
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        [(int? e) e]
        [(fun? e) (closure env e)]
        [(ifgreater? e)
         (letrec ([v1 (eval-under-env (ifgreater-e1 e) env)]
                  [v2 (eval-under-env (ifgreater-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (if (> (int-num v1)
                      (int-num v2))
                   (eval-under-env (ifgreater-e3 e) env)
                   (eval-under-env (ifgreater-e4 e) env))
               (error "MUPL ifgreater applied to non-number")))]
        [(mlet? e) (eval-under-env (mlet-body e)
                                   (cons (cons (mlet-var e)
                                               (eval-under-env (mlet-e e) env))
                                         env))]
        [(call? e)
         (letrec ([cls (eval-under-env (call-funexp e) env)]
                  [arg (eval-under-env (call-actual e) env)]
                  [cls-fun (closure-fun cls)]
                  [cls-env (closure-env cls)])
           (if (closure? cls)
               (if (false? (fun-nameopt cls-fun))
                   (eval-under-env (fun-body cls-fun)
                                   (cons (cons (fun-formal cls-fun) arg)
                                         cls-env))
                   (eval-under-env (fun-body cls-fun)
                                   (append (list (cons (fun-nameopt cls-fun) cls)
                                                 (cons (fun-formal cls-fun) arg))
                                           cls-env)))
               (error "the first expression is not a closure")))]
        [(closure? e) e]
        [(apair? e) (apair (eval-under-env (apair-e1 e) env)
                           (eval-under-env (apair-e2 e) env))]
        [(fst? e) (letrec ([exp (eval-under-env (fst-e e) env)])
                    (if (apair? exp)
                        (apair-e1 exp)
                        (error "MUPL fst applied to non-pair expression")))]
        [(snd? e) (letrec ([exp (eval-under-env (snd-e e) env)])
                    (if (apair? exp)
                        (apair-e2 exp)
                        (error "MUPL snd applied to non-pair expression")))]
        [(isaunit? e) (if (aunit? (eval-under-env (isaunit-e e) env))
                          (int 1)
                          (int 0))]
        [(aunit? e) e]
        [#t (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))


;; Problem 3

(define (ifaunit e1 e2 e3)
  (ifgreater (isaunit e1) (int 0) e2 e3))

(define (mlet* lstlst e2)
  (cond [(null? lstlst) e2]
        [#t (mlet (car (car lstlst))
                  (cdr (car lstlst))
                  (mlet* (cdr lstlst) e2))]))

(define (ifeq e1 e2 e3 e4)
  (mlet "_x" e1
        (mlet "_y" e2
              (ifgreater (var "_x") (var "_y") e4
                         (ifgreater (var "_y") (var "_x") e4 e3)))))


;; Problem 4

(define mupl-map
  (fun "mupl-map" "x"
       (fun #f "y"
            (ifaunit (var "y")
                     (aunit)
                     (apair (call (var "x") (fst (var "y")))
                            (call (call (var "mupl-map") (var "x"))
                                  (snd (var "y"))))))))

(define mupl-mapAddN
  (mlet "map" mupl-map
        (fun #f "x"
             (fun #f "y"
                  (call (call (var "map")
                              (fun #f "z" (add (var "z")
                                               (var "x"))))
                        (var "y"))))))


;; Challenge Problem

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e) "CHANGE")

;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env) "CHANGE")

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))
