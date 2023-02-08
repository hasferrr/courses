(* Homework 2 *)

(* Problem 1 *)

fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* Solutions for problem 1 *)

(* String, String-List -> ListOption *)
(* return NONE if the string is not in the list, otherwise return SOME list not containing the given string *)
fun all_except_option(str, strlst0) =
    let
        fun all_except_option(strlst, rsf) =
            case strlst of
                [] => if rsf = strlst0
                        then NONE
                        else SOME rsf
                | x::xs => if same_string(x, str)
                           then all_except_option(xs, rsf)
                           else all_except_option(xs, rsf @ [x])
    in
        all_except_option(strlst0, [])
    end


(* String-List-List, String -> StringList *)
(* return string list that are in some list in substitutions that also has s, but s itself should not be in the result *)
fun get_substitutions1 (strlstlst, str) =
    case strlstlst of
        [] => []
        | x::xs => (case all_except_option(str, x) of
                        NONE => []
                        | SOME y => y) @ get_substitutions1(xs, str)


(* String-List-List, String -> StringList *)
(* tail-recursive version of get_substitutions1 *)
fun get_substitutions2 (strlstlst, str) =
    let
        fun get_substitutions (strlstlst, rsf) =
            case strlstlst of
                [] => rsf
                | x::xs => get_substitutions(xs, rsf @ (case all_except_option(str, x) of
                                                            NONE => []
                                                            | SOME y => y))
    in
        get_substitutions(strlstlst, [])
    end


(* String-List-List, {first:string, middle:string, last:string} -> StringList *)
(* returns a list of full names record can produce by substituting for the first name with the original name *)
fun similar_names (strlstlst, fullname) =
    let
        val {first=first, middle=middle, last=last} = fullname
        val substitution_name = get_substitutions2(strlstlst, first)
        fun get_similar_names (names, rsf) =
            case names of
                [] => rsf
                | x::xs => get_similar_names(xs, rsf @ [{first=x, middle=middle, last=last}])
    in
        get_similar_names(substitution_name, [fullname])
    end;


(* Problem 2 *)

(* Assume that Num is always used with values >= 2 and <= 10 *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw

exception IllegalMove

(* Solutions for problem 2 *)

(* Card -> Color *)
(* returns its color (spades and clubs are black, diamonds and hearts are red) *)
fun card_color crd =
    case crd of
        (Clubs,_) => Black
        | (Spades,_) => Black
        |  _ => Red


(* Card -> Int *)
(* returns its value (numbered cards have their number as the value, aces are 11, everything else is 10). *)
fun card_value crd =
    case crd of
        (_,Ace) => 11
        | (_,Num n) => n
        | _ => 10


(* Card-List Card Exn -> Card-List *)
(* returns a list that has all the elements of cs except c
    If c is in the list more than once, remove only the first one
    If c is not in the list, raise the exception e *)
fun remove_card (cs, c, e) =
    let
        fun remove_card (cardlist, isfound, rsf) =
            case cardlist of
            [] => if isfound
                  then rsf
                  else raise e
            | x::xs =>  if x = c andalso not isfound
                        then remove_card (xs, true, rsf)
                        else remove_card (xs, isfound, rsf @ [x])
    in
        remove_card (cs, false, [])
    end


(* Card-List -> Boolean *)
(* returns true if all the cards in the list are the same color, otherwise false *)
fun all_same_color cs =
    case cs of
        [] => true
        | head::[] => true
        | head::neck::rest => (card_color head = card_color neck) andalso all_same_color (neck::rest)


(* Card-List -> Int *)
(* returns the sum of card values from the given list of card *)
fun sum_cards cs =
    let
        fun sum_cards (cardlist, rsf) =
            case cardlist of
                [] => rsf
                | x::xs => sum_cards (xs, rsf + card_value x)
    in
        sum_cards (cs, 0)
    end


(* Card-List Int -> Int *)
(* calculate score *)
fun score (heldcardlst, goal) =
    let
        val sum = sum_cards heldcardlst
        val preliminary_score = if sum > goal
                                then 3 * (sum - goal)
                                else (goal - sum)
        val get_score = if all_same_color heldcardlst
                        then preliminary_score div 2
                        else preliminary_score
    in
        get_score
    end


(* Card-List Move-List Int -> Int *)
(* returns the score at the end of the game after processing (some or all of) the moves in the move list in order *)
fun officiate (cardlst, movelst, goal) =
    let
        (* Card-List Move-List Card-List -> Int *)
        fun continue (cardlst, movelst, held_cards) =
            if sum_cards (held_cards) > goal
            then score (held_cards, goal)
            else
                case (movelst, cardlst) of
                      ([], _)                                   => score (held_cards, goal)
                    | (Draw :: restmovelst, [])                 => score (held_cards, goal)
                    | (Draw :: restmovelst, crd :: restcardlst) => continue (restcardlst, restmovelst, crd :: held_cards)
                    | (Discard c :: restmovelst, _)             => continue (cardlst, restmovelst, remove_card (held_cards, c, IllegalMove))
    in
        continue (cardlst, movelst, [])
    end
