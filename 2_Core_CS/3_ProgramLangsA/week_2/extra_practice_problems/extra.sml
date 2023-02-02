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


(*  22
    fullDivide : int * int -> int * int
    that given two numbers (k, n) it attempts to evenly divide k into n as many times as possible,
    and returns a pair (d, n2) where d is the number of times while n2 is the resulting n after all those divisions *)
fun fullDivide (int_pair : int * int) =
    let
        fun divide (k : int, n : int, divisions : int) =
            if n mod k <> 0
            then (divisions, n)
            else divide (k, n div k, divisions + 1)
    in
        divide (#1 int_pair, #2 int_pair, 0)
    end


(* produce power of pow of number*)
fun power (number : int, pow : int) =
    if pow = 0
    then 1
    else number * power (number, pow - 1)


(*  23
    factorize : int -> (int * int) list
    produce list of factorize of given int and how many division *)
fun factorize (n0 : int) =
    let
        fun next_prime (prime : int) =
            let
                fun next (prime : int, num : int) =
                    if prime = num
                    then prime
                    else
                        if prime mod num = 0
                        then next (prime + 1, 2)
                        else next (prime, num + 1)
            in
                next (prime + 1, 2)
            end

        fun calculate (n : int, prime : int, rsf : (int * int) list, multiply : int) =
            let
                val result = fullDivide(prime, n)
            in
                if multiply = n0
                then rsf
                else if #1 result = 0
                then calculate (n, next_prime(prime), rsf, multiply)
                else calculate (n, next_prime(prime), rsf @ [(prime, #1 result)], multiply * power(prime, #1 result))
            end
    in
        calculate (n0, 2, [], 1)
    end


(*  24
    multiply : (int * int) list -> int
    computes back the number of factorized *)
fun multiply (factor : (int * int) list) =
    let
        fun mult (factor : (int * int) list, rsf : int) =
            if null factor
            then rsf
            else mult (tl factor, rsf * power(#1 (hd factor), #2 (hd factor)))
    in
        mult (factor, 1)
    end


(*  25
    all_products : (int * int) list -> int list
    creates a list all of possible products produced from using some or all of those prime factors no more than the number of times they are available *)
fun all_products (factors: (int * int) list) =
    let

        fun calculate (factors0: (int * int) list) =
            let
                fun calculate_rest (factors: (int * int) list, mult : int) =
                    if null factors
                    then []
                    else mult * power (#1 (hd factors), #2 (hd factors)) :: calculate_rest (tl factors, mult)

                fun calculate (factors: (int * int) list, mult : int, rsf : int list) =
                    if null factors
                    then rsf
                    else
                        calculate (tl factors,
                                   mult * power (#1 (hd factors), #2 (hd factors)),
                                   rsf @ calculate_rest(factors, mult))

                fun calculate_factor_by_factor (factors: (int * int) list) =
                    if null factors
                    then []
                    else
                        calculate (factors, 1, []) @
                        calculate_factor_by_factor (tl factors)
            in
                calculate_factor_by_factor (factors0)
            end

        fun products_many (listof_factors : ((int * int) list) list) =
            let
                fun another_multiply_check (factors : (int * int) list, rsf : int) =
                    if null factors
                    then 0
                    else
                        if #2 (hd factors) <> 1
                        then rsf
                        else another_multiply_check (tl factors, rsf + 1)

                fun add_another_multiply (factors : (int * int) list, index : int, enum : int, rsf : (int * int) list) =
                    if null factors
                    then []
                    else
                        if index = enum
                        then rsf @ [(#1 (hd factors), #2 (hd factors) - 1)] @ tl factors
                        else add_another_multiply (tl factors, index, enum + 1, hd factors :: rsf)

                val check_result = another_multiply_check (hd listof_factors, 1)
            in
                if check_result <> 0
                then products_many (add_another_multiply (hd listof_factors,
                                                          check_result,
                                                          1,
                                                          [])
                                    :: listof_factors)

                else listof_factors
            end

        fun products_one_by_one (lof : ((int * int) list) list) =
            if null lof
            then []
            else
                calculate (hd lof) @
                products_one_by_one (tl lof)

    in
        (* TODO:
        - REMOVE DUPLICATE
        - SORT
        *)
        1 :: products_one_by_one (products_many [factors])
    end
