# Gobblet Gobblers

In this project, we will explore the game-playing of Gobblet, Gobblet is an abstract game played on a 4x4 grid with each of the two players having twelve pieces that can nest on top of one another to create three stacks of four pieces.
Your goal in Gobblet is to place four of your pieces in a horizontal, vertical, or diagonal row. Your pieces start nested off the board. On a turn, you either play one exposed piece from your three off-the-board piles or move one piece on the board to any other spot on the board where it fits. A larger piece can cover any smaller piece. A piece being played from off the board may not cover an opponent's piece unless it's in a row where your opponent has three of his coloa.
Your memory is tested as you try to remember which color one of your larger pieces is covering before you move it. As soon as a player has four like-colored pieces in a row, he wins — except in one case: If you lift your piece and reveal an opponent's piece that finishes a four-in-a-row, you don't immediately lose; you can't return the piece to its starting location, but if you can place it over one of the opponent's three other pieces in that row, the game continues..

## Components

- 16-square playing board
- 12 white Gobblets
- 12 black Gobblets

### Game rules: RULES OF THE GAME

- video: https://www.youtube.com/watch?v=aSaAjQY8_b0

## The GUI

The GUI support human vs. human, human vs. computer, and computer vs. computer gameplay.
The GUI includes the following main features:

1. Board: Display the current game board and the current pieces on the board.
2. Move input: Allow human players to input their moves by clicking on the board
3. Game status: Whose turn it is, and if the game is over.
4. Game options: Allow players to choose different game modes (e.g., human vs. human, human vs. computer, computer vs. computer), choose the AI player difficulty level (for each AI player), and start/restart a new game.
5. The Project can be built using any programming language and framework of your choice.

## Game Playing Algorithms

1. The minimax algorithm: a basic search algorithm that examines all possible moves from a given position and selects the move that leads to the best outcome for the current player
2. Alpha-beta pruning: an improvement on the minimax algorithm that can reduce the number of nodes that need to be searched.
3. Alpha-beta pruning with iterative deepening (depth is increased iteratively in the search tree until the timing constraints are violated)

## Heuristics

### Evaluation Process on a 4 × 4 Grid

- The evaluation process on a 4 × 4 grid involves considering 8 directions in which a player can achieve 3 in a row. For each of these rows, the following criteria are checked:

### 1. MAX Player Wins:

- If there are 4 in a row for a MAX player, the game concludes, and the rating is set to the maximum positive value.

### 2. MIN Player Wins:

- If there are 4 in a row for a MIN player, the game concludes, and the rating is set to the minimum negative value.

### 3. Scoring for MAX Player:

- If only the pawns are in the direction of the MAX player:
  - For each empty box in the row, a score of 1 is assigned.
  - For every smallest top piece of size 1, the score is 10.
  - For each larger piece, its score is i \* 10, where i is its size (1, 2, 3,or 4).
  - The final score for one direction is the sum of the scores for all three fields.

### 4. Both Players in the Direction:

- If both players have MAX and MIN pieces in the direction:
  - If the MIN player's pieces are smaller than the available pieces outside the MAX player's board:
    - Evaluate the MAX player's pieces as described above.
    - otherwise, the species score is 0.

### 5. Scoring for MIN Player:

- The direction estimate for the MIN player's pieces is calculated similarly to the MAX player, but the value is negative.

### 6. Final Area Estimate:

- The final estimate of the area is the sum of scores from all directions.
