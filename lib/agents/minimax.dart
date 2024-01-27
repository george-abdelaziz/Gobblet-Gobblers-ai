import 'package:logger/logger.dart';

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

class MiniMax extends Agent {
  MiniMax(depth) : super(depth);
  int count = 0;
  double minimax(
      Map<String, dynamic> gamestate, bool maximizer, int plr, int depth) {
    count++;
    if (depth == 0) {
      return evaluate(gamestate, plr);
    }

    if (isWinningPos(gamestate['board']) != 0) {
      return Config.winning;
    }

    List<dynamic> candidateMoves = genMoves(plr, gamestate);
    int nextplr = plr == 1 ? 2 : 1;

    if (candidateMoves.isEmpty) {
      return Config.draw;
    }

    double score = maximizer ? double.negativeInfinity : double.infinity;

    for (var move in candidateMoves) {
      var newGameState = applyMove(gamestate, plr, move);
      var v = minimax(newGameState, !maximizer, nextplr, depth - 1);

      if (maximizer) {
        score = (v > score) ? v : score;
      } else {
        score = (v < score) ? v : score;
      }
    }
    return score;
  }

  @override
  Map calcBestMove(Map gamestate, int plr) {
    double score = double.infinity;
    Map bestMove = {};
    int nextPlr = plr == 1 ? 2 : 1;
    List<dynamic> candidateMoves = genMoves(plr, gamestate);

    count = 0;
    for (var i = 0; i < candidateMoves.length; i++) {
      var move = candidateMoves[i];
      var newGameState = applyMove(gamestate, plr, move);
      if (isWinningPos(newGameState['board']) == plr) {
        move['score'] = Config.winning;
        return move;
      }
      var v = minimax(newGameState, true, nextPlr, super.depth - 1);
      move["score"] = v;

      if (v < score) {
        score = v;
        bestMove = move;
      }
    }
    bestMove["count"] = count;
    return bestMove;
  }
}
