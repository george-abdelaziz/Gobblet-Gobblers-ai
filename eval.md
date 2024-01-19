## 3.4 Heuristic evaluation function

- Since minimax is an extremely accurate algorithm even with alpha-beta cutting, they are only rare games simple enough that it is possible to explore all the possibilities to win or defeat.

- Therefore, it is necessary to limit the inspection of the tree to a certain depth and assess whether the tiles at this depth are good or bad. This rating is essential as well the computer will play. Last but not least, it's not useful to go through a tree of 20 moves further, if at this depth it is estimated that the slab is favorable, when in reality it is defeated. A good heuristic estimation function should estimate the slab more like a true evaluation function.
- This means higher values for Tiles that lead to victory, around zero for a draw and negative values for tiles that lead to defeat.
- It is also mandatory that the evaluation of the plate is fast operation, as its purpose is only to speed up the search for the beet position. In order to construct a good heuristic evaluation function, a good knowledge of in the domain of our game, so there is no universal recipe that works for every game. However, the basic principle of weighting can often be used in composition linear functions [22]:
  (3.1)
  $$eval(s) =  \sum^n_{i=1} w_if_i(s)$$
  Where s is the state of the board we are evaluating, i are the individual figures on the board, $w_i$ is the weight assigned to figure i, and $f_i$ is its function on the plate.
- For more complex game, the weakness of the weighted linear function is that it assumes the independence of the contributions of different figures. Therefore, to improve the assessment, it is often it also uses a non-linear combination of functions.
- In the example of the Gobblet game, we chose its size as the weight of the figure $w_i$, because empirically, larger figures proved to be much stronger, because smaller ones did not they can cover and thus keep their position on the board. Their function is $f_i$ smo determinations based on the type for which the position is to be assessed.
- More of the same figure in a line, is a good predictor of more successful records.
- Heuristic board evaluation for Gobblet We used the same heuristic evaluation for Gobblet 3 × 3 and Gobblet 4 × 4 function. This was possible because the smallest size of the figure is equal to 1, the largest is equal to one dimension of the tile, i.e. 3 for a 3 × 3 game and 4 for a 4 × 4 game.
- This function could also be used for evaluating larger panels, for a larger hypothetical a game of Gobblet, like say 5×5. The function selects rows by which three or four can be placed in a row (at 4 × 4 game).
- These are all vertical, all horizontal and both diagonals.
- For every its figures are checked separately for each type, then we evaluate them accordingly and agree to the overall assessment of the board.
- The rating of a type is made up of its weight by the figure it represents piece size and the number of pieces of one player in that row.
- Grade sign of one type determines whether it is a player M maximizer or a player M minimzer . An actor M maximizer has a positive sign and player M minimzer has a negative sign. So after all Based on the calculated score, we can see which player is to our liking rate the winner on this board.
- The course of evaluation on the 3 × 3 board is as follows:

  - There are a total of 8 directions, where 3 in a row can be reached. For each of these types, it is necessary to check:

    - If there are 3 in a row for the M maximizer player, it means the end of the game, the score is maximum positive value. **winning pos**
    - If there are 3 in a row for M AND a player, it means the end of the game, the score is minimum negative value. **Losing pos**
    - If there are only pieces in the direction for player M maximizer applies: 
        - Each empty field in a row is scored 1.
        - For each smallest top figure of size 1 on the course, the score is 10.
        - For each larger figure, its estimate consists of i ∗ 10, where i, its size (1, 2 or 3).
        - The final grade of one course is the sum of the grades of all three fields.
    - If the pieces of both players M maximizer and M minimzer are on the direction, then
    - If the player's pieces are M IN , they are less than the available pieces outside player M AKS tiles, then in the same way as we evaluate above player figures M AKS.
    - otherwise, the type rating is 0.
        - For player M AND player pieces, the direction score is calculated to be equal to for player M AKS, and the value is negative.
        - The final grade of the board is the sum of all directions.  Determining the heuristic evaluation on the example

V