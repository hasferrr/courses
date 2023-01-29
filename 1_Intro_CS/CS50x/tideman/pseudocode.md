3 0
0 1'
2 0'
1 2 <-----(cycle) win=1, lose=2
3 1
3 2


```c
bool cycle_check(int win=1, int lose=2,, int i_cycle = 1, int j_cycle = 2) 1-2
{
    for (int i = 0; i < candidate_count; i++)
        if (lose=2 == i=0)
            continue
        else if (locked[lose=2][i=0]==true)
            return cycle(lose=2, i=0, i_cycle, j_cycle)
    if
}

bool cycle_check(int win=2, int lose=0,, int i_cycle = 1, int j_cycle = 2) 2-0
{
    for (int i = 0; i < candidate_count; i++)
        if (lose=0 == i=0--cont-->``````1``````)
            continue
        else if (locked[lose=0][i= 1 ]==true)
            return cycle(lose=0, i=1, i_cycle, j_cycle)

bool cycle_check(int win=0, int lose=1,, int i_cycle = 1, int j_cycle = 2) 0-1
{
    for (int i = 0; i < candidate_count; i++)
        if (lose=1 == i=0)
            continue
        else if (locked[lose=1][i=0]==true) =======> FALSE-> i=1, cont {lose=1; i = 2}
            return cycle(lose=1, i=0, i_cycle, j_cycle)
        else if (lose == i_cycle && i == j_cycle)
            return false
}}
```

=====================================================================================
3 0 = true
0 1 = true
2 0
1 2
3 1
3 2

```c
bool cycle_check(int win, int lose,, int i_cycle, int j_cycle) win 2, lose 0
    for (int i = 0; i < candidate_count; i++)
        if (lose = 0    ==    i = 1)
            continue
        else if (locked[lose = 0][i = 1] == true)
            return cycle(lose, i, i_cycle, j_cycle)
        else if (lose == i_cycle && i == j_cycle)
            return false
    return true


bool cycle_check(int win, int lose,, int i_cycle, int j_cycle) win 0, lose 1
    for (int i = 0; i < candidate_count; i++)
        if (lose = 1    ==    i = 3)
            continue
        else if (locked[lose = 1][i = 3] == true) F F
            return cycle(lose, i, i_cycle, j_cycle)
        else if (lose == i_cycle && i == j_cycle)
            return false
    return true // iya return









final pairs ?

lockPairs skips final pair if it creates cycle

false TRUE false false false false
false false false false TRUE false
false false false false false false
false false false false false TRUE
false false TRUE TRUE false false
false [false] false false false false




wrong answer = TRUE













```c
cycle(win, lose){
// base case
if (locked[lose][win])
    return false

// recursive case
for (i in c_count)
    if (locked[lose][i])
        cycle(lose, i)

return true
```
















orek2




Backup print2 an sort

```c
void sort_pairs(void)
{
    // prprprprprpr
    for (int i = 0; i < pair_count; i++)
    {
        printf("(%i, %i)", pairs[i].winner, pairs[i].loser);
    }
        printf("\n");
}
```

```bash
(0, 1)(0, 2)(0, 3)(2, 1)(1, 3)(2, 3)
(0, 3)(1, 3)(0, 1)(0, 2)(2, 1)(2, 3)
```