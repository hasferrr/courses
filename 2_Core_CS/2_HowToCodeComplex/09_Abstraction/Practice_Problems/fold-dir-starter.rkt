;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname fold-dir-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; fold-dir-starter.rkt

;________________________________________________________________
; 
; In this exercise you will be need to remember the following DDs 
; for an image organizer.
;________________________________________________________________


;; =================
;; Data definitions:

(define-struct dir (name sub-dirs images))
;; Dir is (make-dir String ListOfDir ListOfImage)
;; interp. An directory in the organizer, with a name, a list
;;         of sub-dirs and a list of images.

;; ListOfDir is one of:
;;  - empty
;;  - (cons Dir ListOfDir)
;; interp. A list of directories, this represents the sub-directories of
;;         a directory.

;; ListOfImage is one of:
;;  - empty
;;  - (cons Image ListOfImage)
;; interp. a list of images, this represents the sub-images of a directory.
;; NOTE: Image is a primitive type, but ListOfImage is not.

;      D6
;     /  \
;   D4    D5
;  /  \    |
; I1  I2   I3

(define I1 (square 10 "solid" "red"))
(define I2 (square 12 "solid" "green"))
(define I3 (rectangle 13 14 "solid" "blue"))
(define D4 (make-dir "D4" empty (list I1 I2)))
(define D5 (make-dir "D5" empty (list I3)))
(define D6 (make-dir "D6" (list D4 D5) empty))

;; =================
;; Functions:

;________________________________________________________________
; 
; PROBLEM A:
; 
; Design an abstract fold function for Dir called fold-dir. 
;________________________________________________________________

;; (String Y Z -> X) (X Y -> Y) (Image Z -> Z) Y Z Dir -> X
;; <abstract fold function for Dir>

(define (fold-dir fn1 fn2 fn3 b2 b3 d)

  (local [(define (fn-for-dir d) ;->X
            (fn1 (dir-name d) ;String
                 (fn-for-lod (dir-sub-dirs d))
                 (fn-for-loi (dir-images d))))

          (define (fn-for-lod lod) ;->Y
            (cond [(empty? lod) b2]
                  [else
                   (fn2 (fn-for-dir (first lod))
                        (fn-for-lod (rest lod))
                        )]
                  ))

          (define (fn-for-loi loi) ;->Z
            (cond [(empty? loi) b3]
                  [else
                   (fn3 (first loi) ;Image
                        (fn-for-loi (rest loi))
                        )]
                  ))]
    
    (fn-for-dir d)))

;__________________________________________________________________
; 
; PROBLEM B:
; 
; Design a function that consumes a Dir and produces the number of 
; images in the directory and its sub-directories. 
; Use the fold-dir abstract function.
;__________________________________________________________________

;; Dir -> Integer
;; produce the number of images in the directory and its sub-dirs
(check-expect (num-of-images (make-dir "D0" empty empty)) 0)
(check-expect (num-of-images D5) 1)
(check-expect (num-of-images D4) 2)
(check-expect (num-of-images D6) 3)

;(define (num-of-images d) 0) ;stub

(define (num-of-images d)
  (local [(define (fn1 s lod loi)
            (+ lod
               loi))
          (define (fn2 d lod)
            (+ d
               lod))
          (define (fn3 i loi)
            (+ 1 loi)
            )]
    (fold-dir fn1 fn2 fn3 0 0 d)))

;_______________________________________________________________________________
; 
; PROBLEM C:
; 
; Design a function that consumes a Dir and a String. The function looks in
; dir and all its sub-directories for a directory with the given name. If it
; finds such a directory it should produce true, if not it should produce false. 
; Use the fold-dir abstract function.
;_______________________________________________________________________________

;; Dir String -> Boolean
;; produce true If found a directory with the given name , otherwise false
(check-expect (find-dir (make-dir "DX" empty empty) "D0") false)
(check-expect (find-dir (make-dir "D0" empty empty) "D0") true)
(check-expect (find-dir D5 "D5") true)
(check-expect (find-dir D6 "D5") true)
(check-expect (find-dir D6 "D0") false)

;(define (find-dir d str) false) ;stub

(define (find-dir d str)
  (local [(define (fn1 s lod loi)
            (or (string=? s str)
                lod
                loi))
          (define (fn2 d lod)
            (or d
                lod))
          (define (fn3 i loi)
            false)]
    (fold-dir fn1 fn2 fn3 false false d)))



;_______________________________________________________________________________
; 
; PROBLEM D:
; 
; Is fold-dir really the best way to code the function from part C? Why or 
; why not?
;_______________________________________________________________________________

#|

Tidak, karena fold-dir akan terus mencari ke seluruh directori meskipun directory
yang diinginkan telah ditemukan

No, because fold-dir will keep looking for desired directory in the whole tree even
if the desired directory has been found

|#

