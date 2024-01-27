import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../agents/alphabeta.dart';
import '../../../agents/minimax.dart';
import '/agents/agent.dart';
import '/agents/utils.dart';
import '/layout/gobblet/cubit/states.dart';
import '/models/my_classes.dart';
import '/modules/board/board_screen.dart';
import '/modules/player_selection/player_selection_screen.dart';
import '/modules/win/win.dart';

class GameCubit extends Cubit<GameStates> {
  GameCubit() : super(GameInitialState());

  static GameCubit get(context) {
    return BlocProvider.of(context);
  }

  bool aiai=false;
  int whosturn = 1;
  int aPieceIsToushed = 0;
  int currentScreenIndex = 0;
  int winner = 0;
  int difficultyLevelForAI1 = 1;
  int difficultyLevelForAI2 = 1;
  MyPoint from = MyPoint()..nagOne();
  MyPoint to = MyPoint()..nagOne();
  PlayerType playerType1 = PlayerType.human;
  PlayerType playerType2 = PlayerType.human;
  Selected type1=Selected.not;
  Selected type2=Selected.not;
  Selected level1=Selected.not;
  Selected level2=Selected.not;
  Agent ai1=MiniMax(1);
  Agent ai2=MiniMax(1);
  var logger = Logger();
  final List<Widget> screens = [
    const PlayerSelectionScreen(),
    const BoardScreen(),
    const WinScreen(),
  ];

  Future<void> playerSelectionDone() async {
    if (type1 == Selected.selected && type2 == Selected.selected ) {
      if (playerType1 != PlayerType.human && level1 == Selected.not) {return;}
      if (playerType2 != PlayerType.human && level2 == Selected.not) {return;}
      currentScreenIndex = 1;
      startup();
      emit(GameStarted());
    } else {
      emit(PlayersNotSelected());
    }
  }

  Future<void> startup() async {
    print('${playerType1}');
    print('${playerType2}');
    print('${difficultyLevelForAI1}');
    print('${difficultyLevelForAI2}');
    if(playerType1==PlayerType.minmax){ai1=MiniMax(difficultyLevelForAI1);}
    else if(playerType1==PlayerType.alpa){ai1=AlphaBeta(difficultyLevelForAI1);}
    else if(playerType1==PlayerType.iter){ai1=MiniMax(difficultyLevelForAI1);}
    if(playerType2==PlayerType.minmax){ai2=MiniMax(difficultyLevelForAI2);}
    else if(playerType2==PlayerType.alpa){ai2=AlphaBeta(difficultyLevelForAI2);}
    else if(playerType2==PlayerType.iter){ai2=MiniMax(difficultyLevelForAI2);}
    await Future.delayed(const Duration(milliseconds: 50));
    if (playerType1 != PlayerType.human && playerType2 != PlayerType.human) {
      aiai=true;
      whosturn = 3;
      while (aiai) {
        ai();
        await Future.delayed(const Duration(milliseconds: 20));
        ai();
        await Future.delayed(const Duration(milliseconds: 20));
      }
    }
    else if (playerType1 != PlayerType.human) {
      whosturn = 3;
      ai();
    }
    else {
      whosturn = 1;
    }
  }

  Future<void> ai() async {
    emit(AI1Played());
    logger.d('message');
    Agent player = (whosturn==3)?ai1:ai2;
    var x = getGameState(bti(board[0]), ctd(board[1][0]), ctd(board[2][0]));
    var move = player.calcBestMove(x, whosturn - 2);
    var y = applyMove(x, whosturn - 2, move);
    board[0] = convertToIntToDouble(y['board']);
    board[1][0] = convertListIntToDouble(y['p1']);
    board[2][0] = convertListIntToDouble(y['p2']);
    Logger().i(move);
    changePlayer();
    emit(AI2Played());
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
    }
    else if (whosturn == 2) {
      if (playerType1 == PlayerType.human) {
        whosturn = 1;
      } else {
        whosturn = 3;
      }
    }
    else if (whosturn == 3) {
      if (playerType2 == PlayerType.human) {
        whosturn = 2;
      } else {
        whosturn = 4;
      }
    }
    else if (whosturn == 4) {
      if (playerType1 == PlayerType.human) {
        whosturn = 1;
      } else {
        whosturn = 3;
      }
    }
    else {
      logger.e('change player');
    }
    if( whosturn == 1 || whosturn == 3 ){
      playerWins(2);
      playerWins(1);
    }
    else{
      playerWins(1);
      playerWins(2);
    }
  }

  void plays({required MyPoint point}) {
    if (whosturn == 1) {
      player1Turn(point: point);
    } else if (whosturn == 2) {
      player2Turn(point: point);
    } else {}
  }

  Future<void> player1Turn({required MyPoint point}) async {
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

  Future<void> player2Turn({required MyPoint point}) async {
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
      currentScreenIndex = 1;
      aiai=false;
      emit(GameFinished());
    }
  }

  double getLastItemInTheBoard({required int y, required int z}) {
    return board[0][y][z].last;
  }

  double getLastNumber({required MyPoint point}) {
    if (board[point.x][point.y][point.z].length == 0) return 0;
    return board[point.x][point.y][point.z].last;
  }

  ///////////////////

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

  /////////////////////////

  void restart() {
    aiai=false;
    whosturn = 1;
    aPieceIsToushed = 0;
    currentScreenIndex = 0;
    winner = 0;
    playerType1 = PlayerType.human;
    playerType2 = PlayerType.human;
    type1=Selected.not;
    type2=Selected.not;
    level1=Selected.not;
    level2=Selected.not;
    difficultyLevelForAI1 = 1;
    difficultyLevelForAI2 = 1;
    from = MyPoint()..nagOne();
    to = MyPoint()..nagOne();
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