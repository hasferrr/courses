;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname image-area-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; image-area-starter.rkt

 #| 
PROBLEM:

DESIGN a function called image-area that consumes an image and produces the 
area of that image. For the area it is sufficient to just multiple the image's 
width by its height.  Follow the HtDF recipe and leave behind commented 
out versions of the stub and template.
 |# 

 #| The HtDF recipe consists of the following steps:
(tidak selalu harus berurutan)
1. Signature, purpose and stub.
2. Define examples, wrap each in check-expect.
3. Template and inventory.
4. Code the function body.
5. Test and debug until correct |# 

(require 2htdp/image)

;; Image --> Integer
;; produces area of the image (width * height) based on given image
(check-expect (image-area (rectangle 4 5 "solid" "red")) 20)
(check-expect (image-area (rectangle 6 6 "solid" "red")) (* 6 6))

;(define (image-area img) 0) ;stub

;(define (image-area img)    ;template
;  (... img))

(define (image-area img)
  (* (image-width img) (image-height img))
)


