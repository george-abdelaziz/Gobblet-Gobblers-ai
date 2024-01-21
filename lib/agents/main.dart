import 'package:ai_project/agents/config.dart';
import 'package:ai_project/agents/minimax.dart';
import 'package:ai_project/agents/utils.dart';

void main(List<String> args) {
  // Agent player1 = MiniMax();
  // Agent player2 = AlphaBeta();
  kprint(DateTime.now());
  Map<String, dynamic> gamestate =
      getGameState(Config.board, Config.set1, Config.set2);

  for (var i = 1; i < 100; i++) {
    kprint("($i)===================");
    var move = MiniMax().calcBestMove(gamestate, 1);
    gamestate = applyMove(gamestate, 1, move);
    if (isWinningPos(gamestate["board"])) {
      kprint("p1 won");
      kprint(move);
      printBoard(gamestate["board"]);
      break;
    }

    move = MiniMax().calcBestMove(gamestate, 2);
    gamestate = applyMove(gamestate, 2, move);
    if (isWinningPos(gamestate["board"])) {
      kprint("p2 won");
      printBoard(gamestate["board"]);
      break;
    }
    printBoard(gamestate["board"]);
  }
  kprint(DateTime.now());
}
