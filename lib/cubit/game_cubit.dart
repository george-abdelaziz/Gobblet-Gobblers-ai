import 'dart:isolate';

import 'package:ai_project/cubit/states.dart';
import 'package:ai_project/models/board_point.dart';
import 'package:ai_project/view/board/board_screen.dart';
import 'package:ai_project/view/player_selection/player_selection_screen.dart';
import 'package:ai_project/view/win/win.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../agents/alphabeta.dart';
import '../agents/minimax.dart';
import '../models/adapter.dart';
import '/agents/agent.dart';
import '/agents/iterative_deeping.dart';
import '/agents/utils.dart';
import '/models/my_classes.dart';

// board[which board][vertical height of the board][horizontal width of the board][n/height of the stack]=double;
class GameCubit extends Cubit<GameStates> {
  GameCubit() : super(GameInitialState());

  static GameCubit get(context) {
    return BlocProvider.of(context);
  }

  final logger = Logger();
  final adapter = Adapter();
  int whosturn = 1;
  int aPieceIsToushed = 0;
  int screenIndex = 0;
  int winner = 0;
  int difficultyLevelForAI1 = 1;
  int difficultyLevelForAI2 = 1;

  BoardPoint from = BoardPoint()..nagOne();
  BoardPoint to = BoardPoint()..nagOne();

  PlayerType playerType1 = PlayerType.human;
  PlayerType playerType2 = PlayerType.human;
  Selected type1 = Selected.not;
  Selected type2 = Selected.not;
  Selected level1 = Selected.not;
  Selected level2 = Selected.not;
  Agent agent1 = MiniMax(1);
  Agent agent2 = MiniMax(1);

  final List<Widget> screens = [
    const PlayerSelectionScreen(),
    const BoardScreen(),
    const WinScreen(),
  ];

  void playerSelectionDone() {
    if (type1 == Selected.selected && type2 == Selected.selected) {
      if (playerType1 != PlayerType.human && level1 == Selected.not) {
        return;
      }
      if (playerType2 != PlayerType.human && level2 == Selected.not) {
        return;
      }
      screenIndex = 1;
      startup();
      emit(GameStarted());
    } else {
      emit(PlayersNotSelected());
    }
  }

  Future<void> startup() async {
    if (playerType1 == PlayerType.minmax) {
      agent1 = MiniMax(difficultyLevelForAI1);
    } else if (playerType1 == PlayerType.alpa) {
      agent1 = AlphaBeta(difficultyLevelForAI1, 2);
    } else if (playerType1 == PlayerType.iter) {
      agent1 = IteravieDeeping(difficultyLevelForAI1, 5);
    }
    if (playerType2 == PlayerType.minmax) {
      agent2 = MiniMax(difficultyLevelForAI2);
    } else if (playerType2 == PlayerType.alpa) {
      agent2 = AlphaBeta(difficultyLevelForAI2, 2);
    } else if (playerType2 == PlayerType.iter) {
      agent2 = IteravieDeeping(difficultyLevelForAI2, 5);
    }
    await Future.delayed(const Duration(milliseconds: 50));
    if (playerType1 != PlayerType.human && playerType2 != PlayerType.human) {
      emit(BattleOfTheAIs());
    } else if (playerType1 != PlayerType.human) {
      whosturn = 3;
      ai();
    } else {
      whosturn = 1;
    }
  }

  void aiBattle() async {
    whosturn = 3;
    ai();
  }

  Future<void> ai() async {
    Agent player;
    if (whosturn == 3) {
      player = agent1;
    } else if (whosturn == 4) {
      player = agent2;
    } else {
      return;
    }
    var x = adapter.f2b(board);
    // var move = player.calcBestMove(x, whosturn - 2);
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn((Map message) {
      SendPort sendPort = message['sendport'];
      Agent agent = message['bot'];
      var move = agent.calcBestMove(message['i1'], message['i2']);
      sendPort.send(move);
    }, {
      'sendport': receivePort.sendPort,
      'bot': player,
      'i1': x,
      'i2': whosturn - 2
    });

    receivePort.listen((move) {
      var y = applyMove(x, whosturn - 2, move);
      board = adapter.b2f(y, board);
      logger.i(move);
      changePlayer();
      kprint('1');
      emit(AIPlayed());
      kprint('2');
      receivePort.close();
    });
  }

  void changePlayer() {
    aPieceIsToushed = 0;
    from.nagOne();
    to.nagOne();
    if (whosturn == 1) {
      if (playerType2 == PlayerType.human) {
        whosturn = 2;
      } else {
        whosturn = 4;
      }
    } else if (whosturn == 2) {
      if (playerType1 == PlayerType.human) {
        whosturn = 1;
      } else {
        whosturn = 3;
      }
    } else if (whosturn == 3) {
      if (playerType2 == PlayerType.human) {
        whosturn = 2;
      } else {
        whosturn = 4;
      }
    } else if (whosturn == 4) {
      if (playerType1 == PlayerType.human) {
        whosturn = 1;
      } else {
        whosturn = 3;
      }
    } else {
      logger.e('change player');
    }
    if (whosturn == 1 || whosturn == 3) {
      playerWins(2);
      playerWins(1);
    } else {
      playerWins(1);
      playerWins(2);
    }
  }

  void plays({required BoardPoint point}) {
    if (whosturn == 1) {
      player1Turn(point: point);
    } else if (whosturn == 2) {
      player2Turn(point: point);
    } else {}
  }

  Future<void> player1Turn({required BoardPoint point}) async {
    if (aPieceIsToushed == 0) {
      if (getLastNumber(point: point) <= 0) {
        return;
      }
      from = point;
      aPieceIsToushed = 1;
      emit(Player1Frist());
    } else {
      aPieceIsToushed = 0;
      if (isValidMove(
        start: from,
        end: point,
      )) {
        to = point;
        movePiece();
        changePlayer();
        emit(Player2Turn());
        if (playerType2 != PlayerType.human) {
          await Future.delayed(const Duration(milliseconds: 50));
          ai();
        }
      } else {
        emit(Player1SelectWrongSquare());
      }
      from.nagOne();
      to.nagOne();
    }
  }

  Future<void> player2Turn({required BoardPoint point}) async {
    if (aPieceIsToushed == 0) {
      if (getLastNumber(point: point) >= 0) {
        return;
      }
      from = point;
      aPieceIsToushed = 1;
      emit(Player2Frist());
    } else {
      aPieceIsToushed = 0;
      if (isValidMove(
        start: from,
        end: point,
      )) {
        to = point;
        movePiece();
        changePlayer();
        from.nagOne();
        to.nagOne();
        emit(Player1Turn());
        if (playerType1 != PlayerType.human) {
          await Future.delayed(const Duration(milliseconds: 50));
          ai();
        }
      } else {
        emit(Player2SelectWrongSquare());
      }
      from.nagOne();
      to.nagOne();
    }
  }

  bool isValidMove({
    required BoardPoint start,
    required BoardPoint end,
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

  void movePiece() {
    if (isValidMove(start: from, end: to)) {
      to.insertNumber(arr: board, num: from.getLastNumber(arr: board));
      from.popNumber(arr: board);
    }
  }

  double getLastItemInTheBoard({required int y, required int z}) {
    return board[0][y][z].last;
  }

  double getLastNumber({required BoardPoint point}) {
    if (board[point.x][point.y][point.z].isEmpty) return 0;
    return board[point.x][point.y][point.z].last;
  }

  void restart() {
    whosturn = 1;
    aPieceIsToushed = 0;
    screenIndex = 0;
    winner = 0;
    playerType1 = PlayerType.human;
    playerType2 = PlayerType.human;
    type1 = Selected.not;
    type2 = Selected.not;
    level1 = Selected.not;
    level2 = Selected.not;
    difficultyLevelForAI1 = 1;
    difficultyLevelForAI2 = 1;
    from = BoardPoint()..nagOne();
    to = BoardPoint()..nagOne();
    board = [
      [
        [
          [0],
          [0],
          [0],
          [0],
        ],
        [
          [0],
          [0],
          [0],
          [0],
        ],
        [
          [0],
          [0],
          [0],
          [0],
        ],
        [
          [0],
          [0],
          [0],
          [0],
        ],
      ],
      [
        [
          [
            0,
            1,
            2,
            3,
            4,
          ],
          [
            0,
            1,
            2,
            3,
            4,
          ],
          [
            0,
            1,
            2,
            3,
            4,
          ],
        ],
      ],
      [
        [
          [
            0,
            -1,
            -2,
            -3,
            -4,
          ],
          [
            0,
            -1,
            -2,
            -3,
            -4,
          ],
          [
            0,
            -1,
            -2,
            -3,
            -4,
          ],
        ],
      ],
    ];
    emit(Restart());
  }

  bool playerWins(int player) {
    bool checker(plr, x) => plr == 1 ? x > 0 : x < 0;
    if (checker(player, getLastItemInTheBoard(y: 0, z: 0)) &&
            checker(player, getLastItemInTheBoard(y: 1, z: 0)) &&
            checker(player, getLastItemInTheBoard(y: 2, z: 0)) &&
            checker(player, getLastItemInTheBoard(y: 3, z: 0)) ||
        checker(player, getLastItemInTheBoard(y: 0, z: 1)) &&
            checker(player, getLastItemInTheBoard(y: 1, z: 1)) &&
            checker(player, getLastItemInTheBoard(y: 2, z: 1)) &&
            checker(player, getLastItemInTheBoard(y: 3, z: 1)) ||
        checker(player, getLastItemInTheBoard(y: 0, z: 2)) &&
            checker(player, getLastItemInTheBoard(y: 1, z: 2)) &&
            checker(player, getLastItemInTheBoard(y: 2, z: 2)) &&
            checker(player, getLastItemInTheBoard(y: 3, z: 2)) ||
        checker(player, getLastItemInTheBoard(y: 0, z: 3)) &&
            checker(player, getLastItemInTheBoard(y: 1, z: 3)) &&
            checker(player, getLastItemInTheBoard(y: 2, z: 3)) &&
            checker(player, getLastItemInTheBoard(y: 3, z: 3)) ||
        checker(player, getLastItemInTheBoard(y: 0, z: 0)) &&
            checker(player, getLastItemInTheBoard(y: 0, z: 1)) &&
            checker(player, getLastItemInTheBoard(y: 0, z: 2)) &&
            checker(player, getLastItemInTheBoard(y: 0, z: 3)) ||
        checker(player, getLastItemInTheBoard(y: 1, z: 0)) &&
            checker(player, getLastItemInTheBoard(y: 1, z: 1)) &&
            checker(player, getLastItemInTheBoard(y: 1, z: 2)) &&
            checker(player, getLastItemInTheBoard(y: 1, z: 3)) ||
        checker(player, getLastItemInTheBoard(y: 2, z: 0)) &&
            checker(player, getLastItemInTheBoard(y: 2, z: 1)) &&
            checker(player, getLastItemInTheBoard(y: 2, z: 2)) &&
            checker(player, getLastItemInTheBoard(y: 2, z: 3)) ||
        checker(player, getLastItemInTheBoard(y: 3, z: 0)) &&
            checker(player, getLastItemInTheBoard(y: 3, z: 1)) &&
            checker(player, getLastItemInTheBoard(y: 3, z: 2)) &&
            checker(player, getLastItemInTheBoard(y: 3, z: 3)) ||
        checker(player, getLastItemInTheBoard(y: 0, z: 0)) &&
            checker(player, getLastItemInTheBoard(y: 1, z: 1)) &&
            checker(player, getLastItemInTheBoard(y: 2, z: 2)) &&
            checker(player, getLastItemInTheBoard(y: 3, z: 3)) ||
        checker(player, getLastItemInTheBoard(y: 0, z: 3)) &&
            checker(player, getLastItemInTheBoard(y: 1, z: 2)) &&
            checker(player, getLastItemInTheBoard(y: 2, z: 1)) &&
            checker(player, getLastItemInTheBoard(y: 3, z: 0))) {
      winner = player;
      screenIndex = 2;
      emit(GameFinished());
      return true;
    }
    return false;
  }

  void backToBoard() {
    screenIndex = 1;
    emit(ShowBoard());
  }

  List<List<List<List<double>>>> board = [
    [
      [
        [0],
        [0],
        [0],
        [0],
      ],
      [
        [0],
        [0],
        [0],
        [0],
      ],
      [
        [0],
        [0],
        [0],
        [0],
      ],
      [
        [0],
        [0],
        [0],
        [0],
      ],
    ],
    [
      [
        [
          0,
          1,
          2,
          3,
          4,
        ],
        [
          0,
          1,
          2,
          3,
          4,
        ],
        [
          0,
          1,
          2,
          3,
          4,
        ],
      ],
    ],
    [
      [
        [
          0,
          -1,
          -2,
          -3,
          -4,
        ],
        [
          0,
          -1,
          -2,
          -3,
          -4,
        ],
        [
          0,
          -1,
          -2,
          -3,
          -4,
        ],
      ],
    ],
  ];
}
