import 'package:ai_project/tmp/evaluate.dart';

import '/tmp/config.dart';

import 'utils.dart';

// p1 : +v
// p2 : -v

// 3
// 2
// 1

// fromRow, fromCol, toRow, toCol

double evaluate(Map gametstate, int player) {
  List<List<List>> board = gametstate["board"];
  var score = 0.0;
  var checkingCondition = player == 1 ? (x) => x > 0 : (x) => x < 0;
  score += evaluateRows(board, player);
  score += evaluateColumns(board, player);
  return score;
}

Map<String, dynamic> applyMove(gamestate, player, move) {
  Map<String, dynamic> newGameState =
      getGameState(gamestate["board"], gamestate["p1"], gamestate["p2"]);
  switch (move["type"]) {
    case "play":
      // pop @ index from player
      // move the piece
      // push it to the board
      // create a new state
      // return it
      final p = player == 1 ? "p1" : "p2";
      newGameState["board"][move["toRow"]][move["toCol"]]
          .add(newGameState[p][move["index"]].last);
      newGameState[p][move["index"]].removeLast();

      return newGameState;
    case "move":
      //
      // pop form board
      // push to board
      //
      newGameState["board"][move["toRow"]][move["toCol"]]
          .add(newGameState["board"][move["fromRow"]][move["fromCol"]].last);
      newGameState["board"][move["fromRow"]][move["fromCol"]].removeLast();

      return newGameState;
    default:
      throw Exception("move type ERR");
  }
}

Map minimax(Map<String, dynamic> gamestate, bool maximizer, int depth, mv) {
  // printToFile(gamestate["board"]);
  late int plr = maximizer ? 2 : 1;

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

  final time = (DateTime.now());
  kprint(minimax(gameState, !true, Config.depth, null));

  kprint((DateTime.now().subtract(Duration(
      minutes: time.minute,
      seconds: time.second,
      microseconds: time.millisecond))));
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
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0]
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