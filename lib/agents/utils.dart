import 'dart:io';

import 'package:ai_project/models/adapter.dart';
import 'package:ai_project/models/board_point.dart';

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
    if (i > 0 && pset[i - 1].isNotEmpty && pset[i - 1].last == pset[i].last) {
      continue;
    }

    if (pset[i].isNotEmpty) {
      for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 4; col++) {
          final move = {
            "type": "play",
            "val": pset[i].last,
            "index": i,
            "toRow": row,
            "toCol": col
          };
          if (isValidMove(move, player, gamestate)) {
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
              "val": gamestate['board'][row][col].last,
              "fromRow": row,
              "fromCol": col,
              "toRow": row2,
              "toCol": col2
            };
            if (isValidMove(move, player, gamestate)) {
              candidateMoves.add(move);
            }
          }
        }
      }
    }
  }
  // candidateMoves.shuffle();
  return candidateMoves;
}

int isWinningPos(List<List<List>> board) {
  // Check rows
  for (int row = 0; row < 4; row++) {
    if (board[row].every((element) => element.last > 0)) {
      // All elements are positive
      return 1;
    }
    if (board[row].every((element) => element.last < 0)) {
      // All elements are negative
      return 2;
    }
  }

  // Check columns
  for (int col = 0; col < 4; col++) {
    if (board.every((row) => row[col].last > 0)) {
      // All elements in the column are positive
      return 1;
    }
    if (board.every((row) => row[col].last < 0)) {
      return 2;
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
          board[3][0].last > 0)) {
    return 1;
  }
  if ((board[0][0].last < 0 &&
          board[1][1].last < 0 &&
          board[2][2].last < 0 &&
          board[3][3].last < 0) ||
      (board[0][3].last < 0 &&
          board[1][2].last < 0 &&
          board[2][1].last < 0 &&
          board[3][0].last < 0)) {
    return 2;
  }

  return 0;
}

Map<String, List> getGameState(
    List<List<List>> board, List<List> p1, List<List> p2) {
  return {
    "board": copyBoard(board),
    "p1": copyPlayer(p1),
    "p2": copyPlayer(p2)
  };
}

bool _validate({
  required BoardPoint start,
  required BoardPoint end,
  required board,
}) {
  int row = 0;
  int col = 0;
  int dia = 0;
  if (end.x != 0 ||
      start.getLastNumber(arr: board).abs() <=
          end.getLastNumber(arr: board).abs()) {
    return false;
  }
  if (start.x == 1 && end.getLastNumber(arr: board) < 0) {
    for (int i = 0; i < 4; i++) {
      if (board[0][end.y][i].last < 0) {
        row++;
      }
    }
    for (int i = 0; i < 4; i++) {
      if (board[0][i][end.z].last < 0) {
        col++;
      }
    }
    if (end.y == end.z) {
      for (int i = 0; i < 4; i++) {
        if (board[0][i][i].last < 0) {
          dia++;
        }
      }
    } else if (end.y + end.z == 3) {
      for (int i = 0; i < 4; i++) {
        if (board[0][i][3 - i].last < 0) {
          dia++;
        }
      }
    }
    if (row == 3 || col == 3 || dia == 3) {
      return true;
    } else {
      return false;
    }
  } else if (start.x == 2 && end.getLastNumber(arr: board) > 0) {
    for (int i = 0; i < 4; i++) {
      if (board[0][end.y][i].last > 0) {
        row++;
      }
    }
    for (int i = 0; i < 4; i++) {
      if (board[0][i][end.z].last > 0) {
        col++;
      }
    }
    if (end.y == end.z) {
      for (int i = 0; i < 4; i++) {
        if (board[0][i][i].last > 0) {
          dia++;
        }
      }
    } else if (end.y + end.z == 3) {
      for (int i = 0; i < 4; i++) {
        if (board[0][i][3 - i].last > 0) {
          dia++;
        }
      }
    }
    if (row == 3 || col == 3 || dia == 3) {
      return true;
    } else {
      return false;
    }
  }
  return true;
}

bool isValidMove(Map move, int player, Map<String, dynamic> gamestate) {
  BoardPoint s;
  BoardPoint e = BoardPoint(x: 0, z: move['toCol'], y: move['toRow']);
  switch (move['type']) {
    case 'play':
      s = BoardPoint(x: player, y: 0, z: move['index']);
      break;
    default:
      s = BoardPoint(x: 0, z: move['fromCol'], y: move['fromRow']);
  }
  List<List<List<List<double>>>> b = [
    [],
    [[]],
    [[]]
  ];
  b = Adapter().b2f(gamestate, b);
  return _validate(start: s, end: e, board: b);
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
    var piece = board[row];
    kprint(
        '${piece[0].last}, ${piece[1].last}, ${piece[2].last}, ${piece[3].last}');
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
