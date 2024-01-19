import 'dart:async';

import 'package:ai_project/tmp/config.dart';

import 'utils.dart';

// p1 : +v
// p2 : -v

// 3
// 2
// 1

// fromRow, fromCol, toRow, toCol
Map bestMove = {};

double evaluate(Map gametstate, int player) {
  List<List<List>> board = gametstate["board"];
  List<List> p1 = gametstate["p1"];
  List<List> p2 = gametstate["p2"];
  var squareDomination = 0.0;
  var checkingCondition = player == 1 ? (x) => x > 0 : (x) => x < 0;
  for (List<List> row in board) {
    for (List col in row) {
      if (col.isEmpty) continue;
      if (checkingCondition(col[col.length - 1])) {
        squareDomination += col[col.length - 1] as int;
      }
      if (abs((col[col.length - 1] * 1.0)) == 4) {
        squareDomination += 0.9;
      }
    }
  }
  return squareDomination;
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

double minimax(Map<String, dynamic> gamestate, bool maximizer, int depth) {
  late int plr = maximizer ? 2 : 1;

  if (depth == 0) {
    return evaluate(gamestate, plr);
  }

  List<dynamic> candidateMoves = genMoves(plr, gamestate);

  if (candidateMoves.isEmpty) return -200; // TODO: handle this case

  double score = maximizer ? double.negativeInfinity : double.infinity;

  for (var moveIndex = 0; moveIndex < candidateMoves.length; moveIndex++) {
    var move = candidateMoves[moveIndex];
    var newGameState = applyMove(gamestate, plr, move);
    if (isWinningPos(gamestate['board'])) return Config.winning;
    var v = minimax(newGameState, !maximizer, depth - 1);

    if (maximizer) {
      if (v > score) {
        if (depth == 3) bestMove = move;
        score = v;
      }
    } else {
      if (v < score) {
        if (depth == 3) bestMove = move;
        score = v;
      }
    }
  }
  return score;
}

calcBestMove(List<List<List>> board, List<List> p1, List<List> p2) async {
  Map<String, dynamic> gameState = getGameState(board, p1, p2);

  final time = (DateTime.now());
  kprint(minimax(gameState, !true, Config.depth));
  kprint(bestMove);

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
      [0, -4],
      [0, -1],
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
  // print((isWinningPos(board)));
  print(odd);
  print(even);
  return;
}
