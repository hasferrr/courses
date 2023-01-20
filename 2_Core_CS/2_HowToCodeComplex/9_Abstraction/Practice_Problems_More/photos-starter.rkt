;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname photos-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; photos-starter.rkt

;; =================
;; Data definitions:

(define-struct photo (location album favourite))
;; Photo is (make-photo String String Boolean)
;; interp. a photo having a location, belonging to an album and having a
;;         favourite status (true if photo is a favourite, false otherwise)
(define PHT1 (make-photo "photos/2012/june" "Victoria" true))
(define PHT2 (make-photo "photos/2013/birthday" "Birthday" true))
(define PHT3 (make-photo "photos/2012/august" "Seattle" true))

;; =================
;; Functions:

; 
; PROBLEM:
; 
; Design a function called to-frame that consumes an album name and a list of photos 
; and produces a list of only those photos that are favourites and that belong to 
; the given album. You must use built-in abstract functions wherever possible. 
; 

;; String (listof Photo) -> (listof Photo)
;; produce a list of only photos that are favourites and belong to the given album
(check-expect (to-frame "" empty) empty)
(check-expect (to-frame "Birthday" (list PHT1 PHT2 PHT3 (make-photo "photos" "Birthday" false))) (list PHT2))
(check-expect (to-frame "Hahahaha" (list PHT1 PHT2 PHT3)) empty)
(check-expect (to-frame "Victoria" (list PHT1 PHT2 PHT3)) (list PHT1))
(check-expect (to-frame "Seattle" (list PHT1 PHT3)) (list PHT3))

;(define (to-frame album lop) empty) ;stub

(define (to-frame album lop)
  (local [(define (criteria? p)
            (and (string=? (photo-album p) album)
                 (not (false? (photo-favourite p)))
                 ))]
    (filter criteria? lop)))

