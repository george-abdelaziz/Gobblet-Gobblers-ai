import '/agents/agent.dart';
import '/agents/config.dart';
import '/agents/evaluate.dart';
import '/agents/utils.dart';

class AlphaBeta extends Agent {
  AlphaBeta(depth) : super(depth);
  int count = 0;

  double alphaBeta(Map<String, dynamic> gamestate, bool maximizer, int plr,
      int depth, double alpha, double beta) {
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
      var v =
          alphaBeta(newGameState, !maximizer, nextplr, depth - 1, alpha, beta);

      if (maximizer) {
        score = (v > score) ? v : score;
        alpha = (score > alpha) ? score : alpha;
      } else {
        score = (v < score) ? v : score;
        beta = (v < beta) ? v : beta;
      }
      if (beta <= alpha) break;
    }
    return score;
  }

  @override
  Map calcBestMove(Map gamestate, int plr) {
    double alpha = double.negativeInfinity;
    double beta = double.infinity;
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
      var v =
          alphaBeta(newGameState, true, nextPlr, super.depth - 1, alpha, beta);
      move["score"] = v;

      if (v < score) {
        score = v;
        bestMove = move;
      }
    }
    bestMove['count'] = count;
    return bestMove;
  }
}
