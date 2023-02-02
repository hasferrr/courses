use "extra.sml";

val test1a = alternate [] = 0
val test1b = alternate [1] = 1
val test1c = alternate [3, 4] = 3 - 4
val test1d = alternate [1, 2, 3, 4] = 1 - 2 + 3 - 4
val test1e = alternate [9, 8, 2, 3, 4, 5] = 9 - 8 + 2 - 3 + 4 - 5
;

val test2a = min_max [2] = (2,2)
val test2b = min_max [1,2,3,4] = (1,4)
val test2c = min_max [3,3,4,5,5] = (3,5)
val test2d = min_max [4,9,6,2,8,2,6,1,8,4,9,5] = (1,9)
;

val test3a = null(cumsum [])
val test3b = cumsum [1,4,20] = [1,5,25]
val test3c = cumsum [2,4,7,40] = [2,6,13,53]
;

val test4a = greeting NONE = "Hello there, you!"
val test4b = greeting (SOME "HasFer") = "Hello there, HasFer!"
;

val test5a = null (repeat ([], []))
val test5b = null (repeat ([2,3], []))
val test5c = null (repeat ([], [4,5]))
val test5d = repeat ([2], [3])         = [2,2,2]
val test5e = repeat ([4], [2,2])       = [4,4]
val test5f = repeat ([6,3], [3])       = [6,6,6]
val test5g = repeat ([1,2,3], [4,0,3]) = [1,1,1,1,3,3,3]
;

val test61 = not (isSome (addOpt (NONE,NONE)))
val test62 = addOpt ((SOME 2),NONE) = SOME 2
val test63 = addOpt (NONE,(SOME 4)) = SOME 4
val test64 = addOpt ((SOME 5),(SOME 4)) = SOME 9
;

val test71 = not (isSome (addAllOpt [NONE]))
val test72 = addAllOpt [SOME 2] = SOME 2
val test73 = addAllOpt [SOME 2, SOME 3, SOME 8] = SOME 13
val test74 = addAllOpt ([SOME 1, NONE, SOME 3]) = SOME 4
;

val test8q = any [] = false
val test8w = any [false] = false
val test8e = any [true] = true
val test8r = any [false,true,false] = true
val test8t = any [false,false,false] = false
;

val test9q = all [] = true
val test9w = all [false] = false
val test9e = all [true] = true
val test9r = all [false,true,false] = false
val test9t = all [false,false,false] = false
val test9y = all [true,true,true] = true
;

val test10q = zip ([], []) = []
val test10w = zip ([2], []) = []
val test10e = zip ([], [3]) = []
val test10r = zip ([1,2,3], [4, 6]) = [(1,4), (2,6)]
;

val test11q = zipRecycle ([], []) = []
val test11w = zipRecycle ([2], []) = []
val test11e = zipRecycle ([], [3]) = []
val test11r = zipRecycle ([1,2,3], [4,6]) = [(1,4), (2,6), (3,4)]
val test11t = zipRecycle ([1,2,3], [1,2,3,4,5,6,7]) = [(1,1), (2,2), (3,3),
                                                      (1,4), (2,5), (3,6), (1,7)]
val test11y = zipRecycle ([1,2,3,4,5,6,7], [1,2,3]) = [(1,1), (2,2), (3,3),
                                                       (4,1), (5,2), (6,3), (7,1)]
;

val test12q = zipOpt ([], []) = SOME []
val test12w = zipOpt ([2], []) = NONE
val test12e = zipOpt ([], [3]) = NONE
val test12r = zipOpt ([1,2,3], [4, 6]) = NONE
val test12t = zipOpt ([1,2,3], [4, 6, 9]) = SOME [(1,4), (2,6), (3,9)]
;

val test13q = lookup ([],"") = NONE
val test13w = lookup ([("a",1)],"") = NONE
val test13e = lookup ([("a",1),("b",2)],"") = NONE
val test13r = lookup ([("a",1),("b",2)],"b") = SOME 2
;

val test22q = fullDivide (2, 40) = (3, 5)  (* because 2*2*2*5 = 40 *)
val test22w = fullDivide (3, 10) = (0, 10) (* because 3 does not divide 10 *)
val test22e = fullDivide (5, 50) = (2, 2)
;

val test23q = null(factorize(1))
val test23w = factorize(2) = [(2,1)]
val test23e = factorize(4) = [(2,2)]
val test23r = factorize(20) = [(2,2), (5,1)]
val test23t = factorize(36) = [(2,2), (3,2)]
val test23y = factorize(84) = [(2,2), (3,1), (7,1)]
;

val test24q = multiply [] = 1
val test24w = multiply [(2,1)] = 2
val test24e = multiply [(2,2)] = 4
val test24r = multiply [(2,2), (5,1)] = 20
val test24t = multiply [(2,2), (3,2)] = 36
val test24y = multiply [(2,2), (3,1), (7,1)] = 84
;

val test251 = all_products [] = [1]
val test252 = all_products [(2,1)] = [1,2]
val test25q = all_products [(2,2), (5,1)] = [1,2,4,5,10,20]
val test25w = all_products [(2,2), (3,2)] = [1,2,3,4,6,9,12,18,36]
val test25e = all_products [(2,2), (3,1), (7,1)] = [1,2,3,4,6,7,12,14,21,28,42,84]
;