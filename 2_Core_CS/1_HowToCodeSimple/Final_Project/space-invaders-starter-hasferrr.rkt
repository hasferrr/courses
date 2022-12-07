;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders-starter-plaintext) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders

;; ==================================================
;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)

(define INVADE-RATE 100)

(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT/2 (/ (image-height TANK) 2))

(define MISSILE (ellipse 5 15 "solid" "red"))



;; ==================================================
;; Data Definitions:


(define-struct game (invaders missiles tank))
;; Game is (make-game (listof Invader)
;;                    (listof Missile)
;;                    Tank)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position
;;
;; Game constants defined below Missile data definition
#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom       (game-missiles s))
       (fn-for-tank      (game-tank s))))



(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1
;;         dir = direction
(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left
#;
(define (fn-for-tank t)
  (... (tank-x t)
       (tank-dir t)))



(define-struct invader (x y dx))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         dx is invader's direction: positive = right; negative = left
;;         (ORIGINAL FILE: the invader along x by dx pixels per clock tick)
(define I1 (make-invader 150 100 12))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -10))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) 10)) ;> landed, moving right
#;
(define (fn-for-invader invader)
  (... (invader-x invader)
       (invader-y invader)
       (invader-dx invader)))



(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is (x, y) in screen coordinates
(define M1 (make-missile 150 300))                       ;not hit U1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit U1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit U1
#;
(define (fn-for-missile m)
  (... (missile-x m)
       (missile-y m)))



(define G0 (make-game empty empty T0))
(define G1 (make-game empty empty T1))
(define G2 (make-game (list I1)    (list M1)    T1))
(define G3 (make-game (list I1 I2) (list M1 M2) T1))



;; ==================================================
;; Functions:

;; Game -> Game
;; start the world with (main G0)
;;
(define (main s)
  (big-bang s                    ; Game
    (on-tick    next-state)      ; Game -> Game
    (to-draw    render-state)    ; Game -> Image
    (on-key     handle-key)      ; Game KeyEvent -> Game
    (stop-when  game-over?)))    ; Game -> Boolean



;; --------------------------------------------------

;; Game -> Game
;; produce game's next state => invader(moving,bounce); missile(moving); tank(moving)

;I comment out check-expect because in (next-loinvader) function contais randomness
;This check-expect has 2% chance to fail
#;
(check-expect (next-state (make-game empty empty T0))
              (make-game empty empty (make-tank (+ (/ WIDTH 2) TANK-SPEED) 1)))
#;
(check-expect (next-state (make-game (list I1) (list M1) T1))
              (make-game (list (make-invader (+ 150 INVADER-X-SPEED) (+ 100 INVADER-Y-SPEED) 12))
                         (list (make-missile 150 (- 300 MISSILE-SPEED)))
                         (make-tank (+ 50 TANK-SPEED) 1)))

;(define (next-state s) s) ;stub

;Use Template from Game

(define (next-state s)
  (make-game (next-loinvader (game-invaders s) (game-missiles s))
             (next-lomissile (game-missiles s) (game-invaders s))
             (next-tank      (game-tank s))))

;; --------------------------------------------------
;; --------------------------------------------------

;; listofInvaders listofMissiles -> listofInvaders
;; produce the next listofInvaders

; no check-expect because its contais randomness
; check-expect in the combined check-expect 2 function below: missile-hit and invaders-next-move

;(define (next-loinvader loi) loi) ;stub

;Use function composition

(define (next-loinvader loi lom)
  (random-spawn (missile-hit (invaders-next-move loi) lom)))

;; --------------------------------------------------
;; --------------------------------------------------
;; --------------------------------------------------

;; listofInvader -> listofInvader
;; spawn new Invader in the list located in y=0, x=random, random direction, and have 56% chance to spawn per second
;;   spamegg: "There are 28 ticks per second, INVADE-RATE is 100"
;;   "So, let's say, at each tick, with a really low prob, say 1%, I want to spawn a new invader."
;;   "This way, every second, a new invader will spawn with probability 28% !!!"
;;   Therefore, 56% chance to spawn / second --> probability 2/100

;(define (random-spawn loi) loi) ;stub

(define (random-spawn loi)
  (if (<= (random INVADE-RATE) 2)
      (cons (make-invader (random WIDTH)
                          0
                          (if (zero? (random 2)) 1 -1))
            loi)
      loi))

;; --------------------------------------------------
;; --------------------------------------------------
;; --------------------------------------------------

;; listofInvaders listofMissiles -> listofInvaders
;; remove Invader in the list if hit by missile in range
;;    range: (if (inv-y <= msl-y - 5 AND inv-y >= msl-y + 5) AND (inv-x >= msl-x - 5 AND inv-x <= msl-x + 5))
(check-expect (missile-hit empty empty) empty)
(check-expect (missile-hit empty (list M1 M2)) empty)        ;has no listofInvader
(check-expect (missile-hit (list I1 I2) empty) (list I1 I2)) ;has no listofMissiles

(check-expect (missile-hit (list (make-invader 1 100 1) I2) (list M1 M2))
              (list (make-invader 1 100 1) I2))              ;missile doesnt hit

(check-expect (missile-hit (list I1 I2) (list M1 M2))
              (list I2))                                     ;M2 hit I1

(check-expect (missile-hit (list I1 I2) (list M1 M3))
              (list I2))                                     ;M3 > hit I1

;(define (missile-hit loi lom) loi) ;stub

;Use enumeration

(define (missile-hit loi lom)
  (cond [(empty? loi) empty]
        [(empty? lom) loi]
        [else
         (if (is-hit? (first loi) lom)
             (missile-hit (rest loi) lom)
             (cons (first loi) (missile-hit (rest loi) lom))
             )]
        ))

;; Invader listofMissile -> Boolean
;; produce true if given Invader hit by a missile in listofMissile
(check-expect (is-hit? I1 (list M1)) false)
(check-expect (is-hit? I1 (list M2 M1)) true)
(check-expect (is-hit? I1 (list M1 M3)) true)

;(define (is-hit? inv lom) false) ;stub
;(if (inv-y <= msl-y - 5 AND inv-y >= msl-y + 5) AND (inv-x >= msl-x - 5 AND inv-x <= msl-x + 5))

(define (is-hit? inv lom)
  (cond [(empty? lom) false]
        [else
         (if  (and (>= (invader-y inv)
                       (- (missile-y (first lom)) HIT-RANGE))
                   (<= (invader-y inv)
                       (+ (missile-y (first lom)) HIT-RANGE))
                   (>= (invader-x inv)
                       (- (missile-x (first lom)) HIT-RANGE))
                   (<= (invader-x inv)
                       (+ (missile-x (first lom)) HIT-RANGE)))
              true
              (is-hit? inv (rest lom))
              )]
        ))

;; --------------------------------------------------
;; --------------------------------------------------
;; --------------------------------------------------

;; listofInvaders -> listofInvaders
;; produce next move (next-tick) of listofInvaders
(check-expect (invaders-next-move empty) empty)
(check-expect (invaders-next-move (list I1))
              (list (make-invader (+ 150 INVADER-X-SPEED)
                                  (+ 100 INVADER-Y-SPEED)
                                  12)))
(check-expect (invaders-next-move (list I1 (make-invader WIDTH 300 1)))
              (list (make-invader (+ 150 INVADER-X-SPEED)
                                  (+ 100 INVADER-Y-SPEED)
                                  12)
                    (make-invader (- WIDTH INVADER-X-SPEED)
                                  (+ 300   INVADER-Y-SPEED)
                                  -1)
                    ))

;(define (invaders-next-move loi) loi) ;stub

;Use enumerations of listof Invaders, and self-referential applied to Invaders

(define (invaders-next-move loi)
  (cond [(empty? loi) empty]
        [else
         (cons (next-invader (first loi))
               (invaders-next-move (rest loi))
               )]
        ))

;; --------------------------------------------------
;; --------------------------------------------------
;; --------------------------------------------------
;; --------------------------------------------------

;; Invader -> Invader
;; produce next-Invader: move invader down diagonnally, and bounce if invader-dx (< 0) or (> WIDTH)
(check-expect (next-invader (make-invader 150 100 12))
              (make-invader (+ 150 INVADER-X-SPEED)
                            (+ 100 INVADER-Y-SPEED)
                            12))
(check-expect (next-invader (make-invader 200 250 -1))
              (make-invader (- 200 INVADER-X-SPEED)
                            (+ 250 INVADER-Y-SPEED)
                            -1))
(check-expect (next-invader (make-invader WIDTH 300 1)) ;bounce right -> left
              (make-invader (- WIDTH INVADER-X-SPEED)
                            (+ 300   INVADER-Y-SPEED)
                            -1)) ;change direction 1 -> -1
(check-expect (next-invader (make-invader 0 350 -1))    ;bounce left -> right
              (make-invader (+ 0   INVADER-X-SPEED)
                            (+ 350 INVADER-Y-SPEED)
                            1)) ;change direction -1 -> 1

;(define (next-invader invader) invader)

;Use template from Invader

(define (next-invader inv)
  (make-invader (new-x-invader (invader-x inv) (invader-dx inv))
                (+ (invader-y inv) INVADER-Y-SPEED)
                (new-dx-invader (invader-x inv) (invader-dx inv))
                ))

;; Number Number -> Number
;; bounce if invader-x exceeded WIDTH or 0
(define (new-x-invader x dx)
  (if (positive? dx)
      (if (> (+ x INVADER-X-SPEED) WIDTH)
          (- x INVADER-X-SPEED)
          (+ x INVADER-X-SPEED))
      (if (< (- x INVADER-X-SPEED) 0)
          (+ x INVADER-X-SPEED)
          (- x INVADER-X-SPEED))))

;; Number Number -> Number
;; change direction if invader-x exceeded WIDTH or 0
(define (new-dx-invader x dx)
  (if (positive? dx)
      (if (> (+ x INVADER-X-SPEED) WIDTH)
          (* -1 dx)
          dx)
      (if (< (- x INVADER-X-SPEED) 0)
          (* -1 dx)
          dx)))

;; --------------------------------------------------
;; --------------------------------------------------

;; listofMissile listofInvader -> listofMissile
;; produce next-lomissile

;;(check expect in nested function bcs iam lazy)

;(define (next-lomissile lom loi) lom loi) ;stub

;Use function compotition

(define (next-lomissile lom loi)
  (onscreen-only (next-lomissile-all (after-kill-invaders lom loi))))

;; --------------------------------------------------
;; --------------------------------------------------
;; --------------------------------------------------
;; listofMissile -> listofMissile
;; remove missile in the next listofMissile that out of screen (when missile-y <= 0)

(check-expect (onscreen-only empty) empty)

(check-expect (onscreen-only (list (make-missile 150 300)))
              (list (make-missile 150 300)))

(check-expect (onscreen-only (list (make-missile 150 0)))
              empty)

(check-expect (onscreen-only (list (make-missile 150 -1)
                                   (make-missile 20 200)))
              (list (make-missile 20 200)))

(check-expect (onscreen-only (list (make-missile 150 350)
                                   (make-missile 20 -2)))
              (list (make-missile 150 350)))

;(define (onscreen-only lom) lom) ;stub

;Use enumeration template

(define (onscreen-only loi)
  (cond [(empty? loi) empty]
        [else
         (if (onscreen? (first loi))
             (cons (first loi) (onscreen-only (rest loi)))
             (onscreen-only (rest loi))
             )]
        ))

;; --------------------------------------------------
;; --------------------------------------------------
;; --------------------------------------------------
;; --------------------------------------------------
;; Missile -> Boolean
;; produce true if missile-y > 0 (onscreen)
(check-expect (onscreen? (make-missile 150 300)) true)
(check-expect (onscreen? (make-missile 160 0)) false)
(check-expect (onscreen? (make-missile 170 -1)) false)

;(define (onscreen? m) true) ;stub

(define (onscreen? m)
  (> (missile-y m) 0))

;; --------------------------------------------------
;; --------------------------------------------------
;; --------------------------------------------------

;; listofMissile -> listofMissile
;; produce next list of missile that go up (higher y to lower y)
(check-expect (next-lomissile-all empty) empty)

(check-expect (next-lomissile-all (list M1))
              (list (make-missile 150 (- 300 MISSILE-SPEED))))

(check-expect (next-lomissile-all (list M1
                                        (make-missile 20 200)))
              (list (make-missile 150 (- 300 MISSILE-SPEED))
                    (make-missile 20 (- 200 MISSILE-SPEED))))

;(define (next-lomissile-all m) m)

;Use enumerations

(define (next-lomissile-all loi)
  (cond [(empty? loi) empty]
        [else
         (cons (next-missile (first loi))
               (next-lomissile-all (rest loi))
               )]
        ))

;; --------------------------------------------------
;; --------------------------------------------------
;; --------------------------------------------------
;; --------------------------------------------------

;; Missile -> Missile
;; produce next-tick of missile
(check-expect (next-missile (make-missile 150 300))
              (make-missile 150 (- 300 MISSILE-SPEED)))

;(define (next-missile m) m) ;stub

(define (next-missile m)
  (make-missile (missile-x m)
                (- (missile-y m) MISSILE-SPEED)))



;; --------------------------------------------------
;; --------------------------------------------------
;; --------------------------------------------------

;; listofMissile listofInvader -> listofMissile
;; remove missile that kills invader
(check-expect (after-kill-invaders empty empty) empty)
(check-expect (after-kill-invaders empty (list I1 I2)) empty)               ;has no listofMissiles
(check-expect (after-kill-invaders (list M1 M2) empty) (list M1 M2))        ;has no listofInvader

(check-expect (after-kill-invaders (list M1 M2)
                                   (list (make-invader 1 100 1) I2))
              (list M1 M2))              ;missile doesnt hit

(check-expect (after-kill-invaders (list M1 M2) (list I1 I2))
              (list M1))                                     ;M2 hit I1

(check-expect (after-kill-invaders (list M1 M3) (list I1 I2))
              (list M1))                                     ;M3 > hit I1

;(define (after-kill-invaders lom loi) lom) ;stub

(define (after-kill-invaders lom loi)
  (cond [(empty? lom) empty]
        [(empty? loi) lom]
        [else
         (if (is-kill? (first lom) loi)
             (after-kill-invaders (rest lom) loi)
             (cons (first lom) (after-kill-invaders (rest lom) loi))
             )]
        ))


;; Missile listofInvader -> Boolean
;; produce true if given Missile hits invader in the list
(check-expect (is-kill? M1 (list I2)) false)
(check-expect (is-kill? M2 (list I1 I2)) true)
(check-expect (is-kill? M3 (list I3 I1)) true)

;(define (is-kill? inv loi) false) ;stub

(define (is-kill? m loi)
  (cond [(empty? loi) false]
        [else
         (if  (and (>= (invader-y (first loi))
                       (- (missile-y m) HIT-RANGE))
                   (<= (invader-y (first loi))
                       (+ (missile-y m) HIT-RANGE))
                   (>= (invader-x (first loi))
                       (- (missile-x m) HIT-RANGE))
                   (<= (invader-x (first loi))
                       (+ (missile-x m) HIT-RANGE)))
              true
              (is-kill? m (rest loi))
              )]
        ))


;; --------------------------------------------------
;; --------------------------------------------------

;; Tank -> Tank
;; if dir=1 move tank to right, if dir=-1 move tank to left by TANK-SPEED not crossing edges

(check-expect (next-tank (make-tank (/ WIDTH 2) 1))
              (make-tank (+ (/ WIDTH 2) TANK-SPEED) 1))      ;right

(check-expect (next-tank (make-tank (/ WIDTH 2) -1))
              (make-tank (- (/ WIDTH 2) TANK-SPEED) -1))     ;left

(check-expect (next-tank (make-tank (- WIDTH TANK-SPEED) 1)) ;on the edge
              (make-tank WIDTH 1))

(check-expect (next-tank (make-tank (+ 0 TANK-SPEED) -1))
              (make-tank 0 -1))

(check-expect (next-tank (make-tank (+ WIDTH 1) 1))          ;exceed the edge
              (make-tank WIDTH 1))

(check-expect (next-tank (make-tank (- 0 1) -1))
              (make-tank 0 -1))

;(define (next-tank t) t) ;stub

(define (next-tank t)
  (cond [(> (tank-x t) WIDTH)
         (make-tank WIDTH (tank-dir t))]
        [(< (tank-x t) 0)
         (make-tank 0 (tank-dir t))]
        [(= 1 (tank-dir t))
         (make-tank (+ (tank-x t) TANK-SPEED) (tank-dir t))]
        [(= -1 (tank-dir t))
         (make-tank (- (tank-x t) TANK-SPEED) (tank-dir t))]
        [else
         (make-tank (tank-x t) (tank-dir t))]
        ))


;; --------------------------------------------------

;; Game -> Image
;; render next-state image

(check-expect (render-state G0)
              (place-image TANK (/ WIDTH 2) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))

(check-expect (render-state G2)
              (place-image INVADER 150 100
                           (place-image MISSILE 150 300
                                        (place-image TANK 50 (- HEIGHT TANK-HEIGHT/2) BACKGROUND))))

(check-expect (render-state (make-game (list (make-invader 150 100 12) (make-invader WIDTH 300 1))
                                       (list (make-missile 150 300) (make-missile 20 200))
                                       (make-tank (/ WIDTH 2) 1)
                                       ))
              (place-image INVADER 150 100
                           (place-image INVADER WIDTH 300
                                        (place-image MISSILE 150 300
                                                     (place-image MISSILE 20 200
                                                                  (place-image TANK (/ WIDTH 2) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))))))

;(define (render-state s) BACKGROUND) ;stub

;Use template from Game

(define (render-state s)
  (place-game (game-invaders s)
              (game-missiles s)
              (game-tank s)))

;; --------------------------------------------------
;; --------------------------------------------------

;; listofInvader listofMissile Tank -> Image
;; place all image to BACKGROUND
(check-expect (place-game (list (make-invader 150 100 12))
                          (list (make-missile 150 300))
                          (make-tank (/ WIDTH 2) 1))
              (place-image INVADER 150 100
                           (place-image MISSILE 150 300
                                        (place-image TANK (/ WIDTH 2) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))))

;(define (place-game loi lom t) BACKGROUND)

;Use template from enumeration

(define (place-game loi lom t)
  (render-loinvader loi (render-lom lom (render-tank t))))
  

;; --------------------------------------------------
;; --------------------------------------------------
;; --------------------------------------------------

;; listofInvader Image -> Image
;; place listofInvader image on top render-lom produced image
(check-expect (render-loinvader empty (render-lom empty (render-tank T0)))
              (place-image empty-image (/ WIDTH 2) (/ HEIGHT 2)
                           (render-lom empty (render-tank T0))))
                           
(check-expect (render-loinvader (list (make-invader 150 100 12) (make-invader 100 200 -1))
                                (render-lom (list M1)
                                            (render-tank T0)))
              (place-image INVADER 150 100
                           (place-image INVADER 100 200
                                        (place-image empty-image (/ WIDTH 2) (/ HEIGHT 2)
                                                     (render-lom (list M1)
                                                                 (render-tank T0))))))

;(define (render-loinvader loi img) empty-image) ;stub

;Use enumeration template, with Invader inside it

(define (render-loinvader loi img)
  (cond [(empty? loi) (place-image empty-image (/ WIDTH 2) (/ HEIGHT 2) img)]
        [else
         (place-image INVADER
                      (invader-x (first loi))
                      (invader-y (first loi))
                      (render-loinvader (rest loi) img)
                      )]
        ))


;; listofMissile Image -> Image
;; place listofInvader image on top render-tank produced image
(check-expect (render-lom empty
                          (render-tank T0))
              (place-image empty-image (/ WIDTH 2) (/ HEIGHT 2)
                           (render-tank T0)))

(check-expect (render-lom (list (make-missile 150 300) (make-missile 100 250))
                          (render-tank T0))
              (place-image MISSILE 150 300
                           (place-image MISSILE 100 250
                                        (place-image empty-image (/ WIDTH 2) (/ HEIGHT 2)
                                                     (render-tank T0)))))

;(define (render-lom lom img) BACKGROUND) ;stub

;Use enumeration template, with Missile inside it

(define (render-lom lom img)
  (cond [(empty? lom) (place-image empty-image (/ WIDTH 2) (/ HEIGHT 2) img)]
        [else
         (place-image MISSILE
                      (missile-x (first lom))
                      (missile-y (first lom))
                      (render-lom (rest lom) img)
                      )]
        ))


;; Tank -> Image
;; place tank image in BACKGROUND
(check-expect (render-tank (make-tank (/ WIDTH 2) 1))
              (place-image TANK (/ WIDTH 2) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))
(check-expect (render-tank T1)
              (place-image TANK (tank-x T1) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))

;(define (render-tank t) BACKGROUND) ;stub

(define (render-tank t)
  (place-image TANK (tank-x t) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))



;; --------------------------------------------------

;; Game KeyEvent -> Game
;; left arrow or right arrow will change tank direction (by multiply dx with) -1 ; and space to shoot (append new missile)
;; !!!
(check-expect (handle-key (make-game (list I1) (list M1 M2) (make-tank 50 1))
                          "left")
              (make-game (list I1) (list M1 M2) (make-tank 50 -1)))
(check-expect (handle-key (make-game (list I1) (list M1 M2) (make-tank 50 -1))
                          "left")
              (make-game (list I1) (list M1 M2) (make-tank 50 -1)))

(check-expect (handle-key (make-game (list I1) (list M1 M2) (make-tank 50 1))
                          "right")
              (make-game (list I1) (list M1 M2) (make-tank 50 1)))
(check-expect (handle-key (make-game (list I1) (list M1 M2) (make-tank 50 -1))
                          "right")
              (make-game (list I1) (list M1 M2) (make-tank 50 1)))

(check-expect (handle-key (make-game (list I1) (list M1 M2) (make-tank 33 1))
                          " ")
              (make-game (list I1)
                         (cons (make-missile 33 (- HEIGHT TANK-HEIGHT/2)) (list M1 M2))
                         (make-tank 33 1)))

;(define (handle-key s ke) s) ;stub

;Use template from HandleKey

(define (handle-key s ke)
  (cond [(key=? ke "left") (leftbutton s)]
        [(key=? ke "right") (rightbutton s)]
        [(key=? ke " ") (spacebutton s)]
        [else s]))

;; --------------------------------------------------
;; --------------------------------------------------

;; Game -> Game
;; produce new Game that change tank-dir to negative
(check-expect (leftbutton (make-game (list I1) (list M1 M2) (make-tank 50 1)))
              (make-game (list I1) (list M1 M2) (make-tank 50 -1)))
(check-expect (leftbutton (make-game (list I1) (list M1 M2) (make-tank 50 -1)))
              (make-game (list I1) (list M1 M2) (make-tank 50 -1)))

;(define (leftbutton s) s) ;stub

(define (leftbutton s)
  (if (positive? (tank-dir (game-tank s)))
      (make-game (game-invaders s)
                 (game-missiles s)
                 (make-tank (tank-x (game-tank s))
                            -1))
      s))


;; Game -> Game
;; produce new Game that change tank-dir to positive
(check-expect (rightbutton (make-game (list I1) (list M1 M2) (make-tank 60 1)))
              (make-game (list I1) (list M1 M2) (make-tank 60 1)))
(check-expect (rightbutton (make-game (list I1) (list M1 M2) (make-tank 60 -1)))
              (make-game (list I1) (list M1 M2) (make-tank 60 1)))

;(define (rightbutton s) s) ;stub

(define (rightbutton s)
  (if (negative? (tank-dir (game-tank s)))
      (make-game (game-invaders s)
                 (game-missiles s)
                 (make-tank (tank-x (game-tank s))
                            1))
      s))


;; Game -> Game
;; produce new Game that append new missile
(check-expect (spacebutton (make-game (list I1) (list M1 M2) (make-tank 33 1)))
              (make-game (list I1)
                         (cons (make-missile 33 (- HEIGHT TANK-HEIGHT/2)) (list M1 M2))
                         (make-tank 33 1)))

;(define (spacebutton s) s) ;stub

(define (spacebutton s)
  (make-game (game-invaders s)
             (cons (make-missile (tank-x (game-tank s)) (- HEIGHT TANK-HEIGHT/2))
                   (game-missiles s))
             (game-tank s)))



;; --------------------------------------------------

;; Game -> Boolean
;; return true or stop the game when an invader reaches the bottom (when invader-y => HEIGHT)
(check-expect (game-over? G1) false)
(check-expect (game-over? G2) false)
(check-expect (game-over? (make-game (list I1 I3 I2) (list M1 M2) T1)) true)

;(define (game-over? s) false) ;stub

;Use template from Game

(define (game-over? s)
  (reaches-the-bottom? (game-invaders s)))

;; --------------------------------------------------
;; --------------------------------------------------
;; listofInvader -> Boolean
;; produce true if at least one invader have invader-y => HEIGHT
(check-expect (reaches-the-bottom? empty) false)
(define I11 (make-invader 200 (- HEIGHT 1) 1))
(check-expect (reaches-the-bottom? (list I1 I11)) false)
(check-expect (reaches-the-bottom? (list I1 I2)) true)
(check-expect (reaches-the-bottom? (list I2 I1 I3)) true)

;(define (reaches-the-bottom? loi) false)

;Use enumeration template

(define (reaches-the-bottom? loi)
  (cond [(empty? loi) false]
        [else (if (invader-win? (first loi))
                  true
                  (reaches-the-bottom? (rest loi))
                  )]
        ))

;; --------------------------------------------------
;; --------------------------------------------------
;; --------------------------------------------------
;; Invader -> Boolean
;; produce true if an Invader reaches the bottom (invader-y => HEIGHT)
(check-expect (invader-win? I1) false)
(check-expect (invader-win? I2) true)
(check-expect (invader-win? I3) true)

;(define (invader-win? inv) false) ;stub

(define (invader-win? inv)
  (>= (invader-y inv) HEIGHT))
