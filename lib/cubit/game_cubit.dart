import 'package:ai_project/agents/alphabeta.dart';
import 'package:ai_project/models/adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../agents/minimax.dart';
import '/agents/agent.dart';
import '/agents/utils.dart';
import 'game_states.dart';
import '/models/my_classes.dart';
import '../screens/board_screen.dart';
import '../screens/player_selection_screen.dart';
import '../screens/win.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameInitialState());

  // carefull
  static GameCubit get(context) {
    return BlocProvider.of(context);
  }

  int whosturn = 1;
  int aPieceIsToushed = 0;
  int winner = 0;
  int screenIndex = 0;

  Agent? player1;
  Agent? player2;
  String player1Type = '';
  String player2Type = '';
  String difficultyLevelForAI1 = '';
  String difficultyLevelForAI2 = '';

  MyPoint from = MyPoint()..nagOne();
  MyPoint to = MyPoint()..nagOne();

  final Logger logger = Logger();
  final Adapter adapter = Adapter();

  final List<Widget> screens = [
    const PlayerSelectionScreen(),
    const GameScreen(),
    const WinScreen(),
  ];

  void playerSelectionDone() {
    if (player1Type != '' && player2Type != '!') {
      if (player1Type != '0' && difficultyLevelForAI1 == '') {
        return;
      }
      if (player2Type != '0' && difficultyLevelForAI2 == '') {
        return;
      }
      screenIndex = 1;
      //start up code
      emit(GameStarted());
      if (player1Type != '0' && player2Type != '0') {
        whosturn = 3;
        while (isWinningPos(adapter.f2b(board)['board']) == 0) {
          ai();
          // ai();
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

  void ai() {
    emit(AI1Played());

    var x = adapter.f2b(board);
    var move = player1!.calcBestMove(x, whosturn - 2);
    var y = applyMove(x, whosturn - 2, move);
    board = adapter.b2f(y, board);

    Logger().i(move);
    changePlayer();
    emit(AI2Played());
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
      kprint('qqqqq');
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

  bool isValidMove({required MyPoint start, required MyPoint end}) {
    int row = 0;
    int col = 0;
    int dia = 0;
    // greybeast
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

  double getLastNumber({required MyPoint point}) {
    if (board[point.x][point.y][point.z].isEmpty) return 0;
    return board[point.x][point.y][point.z].last;
  }

  void selectPlayer1(String value) {
    player1Type = value;
  }

  void selectPlayer2(String value) {
    player2Type = value;
  }

  // greyBeast defines:
  Agent _createAgent(String agentType) {
    switch (agentType) {
      case 'MiniMax':
        return MiniMax(3);
      case 'AlphaBeta':
        return AlphaBeta(3);
      case 'AlphaBetaPruning':
        // TODO: not implemented
        throw Exception("not implemented");
      // return AlphaBetaPruning(3);
      default:
        throw Exception('Invalid agent type: $agentType');
    }
  }

  void setAgent(String agentType, int player) {
    switch (player) {
      case 1:
        player1 = _createAgent(agentType);
        break;
      case 2:
        player2 = _createAgent(agentType);
        break;
      default:
        throw Exception('Invalid player: $player');
    }
  }

  // useful
  void restart() {
    whosturn = 1;
    aPieceIsToushed = 0;
    screenIndex = 0;
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

  //board[which board][vertical height of the board][horizontal width of the board][n/height of the stack]=double;
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
      screenIndex = 2;
      emit(player == 1 ? Player1Win() : Player2Win());
    }
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
