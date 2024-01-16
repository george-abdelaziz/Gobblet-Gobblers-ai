import 'package:ai_project/layout/gobblet/cubit/states.dart';
import 'package:ai_project/models/my_classes.dart';
import 'package:ai_project/modules/board/board_screen.dart';
import 'package:ai_project/modules/player_selection/player_selection_screen.dart';
import 'package:ai_project/modules/win/win.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../modules/mode/mode_selection_screen1.dart';
import '../../../modules/mode/mode_selection_screen2.dart';

class GameCubit extends Cubit<GameStates> {
  GameCubit() : super(GameStarted());
  static GameCubit get(context) {
    return BlocProvider.of(context);
  }
/*
function moves
evaluate
*/
  init() {}

  bool isHuman1 = true;
  bool isHuman2 = true;
  bool isPlayer1Turn = true;
  int touch = 0;
  int currentScreenIndex = 0;
  int winner = 0;
  int ai1def = 0;
  int ai2def = 0;
  String? player1;
  String? player2;
  MyPoint from = MyPoint(x: 0);
  MyPoint to = MyPoint(x: 0);
  List<Widget> screens = [
    PlayerSelectionScreen(),
    ModeSelectionScreen1(),
    ModeSelectionScreen2(),
    BoardScreen(),
    WinScreen(),
  ];
  List<List<List<List<double>>>> boardz = [
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
  //boardz[which board][vertical height of the board][horizontal width of the board][n/height of the stack]=double;

  void startGame() {
    if (isHuman1) {
    } else {
      // start the ai
      //change player
    }
  }

  void playerSelectionDone() {
    if (player1 != null && player2 != null) {
      if (player1 == '3') {
        currentScreenIndex = 1;
        return;
      } else if (player2 == '3') {
        currentScreenIndex = 2;
        return;
      } else {
        currentScreenIndex = 3;
      }
      emit(GameStarted());
      print('${currentScreenIndex}');
    } else {
      emit(PlayersNotSelected());
    }
  }

  void selectPlayer1(String value) {
    player1 = value;
  }

  void selectPlayer2(String value) {
    player2 = value;
  }

  void changePlayer() {
    isPlayer1Turn = !isPlayer1Turn;
    touch = 0;
  }

  void APieceIsTouched({required MyPoint point}) {
    if (isPlayer1Turn) {
      player1Turn(point: point);
    } else {
      player2Turn(point: point);
    }
  }

  void player1Turn({required MyPoint point}) {
    if (touch == 0) {
      if (point.x == 2 || getLastNumber(point: point) <= 0) {
        touch = 0;
        emit(Player1SelectWrongSquare());
        return;
      }
      from = point;
      touch = 1;
      emit(Player1Frist());
    } else {
      touch = 0;
      if (isValidMove(
        start: from,
        end: point,
      )) {
        to = point;
        movePiece();
        isPlayer1Turn = false;
        if (player2wins()) {
          currentScreenIndex = 4;
          winner = 2;
          emit(Player2Win());
          return;
        } else if (player1wins()) {
          currentScreenIndex = 4;
          winner = 1;
          emit(Player1Win());
          return;
        }
        emit(Player2Turn());
      } else {
        emit(Player1SelectWrongSquare());
      }
      from.nagOne();
      to.nagOne();
    }
  }

  void player2Turn({required MyPoint point}) {
    if (touch == 0) {
      if (point.x == 1 || getLastNumber(point: point) >= 0) {
        touch = 0;
        emit(Player2SelectWrongSquare());
        return;
      }
      from = point;
      touch = 1;
      emit(Player2Frist());
    } else {
      touch = 0;
      if (isValidMove(
        start: from,
        end: point,
      )) {
        to = point;
        movePiece();
        isPlayer1Turn = true;
        if (player1wins()) {
          winner = 1;
          currentScreenIndex = 2;
          emit(Player1Win());
          return;
        } else if (player2wins()) {
          currentScreenIndex = 2;
          winner = 2;
          emit(Player2Win());
          return;
        }
        emit(Player1Turn());
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
    if (end.x != 0 ||
        abs(start.getLastNumber(arr: boardz)) <=
            abs(end.getLastNumber(arr: boardz))) {
      return false;
    }

    return true;
  }

  void movePiece() {
    if (isValidMove(start: from, end: to)) {
      to.insertNumber(arr: boardz, num: from.getLastNumber(arr: boardz));
      from.popNumber(arr: boardz);
    }
  }

  void movePieceFromTo({
    required MyPoint start,
    required MyPoint end,
  }) {
    if (isValidMove(start: start, end: end)) {
      end.insertNumber(arr: boardz, num: start.getLastNumber(arr: boardz));
      start.popNumber(arr: boardz);
    }
  }

  bool player1wins() {
    if (q(y: 0, z: 0) > 0 &&
            q(y: 1, z: 0) > 0 &&
            q(y: 2, z: 0) > 0 &&
            q(y: 3, z: 0) > 0 ||
        q(y: 0, z: 1) > 0 &&
            q(y: 1, z: 1) > 0 &&
            q(y: 2, z: 1) > 0 &&
            q(y: 3, z: 1) > 0 ||
        q(y: 0, z: 2) > 0 &&
            q(y: 1, z: 2) > 0 &&
            q(y: 2, z: 2) > 0 &&
            q(y: 3, z: 2) > 0 ||
        q(y: 0, z: 3) > 0 &&
            q(y: 1, z: 3) > 0 &&
            q(y: 2, z: 3) > 0 &&
            q(y: 3, z: 3) > 0 ||
        q(y: 0, z: 0) > 0 &&
            q(y: 0, z: 1) > 0 &&
            q(y: 0, z: 2) > 0 &&
            q(y: 0, z: 3) > 0 ||
        q(y: 1, z: 0) > 0 &&
            q(y: 1, z: 1) > 0 &&
            q(y: 1, z: 2) > 0 &&
            q(y: 1, z: 3) > 0 ||
        q(y: 2, z: 0) > 0 &&
            q(y: 2, z: 1) > 0 &&
            q(y: 2, z: 2) > 0 &&
            q(y: 2, z: 3) > 0 ||
        q(y: 3, z: 0) > 0 &&
            q(y: 3, z: 1) > 0 &&
            q(y: 3, z: 2) > 0 &&
            q(y: 3, z: 3) > 0 ||
        q(y: 0, z: 0) > 0 &&
            q(y: 1, z: 1) > 0 &&
            q(y: 2, z: 2) > 0 &&
            q(y: 3, z: 3) > 0 ||
        q(y: 0, z: 3) > 0 &&
            q(y: 1, z: 2) > 0 &&
            q(y: 2, z: 1) > 0 &&
            q(y: 3, z: 0) > 0) {
      return true;
    }
    return false;
  }

  bool player2wins() {
    if (q(y: 0, z: 0) < 0 &&
            q(y: 1, z: 0) < 0 &&
            q(y: 2, z: 0) < 0 &&
            q(y: 3, z: 0) < 0 ||
        q(y: 0, z: 1) < 0 &&
            q(y: 1, z: 1) < 0 &&
            q(y: 2, z: 1) < 0 &&
            q(y: 3, z: 1) < 0 ||
        q(y: 0, z: 2) < 0 &&
            q(y: 1, z: 2) < 0 &&
            q(y: 2, z: 2) < 0 &&
            q(y: 3, z: 2) < 0 ||
        q(y: 0, z: 3) < 0 &&
            q(y: 1, z: 3) < 0 &&
            q(y: 2, z: 3) < 0 &&
            q(y: 3, z: 3) < 0 ||
        q(y: 0, z: 0) < 0 &&
            q(y: 0, z: 1) < 0 &&
            q(y: 0, z: 2) < 0 &&
            q(y: 0, z: 3) < 0 ||
        q(y: 1, z: 0) < 0 &&
            q(y: 1, z: 1) < 0 &&
            q(y: 1, z: 2) < 0 &&
            q(y: 1, z: 3) < 0 ||
        q(y: 2, z: 0) < 0 &&
            q(y: 2, z: 1) < 0 &&
            q(y: 2, z: 2) < 0 &&
            q(y: 2, z: 3) < 0 ||
        q(y: 3, z: 0) < 0 &&
            q(y: 3, z: 1) < 0 &&
            q(y: 3, z: 2) < 0 &&
            q(y: 3, z: 3) < 0 ||
        q(y: 0, z: 0) < 0 &&
            q(y: 1, z: 1) < 0 &&
            q(y: 2, z: 2) < 0 &&
            q(y: 3, z: 3) < 0 ||
        q(y: 0, z: 3) < 0 &&
            q(y: 1, z: 2) < 0 &&
            q(y: 2, z: 1) < 0 &&
            q(y: 3, z: 0) < 0) {
      return true;
    }
    return false;
  }

  double getLastNumber({required MyPoint point}) {
    return boardz[point.x][point.y][point.z].last;
  }

  double q({required int y, required int z}) {
    return boardz[0][y][z].last;
  }

  void popNumber({required MyPoint point}) {
    if (getLastNumber(point: point) == 0) {
      return;
    }
    boardz[point.x][point.y][point.z].removeLast();
  }

  void insertNumber({required MyPoint point, required double num}) {
    boardz[point.x][point.y][point.z].add(num);
  }

  void api1() {}
}
