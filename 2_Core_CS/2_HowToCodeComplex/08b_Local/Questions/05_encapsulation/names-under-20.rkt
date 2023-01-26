;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname sort-lon) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;Recall the following functions from the Mutual Reference module:

;; Person -> ListOfString
;; produce a list of the names of the persons under 20

(check-expect (names-under-20 P1) (list "N1"))
(check-expect (names-under-20 P2) (list "N1"))
(check-expect (names-under-20 P4) (list "N3" "N1"))

(define (names-under-20 p)
  (local [(define (names-under-20--person p)
            (if (< (person-age p) 20)
                (cons (person-name p)
                      (names-under-20--lop (person-children p)))
                (names-under-20--lop (person-children p))))

          (define (names-under-20--lop lop)
            (cond [(empty? lop) empty]
                  [else
                   (append (names-under-20--person (first lop))
                           (names-under-20--lop (rest lop)))]))]

    (names-under-20--person p)))

;The function that other parts of the program are interested in is names-under-20--person. Let's call the new function names-under-20.

;Before moving onto the next questions, encapsulate the functions names-under-20--person and names-under-20--lop using local.