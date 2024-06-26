;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname arrange-images-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; arrange-images-starter.rkt (problem statement)

 #| 
PROBLEM:

In this problem imagine you have a bunch of pictures that you would like to 
store as data and present in different ways. We'll do a simple version of that 
here, and set the stage for a more elaborate version later.

(A) Design a "data definition" to represent an arbitrary number of images.

(B) Design a "function" called arrange-images that consumes an arbitrary number
    of images and lays them out left-to-right in increasing order of size.
     |# 

;; Constant
(define BLANK (square 0 "solid" "white"))
;; for testing:
(define I1 (rectangle 10 20 "solid" "blue"))
(define I2 (rectangle 20 30 "solid" "red"))
(define I3 (rectangle 30 40 "solid" "green"))


;; ===================================================
;; Data definition
;; ListOfImage is one of:
;; - empty
;; - (cons Image ListOfImage)
;; interp. an arbitrary number of images

(define LOI0 empty)
(define LOI1 (cons (square 10 "solid" "white")
                   empty))
(define LOI2 (cons (square 20 "solid" "white")
                   (cons (square 10 "solid" "white")
                         empty)))
#;
(define (fn-for-loi loi)
  (cond [(empty? loi) (...)]
        [else
         (... (first loi)
              (fn-for-loi (rest loi))
              )]
        )
  )

;; Template rules used:
;; is one of: 2 cases
;; - atomic distinct: empty
;; - compound: (cons Image ListOfImage)
;;   - self-reference: (rest loi) is ListOfImage


;; ===================================================
;; Functions
;; ListOfImages -> Images
;; produce image that lays them out left-to-right in increasing order of size
;; (1) sort images, then (2) lays them out left-to-right
(check-expect (arrange-images (cons I1 empty))
              (beside I1 BLANK))
(check-expect (arrange-images (cons I1 (cons I2 empty)))
              (beside I1 I2 BLANK))
(check-expect (arrange-images (cons I2 (cons I1 empty)))
              (beside I1 I2 BLANK))
(check-expect (arrange-images (cons I3 (cons I2 (cons I1 empty))))
              (beside I1 I2 I3 BLANK))

;(define (arrange-images loi) BLANK) ;stub

(define (arrange-images loi)
  (layout-images (sort-images loi)))

;; ===================================================
;; ===================================================
;; ListOfImage -> Image
;; layout images left-to-right
(check-expect (layout-images empty) BLANK)
(check-expect (layout-images (cons I1 empty))
              (beside I1 BLANK))
(check-expect (layout-images (cons I1 (cons I2 empty)))
              (beside I1 I2 BLANK))

;(define (layout-images loi) BLANK) ;stub

(define (layout-images loi)
  (cond [(empty? loi) BLANK]
        [else
         (beside (first loi)
                 (layout-images (rest loi))
                 )]
        )
  )
;; ===================================================
;; ===================================================
;; ListOfImage -> ListOfImage
;; sort images in increasing order of size by area 
(check-expect (sort-images empty) empty)
(check-expect (sort-images (cons I1 (cons I2 empty)))
              (cons I1 (cons I2 empty)))
(check-expect (sort-images (cons I2 (cons I1 empty)))
              (cons I1 (cons I2 empty)))
(check-expect (sort-images (cons I3 (cons I1 (cons I2 empty))))
              (cons I1 (cons I2 (cons I3 empty))))
;(check-expect (sort-images (cons I3 (cons I2 (cons I1 empty))))
;              (cons I2 (cons I1 (cons I3 empty))))

;(define (sort-images loi) loi) ;stub

(define (sort-images loi)
  (cond [(empty? loi) empty]
        [else
         (insert (first loi) 
                 (sort-images (rest loi)) ;result of natural recursion will be sorted
                 )]
        )
  )

 #| Mengapa kita buat fungsi "insert" ?
Sebenarnya kita akan membuat (cons A1 A2),
tetapi karena kita perlu 'operate' yang mana yang A1 dan mana yg A2,
kita pakai fungsi lain untuk menentukannya, yaitu if A1 < A2 maka ... untuk
menentukan urutan dari (cons), mengingat bahwa fungsi "sort-images" itu membuat cons,
bukan menentukan urutan dari (cons). Jadi, kita buat fungsi lain untuk melakukannya, yaitu
fungsi "insert".

we need to operate on arbitary-sized data, maka dari itu
we have to use a function to do it |# 

;; ===================================================
;; ===================================================
;; ===================================================
;; Images ListOfImages -> ListOfImages
;; produce new list with image in proper place in list (in increasing order of size)
;; ASSUME: loi is already sorted
(check-expect (insert I1 empty)
              (cons I1 empty))
(check-expect (insert I1 (cons I2 (cons I3 empty)))
              (cons I1 (cons I2 (cons I3 empty))))
(check-expect (insert I2 (cons I1 (cons I3 empty)))
              (cons I1 (cons I2 (cons I3 empty))))
(check-expect (insert I3 (cons I1 (cons I2 empty)))
              (cons I1 (cons I2 (cons I3 empty))))

;(define (insert i loi) loi) ;stub

(define (insert i loi)
  (cond [(empty? loi) (cons i empty)]
        [else
         (if (area-bigger-than i (first loi))
             (cons (first loi) (insert i (rest loi)))
             (cons i loi)
             )]
        )
  )

;; ===================================================
;; ===================================================
;; ===================================================
;; ===================================================
;; Images Images -> Boolean
;; produce true if i1 area is larger than i2 area (w times h)
(check-expect (area-bigger-than I1 I1) false)
(check-expect (area-bigger-than I1 I2) false)
(check-expect (area-bigger-than I3 I2) true)

;(define (area-bigger-than i1 i2) true) ;stub

(define (area-bigger-than i1 i2)
  (> (* (image-height i1) (image-width i1))
     (* (image-height i2) (image-width i2))
     )
  )

; bang bang bang bang bang bang bang bang bang bang bang bang bang bang
; lmao



