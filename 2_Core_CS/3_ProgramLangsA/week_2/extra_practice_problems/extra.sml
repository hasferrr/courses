(* 1 *)
(* alternate : int list -> int *)
(* adds every element in int list with alternating sign (- then +) *)
fun alternate (numbers : int list) =
    let
        fun alternate_with_acc (numbers : int list, acc : int, rsf : int) =
            if null numbers
            then rsf
            else
                if acc = 0
                then alternate_with_acc (tl numbers, 1, rsf + (hd numbers))
                else alternate_with_acc (tl numbers, 0, rsf + ~(hd numbers))
    in
        alternate_with_acc (numbers, 0, 0)
    end


(* 2 *)
(* min_max : int list -> (int * int) *)
(* produce (minimum, maximum) of the numbers in the list *)
(* ASSUME: int list is non-empty list *)
fun min_max (numbers : int list) =
    let
        fun get_min_max (numbers : int list, rsf : int * int) =
            if null numbers
            then rsf
            else get_min_max (tl numbers,
                              (if hd numbers < #1 rsf then hd numbers else #1 rsf,
                               if hd numbers > #2 rsf then hd numbers else #2 rsf))
    in
        get_min_max (tl numbers, (hd numbers, hd numbers))
    end


(* 3 *)
(* cumsum : int list -> int list *)
(* produce list of the partial sums of those numbers *)
fun cumsum (numbers0 : int list) =
    let
        fun cumsum (numbers : int list, prev_number : int) =
            if null numbers
            then []
            else
                let
                    val current_plus_prev = hd numbers + prev_number
                in
                    current_plus_prev ::
                    cumsum (tl numbers, current_plus_prev)
                end
    in
        cumsum (numbers0, 0)
    end


(* 4 *)
(* greeting : string option -> string *)
(* produce string from given string option*)
fun greeting (str_option : string option) =
    if not (isSome str_option)
    then "Hello there, you!"
    else "Hello there, " ^ valOf str_option ^ "!"


(* 5 *)
(* repeat : int list * int list -> int list *)
(* produce list of repeated integers in the first list according to the numbers indicated by the second list*)
fun repeat (numbers1 : int list, numbers2 : int list) =
    if null numbers1
    then []
    else if null numbers2
    then []
    else
        if hd numbers2 = 0
        then repeat (tl numbers1, tl numbers2)
        else hd numbers1 :: repeat (numbers1, (hd numbers2 - 1) :: (tl numbers2))


(* 6 *)
(* addOpt  : int option * int option -> int option *)
(* produce SOME of two given int SOME; treat NONE as 0 *)
fun addOpt (opt1 : int option, opt2 : int option) =
    if not (isSome (opt1))
    then opt2
    else if not (isSome (opt2))
    then opt1
    else SOME (valOf (opt1) + valOf (opt2))


(* 7 *)
(* addAllOpt  : int option list -> int option *)
(* produce the sum of int option list *)
fun addAllOpt (intOptions_0 : int option list) =
    let
        fun addAllOpt (intOptions : int option list) =
            if null intOptions
            then 0
            else
                if not (isSome (hd intOptions))
                then addAllOpt (tl intOptions)
                else
                    valOf (hd intOptions) +
                    addAllOpt (tl intOptions)

        val answer = addAllOpt (intOptions_0)
    in
        if answer = 0
        then NONE
        else SOME answer
    end

(* 8
    any : bool list -> boolany : bool list -> bool
    returns TRUE if there is at least one of them that is TRUE, otherwise FALSE *)
fun any (bool_list : bool list) =
    if null bool_list
    then false
    else
        hd bool_list orelse any (tl bool_list)

(*  9
    all : bool list -> boolall : bool list -> bool
    returns TRUE if all of them truetrue, otherwise returns FALSE *)
fun all (bool_list : bool list) =
    if null bool_list
    then true
    else
        hd bool_list andalso all (tl bool_list)

(*  10
    zip : int list * int list -> (int * int) list
    produce consecutive pairs from two given lists, and stops when one of the lists is empty *)
fun zip (lst1 : int list, lst2 : int list) =
    if null lst1
    then []
    else if null lst2
    then []
    else
        [(hd lst1, hd lst2)] @ zip (tl lst1, tl lst2)


(*  11
    zipRecycle : int list * int list -> (int * int) list
    like zip, but where when one list is empty the other list start from the beginning until the list completes *)
fun zipRecycle (lst1_0 : int list, lst2_0 : int list) =
    if null lst1_0 orelse null lst2_0
    then []
    else
        let
            fun zipRecycle (lst1 : int list, lst2 : int list, recycling1 : bool, recycling2 : bool) =

                if null lst1 andalso not recycling2
                then zipRecycle (lst1_0, lst2, true, recycling2)

                else if null lst2 andalso not recycling1
                then zipRecycle (lst1, lst2_0, recycling1, true)

                else if null lst1 orelse null lst2
                then []

                else
                    [(hd lst1, hd lst2)] @ zipRecycle (tl lst1, tl lst2, recycling1, recycling2)
        in
            zipRecycle (lst1_0, lst2_0, false, false)
        end


(*  12
    zipOpt : int list * int list -> (int * int) list
    produce SOME consecutive pairs from two given lists, and stops when one of the lists is empty
    produce NONE if two given lists has no same length *)
fun zipOpt (lst1_0 : int list, lst2_0 : int list) =
    if length lst1_0 <> length lst2_0
    then NONE
    else
        let
            fun zipOpt (lst1 : int list, lst2 : int list) =
                if null lst1
                then []
                else if null lst2
                then []
                else
                    [(hd lst1, hd lst2)] @ zip (tl lst1, tl lst2)
        in
            SOME (zipOpt (lst1_0, lst2_0))
        end


(*  13
    lookup : (string * int) list * string -> int option
    goes through the list of pairs looking for the string in the pair.
    produce SOME i if corresponding string match with stirng in the pair
    produce NONE if it doesnt *)
fun lookup (listof_string_int_pair_0 : (string * int) list, s2 : string) =
    if null listof_string_int_pair_0
    then NONE
    else
        let
            fun lookup (listof_string_int_pair : (string * int) list) =
                if null listof_string_int_pair
                then NONE
                else
                    if s2 = #1 (hd listof_string_int_pair)
                    then SOME (#2 (hd listof_string_int_pair))
                    else lookup (tl listof_string_int_pair)
        in
            lookup listof_string_int_pair_0
        end
