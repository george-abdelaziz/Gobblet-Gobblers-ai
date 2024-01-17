import 'dart:io';
import 'dart:math';

// p1 : +v
// p2 : -v

// 3
// 2
// 1

// fromRow, fromCol, toRow, toCol
final File file = File("temp.txt");
printBoard(board) async {
  if (board == null) return;
  await file.writeAsString("========================\n", mode: FileMode.append);
  for (var row in board) {
    for (var col in row) {
      await file.writeAsString("${col.last}, ", mode: FileMode.append);
    }
    await file.writeAsString("\n", mode: FileMode.append);
  }
}

int evaluate(Map gametstate, int player) {
  List<List<List>> board = gametstate["board"];
  List<List> p1 = gametstate["p1"];
  List<List> p2 = gametstate["p2"];
  var squareDomination = 0;
  if (player == 1) {
    for (List<List> row in board) {
      for (List col in row) {
        if (col[col.length - 1] > 0) {
          squareDomination += col[col.length - 1] as int;
        }
      }
    }
  } else {
    for (List<List> row in board) {
      for (List col in row) {
        if (col[col.length - 1] < 0) {
          squareDomination += (col[col.length - 1] as int) * -1;
        }
      }
    }
  }
  return squareDomination;
  // return Random(DateTime.now().second.toInt()).nextDouble() * 50;
}

void pop(List list) {
  list.removeLast();
}

Map<String, dynamic> applyMove(gamestate, player, move) {
  Map<String, dynamic> newGameState =
      getGameState(gamestate["board"], gamestate["p1"], gamestate["p2"]);
  switch (move["type"]) {
    case "play":
      // pop @ index
      // move the piece
      // create a new state
      // return it
      if (player == 1) {
        newGameState["board"][move["toRow"]][move["toCol"]] =
            newGameState["p1"][move["index"]];
        newGameState["p1"][move["index"]].removeLast();
      } else {
        newGameState["board"][move["toRow"]][move["toCol"]]
            .add(newGameState["p2"][move["index"]].last);
        ;
        newGameState["p2"][move["index"]].removeLast();
      }
      return newGameState;
    case "move":
      break;
    default:
      print("applymove error");
  }
  return {};
}

Map<String, List> getGameState(
    List<List<List>> board, List<List> p1, List<List> p2) {
  return {
    "board": copyBoard(board),
    "p1": copyPlayer(p1),
    "p2": copyPlayer(p2)
  };
}

List genMoves(int player, gamestate) {
  final List<List<List>> sboard = gamestate["board"];
  List<List> pset = gamestate["p1"];
  List<Map> candidateMoves = [];
  if (player < 0) {
    pset = gamestate["p2"];
  }
  for (int i = 0; i < 3; i++) {
    if (pset[i].isNotEmpty) {
      for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 4; col++) {
          if (validateMove()) {
            candidateMoves
                .add({"type": "play", "index": i, "toRow": row, "toCol": col});
          }
        }
      }
    }
  }
  for (int row = 0; row < 4; row++) {
    for (int col = 0; col < 4; col++) {
      // TODO: get the top most piecse instead
      if (sboard[row][col].isEmpty) continue;
      if (player > 0 ? sboard[row][col][0] > 0 : sboard[row][col][-1] < 0) {
        for (int row2 = 0; row2 < 4; row2++) {
          for (int col2 = 0; col2 < 4; col2++) {
            if (validateMove()) {
              // candidateMoves.add({
              //   "type": "move",
              //   "fromRow": row,
              //   "fromCol": col,
              //   "toRow": row2,
              //   "toCol": col2
              // });
            }
          }
        }
      }
    }
  }
  return candidateMoves;
}

bool validateMove() {
  return true;
}

Future<int> minimax(gamestate, bool maximizer, int depth) async {
  await printBoard(gamestate["board"]);
  print(gamestate["p1"]);
  print(gamestate["p2"]);
  int plr = maximizer ? 2 : 1;

  if (depth == 0) {
    return evaluate(gamestate, plr);
  }
  List candiateMoves = genMoves(plr, gamestate);

  // TODO: CheckWining
  int score = evaluate(gamestate, maximizer ? 2 : 1);

  if (maximizer) {
    for (var move in candiateMoves) {
      var newgameState = applyMove(gamestate, maximizer ? 2 : 1, move);
      int v = await minimax(newgameState, !maximizer, depth - 1);
      score = max(v, score);
    }
  } else {
    for (var move in candiateMoves) {
      var newgameState = applyMove(gamestate, maximizer ? 2 : 1, move);
      int v = await minimax(newgameState, !maximizer, depth - 1);
      score = min(v, score);
    }
  }
  // print(score);
  return score;
}

calcBestMove(List<List<List>> board, List<List> p1, List<List> p2) async {
  Map gameState = getGameState(board, p1, p2);
  minimax(gameState, true, 3);
}

List<List> copyPlayer(List<List> original) {
  return original.map((row) => List<int>.from(row)).toList();
}

List<List<List>> copyBoard(List<List<List>> original) {
  return original
      .map((row) => row.map((col) => List.from(col)).toList())
      .toList();
}

dynamic top(List<dynamic> g) {
  return g.isNotEmpty ? g[g.length] : null;
}

void main(List<String> args) {
  final p1 = [
    [4, 3, 2, 1],
    [4, 3, 2, 1],
    [4, 3, 2, 1],
  ];
  final p2 = [
    [-4, -3, -2, -1],
    [-4, -3, -2, -1],
    [-4, -3, -2, -1],
  ];
  final board = [
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
