use "extraw3.sml";

(* Problems 1-4 *)

val test1a = pass_or_fail {id=1, grade=NONE} = fail
val test1b = pass_or_fail {id=1, grade=SOME 1} = fail
val test1c = pass_or_fail {id=1, grade=SOME 74} = fail
val test1d = pass_or_fail {id=1, grade=SOME 75} = pass
val test1e = pass_or_fail {id=1, grade=SOME 90} = pass
;

val test2a = has_passed {id=1, grade=NONE} = false
val test2b = has_passed {id=1, grade=SOME 1} = false
val test2c = has_passed {id=1, grade=SOME 74} = false
val test2d = has_passed {id=1, grade=SOME 75} = true
val test2e = has_passed {id=1, grade=SOME 90} = true
;

val test3aa = number_passed [{id=1, grade=NONE}] = 0
val test3ab = number_passed [{id=1, grade=NONE},{id=1, grade=SOME 80}] = 1
val test3ce = number_passed [{id=1, grade=SOME 74},{id=1, grade=SOME 75},{id=1, grade=SOME 90}] = 2
;

val test4aa = number_misgraded [(fail, {id=1, grade=NONE})] = 0
val test4ab = number_misgraded [(pass, {id=1, grade=NONE})] = 1
val test4ba = number_misgraded [(fail, {id=1, grade=NONE}), (pass, {id=1, grade=SOME 80})] = 0
val test4bb = number_misgraded [(fail, {id=1, grade=NONE}), (fail, {id=1, grade=SOME 80})] = 1
val test4bc = number_misgraded [(pass, {id=1, grade=NONE}), (fail, {id=1, grade=SOME 80})] = 2
val test4ca = number_misgraded [(fail, {id=1, grade=SOME 74}), (pass, {id=1, grade=SOME 90})] = 0
;

(* Problems 5-7 *)

val L = leaf
val A = node { value=1, left=L, right=L }
val B = node { value=2, left=A, right=L }
val C = node { value=3, left=L, right=L }
val D = node { value=4, left=C, right=B }
val E = node { value=5, left=L, right=L }
val F = node { value=6, left=E, right=L }
val G = node { value=7, left=F, right=D }
;

val test5l = tree_height L = 0
val test5a = tree_height A = 1
val test5b = tree_height B = 2
val test5d = tree_height D = 3
val test5g = tree_height G = 4
;

val test6l = sum_tree L = 0
val test6a = sum_tree A = 1
val test6b = sum_tree B = 2+1
val test6C = sum_tree C = 3
val test6d = sum_tree D = 4+3+3
val test6E = sum_tree E = 5
val test6F = sum_tree F = 5+6
val test6g = sum_tree G = 7+6+5+4+3+2+1
;

val L = leaf
val A = node { value=leave_me_alone, left=L, right=L }
val B = node { value=leave_me_alone, left=A, right=L }
val C = node { value=leave_me_alone, left=L, right=L }
val D = node { value=prune_me,       left=C, right=B }
val E = node { value=leave_me_alone, left=L, right=L }
val F = node { value=leave_me_alone, left=E, right=L }
val G = node { value=leave_me_alone, left=F, right=D }
;

val test7L = gardener L = L
val test7A = gardener A = A
val test7B = gardener B = B
val test7C = gardener C = C
val test7D = gardener D = L
val test7E = gardener E = E
val test7F = gardener F = F
val test7G = gardener G = node { value=leave_me_alone, left=F, right=L }
;

(* Problems 9-16 *)

val test9aa = is_positive (ZERO) = false
val test9bb = is_positive (SUCC ZERO) = true
val test9cc = is_positive (SUCC (SUCC ZERO)) = true
;

val test10Z = (pred ZERO; false) handle Negative => true
val test10a = pred (SUCC ZERO) = ZERO
val test10b = pred (SUCC (SUCC ZERO)) = SUCC ZERO
;

val test11a: bool = nat_to_int ZERO = 0
val test11b: bool = nat_to_int (SUCC (SUCC (SUCC ZERO))) = 3
;

val test12Z = (int_to_nat ~1; false) handle Negative => true
val test12a: bool = int_to_nat 0 = ZERO
val test12b: bool = int_to_nat 3 = (SUCC (SUCC (SUCC ZERO)))
;

val test13a: bool = add (ZERO, ZERO) = ZERO
val test13b: bool = add (ZERO, SUCC ZERO) = SUCC ZERO
val test13q: bool = add (SUCC ZERO, ZERO) = SUCC ZERO
val test13c: bool = add (int_to_nat 5, int_to_nat 7) = int_to_nat 12
;

val test14a: bool = sub (ZERO, ZERO) = ZERO
val test14b: bool = sub (SUCC ZERO, ZERO) = SUCC ZERO
val test14q: bool = sub (ZERO, SUCC ZERO) = SUCC ZERO
val test14c: bool = sub (int_to_nat 7, int_to_nat 5) = int_to_nat 2
;

val test15a = mult (ZERO, SUCC ZERO) = ZERO
val test15b = mult (SUCC ZERO, ZERO) = ZERO
val test15c = mult (SUCC ZERO, SUCC ZERO) = SUCC ZERO
val test15d = mult (int_to_nat 7, int_to_nat 5) = int_to_nat 35
;

val test16a: bool = less_than (ZERO, SUCC ZERO) = true
val test16b: bool = less_than (ZERO, ZERO) = false
val test16c: bool = less_than (SUCC (SUCC ZERO), SUCC ZERO) = false
;
