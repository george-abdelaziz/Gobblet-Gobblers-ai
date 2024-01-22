# Evaluation Process on a 4 × 4 Grid

- The evaluation process on a 4 × 4 grid involves considering 8 directions in which a player can achieve 3 in a row. For each of these rows, the following criteria are checked:

## 1. MAX Player Wins:

- If there are 4 in a row for a MAX player, the game concludes, and the rating is set to the maximum positive value.

## 2. MIN Player Wins:

- If there are 4 in a row for a MIN player, the game concludes, and the rating is set to the minimum negative value.

## 3. Scoring for MAX Player:

- If only the pawns are in the direction of the MAX player:
  - For each empty box in the row, a score of 1 is assigned.
  - For every smallest top piece of size 1, the score is 10.
  - For each larger piece, its score is i \* 10, where i is its size (1, 2, 3,or 4).
  - The final score for one direction is the sum of the scores for all three fields.

## 4. Both Players in the Direction:

- If both players have MAX and MIN pieces in the direction:
  - If the MIN player's pieces are smaller than the available pieces outside the MAX player's board:
    - Evaluate the MAX player's pieces as described above.
    - otherwise, the species score is 0.

## 5. Scoring for MIN Player:

- The direction estimate for the MIN player's pieces is calculated similarly to the MAX player, but the value is negative.

## 6. Final Area Estimate:

- The final estimate of the area is the sum of scores from all directions.
