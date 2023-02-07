(* Data Definition *)
datatype mytype =
    Constant of int
    | Negate of mytype
    | Add of mytype * mytype
    | Subtract of mytype * mytype
;

val asdf5 : mytype = Constant 5
val asdf2 : mytype = Constant 2
val addzz : mytype = Add (asdf5, asdf2)
val subzz : mytype = Subtract (asdf5, asdf2)
;

(* Function Definition *)
fun eval e =
    case e of
        Constant e => e
        | Negate e => ~ (eval e)
        | Add (e1, e2) => eval e1 + eval e2
        | Subtract (e1, e2) => eval e1 - eval e2

fun eval_2 (Constant e) = e
    | eval_2 (Negate e) = ~ (eval_2 e)
    | eval_2 (Add(e1, e2)) = (eval_2 e1) + (eval_2 e2)
    | eval_2 (Subtract(e1, e2)) = (eval_2 e1) - (eval_2 e2)
;

val qwert1 = eval_2 asdf5
val qwert2 = eval addzz
val qwert3 = eval subzz
;

fun max_constant e =
    case e of
        Constant e => e
        | Negate e => max_constant e
        | Add (e1, e2) => Int.max(max_constant e1, max_constant e2)
        | Subtract (e1, e2) => Int.max(max_constant e1, max_constant e2)
;

val wasd = Add (Constant 9, Negate (Constant 5))
val max_wasd = max_constant wasd = 9
;

(* ============================================================== *)

datatype my_int_list =
    Empty
    | Cons of int * my_int_list
;

fun append_mylist (xs,ys) =
    case xs of
        Empty => ys
        | Cons(x,xs') => Cons (x, (append_mylist (xs', ys)))
;

append_mylist (Cons (1, Cons (2, Empty)),
               Cons (7, Empty))
;
