(* Extra Practice Problem - Week 3 *)

(* ================================= Problems 1-4 ================================= *)

type student_id    = int
type grade         = int (* must be in 0 to 100 range *)
type final_grade   = { id : student_id, grade : grade option }
datatype pass_fail = pass | fail


(* final_grade -> pass_fail *)
(* returns pass if the grade field contains SOME i for an i >= 75, else fail *)
fun pass_or_fail fg =
    let
        val {id=id, grade=gradeoption} = fg
    in
        case gradeoption of
            NONE => fail
            | SOME i => if i >= 75 then pass else fail
    end


(* final_grade -> Boolean *)
(* returns true if and only if the the grade field contains SOME i for an i >= 75 *)
fun has_passed fg =
    pass_or_fail fg = pass


(* List of final_grade -> Int *)
(* returns how many list elements have passing the grades *)
fun number_passed lofg0 =
    let
        fun number_passed (lofg, rsf) =
            case lofg of
                [] => rsf
                | fg::restlofg => if has_passed fg
                                  then number_passed (restlofg, rsf + 1)
                                  else number_passed (restlofg, rsf)
    in
        number_passed (lofg0, 0)
    end


(* List of (pass_fail * final_grade) -> Int *)
(* returns how many list elements are mislabeled *)
fun number_misgraded lopffg0 =
      let
        fun number_misgraded (lopffg, rsf) =
            case lopffg of
                [] => rsf
                | (pf,fg) :: restlopffg => if not (pf = pass_or_fail fg)
                                           then number_misgraded (restlopffg, rsf + 1)
                                           else number_misgraded (restlopffg, rsf)
    in
        number_misgraded (lopffg0, 0)
    end


(* ================================= Problems 5-7 ================================= *)

datatype 'a tree = leaf
                   | node of { value : 'a, left : 'a tree, right : 'a tree }
datatype flag = leave_me_alone | prune_me


(* 'a tree -> Int  *)
(* produce height of given tree (the length of the longest path to a leaf) *)
fun tree_height tr =
    case tr of
        leaf => 0
        | node {value=v, left=l, right=r} => 1 + Int.max(tree_height(l), tree_height(r))


(* 'a tree -> Int *)
(* produce the sum of all values in the nodes *)
fun sum_tree tr =
    case tr of
        leaf => 0
        | node {value=v, left=l, right=r} => v + sum_tree(l) + sum_tree(r)


(* flag tree -> flag tree *)
(* produce the sum of all values in the nodes *)
fun gardener tr =
    case tr of
        leaf => leaf
        | node {value=flg, left=l, right=r} => case flg of
                                                    prune_me => leaf
                                                    | leave_me_alone => node {value=flg, left=gardener l, right=gardener r}


(* problem 8 skipped *)


(* ================================= Problems 9-16 ================================= *)

datatype nat = ZERO | SUCC of nat
exception Negative

(* nat -> bool *)
(* returns whether that number is positive (i.e. not zero) *)
fun is_positive natural =
    case natural of
        ZERO => false
        | SUCC _ => true


(* nat -> nat *)
(* returns its predecessor. Since 0 does not have a predecessor in the natural numbers, throw an exception Negative *)
fun pred natural =
    case natural of
        ZERO => raise Negative
        | SUCC x => x


(* nat -> int *)
(* returns the corresponding int *)
fun nat_to_int  natural =
    case natural of
        ZERO => 0
        | SUCC x => 1 + nat_to_int (x)


(* int -> nat *)
(* returns a "natural number" representation for it, or throws a Negative exception if the integer was negative *)
fun int_to_nat integer =
    let
        fun int_to_nat i =
            if i = 0
            then ZERO
            else SUCC (int_to_nat (i - 1))
    in
        if integer < 0
        then raise Negative
        else int_to_nat integer
    end

(* nat, nat -> nat *)
(* perform addition. *)
fun add twonatural =
    case twonatural  of
        (ZERO, y) => y
        | (x, ZERO) => x
        | (SUCC x, y) => SUCC (add (x, y))


(* nat, nat -> nat *)
(* perform subtraction.  (Hint: Use pred) *)
fun sub twonatural =
    case twonatural  of
        (ZERO, y) => y
        | (x, ZERO) => x
        | (SUCC x, SUCC y) => sub (x, y)


(* nat, nat -> nat *)
(* perform multiplication. (Hint: Use add) *)
fun mult twonatural =
    let
        fun mult (twonat, rsf) =
            case twonat of
                (ZERO, x) => rsf
                | (x, ZERO) => rsf
                | (SUCC x, SUCC y) => mult ((SUCC x, y), add(rsf, SUCC x))
    in
        mult (twonatural, ZERO)
    end


(* nat, nat -> bool *)
(* return true when the first argument is less than the second (<) *)
fun less_than twonatural =
    case twonatural  of
        (ZERO, ZERO) => false
        | (ZERO, y) => true
        | (x, ZERO) => false
        | (SUCC x, SUCC y) => less_than (x, y)
