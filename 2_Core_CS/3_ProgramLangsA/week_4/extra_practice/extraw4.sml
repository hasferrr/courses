(* ('b -> 'c option) -> ('a -> 'b option) -> 'a -> 'c option *)
(* composes two functions with "optional" values.
   If either function returns NONE, then the result is NONE. *)
fun compose_opt f g a =
    case g a of
          NONE => NONE
        | SOME b => f b


(* ('a -> 'a) -> ('a -> bool) -> 'a -> 'a *)
(* do_until f p x will apply f to x and f again to that result and so on until p x is false *)
fun do_until f p x =
    if p x
    then do_until f p (f x)
    else x


(* int -> int *)
(* produce factorial number of the given number *)
fun factorial1 n =
    case do_until (fn (i, acc) => (i - 1, i * acc))
                  (fn (i, _) => i >= 1)
                  (n, 1)
    of (_, acc) => acc


(* (''a -> ''a) -> ''a -> ''a *)
(* given a function f and an initial value x applies f to x until f x = x *)
fun fixed_point f =
    do_until (fn x => f x) (fn x => f x <> x)


(* ('a -> 'b) -> ('a * 'a) -> ('b * 'b) *)
(* takes 'a values to 'b values and a pair of 'a values returns the corresponding pair of 'b values *)
fun map2 f (x, y) =
    (f x, f y)


(* ('b -> 'c list) -> ('a -> 'b list) -> 'a -> 'c list *)
(* app_all f g x will apply f to every element of the list g x and concatenate the results into a single list *)
fun app_all f g a =
    let
        (* 'b list -> 'c list *)
        fun app bl =
            case bl of
              [] => []
            | b::bs => f b @ app bs
    in
        app (g a)
    end


(* ('a * 'b -> 'b) 'b ('a list) -> 'b *)
(* foldr function: foldr f init [x1, x2, ..., xn] -> f(x1, f(x2, ..., f(xn, init)...)) *)
fun myfoldr f init lst =
    case lst of
          [] => init
        | x::xs => f(x, myfoldr f init xs)


(* ('a -> bool) -> 'a list -> ('a list * 'a list) *)
(* produce tuple of 2 lists:
   (1) list of 'a for which the first element evaluates f to true
   (2) list of the other element *)
fun partition f lst =
    let
        fun do_partition lst first second =
            case lst of
              [] => (first, second)
            | x::xs =>  if f x
                        then do_partition xs (first @ [x]) second
                        else do_partition xs first (second @ [x])
    in
        do_partition lst [] []
    end


(* ('a -> ('b * 'a) option) -> 'a -> ('b list) *)
(* produces a list of 'b values given a "seed" of type 'a and a function that given a seed
   produces SOME of a pair of a 'b value and a new seed, or
            NONE if it is done seeding *)
fun unfold f seed =
    case f seed of
          NONE => []
        | SOME (b,a) => b :: unfold f a


(* int -> int *)
(* factorial function agane *)
fun factorial2 i =
    foldl (fn (x,y) => x*y) 1 (unfold (fn num => if num < 1 then NONE else SOME (num, num-1)) i)


(* ('a -> 'b) -> 'a list -> 'b list *)
(* Implement map using List.foldr *)
fun mymap f lst =
    foldr (fn (x,y) => [f x] @ y) [] lst


(* ('a -> bool) -> 'a list -> 'a list *)
(* Implement filter using List.foldr *)
fun myfilter f lst =
    foldr (fn (x,y) => (if f x then [x] else []) @ y) [] lst


(* ('a * 'b -> 'b) -> 'b -> 'a list -> 'b *)
(* Implement foldl using foldr on functions *)
fun myfoldl f init lst =
    let
        fun traverse lst acc =
            case lst of
                  [] => acc
                | x::xs => traverse xs (foldr f acc [x])
    in
        traverse lst init
    end


datatype 'a tree = leaf | node of {value:'a, left:'a tree, right:'a tree}

(* ('a -> 'b) -> 'a tree -> 'b tree *)
fun tree_map f tr =
    case tr of
          leaf => leaf
        | node {value=v, left=l, right=r} => node {value=f v, left=tree_map f l, right=tree_map f r}

(* ('a -> bool) -> 'a tree -> 'a tree *)
fun tree_filter f tr =
    case tr of
          leaf => leaf
        | node {value=v, left=l, right=r} => if f v then node {value=v, left=tree_filter f l, right=tree_filter f r} else leaf

(* ('a * 'b -> 'b) -> 'b -> 'a tree -> 'b *)
fun tree_fold f init tr =
    case tr of
          leaf => init
        | node {value=v, left=l, right=r} => f(v, f(tree_fold f init l, tree_fold f init r))
