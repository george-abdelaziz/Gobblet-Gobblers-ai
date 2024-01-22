import 'dart:math';

import 'package:ai_project/agents/config.dart';
import 'package:ai_project/agents/utils.dart';

int weight = 1;
double evaluate(Map gametstate, int player) {
  List<List<List>> board = gametstate["board"];
  var score = 0.0;

  if (isWinningPos(board)) {
    return Config.winning;
  }

  score += evaluateRows(board, player);
  score += evaluateColumns(board, player);
  // score += evaluateDiagonals(board, player);
  return score;
}

int evaluateRows(List<List<List>> board, int player) {
  // return 0;
  int finalScore = 0;

  for (var row in board) {
    finalScore += evalRow(row, player);
  }

  return finalScore;
}

int evaluateColumns(List<List<List>> board, int player) {
  int finalScore = 0;

  for (int col = 0; col < 4; col++) {
    int empty = 0;
    int sumPos = 0;
    int sumNeg = 0;
    int maxP = 0;
    int maxN = 0;
    int nPos = 0;
    int nNeg = 0;

    for (int row = 0; row < 4; row++) {
      int piece = board[row][col].last;

      if (piece == 0) {
        empty++;
      } else if (piece > 0) {
        nPos++;
        sumPos += piece;
        maxP = max(piece, maxP);
      } else {
        sumNeg += piece.abs();
        maxN = max(maxN, piece.abs());
      }
    }
    finalScore +=
        analysis(player, nNeg, nPos, maxN, maxP, empty, sumPos, sumNeg);
  }

  return finalScore;
}

int evaluateDiagonals(List<List<List>> board, int player) {
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
    finalScore += mainDiagonalPosPieces * weight + mainDiagonalEmptyBoxScore;
  } else {
    if (mainDiagonalMinPieces < mainDiagonalMaxPieces) {
      return 0;
    }
    finalScore += mainDiagonalNegPieces * weight + mainDiagonalEmptyBoxScore;
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
    finalScore += otherDiagonalPosPieces * weight + otherDiagonalEmptyBoxScore;
  } else {
    if (otherDiagonalMinPieces < otherDiagonalMaxPieces) {
      return 0;
    }
    finalScore += otherDiagonalNegPieces * weight + otherDiagonalEmptyBoxScore;
  }

  return finalScore;
}

int evalRow(row, int player) {
  int empty = 0;
  int sumPos = 0;
  int sumNeg = 0;
  int nPos = 0;
  int nNeg = 0;
  int maxP = 0;
  int maxN = 0;

  for (int i = 0; i < 4; i++) {
    int piece = row[i].last;
    if (piece == 0) {
      empty++;
    } else if (piece > 0) {
      sumPos += piece;
      maxP = max(piece, maxP);
      nPos++;
    } else {
      sumNeg += piece.abs();
      maxN = max(piece.abs(), maxN);
      nNeg++;
    }
  }
  return analysis(player, nNeg, nPos, maxN, maxP, empty, sumPos, sumNeg);
}

int analysis(int player, int nNeg, int nPos, int maxN, int maxP, int empty,
    int sumPos, int sumNeg) {
  if (player == 1) {
    if (nNeg == 3) return 0;
    if (maxN >= maxP) return 0;
    return sumPos + empty;
  } else {
    if (nNeg == 3) return 0;
    if (maxN >= maxP) return 0;
    // if (nPos == 3) return Config.danger;
    // if (maxN <= maxP) return 50;
    return sumNeg + empty;
  }
}
