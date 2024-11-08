;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname insert-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; insert-starter.rkt

;; ----------
;; Data definitions:

(define-struct node (key val l r))
;; A BST (Binary Search Tree) is one of:
;;  - false
;;  - (make-node Integer String BST BST)
;; interp. false means no BST, or empty BST
;;         key is the node key
;;         val is the node val
;;         l and r are left and right subtrees
;; INVARIANT: for a given node:
;;     key is > all keys in its l(eft)  child
;;     key is < all keys in its r(ight) child
;;     the same key never appears twice in the tree

(define BST0 false)
(define BST1 (make-node 1 "abc" false false))
(define BST7 (make-node 7 "ruf" false false))
(define BST4 (make-node 4 "dcj" false (make-node 7 "ruf" false false)))
(define BST3 (make-node 3 "ilk" BST1 BST4))
(define BST42 
  (make-node 42 "ily"
             (make-node 27 "wit" (make-node 14 "olp" false false) false)
             false))
(define BST10 (make-node 10 "why" BST3 BST42))

#;
(define (fn-for-bst t)
  (cond [(false? t) (...)]
        [else
         (... (node-key t)    ;Integer
              (node-val t)    ;String
              (fn-for-bst (node-l t))
              (fn-for-bst (node-r t)))]))

;; Template rules used:
;;  - one of: 2 cases
;;  - atomic-distinct: false
;;  - compound: (make-node Integer String BST BST)
;;  - self reference: (node-l t) has type BST
;;  - self reference: (node-r t) has type BST


;; ----------
;; Functions:

 #| 
PROBLEM:

Design a function that consumes an Integer, String and BST, and "adds a node
that has the given key and value to the tree". The node should be inserted in 
the proper place in the tree. The function can "assume" there is not already 
an entry for that number in the tree. The function should "produce the new BST."

Do not worry about keeping the tree balanced. We will come back to this later.
 |# 
 #| "Image removed" |# 
;; Integer String BST -> BST
;; insert a node that has the given key and value to the BST, then produce the new BST
;; ASSUME: there is not already an entry for that number in the tree

;add to empty BST
(check-expect (insert 2 "abc" false)
              (make-node 2 "abc" false false))                           

;add to left
(check-expect (insert 2 "abc" (make-node 7 "ruf" false false))
              (make-node 7 "ruf" (insert 2 "abc" false) false))          
(check-expect (insert 1 "abc" (make-node 2 "abc" false false))
              (make-node 2 "abc" (make-node 1 "abc" false false) false))

;add to left that have sub-tree
(check-expect (insert 2 "abc" (make-node 3 "ilk" BST1 BST4))
              (make-node 3 "ilk" (make-node 2 "abc" BST1 false) BST4))   

(check-expect (insert 2 "abc" (make-node 3 "ilk" BST1 BST4))
              (make-node 3 "ilk" (insert 1 "abc" (make-node 2 "abc" false false)) BST4))

(check-expect (insert 2 "abc" (make-node 3 "ilk" (make-node 1 "abc" false false) BST4))
              (make-node 3 "ilk" (insert 1 "abc" (insert 2 "abc" false)) BST4))

;add to right
(check-expect (insert 8 "asd" (make-node 7 "ruf" false false))
              (make-node 7 "ruf" false (make-node 8 "asd" false false)))
(check-expect (insert 7 "ruf" (make-node 5 "cvb" false false))
              (make-node 5 "cvb" false (make-node 7 "ruf" false false)))

;add to right that have sub-tree
(check-expect (insert 5 "cvb" (make-node 4 "dcj" false BST7))
              (make-node 4 "dcj" false (make-node 5 "cvb" false BST7)))

(check-expect (insert 5 "cvb" (make-node 4 "dcj" false (make-node 7 "ruf" false false)))
              (make-node 4 "dcj" false (make-node 5 "cvb" false (make-node 7 "ruf" false false))))
            

;(define (insert int str bst) BST0) ;stub

;Use template from BST, with additional atomic parameter: Integer, String

(define (insert int str t)
  (cond [(false? t) (make-node int str false false)]
        [else
         (cond
           ; insert to left
           [(< int (node-key t))
            (if (false? (node-l t))
                ; if node-l is false (dont have any sub-tree)
                (make-node (node-key t)
                           (node-val t)
                           (insert int str (node-l t))
                           (node-r t)
                           )
                ;have sub-tree
                (make-node (node-key t)
                           (node-val t)
                           (insert (node-key (node-l t)) (node-val (node-l t)) (insert int str false))
                           (node-r t)
                           )
                )]
           
           ; insert to right
           [(> int (node-key t))
            (if (false? (node-r t))
                ; if node-r is false (dont have any sub-tree)
                (make-node (node-key t)
                           (node-val t)
                           (node-l t)
                           (insert int str (node-r t))
                           )
                ;have sub-tree
                (make-node (node-key t)
                           (node-val t)
                           (node-l t)
                           (insert (node-key (node-r t)) (node-val (node-r t)) (insert int str false))
                           )
                )]
           )]
        ))


 #| ; old insert function

(define (insert int str t)
  (cond [(false? t) (make-node int str false false)]
        [else
         (cond
           ; insert to left
           [(< int (node-key t))
            (make-node (node-key t)
                           (node-val t)
                           (insert int str (node-l t))
                           (node-r t)
                           )]
           
           ; insert to right
           [(> int (node-key t))
            (make-node (node-key t)
                           (node-val t)
                           (node-l t)
                           (insert int str (node-r t))
                           )]
           )]
        )) |# 


