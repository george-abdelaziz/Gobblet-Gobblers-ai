import 'dart:math';

import '/tmp/utils.dart';

int evaluateRows(List<List<List>> board, int player) {
  int finalScore = 0;
  evalRow(row) {
    int localScore = 0;
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
      localScore = posPieces * 10 + emptyBoxScore;
    } else {
      if (minPieces < maxPieces) return 0;
      localScore = negPieces * 10 + emptyBoxScore;
    }
    return localScore;
  }

  for (var row in board) {
    finalScore += evalRow(row);
  }

  return finalScore;
}

int evaluateColumns(List<List<List>> board, int player) {
  int finalScore = 0;

  for (int col = 0; col < 4; col++) {
    int emptyBoxScore = 0;
    int posPieces = 0;
    int negPieces = 0;
    int maxPieces = 0;
    int minPieces = 0;

    for (int row = 0; row < 4; row++) {
      int piece = board[row][col].last;

      if (piece == 0) {
        emptyBoxScore++;
      } else if (piece > 0) {
        posPieces += piece;
        maxPieces = (piece > maxPieces) ? piece : maxPieces;
      } else {
        negPieces += piece.abs();
        minPieces = (piece.abs() > minPieces) ? piece.abs() : minPieces;
      }
    }

    if (player == 1) {
      if (minPieces > maxPieces) {
        return 0;
      }
      finalScore += posPieces * 10 + emptyBoxScore;
    } else {
      if (minPieces < maxPieces) {
        return 0;
      }
      finalScore += negPieces * 10 + emptyBoxScore;
    }
  }

  return finalScore;
}

int evaluateDiagonals(List<List<List<int>>> board, int player) {
  int finalScore = 0;

  // Main diagonal
  int mainDiagonalEmptyBoxScore = 0;
  int mainDiagonalPosPieces = 0;
  int mainDiagonalNegPieces = 0;
  int mainDiagonalMaxPieces = 0;
  int mainDiagonalMinPieces = 0;

  for (int i = 0; i < 4; i++) {
    int piece = board[i][i][0];

    if (piece == 0) {
      mainDiagonalEmptyBoxScore++;
    } else if (piece > 0) {
      mainDiagonalPosPieces += piece;
      mainDiagonalMaxPieces =
          (piece > mainDiagonalMaxPieces) ? piece : mainDiagonalMaxPieces;
    } else {
      mainDiagonalNegPieces += piece.abs();
      mainDiagonalMinPieces = (piece.abs() > mainDiagonalMinPieces)
          ? piece.abs()
          : mainDiagonalMinPieces;
    }
  }

  if (player == 1) {
    if (mainDiagonalMinPieces > mainDiagonalMaxPieces) {
      return 0;
    }
    finalScore += mainDiagonalPosPieces * 10 + mainDiagonalEmptyBoxScore;
  } else {
    if (mainDiagonalMinPieces < mainDiagonalMaxPieces) {
      return 0;
    }
    finalScore += mainDiagonalNegPieces * 10 + mainDiagonalEmptyBoxScore;
  }

  // Other diagonal
  int otherDiagonalEmptyBoxScore = 0;
  int otherDiagonalPosPieces = 0;
  int otherDiagonalNegPieces = 0;
  int otherDiagonalMaxPieces = 0;
  int otherDiagonalMinPieces = 0;

  for (int i = 0; i < 4; i++) {
    int piece = board[i][3 - i][0];

    if (piece == 0) {
      otherDiagonalEmptyBoxScore++;
    } else if (piece > 0) {
      otherDiagonalPosPieces += piece;
      otherDiagonalMaxPieces =
          (piece > otherDiagonalMaxPieces) ? piece : otherDiagonalMaxPieces;
    } else {
      otherDiagonalNegPieces += piece.abs();
      otherDiagonalMinPieces = (piece.abs() > otherDiagonalMinPieces)
          ? piece.abs()
          : otherDiagonalMinPieces;
    }
  }

  if (player == 1) {
    if (otherDiagonalMinPieces > otherDiagonalMaxPieces) {
      return 0;
    }
    finalScore += otherDiagonalPosPieces * 10 + otherDiagonalEmptyBoxScore;
  } else {
    if (otherDiagonalMinPieces < otherDiagonalMaxPieces) {
      return 0;
    }
    finalScore += otherDiagonalNegPieces * 10 + otherDiagonalEmptyBoxScore;
  }

  return finalScore;
}
