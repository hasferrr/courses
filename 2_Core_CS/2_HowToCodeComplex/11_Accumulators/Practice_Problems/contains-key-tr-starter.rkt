;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname contains-key-tr-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; bt-contains-tr-starter.rkt

; Problem:
; 
; Starting with the following data definition for a binary tree (not a binary search tree) 
; design a tail-recursive function called contains? that consumes a key and a binary tree 
; and produces true if the tree contains the key.
; 

(define-struct node (k v l r))
;; BT is one of:
;;  - false
;;  - (make-node Integer String BT BT)
;; Interp. A binary tree, each node has a key, value and 2 children
(define BT1 false)
(define BT2 (make-node 1 "a"
                       (make-node 6 "f"
                                  (make-node 4 "d" false false)
                                  false)
                       (make-node 7 "g" false false)))
#;
(define (fn-for-bt bt)
  (cond [(false? bt) (...)]
        [else
         (... (node-k bt)  ;Integer
              (node-v bt)  ;String
              (fn-for-bt (node-l bt))
              (fn-for-bt (node-r bt))
              )]))


;; Node Integer -> Boolean
;; produces true if the tree contains the key
(check-expect (contains? BT1 0) false)
(check-expect (contains? BT2 1) true)
(check-expect (contains? BT2 6) true)
(check-expect (contains? BT2 7) true)
(check-expect (contains? BT2 4) true)
(check-expect (contains? BT2 9) false)

;(define (contains? bt k) false)

(define (contains? bt0 key)
  ;; todo is (listof bt); BTs we need to visit with contains?
  ;; (constains? BT2)
  ;; (fn-for-lobt (6f 7g))
  ;; (fn-for-lobt (4d 7g))
  ;; (fn-for-lobt (7g))
  ;; (fn-for-lobt empty)
  (local [(define (contains? bt todo)
            (cond [(false? bt) false]
                  [else
                   (if (= key (node-k bt))
                       true
                       (fn-for-lobt (filter (λ (node) (not (false? node)))
                                            (cons (node-l bt) (cons (node-r bt) todo)))
                                    ))]))
          
          (define (fn-for-lobt todo)
            (cond [(empty? todo) false]
                  [else
                   (contains? (first todo) (rest todo)
                              )]))]
    
    (contains? bt0 empty)))

