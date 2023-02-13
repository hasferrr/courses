fun n_times (f,n,x) =
    if n = 0
    then x
    else f (n_times (f, n-1, x))
;

fun double x = x + x
val db0 = n_times (double, 0, 5)
val db1 = n_times (double, 1, 5)
val db2 = n_times (double, 2, 5)
;

(*
    ===== Evaluation =====
    n_times (double, 2, 5)
    double (n_times (double, 1, 5))
    double (double (n_times (double, 0, 5)))
    double (double (5))
    double (5 + 5)
    double (10)
    (10 + 10)
    20
*)

fun increment x = x + 1
val inc0 = n_times (increment, 0, 5)
val inc1 = n_times (increment, 1, 5)
val inc2 = n_times (increment, 2, 5)
;

val tail0 = n_times (tl, 0, [4,5,6,7])
val tail1 = n_times (tl, 1, [4,5,6,7])
val tail2 = n_times (tl, 2, [4,5,6,7])
;

fun addition(n,x) = n_times (increment, n, x)
val a = addition(2,5)
;