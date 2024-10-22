(* Homework 3 *)

exception NoAnswer

datatype pattern = Wildcard
         | Variable of string
         | UnitP
         | ConstP of int
         | TupleP of pattern list
         | ConstructorP of string * pattern

datatype valu = Const of int
          | Unit
          | Tuple of valu list
          | Constructor of string * valu

fun g f1 f2 p =
    let
        val r = g f1 f2
    in
        case p of
            Wildcard          => f1 ()
          | Variable x        => f2 x
          | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
          | ConstructorP(_,p) => r p
          | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
         | UnitT
         | IntT
         | TupleT of typ list
         | Datatype of string


(**** Solutions ****)


(* string list -> string list *)
(* produce a string list that only start with an uppercase letter *)
(* Assume: all strings have at least 1 character *)
val only_capitals =
    List.filter (Char.isUpper o (fn s => String.sub (s, 0)))


(* string list -> string *)
(* produce the longest string in the list *)
fun longest_string1 los =
    foldl (fn (s, s_acc) => if String.size s > String.size s_acc then s else s_acc) "" los


(* string list -> string *)
(* produce the longest string in the list from right *)
fun longest_string2 los =
    foldl (fn (s, s_acc) => if String.size s >= String.size s_acc then s else s_acc) "" los


(* (int * int -> bool) -> string list -> string *)
(* helper function for the longest string function *)
fun longest_string_helper f los =
    foldl (fn (s, s_acc) => if f (String.size s, String.size s_acc) then s else s_acc) "" los


(* string list -> string *)
(* produce the longest string in the list *)
val longest_string3 =
    longest_string_helper (fn (x,y) => x > y)


(* string list -> string *)
(* produce the longest string in the list from right *)
val longest_string4 =
    longest_string_helper (fn (x,y) => x >= y)


(* string list -> string *)
(* produce the longest string in the list that begins with an uppercase letter *)
(* Assume: all strings have at least 1 character *)
val longest_capitalized =
    longest_string3 o only_capitals


(* string -> string *)
(* returns the string that is the same characters in reverse order (String.rev) *)
val rev_string =
    String.implode o rev o String.explode


(* ('a -> 'b option) -> 'a list -> 'b *)
(* produce the first element in the 'a list that satisfy the given function *)
fun first_answer f alist =
    case alist of
          [] => raise NoAnswer
        | x::xs => case f x of
                          NONE => first_answer f xs
                        | SOME y => y


(* ('a -> 'b list option) -> 'a list -> 'b list option *)
(* produce all list option in the 'a list that satisfy the given function *)
fun all_answers f alist =
    let
        fun all_answers lst acc =
            case lst of
                  [] => SOME acc
                | x::xs => case f x of
                                  NONE => NONE
                                | SOME y => all_answers xs (acc @ y)
    in
        all_answers alist []
    end


(* pattern -> int *)
(* produce number of Wildcard patterns it contains *)
fun count_wildcards p =
    g (fn () => 1) (fn _ => 0) p


(* pattern -> int *)
(* produce number of Wildcard patterns plus variable name *)
fun count_wild_and_variable_lengths p =
    g (fn () => 1) String.size p


(* (string * pattern) -> int *)
(* produce the number of times the string appears as a variable in the pattern *)
fun count_some_var (s, p) =
    g (fn () => 0) (fn x => if x = s then 1 else 0) p


(* pattern -> bool *)
(* produce true if and only if all the variables appearing in the pattern are distinct from each other *)
fun check_pat p =
    let
        (* listof-string -> bool *)
        (* produce true if string in the list of string has no repeat *)
        fun noRepeat los =
            case los of
                [] => true
                | x::xs => not (List.exists (fn s => x=s) xs) andalso noRepeat xs

        (* pattern -> listof-string *)
        (* produce list of all the strings it uses for variables *)
        fun check p =
            case p of
                Variable x        => [x]
              | TupleP ps         => List.foldl (fn (p,i) => (check p) @ i) [] ps
              | ConstructorP(_,p) => check p
              | _                 => []
    in
        noRepeat (check p)
    end


(* (valu * pattern) -> (string * valu) list option *)
(* produce NONE if the pattern does not match, or SOME lst where lst is the list of bindings if it does *)
fun match (v, p) =
    let
        (* (listof-valu * listof-pattern) listof-(string * valu) -> (string * valu) list option *)
        fun match_many (lov, lop) acc =
            case (lov, lop) of
                  ([],[])                  => SOME acc
                | (v::restlov, p::restlop) => (case match (v, p) of
                                                  NONE   => NONE
                                                | SOME a => match_many (restlov, restlop) (acc @ a))
                | _                        => NONE
    in
        case (v, p) of
              (_, Wildcard)                           => SOME []
            | (Unit, UnitP)                           => SOME []
            | (Const x, ConstP y)                     => if x = y then SOME [] else NONE
            | (Tuple lov, TupleP lop)                 => match_many (lov, lop) []
            | (Constructor(s1,x), ConstructorP(s2,y)) => if s1 = s2 then match (x, y) else NONE
            | (v, Variable s)                         => SOME [(s, v)]
            | _                                       => NONE
    end


(* valu, listof-pattern -> (string * valu) list option *)
(* produce NONE if no pattern in the list matches, or
           SOME lst where lst is the list of bindings for the first pattern in the list that matches *)
fun first_match v lop =
    SOME (first_answer (fn p => match(v,p)) lop) handle NoAnswer => NONE
