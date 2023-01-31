(* Homework1 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "hw1.sml";


val test1   = is_older ((1,2,3),(2,3,4)) = true

(* YEAR *)
(* 2000 vs 2099 *)
val test1_year_a0    = is_older ((2000,1,15),(2099,1,15)) = true

val test1_year_a1    = is_older ((2000,9,15),(2099,1,15)) = true
val test1_year_a2    = is_older ((2000,9,30),(2099,1,15)) = true
val test1_year_a3    = is_older ((2000,9,10),(2099,1,15)) = true

val test1_year_a4    = is_older ((2000,1,15),(2099,9,15)) = true
val test1_year_a5    = is_older ((2000,1,30),(2099,9,15)) = true
val test1_year_a6    = is_older ((2000,1,10),(2099,9,15)) = true

(* 2099 vs 2000 *)
val test1_year_b0    = is_older ((2088,1,15),(2001,1,15)) = false

val test1_year_b1    = is_older ((2088,9,15),(2001,1,15)) = false
val test1_year_b2    = is_older ((2088,9,30),(2001,1,15)) = false
val test1_year_b3    = is_older ((2088,9,10),(2001,1,15)) = false

val test1_year_b4    = is_older ((2088,1,15),(2001,9,15)) = false
val test1_year_b5    = is_older ((2088,1,30),(2001,9,15)) = false
val test1_year_b6    = is_older ((2088,1,10),(2001,9,15)) = false

(* MONTH *)
val test1_month_a1   = is_older ((2000,1,15),(2000,9,15)) = true
val test1_month_a2   = is_older ((2000,1,30),(2000,9,15)) = true
val test1_month_a3   = is_older ((2000,1,15),(2000,9,30)) = true

val test1_month_b1   = is_older ((2000,9,15),(2000,1,15)) = false
val test1_month_b2   = is_older ((2000,9,30),(2000,1,15)) = false
val test1_month_b3   = is_older ((2000,9,15),(2000,1,30)) = false

(* DAY *)
val test1_day_a1   = is_older ((2000,1,15),(2000,1,15)) = false
val test1_day_a2   = is_older ((2000,1,30),(2000,1,15)) = false
val test1_day_a3   = is_older ((2000,1,15),(2000,1,30)) = true

(* SAME DATE *)
val test1_same_date = is_older ((2000,2,15),(2000,2,15)) = false
;


val test2_0 = number_in_month ([],2) = 0
val test2_1 = number_in_month ([(2099,2,28)],9) = 0
val test2_2 = number_in_month ([(2099,2,28)],2) = 1
val test2_3 = number_in_month ([(2012,2,28),(2013,12,1)],2) = 1
val test2_4 = number_in_month ([(2012,12,28),(2013,12,1)],12) = 2
val test2_5 = number_in_month ([(2012,12,28),(2013,12,1),(9999,12,10),(8888,1,3),(2000,9,2),(2045,12,9),(2012,12,28)],12) = 5
val test2_6 = number_in_month ([(8888,12,28),(2013,12,1),(9999,12,10),(8888,1,3),(2000,9,2),(2045,12,9),(8888,12,28)],99) = 0
;


val test3 = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = 3
val test3_b0 = number_in_months ([],[]) = 0
val test3_b1 = number_in_months ([(2012,2,28),(2013,12,1)],[]) = 0
val test3_b2 = number_in_months ([],[3,4,5]) = 0
val test3_1 = number_in_months ([(2012,2,28)],[2]) = 1
val test3_2 = number_in_months ([(2012,2,28)],[2,3]) = 1
val test3_3 = number_in_months ([(2012,2,28),(2012,3,28),(2012,12,28)],[2,3,4]) = 2
val test3_4 = number_in_months ([(2012,2,28),(2012,3,28),(2012,12,28)],[7,8,9]) = 0
;


val test4_base = dates_in_month ([],9) = []
val test4 = dates_in_month ([(2012,2,28),(2013,12,1)],2) = [(2012,2,28)]
val test4_a = dates_in_month ([(2012,9,28),(2012,1,28)],9) = [(2012,9,28)]
val test4_b = dates_in_month ([(2012,9,28),(2012,9,28)],9) = [(2012,9,28),(2012,9,28)]
val test4_c = dates_in_month ([(2012,2,28),(2013,12,1)],1) = []
val test4_d = dates_in_month ([(2012,3,28),(2013,12,1),(2013,3,29),
                              (2011,12,1),(2014,12,1),(2013,3,2)], 3)
                              = [(2012,3,28),(2013,3,29),(2013,3,2)]
;

val test5 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = [(2012,2,28),(2011,3,31),(2011,4,28)]
val test5_base_0 = dates_in_months ([],[]) = []
val test5_base_l = dates_in_months ([(2012,2,28)],[]) = []
val test5_base_r = dates_in_months ([],[2]) = []
val test5_a = dates_in_months ([(2012,2,28)],[2]) = [(2012,2,28)]
val test5_b = dates_in_months ([(2012,2,28)],[2,3,4]) = [(2012,2,28)]
val test5_c = dates_in_months ([(2012,2,28),
                                (2023,1,11),
                                (2022,2,22)],[2]) = [(2012,2,28),(2022,2,22)]
val test5_d = dates_in_months ([(2012,3,28),
                                (2023,4,11),
                                (2022,5,22)],[3,4,5]) = [(2012,3,28), (2023,4,11), (2022,5,22)]
;


val test6_1 = get_nth(["hi", "there", "how", "are", "you"], 1) = "hi"
val test6_2 = get_nth(["hi", "there", "how", "are", "you"], 2) = "there"
val test6_3 = get_nth(["hi", "there", "how", "are", "you"], 3) = "how"
val test6_4 = get_nth(["hi", "there", "how", "are", "you"], 4) = "are"
val test6_5 = get_nth(["hi", "there", "how", "are", "you"], 5) = "you"
;


val test7_1 = date_to_string (2013, 6, 1) = "June 1, 2013"
val test7_2 = date_to_string (1945, 8, 17) = "August 17, 1945"
val test7_3 = date_to_string (9999, 12, 1) = "December 1, 9999"
val test7_4 = date_to_string (2013, 1, 20) = "January 20, 2013"
;

val test8_base = number_before_reaching_sum (0, [2]) = 0
val test8_1 = number_before_reaching_sum (10, [1,2,3,4,5]) = 3
val test8_2 = number_before_reaching_sum (30, [4,7,13,2,5]) = 4
val test8_3 = number_before_reaching_sum (2, [1,1]) = 1
val test833 = number_before_reaching_sum (10, [5,5]) = 1
val test8_4 = number_before_reaching_sum (5, [1,2,3]) = 2
val test8_5 = number_before_reaching_sum (20, [2,3,4,5,6,4,5,6]) = 4
val test8_6 = number_before_reaching_sum (20, [6,2,5,3,4,2,7,1]) = 4
;

val test9a = what_month 1 = 1
val test9b = what_month 31 = 1
val test9c = what_month 32 = 2
val test9d = what_month 59 = 2
val test9e = what_month 60 = 3
val test9f = what_month 90 = 3
val test9g = what_month 91 = 4
val test9h = what_month 120 = 4
val test9i = what_month 121 = 5
val test9k = what_month 151 = 5
val test9l = what_month 152 = 6
val test9m = what_month 181 = 6
val test9n = what_month 182 = 7
val test9o = what_month 212 = 7
val test9p = what_month 213 = 8
val test9q = what_month 243 = 8
val test9r = what_month 244 = 9
val test9s = what_month 273 = 9
val test9t = what_month 274 = 10
val test9u = what_month 304 = 10
val test9v = what_month 305 = 11
val test9w = what_month 334 = 11
val test9x = what_month 335 = 12
val test9_end = what_month 365 = 12
;

val test10 = month_range (31, 34) = [1,2,2,2]
val test10a = month_range(2, 1) = []
val test10b = month_range(1, 1) = [1]
val test10c = month_range(1, 2) = [1, 1]
val test10d = month_range(1, 3) = [1, 1, 1]
val test10e = month_range(31, 32) = [1, 2]
val test10f = month_range(304, 305) = [10, 11]
val test10g = month_range(242, 245) = [8, 8, 9, 9]
;

val test11 = oldest([(2012,2,28),(2011,3,31),(2011,4,28)]) = SOME (2011,3,31)
val test11_a = oldest [] = NONE
val test11_b = oldest [(2012,2,28)] = SOME (2012,2,28)
val test11_c = oldest [(2012,2,28),(2011,3,31),(2011,4,28)] = SOME (2011,3,31)
val test11_d = oldest [(2011,2,28),(2011,2,28),(2011,4,28)] = SOME (2011,2,28)
val test11_e = oldest [(2011,3,31),(2011,3,31),(2011,3,31)] = SOME (2011,3,31)
