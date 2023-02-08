fun sum_triple_0_args (tr1 : int, tr2 : int, tr3 : int) =
    tr1 +
    tr2 +
    tr3

fun sum_triple_0_tups (triple : int*int*int) =
    #1 triple +
    #2 triple +
    #3 triple

fun sum_triple_1 (triple : int*int*int) =
    case triple of
        (x,y,z) => z + y + x

fun sum_triple_2 (triple : int*int*int) =
    let
        val (x,y,z) = triple
    in
        x + y + z
    end

fun sum_triple_3 (x,y,z) =
    x + y + z
;

val data = (3,4,5)
val result_0 = sum_triple_0_args data
val result_3 = sum_triple_3 data
;

fun sum_triple_records (triple : {first:int, middle:int, last:int}) =
    let
        val {first=a, middle=b, last=c} = triple
    in
        a + b + c
    end

val result_records = sum_triple_records {first=3, middle=4, last=5}
