(require 2htdp/image)

;; image-organizer-starter.rkt

;
; PROBLEM:
;
; Complete the design of a hierarchical image organizer.  The information and data
; for this problem are similar to the file system example in the fs-starter.rkt file.
; But there are some key differences:
;   - this data is designed to keep a hierchical collection of images
;   - in this data a directory keeps its sub-directories in a separate list from
;     the images it contains
;   - as a consequence data and images are two clearly separate types
;
; Start by carefully reviewing the partial data definitions below.
;


;; =================
;; Constants:

(define SIZE 15)
(define COLOR "white")

;; =================
;; Data definitions:

(define-struct dir (name sub-dirs images))
;; Dir is (make-dir String ListOfDir ListOfImage)
;; interp. An directory in the organizer; with a name,
;;         a list of sub-dirs, and a list of images.

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

(define I1 (square 10 "solid" "red"))
(define I2 (square 10 "solid" "green"))
(define I3 (rectangle 13 14 "solid" "blue"))
(define D4 (make-dir "D4" empty (list I1 I2)))
(define D5 (make-dir "D5" empty (list I3)))
(define D6 (make-dir "D6" (list D4 D5) empty))

;
; PART A:
;
; Annotate the type comments with reference arrows and label each one to say
; whether it is a reference, self-reference or mutual-reference.
;
; PART B:
;
; Write out the templates for Dir, ListOfDir and ListOfImage. Identify for each
; call to a template function which arrow from part A it corresponds to.
;

#;
(define (fn-for-dir d)
  (... (dir-name d)
       (fn-for-lod (dir-sub-dirs d))
       (fn-for-loi (dir-images d))
       ))
#;
(define (fn-for-lod lod)
  (cond [(empty? lod) (...)]
        [else
         (... (fn-for-dir (first lod))
              (fn-for-lod (rest lod))
              )]
        ))
#;
(define (fn-for-loi loi)
  (cond [(empty? loi) (...)]
        [else
         (... (first loi)
              (fn-for-loi (rest loi))
              )]
        ))

;; =================
;; Functions:

;
; PROBLEM B:
;
; Design a function to calculate the total size (width * height) of all the images
; in a directory and its sub-directories.
;


;; Dir          -> Integer
;; ListOfDir    -> Integer
;; ListOfImages -> Integer
;; produce total size (width * height) of all the images in a directory and its sub-directories
(check-expect (total-size--lod empty) 0)
(check-expect (total-size--loi empty) 0)

(check-expect (total-size--loi (list I3)) (+ (* (image-width I3)
                                                (image-height I3))
                                             0))
(check-expect (total-size--loi (list I1 I2)) (+ (* (image-width I1)
                                                   (image-height I1))
                                                (* (image-width I2)
                                                   (image-height I2))
                                                0))

(check-expect (total-size--lod (list (make-dir "empty_dir" empty empty))) 0)
(check-expect (total-size--lod (list D4 D5))
              (+ (total-size--dir D4)
                 (total-size--lod (list D5))
                 ))

(check-expect (total-size--dir (make-dir "empty_dir" empty empty)) 0)
(check-expect (total-size--dir D5)
              (+ (total-size--lod empty)
                 (total-size--loi (list I3))
                 ))


;(define (total-size--dir d) 0)   ;stubs
;(define (total-size--lod lod) 0)
;(define (total-size--loi loi) 0)

(define (total-size--dir d)
  (+ (total-size--lod (dir-sub-dirs d))
     (total-size--loi (dir-images d))
     ))

(define (total-size--lod lod)
  (cond [(empty? lod) 0]
        [else
         (+ (total-size--dir (first lod)) ;integer
            (total-size--lod (rest lod))
            )]
        ))

(define (total-size--loi loi)
  (cond [(empty? loi) 0]
        [else
         (+ (calc-area (first loi))
            (total-size--loi (rest loi))
            )]
        ))

;; Image -> Integer
;; produce area (width * height) of given image
(check-expect (calc-area (rectangle 2 4 "solid" "white")) (* 2 4))

;(define (calc-area i) 0) ;stub

(define (calc-area i)
  (* (image-width i)
     (image-height i)))


;
; PROBLEM C:
;
; Design a function to produce rendering of a directory with its images. Keep it
; simple and be sure to spend the first 10 minutes of your work with paper and
; pencil!
;
; .
;


;; Dir         -> Image
;; ListOfDir   -> Image??
;; ListOfImage -> Image??
;; produce rendering of a directory with its images
(check-expect (render--lod empty) empty-image)
(check-expect (render--loi empty) empty-image)

(check-expect (render--loi (list I3)) (beside I3 empty-image))
(check-expect (render--loi (list I1 I2)) (beside I1 I2 empty-image))

(check-expect (render--dir D6) (above (text "D6" SIZE COLOR)
                                      (beside (render--lod (list D4)) ;lod
                                              (render--lod (list D5)) ;lod
                                              empty-image)     ;loi
                                      ))

(check-expect (render--lod (list D5)) (above (text "D5" SIZE COLOR)  ;dir
                                             (beside I3 empty-image) ;lod
                                             ))
(check-expect (render--lod (list D4)) (above (text "D4" SIZE COLOR)
                                             (beside I1 I2 empty-image)
                                             ))

;(define (render--dir d) empty-image)
;(define (render--lod lod) empty-image)
;(define (render--loi loi) empty-image)

(define (render--dir d)
  (above (text (dir-name d) SIZE COLOR)
         (beside (render--lod (dir-sub-dirs d))
                 (render--loi (dir-images d)))
         ))

(define (render--lod lod)
  (cond [(empty? lod) empty-image]
        [else
         (beside (render--dir (first lod))
                 (render--lod (rest lod))
                 )]
        ))

(define (render--loi loi)
  (cond [(empty? loi) empty-image]
        [else
         (beside (first loi)
                 (render--loi (rest loi))
                 )]
        ))





