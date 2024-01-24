import 'package:ai_project/agents/agent.dart';
import 'package:ai_project/agents/utils.dart';
import 'package:ai_project/layout/gobblet/cubit/states.dart';
import 'package:ai_project/models/my_classes.dart';
import 'package:ai_project/modules/board/board_screen.dart';
import 'package:ai_project/modules/player_selection/player_selection_screen.dart';
import 'package:ai_project/modules/win/win.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../agents/minimax.dart';

class GameCubit extends Cubit<GameStates> {
  GameCubit() : super(GameInitialState());

  static GameCubit get(context) {
    return BlocProvider.of(context);
  }

  int whosturn = 1;
  int aPieceIsToushed = 0;
  int currentScreenIndex = 0;
  int winner = 0;
  String player1Type = '';
  String player2Type = '';
  String difficultyLevelForAI1 = '';
  String difficultyLevelForAI2 = '';
  MyPoint from = MyPoint(x: 0);
  MyPoint to = MyPoint(x: 0);
  final List<Widget> screens = [
    PlayerSelectionScreen(),
    BoardScreen(),
    const WinScreen(),
  ];
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
  //board[which board][vertical height of the board][horizontal width of the board][n/height of the stack]=double;

  void playerSelectionDone() {
    if (player1Type != '' && player2Type != '!') {
      if (player1Type != '0' && difficultyLevelForAI1 == '') {
        return;
      }
      if (player2Type != '0' && difficultyLevelForAI2 == '') {
        return;
      }
      currentScreenIndex = 1;
      //start up code
      emit(GameStarted());
      if (player1Type != '0' && player2Type != '0') {
        whosturn = 3;
        while (true) {
          ai();
          ai();
        }
      } else if (player1Type != '0') {
        whosturn = 3;
        ai();
      } else {
        whosturn = 1;
      }
    } else {
      emit(PlayersNotSelected());
    }
  }

  List<List<List<double>>> convertToIntToDouble(List<List<List>> inputList) {
    List<List<List<double>>> result = [];

    for (List<List> outerList in inputList) {
      List<List<double>> outerResult = [];

      for (List innerList in outerList) {
        List<double> innerResult = [];

        for (int value in innerList) {
          innerResult.add(value.toDouble());
        }

        outerResult.add(innerResult);
      }

      result.add(outerResult);
    }

    return result;
  }

  List<List<double>> convertListIntToDouble(List<List> inputList) {
    List<List<double>> result = [];

    for (List innerList in inputList) {
      List<double> innerResult = [];

      for (int value in innerList) {
        innerResult.add(value.toDouble());
      }

      result.add(innerResult);
    }

    return result;
  }

  List<List> ctd(List<List<double>> inputList) {
    List<List> result = [];

    for (List<double> innerList in inputList) {
      List<int> innerResult = [];

      for (double value in innerList) {
        innerResult.add(value.toInt());
      }

      result.add(innerResult);
    }

    return result;
  }

  List<List<List>> bti(List<List<List<double>>> inputList) {
    List<List<List>> result = [];

    for (List<List<double>> outerList in inputList) {
      List<List<int>> outerResult = [];

      for (List<double> innerList in outerList) {
        List<int> innerResult = [];

        for (double value in innerList) {
          innerResult.add(value.toInt());
        }

        outerResult.add(innerResult);
      }

      result.add(outerResult);
    }

    return result;
  }

  void ai() {
    //for(int i=0;i<10000000000;i++){}
    //print('qqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
    //some logic for the ai
    Agent player = MiniMax();

    var x = getGameState(bti(board[0]), ctd(board[1][0]), ctd(board[2][0]));
    var move = player.calcBestMove(x, whosturn - 2);
    //play from outside
    // if(move['type']=='play'){from.x=2;}
    // else{from.x=0;}
    var y = applyMove(x, whosturn - 2, move);
    board[0] = convertToIntToDouble(y['board']);
    board[1][0] = convertListIntToDouble(y['p1']);
    board[2][0] = convertListIntToDouble(y['p2']);
    Logger().i(move);
    changePlayer();
    emit(AIPlayed());
  }

  void changePlayer() {
    if (whosturn == 1) {
      if (player2Type == '0') {
        whosturn = 2;
      } else {
        whosturn = 4;
      }
    } else if (whosturn == 2) {
      if (player1Type == '0') {
        whosturn = 1;
      } else {
        whosturn = 3;
      }
    } else if (whosturn == 3) {
      if (player2Type == '0') {
        whosturn = 2;
      } else {
        whosturn = 4;
      }
    } else if (whosturn == 4) {
      if (player1Type == '0') {
        whosturn = 1;
      } else {
        whosturn = 3;
      }
    } else {
      kprint(
          'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
    }
    aPieceIsToushed = 0;
  }

  void plays({required MyPoint point}) {
    if (whosturn == 1) {
      player1Turn(point: point);
    } else if (whosturn == 2) {
      player2Turn(point: point);
    } else {}
  }

  void player1Turn({required MyPoint point}) {
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
        playerWins(whosturn);
        playerWins(whosturn);
        // player2wins();
        // player1wins();
        changePlayer();
        emit(Player2Turn());
        if (player2Type != '0') {
          ai();
        }
      } else {
        emit(Player1SelectWrongSquare());
      }
      from.nagOne();
      to.nagOne();
    }
  }

  void player2Turn({required MyPoint point}) {
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
        // @greybeast
        playerWins(whosturn);
        // player1wins();
        // player2wins();
        changePlayer();
        emit(Player1Turn());
        if (player1Type != '0') {
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
    required MyPoint start,
    required MyPoint end,
  }) {
    int row = 0;
    int col = 0;
    int dia = 0;
    if (end.x != 0 ||
        abs(start.getLastNumber(arr: board)) <=
            abs(end.getLastNumber(arr: board))) {
      return false;
    }
    // if (start.x == 1 && end.getLastNumber(arr: board) < 0) {
    //   for (int i = 0; i < 4; i++) {
    //     if (board[0][end.y][i].last < 0) {
    //       row++;
    //     }
    //   }
    //   for (int i = 0; i < 4; i++) {
    //     if (board[0][i][end.z].last < 0) {
    //       col++;
    //     }
    //   }
    //   if (end.y == end.z) {
    //     for (int i = 0; i < 4; i++) {
    //       if (board[0][i][i].last < 0) {
    //         dia++;
    //       }
    //     }
    //   } else if (end.y + end.z == 3) {
    //     for (int i = 0; i < 4; i++) {
    //       if (board[0][i][3 - i].last < 0) {
    //         dia++;
    //       }
    //     }
    //   }
    //   if (row == 3 || col == 3 || dia == 3) {
    //     return true;
    //   } else {
    //     return false;
    //   }
    // } else if (start.x == 2 && end.getLastNumber(arr: board) > 0) {
    //   for (int i = 0; i < 4; i++) {
    //     if (board[0][end.y][i].last > 0) {
    //       row++;
    //     }
    //   }
    //   for (int i = 0; i < 4; i++) {
    //     if (board[0][i][end.z].last > 0) {
    //       col++;
    //     }
    //   }
    //   if (end.y == end.z) {
    //     for (int i = 0; i < 4; i++) {
    //       if (board[0][i][i].last > 0) {
    //         dia++;
    //       }
    //     }
    //   } else if (end.y + end.z == 3) {
    //     for (int i = 0; i < 4; i++) {
    //       if (board[0][i][3 - i].last > 0) {
    //         dia++;
    //       }
    //     }
    //   }
    //   if (row == 3 || col == 3 || dia == 3) {
    //     return true;
    //   } else {
    //     return false;
    //   }
    // }
    return true;
  }

  void movePiece() {
    if (isValidMove(start: from, end: to)) {
      to.insertNumber(arr: board, num: from.getLastNumber(arr: board));
      from.popNumber(arr: board);
    }
  }

// @greybeast
// refactoring the next two methods
  void playerWins(int player) {
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
      currentScreenIndex = 2;
      emit(player == 1 ? Player1Win() : Player2Win());
    }
  }

  double getLastItemInTheBoard({required int y, required int z}) {
    return board[0][y][z].last;
  }

  double getLastNumber({required MyPoint point}) {
    return board[point.x][point.y][point.z].last;
  }

  void selectPlayer1(String value) {
    player1Type = value;
  }

  void selectPlayer2(String value) {
    player2Type = value;
  }

  void restart() {
    whosturn = 1;
    aPieceIsToushed = 0;
    currentScreenIndex = 0;
    winner = 0;
    player1Type = '';
    player2Type = '';
    difficultyLevelForAI1 = '';
    difficultyLevelForAI2 = '';
    from = MyPoint(x: 0);
    to = MyPoint(x: 0);
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

//////////////////// useless functions for now at least
  void movePieceFromTo({
    required MyPoint start,
    required MyPoint end,
  }) {
    if (isValidMove(start: start, end: end)) {
      end.insertNumber(arr: board, num: start.getLastNumber(arr: board));
      start.popNumber(arr: board);
    }
  }

  void popNumber({required MyPoint point}) {
    if (getLastNumber(point: point) == 0) {
      return;
    }
    board[point.x][point.y][point.z].removeLast();
  }

  void insertNumber({required MyPoint point, required double num}) {
    board[point.x][point.y][point.z].add(num);
  }
}
