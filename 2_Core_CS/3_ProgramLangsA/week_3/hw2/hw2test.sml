(* Homework2 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "hw2.sml";

val test1_ = all_except_option ("a", []) = NONE
val test1a = all_except_option ("a", ["a"]) = SOME []
val test1z = all_except_option ("a", ["z"]) = NONE
val test1b = all_except_option ("a", ["q","w","e"]) = NONE
val test1c = all_except_option ("a", ["q","w","a","p"]) = SOME ["q","w","p"]
val test1d = all_except_option ("a", ["a","w","a","p"]) = SOME ["w","p"]
val test1e = all_except_option ("a", ["dsa","qwe"]) = NONE
val test1f = all_except_option ("Fred", ["Fred","Fredrick"]) = SOME ["Fredrick"]
;


val test2a = get_substitutions1 ([["foo"],["there"]], "foo") = []

val test2b = get_substitutions1 ([["Fred","Fredrick"],
                                  ["Elizabeth","Betty"],
                                  ["Freddie","Fred","F"]], "Fred")
                                  = ["Fredrick","Freddie","F"]

val test2c = get_substitutions1 ([["Fred","Fredrick"],
                                  ["Jeff","Jeffrey"],
                                  ["Geoff","Jeff","Jeffrey"]], "Jeff")
                                  = ["Jeffrey","Geoff","Jeffrey"]
;


val test3z = get_substitutions2 ([], "") = []

val test3a = get_substitutions2 ([["foo"],["there"]], "foo") = []

val test3b = get_substitutions2 ([["Fred","Fredrick"],
                                  ["Elizabeth","Betty"],
                                  ["Freddie","Fred","F"]], "Fred")
                                  = ["Fredrick","Freddie","F"]

val test3c = get_substitutions2 ([["Fred","Fredrick"],
                                  ["Jeff","Jeffrey"],
                                  ["Geoff","Jeff","Jeffrey"]], "Jeff")
                                  = ["Jeffrey","Geoff","Jeffrey"]
;


val test4z = similar_names ([], (* --> [] *)
                            {first="Fred", middle="W", last="Smith"}) =
                            [{first="Fred", middle="W", last="Smith"}]

val test4y = similar_names ([["foo"],["there"]], (* --> [] *)
                            {first="foo", middle="W", last="Smith"}) =
                            [{first="foo", middle="W", last="Smith"}]

val test4a = similar_names ([["Fred","Fredrick"],
                             ["Elizabeth","Betty"],
                             ["Freddie","Fred","F"]], (* --> ["Fredrick","Freddie","F"] *)

                            {first="Fred", middle="W", last="Smith"}) =

                    	    [{first="Fred",     last="Smith",   middle="W"},
                             {first="Fredrick", last="Smith",   middle="W"},
                    	     {first="Freddie",  last="Smith",   middle="W"},
                             {first="F",        last="Smith",   middle="W"}]

val test4b = similar_names ([["Fred","Fredrick"],
                             ["Jeff","Jeffrey"],
                             ["Geoff","Jeff","Jeffrey"]], (* --> ["Jeffrey","Geoff","Jeffrey"] *)

                            {first="Jeff", middle="W", last="Smith"}) =

                            [{first="Jeff",     last="Smith",   middle="W"},
                             {first="Jeffrey",  last="Smith",   middle="W"},
                             {first="Geoff",    last="Smith",   middle="W"},
                             {first="Jeffrey",  last="Smith",   middle="W"}]
;

(* =============================================================================== *)

(* Spades and Clubs are black, Diamonds and Hearts are red) *)
val test5c2 = card_color (Clubs, Num 2)  = Black
val test5da = card_color (Diamonds, Ace) = Red
val test5h6 = card_color (Hearts, Num 6) = Red
val test5sj = card_color (Spades, Jack)  = Black
;

val test6q = card_value (Clubs, Num 2)  = 2
val test6w = card_value (Clubs, Num 3)  = 3
val test6r = card_value (Clubs, Num 4)  = 4
val test6t = card_value (Clubs, Num 5)  = 5
val test6y = card_value (Clubs, Num 6)  = 6
val test6u = card_value (Clubs, Num 7)  = 7
val test6i = card_value (Clubs, Num 8)  = 8
val test6o = card_value (Clubs, Num 9)  = 9
val test6p = card_value (Clubs, Num 10) = 10
val test6a = card_value (Clubs, Jack)   = 10
val test6s = card_value (Clubs, Queen)  = 10
val test6d = card_value (Clubs, King)   = 10
val test6f = card_value (Clubs, Ace)    = 11
;


val test7err1 = ((remove_card ([], (Hearts, Ace), IllegalMove));false) handle IllegalMove => true
val test7err2 = ((remove_card ([(Hearts, Ace),(Clubs, King)], (Hearts, Jack), IllegalMove));false) handle IllegalMove => true

val test7q = remove_card ([(Hearts, Ace)], (Hearts, Ace), IllegalMove) = []

val test7w = remove_card ([(Hearts, Ace),
                          (Clubs, King),
                          (Clubs, Num 4),
                          (Spades, Num 6)], (Hearts, Ace), IllegalMove)
                        = [(Clubs, King),
                           (Clubs, Num 4),
                           (Spades, Num 6)]

val test7e = remove_card ([(Hearts, Ace),
                          (Clubs, King),
                          (Clubs, Num 4),
                          (Spades, Num 6)], (Clubs, King), IllegalMove)
                        = [(Hearts, Ace),
                           (Clubs, Num 4),
                           (Spades, Num 6)]

val test7r = remove_card ([(Hearts, Ace),
                          (Clubs, King),
                          (Hearts, Ace),
                          (Spades, Num 6)], (Hearts, Ace), IllegalMove)
                        = [(Clubs, King),
                           (Hearts, Ace),
                           (Spades, Num 6)]
;


(* Spades and Clubs    are Black
   Diamonds and Hearts are Red   *)
val test8q = all_same_color [] = true
val test8w = all_same_color [(Hearts, Ace)] = true
val test8e = all_same_color [(Hearts, Ace), (Hearts, Ace)]    = true
val test8r = all_same_color [(Hearts, Ace), (Diamonds, Jack)] = true
val test8t = all_same_color [(Spades, Ace), (Spades, Ace)] = true
val test8y = all_same_color [(Clubs, King), (Spades, Ace)] = true
val test8u = all_same_color [(Clubs, Ace), (Spades, Jack), (Hearts, Ace)]  = false
val test8i = all_same_color [(Clubs, Ace), (Hearts, Ace), (Spades, King)]  = false
;


val test9q = sum_cards [] = 0
val test9w = sum_cards [(Clubs, Num 2),(Clubs, Num 2)] = 4
val test9e = sum_cards [(Clubs, Num 2),(Clubs, Num 4)] = 6
val test9r = sum_cards [(Clubs, Num 3),(Clubs, Num 6)] = 9
val test9t = sum_cards [(Clubs, Ace),(Clubs, Num 2)]   = 13
val test9y = sum_cards [(Clubs, Ace),(Clubs, Jack)]    = 21
val test9u = sum_cards [(Clubs, King),(Clubs, Queen)]  = 20
val test9i = sum_cards [(Clubs, Num 9),(Clubs, Jack)]  = 19
;


(* CALCULATE SCORE

sum = sum of cs

if sum > goal:
    preliminary_score = 3 x (sum - goal)
else :
    preliminary_score = (goal - sum)

if same color of the held card = True:
    preliminary_score = preliminary_score // 2 (integer division)
else:
    preliminary_score
*)
val test10z = score ([(Hearts, Num 2),(Clubs, Num 4)],10) = 4
val test10a = score ([], 100) = 50
val test10b = score ([(Hearts, Num 2), (Clubs, Num 4)], 10) = 4
val test10c = score ([(Hearts, Num 2), (Clubs, Num 4)], 5) = 3
val test10d = score ([(Hearts, Num 2), (Diamonds, Num 4)], 10) = 2
val test10e = score ([(Hearts, Num 10), (Diamonds, Num 4)], 10) = 6
;


(* ==========================

if movelst is empty orelse sum_cards(held_cards) > goal:
    End the game (---> count score)
else:
    continue


if Discard of card c:
    remove_card(c) from the held_cards

else if Draw:
    if cardlst is empty:
        End the game
    else:
        - removing the first cardlst --> (tinggal rest cardlst)
        - add too held_cards


datatype move = Discard of card | Draw

-> The game starts with the held_cards being the empty list.
-> The game ends if there are no more moves. (The player chose to stop since the move list is empty.)
-> If the player (discards) some card c, play continues (i.e., make a recursive call) with the held_cards not having c and the card-list unchanged. If c is not in the held_cards, raise the IllegalMove exception.
-> If the player (draws) and the card-list is (already) empty, the game is over. Else if drawing causes the sum of the held_cards to exceed the goal, the game is over (after drawing). Else play continues with a larger held_cards and a smaller card-list.


The player makes a move:
- drawing, which means removing the first card in the card-list from the card-list and adding it to the held_cards
- discarding, which means choosing one of the held_cards to remove.

The game ends either when
- the player chooses to make no more moves (move list = [])
- the (sum of the values of the held_cards) is greater than the (goal)

*)
val test11 = officiate ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6
val test12 = officiate ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                        [Draw,Draw,Draw,Draw,Draw],
                        42)
             = 3
val test13 = ((officiate([(Clubs,Jack),(Spades,Num(8))],
                         [Draw,Discard(Hearts,Jack)],
                         42);
               false) 
              handle IllegalMove => true)
;