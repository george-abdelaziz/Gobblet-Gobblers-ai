import 'package:ai_project/agents/evaluate.dart';

import 'config.dart';
import 'utils.dart';

// p1 : +v
// p2 : -v
// 4
// 3
// 2
// 1

// fromRow, fromCol, toRow, toCol
double minimax(Map<String, dynamic> gamestate, bool maximizer, int depth) {
  final int plr = maximizer ? 2 : 1;

  if (depth == 0) {
    return evaluate(gamestate, plr);
  }

  if (isWinningPos(gamestate['board'])) {
    return Config.winning;
  }

  List<dynamic> candidateMoves = genMoves(plr, gamestate);

  if (candidateMoves.isEmpty) {
    return Config.draw;
  }

  double score = maximizer ? double.negativeInfinity : double.infinity;

  for (var i = 0; i < candidateMoves.length; i++) {
    var move = candidateMoves[i];
    var newGameState = applyMove(gamestate, plr, move);
    // var v = 0.0;
    var v = minimax(newGameState, !maximizer, depth - 1);

    if (maximizer) {
      score = (v > score) ? v : score;
    } else {
      score = (v < score) ? v : score;
    }
  }
  return score;
}

Map calcBestMove(Map gamestate, int plr) {
  bool maximizer = true;
  double score = 0;
  Map bestMove = {};
  List<dynamic> candidateMoves = genMoves(plr, gamestate);
  // kprint(candidateMoves);

  for (var i = 0; i < candidateMoves.length; i++) {
    var move = candidateMoves[i];
    var newGameState = applyMove(gamestate, plr, move);
    var v = minimax(newGameState, !maximizer, Config.depth - 1);
    if (v > score) {
      score = v;
      bestMove = move;
    }
  }
  bestMove["score"] = score;
  return bestMove;
}

void main(List<String> args) {
  final p1 = [
    [1, 2, 3, 4],
    [1, 2, 3, 4],
    [1, 2, 3, 4],
  ];
  final p2 = [
    [-1, -2, -3, -4],
    [-1, -2, -3, -4],
    [-1, -2, -3, -4],
  ];
  final board = [
    [
      [0, -4],
      [0, -1],
      [0, -3],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0, -4]
    ]
  ];
  Map<String, dynamic> gamestate = getGameState(board, p1, p2);
  kprint(calcBestMove(gamestate, 1));
  return;
}

// final board = [
//   [ [0, -4], [0], [0], [0, -2] ],
//   [ [0], [0,-2], [0], [0] ],
//   [ [0], [0], [0,-3], [0] ],
//   [ [0], [0, -4], [0], [0, -1] ]
// ];