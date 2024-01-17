import 'package:ai_project/layout/gobblet/cubit/states.dart';
import 'package:ai_project/models/my_classes.dart';
import 'package:ai_project/modules/board/board_screen.dart';
import 'package:ai_project/modules/player_selection/player_selection_screen.dart';
import 'package:ai_project/modules/win/win.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
last rulezzzzzzzzzzzzzzzzzz
*/

class GameCubit extends Cubit<GameStates> {

  GameCubit() : super(GameInitialState());
  static GameCubit get(context) {return BlocProvider.of(context);}

  bool isPlayer1Turn = true;
  int aPieceIsToushed = 0;
  int currentScreenIndex = 0;
  int winner = 0;
  String player1='';
  String player2='';
  String difficultyPlayer1='';
  String difficultyPlayer2='';
  MyPoint from = MyPoint(x: 0);
  MyPoint to = MyPoint(x: 0);
  List<Widget> screens = [
    PlayerSelectionScreen(),
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

  void playerSelectionDone() {
    if(player1!=''&&player2!='!'){
      if(player1!='0'&&difficultyPlayer1==''){return;}
      if(player2!='0'&&difficultyPlayer2==''){return;}
      currentScreenIndex=1;
      emit(GameStarted());
    }
    else {
      emit(PlayersNotSelected());
    }
  }

  void changePlayer() {
    isPlayer1Turn = !isPlayer1Turn;
    aPieceIsToushed = 0;
  }

  void plays({required MyPoint point}) {
    if (isPlayer1Turn) {
      if(player1!='0'){
        //AI1 Control
        changePlayer();
      }
      else{
        player1Turn(point: point);
      }
    }
    else {
      if(player2!='0'){
        //AI2 Control
        changePlayer();
      }
      else {
        player2Turn(point: point);
      }
    }
  }

  void player1Turn({required MyPoint point}) {
    if (aPieceIsToushed == 0) {
      if (getLastNumber(point: point) <= 0) {
        return;
      }
      from = point;
      aPieceIsToushed = 1;
      emit(Player1Frist());
    }
    else {
      aPieceIsToushed = 0;
      if (isValidMove(start: from, end: point,)) {
        to = point;
        movePiece();
        isPlayer1Turn = false;
        player2wins();
        player1wins();
        emit(Player2Turn());
      }
      else {emit(Player1SelectWrongSquare());}
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
    }
    else {
      aPieceIsToushed = 0;
      if (isValidMove(start: from, end: point,)) {
        to = point;
        movePiece();
        isPlayer1Turn = true;
        player1wins();
        player2wins();
        emit(Player1Turn());
      }
      else {emit(Player2SelectWrongSquare());}
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

  void player1wins() {
    if (getLastItemInTheBoard(y: 0, z: 0) > 0 &&
            getLastItemInTheBoard(y: 1, z: 0) > 0 &&
            getLastItemInTheBoard(y: 2, z: 0) > 0 &&
            getLastItemInTheBoard(y: 3, z: 0) > 0 ||
        getLastItemInTheBoard(y: 0, z: 1) > 0 &&
            getLastItemInTheBoard(y: 1, z: 1) > 0 &&
            getLastItemInTheBoard(y: 2, z: 1) > 0 &&
            getLastItemInTheBoard(y: 3, z: 1) > 0 ||
        getLastItemInTheBoard(y: 0, z: 2) > 0 &&
            getLastItemInTheBoard(y: 1, z: 2) > 0 &&
            getLastItemInTheBoard(y: 2, z: 2) > 0 &&
            getLastItemInTheBoard(y: 3, z: 2) > 0 ||
        getLastItemInTheBoard(y: 0, z: 3) > 0 &&
            getLastItemInTheBoard(y: 1, z: 3) > 0 &&
            getLastItemInTheBoard(y: 2, z: 3) > 0 &&
            getLastItemInTheBoard(y: 3, z: 3) > 0 ||
        getLastItemInTheBoard(y: 0, z: 0) > 0 &&
            getLastItemInTheBoard(y: 0, z: 1) > 0 &&
            getLastItemInTheBoard(y: 0, z: 2) > 0 &&
            getLastItemInTheBoard(y: 0, z: 3) > 0 ||
        getLastItemInTheBoard(y: 1, z: 0) > 0 &&
            getLastItemInTheBoard(y: 1, z: 1) > 0 &&
            getLastItemInTheBoard(y: 1, z: 2) > 0 &&
            getLastItemInTheBoard(y: 1, z: 3) > 0 ||
        getLastItemInTheBoard(y: 2, z: 0) > 0 &&
            getLastItemInTheBoard(y: 2, z: 1) > 0 &&
            getLastItemInTheBoard(y: 2, z: 2) > 0 &&
            getLastItemInTheBoard(y: 2, z: 3) > 0 ||
        getLastItemInTheBoard(y: 3, z: 0) > 0 &&
            getLastItemInTheBoard(y: 3, z: 1) > 0 &&
            getLastItemInTheBoard(y: 3, z: 2) > 0 &&
            getLastItemInTheBoard(y: 3, z: 3) > 0 ||
        getLastItemInTheBoard(y: 0, z: 0) > 0 &&
            getLastItemInTheBoard(y: 1, z: 1) > 0 &&
            getLastItemInTheBoard(y: 2, z: 2) > 0 &&
            getLastItemInTheBoard(y: 3, z: 3) > 0 ||
        getLastItemInTheBoard(y: 0, z: 3) > 0 &&
            getLastItemInTheBoard(y: 1, z: 2) > 0 &&
            getLastItemInTheBoard(y: 2, z: 1) > 0 &&
            getLastItemInTheBoard(y: 3, z: 0) > 0) {
      winner = 1;
      currentScreenIndex=2;
      emit(Player1Win());
    }
  }

  void player2wins() {
    if (getLastItemInTheBoard(y: 0, z: 0) < 0 &&
            getLastItemInTheBoard(y: 1, z: 0) < 0 &&
            getLastItemInTheBoard(y: 2, z: 0) < 0 &&
            getLastItemInTheBoard(y: 3, z: 0) < 0 ||
        getLastItemInTheBoard(y: 0, z: 1) < 0 &&
            getLastItemInTheBoard(y: 1, z: 1) < 0 &&
            getLastItemInTheBoard(y: 2, z: 1) < 0 &&
            getLastItemInTheBoard(y: 3, z: 1) < 0 ||
        getLastItemInTheBoard(y: 0, z: 2) < 0 &&
            getLastItemInTheBoard(y: 1, z: 2) < 0 &&
            getLastItemInTheBoard(y: 2, z: 2) < 0 &&
            getLastItemInTheBoard(y: 3, z: 2) < 0 ||
        getLastItemInTheBoard(y: 0, z: 3) < 0 &&
            getLastItemInTheBoard(y: 1, z: 3) < 0 &&
            getLastItemInTheBoard(y: 2, z: 3) < 0 &&
            getLastItemInTheBoard(y: 3, z: 3) < 0 ||
        getLastItemInTheBoard(y: 0, z: 0) < 0 &&
            getLastItemInTheBoard(y: 0, z: 1) < 0 &&
            getLastItemInTheBoard(y: 0, z: 2) < 0 &&
            getLastItemInTheBoard(y: 0, z: 3) < 0 ||
        getLastItemInTheBoard(y: 1, z: 0) < 0 &&
            getLastItemInTheBoard(y: 1, z: 1) < 0 &&
            getLastItemInTheBoard(y: 1, z: 2) < 0 &&
            getLastItemInTheBoard(y: 1, z: 3) < 0 ||
        getLastItemInTheBoard(y: 2, z: 0) < 0 &&
            getLastItemInTheBoard(y: 2, z: 1) < 0 &&
            getLastItemInTheBoard(y: 2, z: 2) < 0 &&
            getLastItemInTheBoard(y: 2, z: 3) < 0 ||
        getLastItemInTheBoard(y: 3, z: 0) < 0 &&
            getLastItemInTheBoard(y: 3, z: 1) < 0 &&
            getLastItemInTheBoard(y: 3, z: 2) < 0 &&
            getLastItemInTheBoard(y: 3, z: 3) < 0 ||
        getLastItemInTheBoard(y: 0, z: 0) < 0 &&
            getLastItemInTheBoard(y: 1, z: 1) < 0 &&
            getLastItemInTheBoard(y: 2, z: 2) < 0 &&
            getLastItemInTheBoard(y: 3, z: 3) < 0 ||
        getLastItemInTheBoard(y: 0, z: 3) < 0 &&
            getLastItemInTheBoard(y: 1, z: 2) < 0 &&
            getLastItemInTheBoard(y: 2, z: 1) < 0 &&
            getLastItemInTheBoard(y: 3, z: 0) < 0) {
      winner = 2;
      currentScreenIndex=2;
      emit(Player2Win());
    }
  }

  double getLastItemInTheBoard({required int y, required int z}) {
    return boardz[0][y][z].last;
  }

  double getLastNumber({required MyPoint point}) {
    return boardz[point.x][point.y][point.z].last;
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

  void selectPlayer1(String value) {
    player1 = value;
  }

  void selectPlayer2(String value) {
    player2 = value;
  }

}