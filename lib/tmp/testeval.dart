import 'dart:math';

import 'utils.dart';

int evaluate(List<List<List<int>>> board, int player) {
  int finalScore = 0;

  return finalScore;
}

int evaluateRows(List<List<int>> row, int player) {
  int finalScore = 0;
  int emptyBoxScore = 0;
  int posPieces = 0;
  int negPieces = 0;
  int maxPieces = 0;
  int minPieces = 0;

  for (int i = 0; i < 4; i++) {
    int piece = row[i].last;
    if (piece == 0) {
      emptyBoxScore++;
    } else if (piece > 0) {
      posPieces += piece;
      maxPieces = max(piece, maxPieces);
    } else {
      negPieces += abs(piece);
      minPieces = max(piece, abs(minPieces));
    }
  }
  if (player == 1) {
    if (minPieces > maxPieces) return 0;
    finalScore = posPieces * 10 + emptyBoxScore;
  } else {
    if (minPieces < maxPieces) return 0;
    finalScore = negPieces * 10 + emptyBoxScore;
  }
  return finalScore;
}

int calculateScore(List<List<List<int>>> board, int player) {
  int finalScore = 0;

  // Iterate over each row
  for (int row = 0; row < 4; row++) {
    int emptyBoxScore = 0;
    int smallestTopFigureScore = 0;

    // Iterate over each column
    for (int col = 0; col < 4; col++) {
      int piece = board[row][col].last;

      if (piece == 0) {
        // For each empty box in the row, add a score of 1
        emptyBoxScore += 1;
      } else if (piece == player) {
        // For every smallest top figure of size 1, add a score of 10
        smallestTopFigureScore += 10;
      } else {
        // For each larger figure, its score is i * 10, where i is its size (1, 2, 3, 4)
        int pieceSize = board[row][col][1];
        int pieceScore = pieceSize * 10;

        // Adjust the score for player 2 (negative values)
        pieceScore = (player == 1) ? pieceScore : -pieceScore;

        // Add the score for the larger figure
        smallestTopFigureScore += pieceScore;
      }
    }

    // Add the final score for one direction
    finalScore += emptyBoxScore + smallestTopFigureScore;
  }

  // If both players have MAX and MIN pieces in the direction
  if (board.any((row) => row.any((cell) => cell[0] == 1)) &&
      board.any((row) => row.any((cell) => cell[0] == -1))) {
    int maxPlayerScore = calculateScore(board, 1);
    int minPlayerScore = calculateScore(board, -1);

    // If the MIN player's pieces are smaller than the available pieces outside the MAX player's board
    if (minPlayerScore < maxPlayerScore) {
      // Evaluate the MAX player's pieces as described above
      return maxPlayerScore;
    } else {
      // Otherwise, the species score is 0
      return 0;
    }
  }

  return finalScore;
}

void main() {
  List<List<List<int>>> board = [
    [
      [1, 1],
      [1, 2],
      [1, 3],
      [1, 4]
    ],
    [
      [-1, 1],
      [-1, 2],
      [-1, 3],
      [-1, 4]
    ],
    [
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0]
    ],
    [
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0]
    ],
  ];

  int maxPlayerScore = calculateScore(board, 1);
  print('Max Player Score: $maxPlayerScore');

  int minPlayerScore = calculateScore(board, -1);
  print('Min Player Score: $minPlayerScore');
}
