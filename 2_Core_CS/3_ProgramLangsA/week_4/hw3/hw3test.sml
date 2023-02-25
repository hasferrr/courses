(* Homework3 Simple Test*)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "hw3.sml";

val test1_b = null (only_capitals [])
val test1_1 = only_capitals ["A"] = ["A"]
val test1_2 = only_capitals ["A","B","C"] = ["A","B","C"]
val test1_3 = only_capitals ["Aqwer","Bqrew","Crewq"] = ["Aqwer","Bqrew","Crewq"]
val test1_4 = only_capitals ["fdA","ewB","fdsC"] = []
val test1_5 = only_capitals ["fdA","Dasd","fdsC"] = ["Dasd"]
val test1_6 = only_capitals ["fdA","Dasd","fdsC","XadsfZ"] = ["Dasd","XadsfZ"]
;

val test2_b = longest_string1 [] = ""
val test2_1 = longest_string1 ["a"] = "a"
val test2_2 = longest_string1 ["A","bc","C"] = "bc"
val test2_3 = longest_string1 ["Aa","bc","C"] = "Aa"
val test2_4 = longest_string1 ["Aq","bc","Cde","eFg"] = "Cde"
;

val test3_b = longest_string2 [] = ""
val test3_1 = longest_string2 ["a"] = "a"
val test3_2 = longest_string2 ["A","bc","C"] = "bc"
val test3_3 = longest_string2 ["Aa","bc","C"] = "bc"
val test3_4 = longest_string2 ["Aq","bc","Cde","eFg"] = "eFg"
;

fun f (x,y) = x > y
fun g (x,y) = x >= y
;
val test4_helper___3_b = longest_string_helper f [] = ""
val test4_helper___3_1 = longest_string_helper f ["a"] = "a"
val test4_helper___3_2 = longest_string_helper f ["A","bc","C"] = "bc"
val test4_helper___3_3 = longest_string_helper f ["Aa","bc","C"] = "Aa"
val test4_helper___3_4 = longest_string_helper f ["Aq","bc","Cde","eFg"] = "Cde"
;
val test4_helper___4_b = longest_string_helper g [] = ""
val test4_helper___4_1 = longest_string_helper g ["a"] = "a"
val test4_helper___4_2 = longest_string_helper g ["A","bc","C"] = "bc"
val test4_helper___4_3 = longest_string_helper g ["Aa","bc","C"] = "bc"
val test4_helper___4_4 = longest_string_helper g ["Aq","bc","Cde","eFg"] = "eFg"
;
val test4_3_a = longest_string3 ["A","bc","C"] = "bc"
val test4_3_b = longest_string3 [] = ""
val test4_3_1 = longest_string3 ["a"] = "a"
val test4_3_2 = longest_string3 ["A","bc","C"] = "bc"
val test4_3_3 = longest_string3 ["Aa","bc","C"] = "Aa"
val test4_3_4 = longest_string3 ["Aq","bc","Cde","eFg"] = "Cde"
;
val test4_4_a = longest_string4 ["A","B","C"] = "C"
val test4_4_b = longest_string4 [] = ""
val test4_4_1 = longest_string4 ["a"] = "a"
val test4_4_2 = longest_string4 ["A","bc","C"] = "bc"
val test4_4_3 = longest_string4 ["Aa","bc","C"] = "bc"
val test4_4_4 = longest_string4 ["Aq","bc","Cde","eFg"] = "eFg"
;

val test5_00 = longest_capitalized [] = ""
val test5_01 = longest_capitalized ["A","bc","C"] = "A"
val test5_02 = longest_capitalized ["aa","bc","C"] = "C"
val test5_03 = longest_capitalized ["aa","bcq","c"] = ""
val test5_04 = longest_capitalized ["Aa","bcq","c"] = "Aa"
val test5_05 = longest_capitalized ["Aa","Bc","ca"] = "Aa"
val test5_06 = longest_capitalized ["aaa","Bc","c","dd","ee"] = "Bc"
val test5_07 = longest_capitalized ["aaa","Bc","c","dd","Ee"] = "Bc"
val test5_08 = longest_capitalized ["Aaa","Bc","c","dd","Ee"] = "Aaa"
val test5_09 = longest_capitalized ["aaa","bc","c","dd","ee"] = ""
;

val test6_0 = rev_string "" = ""
val test6_1 = rev_string "a" = "a"
val test6_2 = rev_string "abc" = "cba"
val test6_3 = rev_string "zQwe" = "ewQz"
;

val isCapitalize = (Char.isUpper o (fn s => String.sub (s, 0)))
;

(* ('a -> 'b option) -> 'a list -> 'b *)
val test7_0 = (first_answer (fn x => if x > 3 then SOME x else NONE) []; false) handle NoAnswer => true
val test7_1 = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] = 4
val test7_2 = (first_answer (fn x => if x > 7 then SOME x else NONE) [1,2,3,4,5]; false) handle NoAnswer => true
val test7_3 = first_answer (fn x => if isCapitalize x then SOME (String.size x) else NONE) ["a","qwe","ss","Zxvc","a","Aaa"] = 4
val test7_4 = (first_answer (fn x => if isCapitalize x then SOME (String.size x) else NONE) ["a","qwe","ss","zxvc","a","aaa"]; false) handle NoAnswer => true
;

(* ('a -> 'b list option) -> 'a list -> 'b list option *)
val test8_a = all_answers (fn x => if x = 1 then SOME [x] else NONE) [] = SOME []
val test8_b = all_answers (fn x => if x = 1 then SOME [x] else NONE) [1] = SOME [1]
val test8_c = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2] = NONE
val test8_1 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE
val test8_2 = all_answers (fn x => if x > 1 then SOME [x] else NONE) [2,3,4,5,6,7] = SOME [2,3,4,5,6,7]
val test8_3 = all_answers (fn x => if isCapitalize x then SOME [(String.size x)] else NONE) ["A","Qwe","Ss","zxvc","A","Aaa"] = NONE
val test8_4 = all_answers (fn x => if isCapitalize x then SOME [(String.size x)] else NONE) ["A","Qwe","Ss","Zxvc","A","Aaa"] = SOME [1,3,2,4,1,3]
;

val test9a_01 = count_wildcards (Wildcard) = 1
val test9a_02 = count_wildcards (Variable "a") = 0
val test9a_03 = count_wildcards (UnitP) = 0
val test9a_04 = count_wildcards (ConstP 3) = 0
val test9a_05 = count_wildcards (TupleP []) = 0
val test9a_06 = count_wildcards (TupleP [Wildcard]) = 1
val test9a_07 = count_wildcards (TupleP [Wildcard, UnitP, Wildcard]) = 2
val test9a_08 = count_wildcards (ConstructorP ("a", UnitP)) = 0
val test9a_09 = count_wildcards (ConstructorP ("a", Wildcard)) = 1
val test9a_10 = count_wildcards (ConstructorP ("a", TupleP [Wildcard, ConstructorP ("b", Wildcard)])) = 2
;

val test9b_01 = count_wild_and_variable_lengths (Wildcard) = 1
val test9b_02 = count_wild_and_variable_lengths (Variable "a") = 1
val test9b_03 = count_wild_and_variable_lengths (Variable "asd") = 3
val test9b_04 = count_wild_and_variable_lengths (UnitP) = 0
val test9b_05 = count_wild_and_variable_lengths (ConstP 3) = 0
val test9b_06 = count_wild_and_variable_lengths (TupleP []) = 0
val test9b_07 = count_wild_and_variable_lengths (TupleP [Wildcard]) = 1
val test9b_08 = count_wild_and_variable_lengths (TupleP [Wildcard, UnitP, Wildcard]) = 2
val test9b_09 = count_wild_and_variable_lengths (TupleP [Wildcard, UnitP, Wildcard, (Variable "asdf")]) = 2 + 4
val test9b_10 = count_wild_and_variable_lengths (ConstructorP ("a", UnitP)) = 0
val test9b_11 = count_wild_and_variable_lengths (ConstructorP ("a", Wildcard)) = 1
val test9b_12 = count_wild_and_variable_lengths (ConstructorP ("a", (Variable "asd"))) = 3
val test9b_13 = count_wild_and_variable_lengths (ConstructorP ("a", TupleP [Wildcard, ConstructorP ("b", (Variable "asdf"))])) = 5
;

val test9c_01 = count_some_var ("x", Variable("x")) = 1
val test9c_02 = count_some_var ("x", Variable("y")) = 0
val test9c_03 = count_some_var ("x", Wildcard) = 0
val test9c_04 = count_some_var ("x", TupleP [Wildcard, Variable("x"), Variable("y"), Variable("x")]) = 2
val test9c_05 = count_some_var ("x", TupleP [Wildcard, Variable("w"), Variable("y"), Variable("q")]) = 0
val test9c_06 = count_some_var ("x", ConstructorP ("q", ConstructorP("a", Variable("x")))) = 1
val test9c_07 = count_some_var ("x", ConstructorP ("w", Wildcard)) = 0
val test9c_08 = count_some_var ("x", ConstructorP ("e", Variable("x"))) = 1
val test9c_09 = count_some_var ("x", ConstructorP ("r", Variable("y"))) = 0
val test9c_10 = count_some_var ("x", ConstructorP ("t", TupleP [Wildcard, Variable("x"), Variable("y")])) = 1
;

val test10_q = check_pat (Wildcard) = true
val test10_r = check_pat (Variable("x")) = true
val test10_w = check_pat (UnitP) = true
val test10_e = check_pat (ConstP 3) = true
val test10_t = check_pat (TupleP []) = true
val test10_y = check_pat (TupleP [Wildcard, Variable("x")]) = true
val test10_u = check_pat (TupleP [Wildcard, Variable("x"), Variable("y")]) = true
val test10_i = check_pat (TupleP [Wildcard, Variable("x"), Variable("x")]) = false
val test10_o = check_pat (ConstructorP ("", Variable("x"))) = true
val test10_p = check_pat (ConstructorP ("", ConstructorP ("", (TupleP [Wildcard, Variable("x")])))) = true
val test10_a = check_pat (ConstructorP ("", ConstructorP ("", (TupleP [Wildcard, Variable("x"), Variable("y")])))) = true
val test10_s = check_pat (ConstructorP ("", ConstructorP ("", (TupleP [Wildcard, Variable("x"), Variable("x")])))) = false
val test10_d = check_pat (TupleP [Variable("x"), TupleP [Variable("y")]]) = true
val test10_f = check_pat (TupleP [Variable("x"), TupleP [Variable("x")]]) = false
;

val test11a = match (Const 1, UnitP)                           = NONE
val test11b = match (Const 17, ConstP 17)                      = SOME []
val test11c = match (Const 1, Wildcard)                        = SOME []
val test11d = match (Unit, Wildcard)                           = SOME []
val test11e = match (Unit, UnitP)                              = SOME []
val test11f = match (Const 1, Variable "pat2")                 = SOME [("pat2", Const 1)]
val test11g = match (Const 1,
                     TupleP [Wildcard, Variable "pat2", UnitP, ConstP 17])   = NONE
val test11h = match (Tuple  [Const 1],
                     TupleP [Wildcard, Variable "pat2", UnitP, ConstP 17])   = NONE

val test11i = match (Tuple  [Const 1 , Const 2        , Unit , Const  17],
                     TupleP [Wildcard, Variable "pat2", UnitP, ConstP 17]) = SOME [("pat2", Const 2)]

val test11j = match(Tuple  [Const 17, Unit, Const 4, Constructor ("egg", Const 4), Constructor("egg", Constructor ("egg", Const 4))],
                    TupleP [Wildcard, Wildcard]) = NONE

val test11_q = match (Tuple  [Const 1], TupleP [UnitP]) = NONE
val test11_w = match (Tuple  [Const 1, Unit, Tuple []],
                      TupleP [ConstP 1, Wildcard, TupleP []]) = SOME []
val test11_e = match (Constructor("a", Unit), ConstructorP("a", UnitP)) = SOME []
val test11_r = match (Constructor("a", Unit), ConstructorP("z", UnitP)) = NONE
val test11_t = match (Const 123, ConstP 123) = SOME []
val test11_y = match (Const 123, ConstP 999) = NONE

val test11_u = match (Tuple [Unit, Const 123], TupleP [Variable "1", Variable "a"]) = SOME [("1",Unit),("a",Const 123)]
val test11_i = match (Constructor("ads",Unit), ConstructorP("ads",Variable "1")) = SOME [("1",Unit)]
;

val test12_q = first_match Unit [UnitP] = SOME []
val test12_w = first_match Unit [Wildcard] = SOME []
val test12_e = first_match Unit [ConstP 1] = NONE
val test12_r = first_match Unit [Wildcard, UnitP] = SOME []
val test12_t = first_match Unit [Wildcard, ConstP 1] = SOME []
val test12_y = first_match Unit [ConstructorP("a", UnitP), ConstP 1] = NONE
val test12_u = first_match (Const 1) [] = NONE
val test12_c = first_match (Const 1) [ConstP 1, ConstP 1] = SOME []
val test12_i = first_match (Const 1) [ConstP 9, ConstP 1] = SOME []
val test12_o = first_match (Const 1) [Variable "a"] = SOME [("a",Const 1)]
val test12_p = first_match (Const 1) [ConstP 1, Variable "a"] = SOME []
val test12_a = first_match (Const 1) [ConstP 9, Variable "a"] = SOME [("a",Const 1)]
val test12_s = first_match (Const 1) [ConstP 9, Variable "a", Variable "b"] = SOME [("a",Const 1)]
val test12_d = first_match (Tuple []) [TupleP []] = SOME []
val test12_f = first_match (Tuple []) [TupleP [UnitP]] = NONE
val test12_g = first_match (Tuple [Unit]) [TupleP [UnitP]] = SOME []
val test12_h = first_match (Tuple [Unit, Const 1]) [TupleP [UnitP, ConstP 1]] = SOME []
val test12_j = first_match (Tuple [Unit, Const 1]) [TupleP [UnitP, ConstP 9]] = NONE
val test12_k = first_match (Tuple [Unit, Const 1]) [TupleP [UnitP, ConstP 1], TupleP [UnitP, ConstP 1]] = SOME []
val test12_l = first_match (Tuple [Unit, Const 1]) [TupleP [UnitP, ConstP 9], TupleP [UnitP, ConstP 1]] = SOME []
val test12_z = first_match (Tuple [Unit, Const 1]) [TupleP [UnitP, Variable "q"], TupleP [UnitP, Variable "z"]] = SOME [("q",Const 1)]
val test12_v = first_match (Tuple [Unit, Const 1]) [TupleP [UnitP, ConstP 9], TupleP [UnitP, Variable "z"]] = SOME [("z",Const 1)]
val test12_b = first_match (Tuple [Unit]) [TupleP [Wildcard, Variable("x"), Variable("x")]] = NONE
;
