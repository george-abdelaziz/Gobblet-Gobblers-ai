import 'agent.dart';
import 'config.dart';
import 'minimax.dart';
import 'utils.dart';

Agent player1 = MiniMax();
Agent player2 = MiniMax();

test(Agent player, int plr, gameState) {
  Map<String, dynamic> gamestate = Config.initialgame;
  var move = player.calcBestMove(gameState, plr);
  kprint(move);
  gameState = applyMove(gamestate, plr, move);
  printBoard(gamestate["board"]);
}

play() {
  Map<String, dynamic> gamestate = Config.initialgame;
  for (var i = 0; i < 20; i++) {
    kprint("($i)==================");
    var move = player1.calcBestMove(gamestate, 1);
    kprint(move);
    gamestate = applyMove(gamestate, 1, move);
    if (isWinningPos(gamestate["board"])) {
      kprint("p1 won");
      printBoard(gamestate["board"]);
      break;
    }
    move = player2.calcBestMove(gamestate, 1);
    kprint(move);
    gamestate = applyMove(gamestate, 2, move);
    if (isWinningPos(gamestate["board"])) {
      kprint("p1 won");
      printBoard(gamestate["board"]);
      break;
    }
    printBoard(gamestate["board"]);
  }
}

void main(List<String> args) {
  play();
}

// var board = [
//   [ [0], [0], [0], [0] ],
//   [ [0], [0], [0], [0] ],
//   [ [0], [0], [0], [0] ],
//   [ [0], [0], [0], [0] ]
// ];
