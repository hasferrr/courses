#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Max number of candidates //////////////////////////////////////////
#define MAX 6

// preferences[i][j] is number of voters who prefer i over j
int preferences[MAX][MAX];

// locked[i][j] means i is locked in over j
bool locked[MAX][MAX];

// Each pair has a winner, loser
typedef struct
{
    int winner;
    int loser;
}
pair;

// Array of candidates
string candidates[MAX];
pair pairs[MAX * (MAX - 1) / 2];

int pair_count;
int candidate_count;

// Function prototypes



void lock_pairs(void);
void print_winner(void);
bool cycle(int win, int lose, int i_cycle_win, int j_cycle_lose);

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: tideman [candidate ...]\n");
        return 1;
    }

    // Populate array of candidates
    candidate_count = argc - 1;
    if (candidate_count > MAX)
    {
        printf("Maximum number of candidates is %i\n", MAX);
        return 2;
    }
    for (int i = 0; i < candidate_count; i++)
    {
        candidates[i] = argv[i + 1];
    }

    // Clear graph of locked in pairs
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = 0; j < candidate_count; j++)
        {
            locked[i][j] = false;
        }
    }


    //case 14:  //lock final pair test

    pair_count = 7;
    pairs[0].winner = 0; pairs[0].loser = 1;
    pairs[1].winner = 1; pairs[1].loser = 4;
    pairs[2].winner = 4; pairs[2].loser = 2;
    pairs[3].winner = 4; pairs[3].loser = 3;
    pairs[4].winner = 3; pairs[4].loser = 5;
    pairs[5].winner = 5; pairs[5].loser = 1;
    pairs[6].winner = 2; pairs[6].loser = 1;

    lock_pairs();
    print_winner();
    return 0;
}






// Lock pairs into the candidate graph in order, without creating cycles
void lock_pairs(void)
{
    for (int i = 0; i < pair_count; i++)
    {
        locked[pairs[i].winner][pairs[i].loser] = cycle(pairs[i].winner, pairs[i].loser, pairs[i].winner, pairs[i].loser);
    }
    return;
}

// Check cycle
bool cycle(int win, int lose, int i_cycle_win, int j_cycle_lose)
{
    bool returned = true;
    for (int i = 0; i < candidate_count; i++)
    {
        if (lose == i)
        {
            continue;
        }
        else if (locked[lose][i])
        {
            returned = returned && cycle(lose, i, i_cycle_win, j_cycle_lose);
        }
        else if ((lose == i_cycle_win) && (i == j_cycle_lose))
        {
            return false;
        }
    }
    return returned;
}









// Print the winner of the election
void print_winner(void)
{
    bool array_locked_check[candidate_count];
    bool bool_check;

    // Combine true/false in column locked[]
    for (int i = 0; i < candidate_count; i++)
    {
        bool_check = false;
        for (int j = 0; j < candidate_count; j++)
        {
            bool_check = bool_check || locked[j][i];
        }
        array_locked_check[i] = bool_check;
    }

    // Iterating, if false is found, print the winner
    for (int i = 0; i < candidate_count; i++)
    {
        if (array_locked_check[i] == false)
        {
            printf("%s\n", candidates[i]);
        }
    }
    return;
}