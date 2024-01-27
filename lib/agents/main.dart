import 'package:logger/logger.dart';

import 'agent.dart';
import 'config.dart';
import 'minimax.dart';
import 'utils.dart';

Agent player1 = MiniMax(1);
Agent player2 = MiniMax(2);

play() {
  Map<String, dynamic> gamestate = Config.initialgame;
  var board = [
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
  gamestate['board'] = board;
  for (var i = 0;; i++) {
    kprint("($i)==================");
    var move = player1.calcBestMove(gamestate, 1);
    // kprint('---------------------------------------');
    kprint(move);
    gamestate = applyMove(gamestate, 1, move);
    if (isWinningPos(gamestate["board"]) != 0) {
      // kprint("p1 won");
      Logger().i("p1 wins");
      printBoard(gamestate["board"]);

      break;
    }
    move = player2.calcBestMove(gamestate, 2);
    kprint('---------------------------------------');
    kprint(move);
    gamestate = applyMove(gamestate, 2, move);
    if (isWinningPos(gamestate["board"]) != 0) {
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

// var board = [
//   [ [0,3], [0], [0], [0,1] ],
//   [ [0], [0,4], [0], [0] ],
//   [ [0], [0], [0,3], [0] ],
//   [ [0], [0], [0], [0] ]
// ];
