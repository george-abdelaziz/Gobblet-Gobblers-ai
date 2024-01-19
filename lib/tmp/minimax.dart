import 'package:ai_project/tmp/evaluate.dart';

import '/tmp/config.dart';

import 'utils.dart';

// p1 : +v
// p2 : -v
// 4
// 3
// 2
// 1

// fromRow, fromCol, toRow, toCol

Map minimax(Map<String, dynamic> gamestate, bool maximizer, int depth, mv) {
  final int plr = maximizer ? 2 : 1;

  if (depth == 0) {
    return {
      "score": evaluate(gamestate, plr),
      "status": "TheGameIsOn",
      "move": mv
    };
  }

  Map res = {};
  List<dynamic> candidateMoves = genMoves(plr, gamestate);

  if (candidateMoves.isEmpty) {
    return {"score": Config.draw, "status": "draw", "move": mv};
  }

  double score = maximizer ? double.negativeInfinity : double.infinity;

  for (var moveIndex = 0; moveIndex < candidateMoves.length; moveIndex++) {
    var move = candidateMoves[moveIndex];
    var newGameState = applyMove(gamestate, plr, move);
    if (isWinningPos(newGameState['board'])) {
      return {
        "score": Config.winning,
        "status": "player $plr Won",
        "move": move
      };
    }
    res = minimax(newGameState, !maximizer, depth - 1, move);
    var v = res["score"];

    if (maximizer) {
      score = (v > score) ? v : score;
    } else {
      score = (v < score) ? v : score;
    }
  }
  res["score"] = score;
  return res;
}

calcBestMove(List<List<List>> board, List<List> p1, List<List> p2) {
  Map<String, dynamic> gameState = getGameState(board, p1, p2);

  kprint(minimax(gameState, !true, Config.depth, null));

  // final time = (DateTime.now());
  // kprint((DateTime.now().subtract(Duration(
  //     minutes: time.minute,
  //     seconds: time.second,
  //     microseconds: time.millisecond))));
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
      [0, -3],
      [0, 1],
      [0],
      [0, -2]
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
      [0, -1],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0, -4]
    ]
  ];
  calcBestMove(board, p1, p2);
  return;
}

  // final board = [
  //   [ [0, -4], [0], [0], [0, -2] ],
  //   [ [0], [0,-2], [0], [0] ],
  //   [ [0], [0], [0,-3], [0] ],
  //   [ [0], [0, -4], [0], [0, -1] ]
  // ];