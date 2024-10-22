(* Homework1 *)


(* produce true if date1 is comes before than date2 *)
fun is_older (date1 : int*int*int, date2 : int*int*int) =
    if (#1 date1) < (#1 date2)
    then true
    else if (#1 date1) > (#1 date2)
    then false
    else if (#2 date1) < (#2 date2)
    then true
    else if (#2 date1) > (#2 date2)
    then false
    else if (#3 date1) < (#3 date2)
    then true
    else if (#3 date1) > (#3 date2)
    then false
    else false


(* produce how many Date(s) in the list are in the given month *)
fun number_in_month (lod : (int*int*int) list, month : int) =
    if null lod
    then 0
    else
        if #2 (hd lod) = month
        then 1 + number_in_month(tl lod, month)
        else number_in_month(tl lod, month)


(* produce number of dates in the list of dates that are in any of the months in the list of months
   Assume: the list of months has no number repeated *)
fun number_in_months (lod : (int*int*int) list, lom : int list) =
    if null lom
    then 0
    else number_in_month (lod, hd lom) + number_in_months (lod, tl lom)


(* produce a list of dates from the argument list of dates that are in the month *)
fun dates_in_month (lod : (int*int*int) list, month : int) =
    if null lod
    then []
    else
        if #2 (hd lod) = month
        then (hd lod) :: dates_in_month(tl lod, month)
        else dates_in_month(tl lod, month)


(* produce a list of dates from the argument list of dates that are in any of the months in the list of months
   Assume: the list of months has no number repeated *)
fun dates_in_months (lod : (int*int*int) list, lom : int list) =
    if null lom
    then []
    else
        dates_in_month (lod, hd lom) @
        dates_in_months (lod, tl lom)


(* produce the n-th element of the list where the head of the list is 1st
   Assume: list of string is not empty and n is greater than 0 *)
fun get_nth (los : string list, n : int) =
    if n = 1
    then hd los
    else get_nth (tl los, n - 1)


(* produce the n-th element of the list where the head of the list is 1st
   Assume: list of string is not empty and n is greater than 0 *)
fun date_to_string (date : (int*int*int)) =
    let
        val months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    in
        get_nth (months, #2 date) ^ " " ^ Int.toString (#3 date) ^ ", " ^ Int.toString (#1 date)
    end


(* produce an n-th from the listof int before current sum of listof int reach the given sum
   Assume: the entire list sums to more than the passed in value; sum > 0; listof_int contains > 0 numbers *)
fun number_before_reaching_sum (sum : int, listof_int : int list) =
    if sum - hd listof_int <= 0
    then 0
    else 1 + number_before_reaching_sum (sum - hd listof_int, tl listof_int)


(* produce month from given day of year (an int between 1 and 365) *)
fun what_month (day_of_year : int) =
    let
        val day_of_months = [31,28,31,30,31,30,31,31,30,31,30,31]
    in
        1 + number_before_reaching_sum (day_of_year, day_of_months)
    end


(* produce int list [m1,m2,...,mn] where m1 is the month of day1,
  m2 is the month of day1+1, ..., and mn is the month of day day2 *)
fun month_range (day1 : int, day2 : int) =
    if day1 > day2
    then []
    else what_month (day1) :: month_range(day1 + 1, day2)


(* produce NONE if the list has no dates
   produce SOME d if the date d is the oldest date in the list. *)
fun oldest (lod : (int*int*int) list) =
    if null lod
    then NONE
    else
        let
            fun oldest_date (lod : (int*int*int) list) =
                if null (tl lod)
                then hd lod
                else
                    let
                        val rest = oldest_date (tl lod)
                    in
                        if is_older (hd lod, rest)
                        then hd lod
                        else rest
                    end
        in
            SOME (oldest_date (lod))
        end
