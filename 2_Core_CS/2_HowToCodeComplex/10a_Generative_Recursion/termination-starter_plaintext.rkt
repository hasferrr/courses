;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |termination-starter - plaintext|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; termination-starter.rkt

; 
; .  ; The Collatz conjecture is a conjecture in mathematics named
; ; after Lothar Collatz, who first proposed it in 1937. ...
; ; The sequence of numbers involved is referred to as the hailstone 
; ; sequence or hailstone numbers (because the values are usually 
; ; subject to multiple descents and ascents like hailstones in a 
; ; cloud). 
; ; 
; ; f(n) = /   n/2     if n is even
; ;        \   3n + 1  if n is odd 
; ;       
; ; 
; ; The Collatz conjecture is: This process will eventually reach
; ; the number 1, regardless of which positive integer is chosen
; ; initially.       
; ;        
; ;        
; ;        
; ;        
; ;        
; 
; [Image and part of text from: https://en.wikipedia.org/wiki/Collatz_conjecture]



;; Integer[>=1] -> (listof Integer[>=1])
;; produce hailstone sequence for n
(check-expect (hailstones 1) (list 1))
(check-expect (hailstones 2) (list 2 1))
(check-expect (hailstones 4) (list 4 2 1))
(check-expect (hailstones 5) (list 5 16 8 4 2 1))

#|
PROBLEM:
Construct a three part termination argument for hailstones:


Base case:
  (= n 1)



Reduction step (next problem):
  if n is even, then (/ n 2)
  if n is odd , then (+ (* n 3) 1)



Argument that repeated application of reduction step will eventually 
reach the base case:

(Indonesian version)
- jika n adalah genap, n akan terus dibagi dengan 2 dan menghasilkan bilangan bulat

- n yang dibagi 2 bisa menghasilkan bilangan ganjil atau genap
     
     example: 8/2 = 4  ---> genap
              10/2 = 5 ---> ganjil


- jika n adalah ganjil, n akan diubah menjadi bilangan genap dengan mengoperasikan
  nilai n dengan (+ (* n 3) 1)
     
     example: 3*3+1 = 10
              5*3+1 = 16
              111*3+1 = 334


- n yang merupakan bilangan genap (katakanlah angka n genap awal),
  hasil dari angka ganjil yang dioperasikan dengan (+ (* n 3) 1),
  setelah dibagi dengan 2 (ya karena angka itu genap),
  akan menghasilkan nilai n yang lebih kecil dari angka n genap awal
  
     example:
       n = 10        <--- it's even, then divide by 2
       10/2 = 5

       n = 5         <--- it's odd, operate it with (n*3 + 1)
       5*3 + 1 = 16

       n = 16        <--- it's even, /2
       16/2 = 8

       n = 8
       ...

     - notice that 8 is less than 10
     - dan terus menerus akan menghasilkan angka n genap yang lebih kecil dari
       angka n sebelumnya


- karena nilai n akan terus menerus menurun, pada akhirnya n akan sama dengan satu

     n = 8     <--- it's even
     8/2 = 4

     n = 4     <--- it's even
     4/2 = 2

     n = 2     <--- it's even
     2/2 = 1

     n = 1
     boom

|#
(define (hailstones n)
  (if (= n 1) 
      (list 1)
      (cons n 
            (if (even? n)
                (hailstones (/ n 2))
                (hailstones (add1 (* n 3)))))))
