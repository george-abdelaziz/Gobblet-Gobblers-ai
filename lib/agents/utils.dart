import 'dart:io';

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

List genMoves(int player, gamestate) {
  final List<List<List>> sboard = gamestate["board"];
  List<List> pset = player == 1 ? gamestate["p1"] : gamestate["p2"];
  bool checkCondition(x, r, c) =>
      (x == 1) ? sboard[r][c].last > 0 : (sboard[r][c].last < 0);
  List<Map> candidateMoves = [];

  for (int i = 0; i < 3; i++) {
    if (pset[i].isNotEmpty) {
      for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 4; col++) {
          final move = {"type": "play", "index": i, "toRow": row, "toCol": col};
          if (validateMove(move, player, gamestate)) {
            candidateMoves.add(move);
          }
        }
      }
    }
  }
  for (int row = 0; row < 4; row++) {
    for (int col = 0; col < 4; col++) {
      if (checkCondition(player, row, col)) {
        for (int row2 = 0; row2 < 4; row2++) {
          for (int col2 = 0; col2 < 4; col2++) {
            var move = {
              "type": "move",
              "fromRow": row,
              "fromCol": col,
              "toRow": row2,
              "toCol": col2
            };
            if (validateMove(move, player, gamestate)) {
              candidateMoves.add(move);
            }
          }
        }
      }
    }
  }

  return candidateMoves;
}

bool isWinningPos(List<List<List>> board) {
  // Check rows
  for (int row = 0; row < 4; row++) {
    if (board[row].every(
            (element) => element.last > 0) || // All elements are positive
        board[row].every((element) => element.last < 0)) {
      // All elements are negative
      return true;
    }
  }

  // Check columns
  for (int col = 0; col < 4; col++) {
    if (board.every((row) =>
            row[col].last > 0) || // All elements in the column are positive
        board.every((row) => row[col].last < 0)) {
      // All elements in the column are negative
      return true;
    }
  }
// Check diagonals
  if ((board[0][0].last > 0 &&
          board[1][1].last > 0 &&
          board[2][2].last > 0 &&
          board[3][3].last > 0) ||
      (board[0][3].last > 0 &&
          board[1][2].last > 0 &&
          board[2][1].last > 0 &&
          board[3][0].last > 0) ||
      (board[0][0].last < 0 &&
          board[1][1].last < 0 &&
          board[2][2].last < 0 &&
          board[3][3].last < 0) ||
      (board[0][3].last < 0 &&
          board[1][2].last < 0 &&
          board[2][1].last < 0 &&
          board[3][0].last < 0)) {
    return true;
  }

  return false;
}

Map<String, List> getGameState(
    List<List<List>> board, List<List> p1, List<List> p2) {
  return {
    "board": copyBoard(board),
    "p1": copyPlayer(p1),
    "p2": copyPlayer(p2)
  };
}

bool validateMove(Map move, int player, Map<String, dynamic> gamestate) {
  final board = gamestate["board"];
  final p = player == 1 ? "p1" : "p2";
  // check if is landing on a blank square
  if (board[move["toRow"]][move["toCol"]].last == 0) return true;
  // in case of a filled square:
  //  - check if it's greater
  //  - if it is greater check if the square have two neighbours
  int toBeMoved = move["type"] == "play"
      ? gamestate[p][move["index"]].last
      : board[move["fromRow"]][move["fromCol"]].last;
  int toBeCovered = board[move["toRow"]][move["toCol"]].last;
  if (toBeCovered.abs() >= toBeMoved.abs()) return false;
  //TODO: handle the neighbours case
  return true;
}

List<List> copyPlayer(List<List> original) {
  return original.map((row) => List<int>.from(row)).toList();
}

List<List<List>> copyBoard(List<List<List>> original) {
  return original
      .map((row) => row.map((col) => List.from(col)).toList())
      .toList();
}

kprint(v) {
  print(v);
}

void printBoard(List<List<List>> board) {
  for (int row = 0; row < 4; row++) {
    for (int col = 0; col < 4; col++) {
      int piece = board[row][col].last;
      kprint('$piece');
    }
    kprint('\n');
  }
}

printToFile(board) async {
  final File file = File("temp.txt");
  if (board == null) return;
  for (var row in board) {
    for (var col in row) {
      await file.writeAsString("${col.last}, ", mode: FileMode.append);
    }
    await file.writeAsString("\n", mode: FileMode.append);
  }
}
