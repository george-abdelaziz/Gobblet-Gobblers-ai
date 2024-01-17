import 'dart:io';
import 'dart:math';

// p1 : +v
// p2 : -v

// 3
// 2
// 1

// fromRow, fromCol, toRow, toCol
final File file = File("temp.txt");

double evaluate() {
  return Random(DateTime.now().second.toInt()).nextDouble() * 50;
}

void applyMove() {}

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
              candidateMoves.add({
                "typw": "move",
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
  return candidateMoves;
}

bool validateMove() {
  return true;
}

Future<double> minimax(gamestate, bool maximizer, int depth) async {
  if (depth == 0) {
    return evaluate();
  }
  List candiateMoves = genMoves(1, gamestate);
  double score;
  var move;
  if (maximizer) {
    for (move in candiateMoves) {
      await file.writeAsString("$depth, $maximizer,move:$move\n",
          mode: FileMode.append);
      print(await minimax(gamestate, !maximizer, depth - 1));
    }
  } else {
    for (move in candiateMoves) {
      await file.writeAsString("$depth, $maximizer,move:$move\n",
          mode: FileMode.append);
      print(await minimax(gamestate, !maximizer, depth - 1));
    }
  }
  return 0;
}

calcBestMove(List<List<List>> board, List<List> p1, List<List> p2) async {
  Map gameState = getGameState(board, p1, p2);
  await minimax(gameState, true, 3);
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
    [[], [], [], []],
    [[], [], [], []],
    [[], [], [], []],
    [[], [], [], []],
  ];
  calcBestMove(board, p1, p2);
  return;
}
