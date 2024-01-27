import 'dart:math';

import 'package:ai_project/agents/config.dart';
import 'package:ai_project/agents/utils.dart';

// row,col
int weight = 1;
double evaluate(Map gametstate, int player) {
  double score = 0;
  double pos = 0;
  double neg = 0;
  double npos = 1;
  double nneg = 1;
  double netPos = 0;
  double netNeg = 0;
  for (int i = 0; i < 4; i++) {
    for (int ii = 0; ii < 4; ii++) {
      if (gametstate['board'][i][ii].last > 0) {
        pos += gametstate['board'][i][ii].last;
        npos *= 10;
      } else if (gametstate['board'][i][ii].last < 0) {
        neg += gametstate['board'][i][ii].last;
        nneg *= 10;
      }
    }
    netPos += pos * npos;
    netNeg += neg * nneg;
    npos = 1;
    nneg = 1;
    pos = 0;
    neg = 0;
  }
  for (int i = 0; i < 4; i++) {
    if (gametstate['board'][i][i].last > 0) {
      pos += gametstate['board'][i][i].last;
      npos *= 10;
    } else if (gametstate['board'][i][i].last < 0) {
      neg += gametstate['board'][i][i].last;
      nneg *= 10;
    }
  }
  netPos += pos * npos;
  netNeg += neg * nneg;
  npos = 1;
  nneg = 1;
  pos = 0;
  neg = 0;
  for (int i = 0; i < 4; i++) {
    if (gametstate['board'][i][3 - i].last > 0) {
      pos += gametstate['board'][i][3 - i].last;
      npos *= 10;
    } else if (gametstate['board'][i][3 - i].last < 0) {
      neg += gametstate['board'][i][3 - i].last;
      nneg *= 10;
    }
  }
  netPos += pos * npos;
  netNeg += neg * nneg;
  score = netPos + netNeg;
  return score;
}

double evaluate2(Map gametstate, int player) {
  List<List<List>> board = gametstate["board"];
  var score = 0.0;

  if (isWinningPos(board) != 0) {
    return Config.winning;
  }

  score += evaluateRows(board, player);
  score += evaluateColumns(board, player);
  score += evaluateDiagonals(board, player);
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

  // // Main diagonal
  int empty = 0;
  int sumPos = 0;
  int sumNeg = 0;
  int maxP = 0;
  int maxN = 0;
  int nPos = 0;
  int nNeg = 0;

  for (int i = 0; i < 4; i++) {
    int piece = board[i][i].last;
    if (piece == 0) {
      empty++;
    } else if (piece > 0) {
      sumPos += piece;
      nPos++;
      maxP = max(maxP, piece);
    } else {
      sumNeg += piece.abs();
      nNeg++;
      maxN = max(piece.abs(), maxN);
    }
  }
  finalScore += analysis(player, nNeg, nPos, maxN, maxP, empty, sumPos, sumNeg);

  // Other diagonal
  empty = 0;
  sumPos = 0;
  sumNeg = 0;
  maxP = 0;
  maxN = 0;
  nPos = 0;
  nNeg = 0;

  for (int i = 0; i < 4; i++) {
    int piece = board[i][3 - i][0];

    if (piece == 0) {
      empty++;
    } else if (piece > 0) {
      sumPos += piece;
      maxP = (piece > maxP) ? piece : maxP;
    } else {
      sumNeg += piece.abs();
      maxN = (piece.abs() > maxN) ? piece.abs() : maxN;
    }
  }
  finalScore += analysis(player, nNeg, nPos, maxN, maxP, empty, sumPos, sumNeg);
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
    if (maxN > maxP) return 0;
    return sumPos + empty;
  } else {
    if (maxN > maxP) return 0;
    return sumNeg + empty;
  }
}
