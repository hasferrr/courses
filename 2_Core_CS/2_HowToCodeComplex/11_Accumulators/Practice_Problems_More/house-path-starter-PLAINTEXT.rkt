;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname house-path-starter-PLAINTEXT) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; house-path-starter.rkt

; Consider the following house diagram:
; 
; .
; 
; Starting from the porch, there are many paths through the house that you can
; follow without retracing your steps.  If we represent these paths as lists:
; (list 
;  (list "Porch")
;  (list "Porch" "Living Room")
;  (list "Porch" "Living Room" "Hall")
;  ...)
; 
; you can see that a lot of these paths start with the same sequence of rooms.
; We can represent these paths, and capture their shared initial parts, by using
; a tree:
; .
; 
; The following data definition does exactly this.


(define-struct path (room nexts))
;; Path is (make-path String (listof Path))
;; interp. An arbitrary-arity tree of paths.
;;  - (make-path room nexts) represents all the paths downward from room
(define P0 (make-path "A" empty)) ; a room from which there are no paths

(define PH 
  (make-path "Porch"
             (list 
              (make-path "Living Room"
                         (list (make-path "Dining Room"
                                          (list (make-path "Kitchen"
                                                          (list (make-path "Hall"
                                                                           (list (make-path "Study" (list))
                                                                                 (make-path "Bedroom" (list))
                                                                                 (make-path "Bathroom" (list))))))))
                               (make-path "Hall"
                                          (list (make-path "Kitchen"
                                                           (list (make-path "Dining Room" (list))))
                                                (make-path "Study" (list))
                                                (make-path "Bedroom" (list))
                                                (make-path "Bathroom" (list)))))))))
   
#;
(define (fn-for-path p)
  (local [(define (fn-for-path p)
            (... (path-room p)
                 (fn-for-lop (path-nexts p))))
          (define (fn-for-lop lop)
            (cond [(empty? lop) (...)]
                  [else
                   (... (fn-for-path (first lop))
                        (fn-for-lop (rest lop)))]))]
    (fn-for-path p)))



; The problems below also make use of the following data definition and function:


;; Result is one of:
;; - Boolean
;; - "never"
;; interp. three possible answers to a question
(define R0 true)
(define R1 false)
(define R2 "never")

#;
(define (fn-for-result r)
  (cond 
    [(boolean? r) (... r)]
    [else (...)]))

;; Result Result -> Result
;; produce the logical combination of two results

; Cross Product of Types Table:
; 
;  ╔════════════════╦═══════════════╦══════════════╗
;  ║                ║               ║              ║
;  ║            r0  ║   Boolean     ║   "never"    ║
;  ║                ║               ║              ║
;  ║    r1          ║               ║              ║
;  ╠════════════════╬═══════════════╬══════════════╣
;  ║                ║               ║              ║
;  ║   Boolean      ║ (and r0 r1)   ║              ║
;  ║                ║               ║              ║
;  ╠════════════════╬═══════════════╣  r1          ║
;  ║                ║               ║              ║
;  ║   "never"      ║  r0           ║              ║
;  ║                ║               ║              ║
;  ╚════════════════╩═══════════════╩══════════════╝


(check-expect (and-result false false)     false)
(check-expect (and-result false true)      false)
(check-expect (and-result false "never")   false)
(check-expect (and-result true false)      false)
(check-expect (and-result true true)       true)
(check-expect (and-result true "never")    true)
(check-expect (and-result "never" true)    true)
(check-expect (and-result "never" false)   false)
(check-expect (and-result "never" "never") "never")

(define (and-result r0 r1)
  (cond [(and (boolean? r0) (boolean? r1)) (and r0 r1)]
        [(string? r0) r1]
        [else r0]))


; PROBLEM 1:   
; 
; Design a function called always-before that takes a path tree p and two room
; names b and c, and determines whether starting from p:
; 
; 1) you must pass through room b to get to room c (produce true),
; 2) you can get to room c without passing through room b (produce false), or
; 3) you just can't get to room c (produce "never").
; 
; Note that if b and c are the same room, you should produce false since you don't
; need to pass through the room to get there.
; 


; Rancang sebuah fungsi bernama always-before yang mengambil pohon jalur p dan dua
; nama ruangan b dan c, dan tentukan apakah dimulai dari p:
; 
; 1) Anda harus melewati ruangan b untuk sampai ke ruangan c (menghasilkan benar),
; 2) Anda bisa masuk ke kamar c tanpa melewati kamar b (menghasilkan salah), atau
; 3) Anda tidak bisa sampai ke kamar c (menghasilkan "tidak pernah").
; 
; Perhatikan bahwa jika b dan c adalah ruangan yang sama, Anda harus menghasilkan false
; karena Anda tidak perlu melewati ruangan untuk sampai ke sana.


;; Path String String -> Result
;; produce:
;; - True    if can get to c pass through room b
;; - False   if can get to c without pass through to room b
;; - "never" if cannot get to room c
(check-expect (always-before PH "Living Room" "Dining Room") true)
(check-expect (always-before PH "Porch" "Kitchen") true)
(check-expect (always-before PH "Hall" "Hall") false)
(check-expect (always-before PH "Hall" "Study") true)
(check-expect (always-before PH "Hall" "Dining Room") false)
(check-expect (always-before PH "Study" "Hall") false)
(check-expect (always-before PH "Dining Room" "Bathroom") false)
(check-expect (always-before PH "Kitchen" "Porch") false)
(check-expect (always-before PH "Study" "Parking Area") "never")

;(define (always-before p b c) false)

;template from Path, added accumulator

(define (always-before p b c)
  ;; passthrough is Boolean; its true if pass through room b, otherwise false
  ;; (always-before PH "Hall" "Dining Room")
  ;; (fn-for-path PH                            false)
  ;; (fn-for-path (make-path "Living Room" ...) false)
  ;; (fn-for-path (make-path "Dining Room" ...) false) ;false
  ;; (fn-for-path (make-path "Living Room" ...) false)
  ;; (fn-for-path (make-path "Hall" ...) true)
  ;; (fn-for-path (make-path "Kitchen" ...) true)
  ;; (fn-for-path (make-path "Dining Room" ...) true)  ;true
  ;; (fn-for-path (make-path "Living Room" ...) false)
  ;; (fn-for-path (make-path "Hall" ...) false)
  ;; (fn-for-path (make-path "Study" ...) false)       ;"never"
  ;; ...
  (local [(define (fn-for-path p passthrough)
            (cond [(string=? (path-room p) c) passthrough]
                  [(string=? (path-room p) b)
                   (fn-for-lop (path-nexts p) true)]
                  [else
                   (fn-for-lop (path-nexts p) passthrough)]))
          
          (define (fn-for-lop lop passthrough)
            (cond [(empty? lop) "never"]
                  [else
                   (and-result (fn-for-path (first lop)
                                            passthrough)
                               (fn-for-lop (rest lop)
                                           passthrough
                                           ))]))]

    (fn-for-path p false)))


; OPTIONAL EXTRA PRACTICE PROBLEM:
; 
; Once you have always-before working, make a copy of it, rename the copy to
; always-before-tr, and then modify the function to be tail recursive.
; 


;; Path String String -> Result
;; produce:
;; - True    if can get to c pass through room b
;; - False   if can get to c without pass through to room b
;; - "never" if cannot get to room c

(check-expect (always-before-tr PH "Living Room" "Dining Room") true)
(check-expect (always-before-tr PH "Porch" "Kitchen") true)
(check-expect (always-before-tr PH "Hall" "Hall") false)
(check-expect (always-before-tr PH "Hall" "Study") true)
(check-expect (always-before-tr PH "Hall" "Dining Room") false)
(check-expect (always-before-tr PH "Study" "Hall") false)
(check-expect (always-before-tr PH "Dining Room" "Bathroom") false)
(check-expect (always-before-tr PH "Kitchen" "Porch") false)
(check-expect (always-before-tr PH "Study" "Parking Area") "never")

(define (always-before-tr p b c)
  ;; pst  is Boolean; its True if pass through room b, otherwise False
  ;; rsf  is Result; result so far
  ;; todo is (listof wle); the Paths need to visit to fn-for-path

  (local [(define-struct wle (path pst))
          ;; WLE is (make-wle Path Boolean)
          ;; interp. worklist entry (wle) for worklist accumulator
          ;; - path is Path
          ;; - pst  is True if current branch has passthrough b, otherwise False
          
          (define (fn-for-path p pst rsf todo)
            (cond [(string=? (path-room p) c)
                   (fn-for-lop todo
                               (and-result pst rsf))]
                  [(string=? (path-room p) b)
                   (fn-for-lop (append (map (λ (one-p) (make-wle one-p true))
                                            (path-nexts p))
                                       todo)
                               rsf)]
                  [else
                   (fn-for-lop (append (map (λ (one-p) (make-wle one-p pst))
                                            (path-nexts p))
                                       todo)
                               rsf)]))
          
          (define (fn-for-lop todo rsf)
            (cond [(empty? todo) rsf]
                  [else
                   (fn-for-path (wle-path (first todo))
                                (wle-pst (first todo))
                                rsf
                                (rest todo))]))]

    (fn-for-path p false "never" empty)))

