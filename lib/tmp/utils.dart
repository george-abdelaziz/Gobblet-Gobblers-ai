import 'dart:io';

int odd = 0;
int even = 0;
final File file = File("temp.txt");
printToFile(board) async {
  if (board == null) return;
  for (var row in board) {
    for (var col in row) {
      await file.writeAsString("${col.last}, ", mode: FileMode.append);
    }
    await file.writeAsString("\n", mode: FileMode.append);
  }
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

bool validateMove() {
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
      if (checkCondition(player, row, col)) {
        for (int row2 = 0; row2 < 4; row2++) {
          for (int col2 = 0; col2 < 4; col2++) {
            if (validateMove()) {
              candidateMoves.add({
                "type": "move",
                "fromRow": row,
                "fromCol": col,
                "toRow": row2,
                "toCol": col2
              });
            }
          }
        }
      }
    }
  }

  // print(candidateMoves[0]);
  return candidateMoves;
}

Map<String, List> getGameState(
    List<List<List>> board, List<List> p1, List<List> p2) {
  return {
    "board": copyBoard(board),
    "p1": copyPlayer(p1),
    "p2": copyPlayer(p2)
  };
}

kprint(v) {
  print(v);
}

int abs(a) {
  if (a < 0) {
    return a * -1;
  } else {
    return a;
  }
}

void printBoard(List<List<List>> board) {
  for (int row = 0; row < 4; row++) {
    for (int col = 0; col < 4; col++) {
      int piece = board[row][col].last;
      print('$piece');
    }
    print('\n');
  }
}
