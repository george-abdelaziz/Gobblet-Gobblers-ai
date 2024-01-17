import 'package:ai_project/layout/gobblet/cubit/states.dart';
import 'package:ai_project/models/my_classes.dart';
import 'package:ai_project/modules/board/board_screen.dart';
import 'package:ai_project/modules/player_selection/player_selection_screen.dart';
import 'package:ai_project/modules/win/win.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
rulezzzzzzzzzzzzzzzzzz

startup code
edit plays
play12
play21
*/

class GameCubit extends Cubit<GameStates> {

  GameCubit() : super(GameInitialState());
  static GameCubit get(context) {return BlocProvider.of(context);}

  int whosturn = 1;
  int aPieceIsToushed = 0;
  int currentScreenIndex = 0;
  int winner = 0;
  String player1Type='';
  String player2Type='';
  String difficultyLevelForAI1='';
  String difficultyLevelForAI2='';
  MyPoint from = MyPoint(x: 0);
  MyPoint to = MyPoint(x: 0);
  List<Widget> screens = [
    PlayerSelectionScreen(),
    BoardScreen(),
    WinScreen(),
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
  //boardz[which board][vertical height of the board][horizontal width of the board][n/height of the stack]=double;

  void playerSelectionDone() {
    if(player1Type!=''&&player2Type!='!'){
      if(player1Type!='0'&&difficultyLevelForAI1==''){return;}
      if(player2Type!='0'&&difficultyLevelForAI2==''){return;}
      currentScreenIndex=1;
      //start up code
      emit(GameStarted());
      if(player1Type!='0'&&player2Type!='0'){
        whosturn=3;
        while(true){
          ai();
          ai();
        }
      }
      else if(player1Type!='0'){
        whosturn=3;
        ai();
      }
      else{
        whosturn=1;
      }
    }
    else {
      emit(PlayersNotSelected());
    }
  }

  void ai(){
    //some logic for the ai
    changePlayer();
    emit(AIPlayed());
  }

  void changePlayer() {
    if(whosturn==1){
      if(player2Type=='0'){whosturn=2;}
      else{whosturn=4;}
    }
    else if(whosturn==2){
      if(player1Type=='0'){whosturn=1;}
      else{whosturn=3;}
    }
    else if(whosturn==3){
      if(player2Type=='0'){whosturn=2;}
      else{whosturn=4;}
    }
    else if(whosturn==4){
      if(player1Type=='0'){whosturn=1;}
      else{whosturn=3;}
    }
    else{
      print('qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
    }
    aPieceIsToushed = 0;
  }

  void plays({required MyPoint point}) {
    if (whosturn==1) {
      player1Turn(point: point);
    }
    else if(whosturn==2){
      player2Turn(point: point);
    }
    else{}
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
        player2wins();
        player1wins();
        changePlayer();
        emit(Player2Turn());
        if(player2Type!='0'){ai();}
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
        player1wins();
        player2wins();
        changePlayer();
        emit(Player1Turn());
        if(player1Type!='0'){ai();}
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
        abs(start.getLastNumber(arr: board)) <=
            abs(end.getLastNumber(arr: board))) {
      return false;
    }

    return true;
  }

  void movePiece() {
    if (isValidMove(start: from, end: to)) {
      to.insertNumber(arr: board, num: from.getLastNumber(arr: board));
      from.popNumber(arr: board);
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

  double getLastItemInTheBoard({required int y, required int z}) {return board[0][y][z].last;}

  double getLastNumber({required MyPoint point}) {return board[point.x][point.y][point.z].last;}

  void selectPlayer1(String value) {player1Type = value;}

  void selectPlayer2(String value) {player2Type = value;}

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

  void insertNumber({required MyPoint point, required double num}) {board[point.x][point.y][point.z].add(num);}

}
