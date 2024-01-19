import 'agent.dart';
import 'config.dart';
import 'evaluate.dart';
import 'utils.dart';

// p1 : +v
// p2 : -v
// 4
// 3
// 2
// 1

// fromRow, fromCol, toRow, toCol
class AlphaBeta extends Agent {
  double alphabeta(Map<String, dynamic> gamestate, bool maximizer, int plr,
      int depth, alpha, beta) {
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
      var v = alphabeta(
          newGameState, !maximizer, plr == 1 ? 2 : 1, depth - 1, alpha, beta);

      if (maximizer) {
        score = (v > score) ? v : score;
        alpha = alpha > score ? alpha : score;
      } else {
        score = (v < score) ? v : score;
        beta = beta < score ? beta : score;
      }
      if (alpha >= beta) return score;
    }
    return score;
  }

  @override
  Map calcBestMove(Map gamestate, int plr) {
    bool maximizer = true;
    double score = 0;
    Map bestMove = {};
    List<dynamic> candidateMoves = genMoves(plr, gamestate);
    // kprint(candidateMoves);

    for (var i = 0; i < candidateMoves.length; i++) {
      var move = candidateMoves[i];
      var newGameState = applyMove(gamestate, plr, move);
      var v = alphabeta(newGameState, !maximizer, plr, 3,
          double.negativeInfinity, double.infinity);
      if (v > score) {
        score = v;
        bestMove = move;
      }
    }
    bestMove["score"] = score;
    return bestMove;
  }
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
  kprint(DateTime.now());
  Map<String, dynamic> gamestate = getGameState(board, p1, p2);
  kprint(AlphaBeta().calcBestMove(gamestate, 1));
  kprint(DateTime.now());
  return;
}

// final board = [
//   [ [0, -4], [0], [0], [0, -2] ],
//   [ [0], [0,-2], [0], [0] ],
//   [ [0], [0], [0,-3], [0] ],
//   [ [0], [0, -4], [0], [0, -1] ]
// ];
