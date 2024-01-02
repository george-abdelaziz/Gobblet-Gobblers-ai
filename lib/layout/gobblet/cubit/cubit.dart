import 'package:ai_project/layout/gobblet/cubit/states.dart';
import 'package:ai_project/models/my_classes.dart';
import 'package:ai_project/modules/board/board_screen.dart';
import 'package:ai_project/modules/player_selection/player_selection_screen.dart';
import 'package:ai_project/modules/win/win.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../modules/mode/mode_selection_screen.dart';
import '../gobblet.dart';

class GameCubit extends Cubit<GameStates>{

  GameCubit() : super(GameStarted());
  static GameCubit get(context) {return BlocProvider.of(context);}
  init(){}

  bool isHuman1=true;
  bool isHuman2=true;
  bool isPlayer1Turn=true;
  int touch=0;
<<<<<<< HEAD
  int currentScreenIndex=0;
  int winner=0;
  String? player1;
  String? player2;
=======
  int currentScreenIndex=1;
  int winner=0;
>>>>>>> dcf5e5f6ba40d64490494de546665759a578e46d
  MyPoint from= MyPoint(x: 0);
  MyPoint to=MyPoint(x: 0);
  List<Widget> screens=[
    PlayerSelectionScreen(),
<<<<<<< HEAD
    ModeSelectionScreen(),
    ModeSelectionScreen(),
    BoardScreen(),
    WinScreen(),
=======
    BoardScreen(),
    WinScreen(),
  ];
  List<String> modes=[
    'minmax',
    'alpha-beta pruning',
    'alpha-beta pruning with iterative deepening '
>>>>>>> dcf5e5f6ba40d64490494de546665759a578e46d
  ];
  //boardz[which board][vertical height of the board][horizontal width of the board][n/height of the stack]=double;
  List<List<List<List<double>>>> boardz=[
    [
      [[0],[0],[0],[0],],
      [[0],[0],[0],[0],],
      [[0],[0],[0],[0],],
      [[0],[0],[0],[0],],
    ],
    [
      [[0,1,2,3,4,],[0,1,2,3,4,],[0,1,2,3,4,],],
    ],
    [
      [[0,-1,-2,-3,-4,],[0,-1,-2,-3,-4,],[0,-1,-2,-3,-4,],],
    ],
  ];

<<<<<<< HEAD
  void goToGame(){
    if(player1!=null&&player2!=null){
      if(player1=='3'){
        currentScreenIndex++;
      }
      emit(GameStarted());
    }
    else{
      emit(PlayersNotSelected());
    }
  }

=======
>>>>>>> dcf5e5f6ba40d64490494de546665759a578e46d
  void startGame(){
    if(isHuman1){

    }
    else{
      // start the ai
      //change player
    }
  }

<<<<<<< HEAD
  void selectPlayer1(String value){
    player1=value;
  }

  void selectPlayer2(String value){
    player2=value;
  }

=======
>>>>>>> dcf5e5f6ba40d64490494de546665759a578e46d
  void changePlayer(){
    isPlayer1Turn=!isPlayer1Turn;
    touch=0;
  }

  void APieceIsTouched({required MyPoint point}){
    if(isPlayer1Turn){
      player1Turn(point: point);
    }
    else{
      player2Turn(point: point);
    }
  }

  void player1Turn({required MyPoint point}){
    if(touch==0){
      if(point.x==2||getLastNumber(point: point)<=0){
        touch=0;
        emit(Player1SelectWrongSquare());
        return;
      }
      from=point;
      touch=1;
      emit(Player1Frist());
    }
    else{
      touch=0;
      if(isValidMove(start: from,end: point,)){
        to=point;
        movePiece();
        isPlayer1Turn=false;
        if(player2wins()){
          print('lollllllllllllllllllllll222222222222222222222');
          currentScreenIndex=2;
          winner=2;
          emit(Player2Win());
          return;
        }
        else if(player1wins()){
          print('lollllllllllllllllllllll1111111111111111111111');
          currentScreenIndex=2;
          winner=1;
          emit(Player1Win());
          return;
        }
        emit(Player2Turn());
      }
      else{
        emit(Player1SelectWrongSquare());
      }
      from.nagOne();
      to.nagOne();
    }
  }

  void player2Turn({required MyPoint point}){
    if(touch==0){
      if(point.x==1||getLastNumber(point: point)>=0){
        touch=0;
        emit(Player2SelectWrongSquare());
        return;
      }
      from=point;
      touch=1;
      emit(Player2Frist());
    }
    else{
      touch=0;
      if(isValidMove(start: from,end: point,)){
        to=point;
        movePiece();
        isPlayer1Turn=true;
        if(player1wins()){
          winner=1;
          currentScreenIndex=2;
          emit(Player1Win());
          return;
        }
        else if(player2wins()){
          currentScreenIndex=2;
          winner=2;
          emit(Player2Win());
          return;
        }
        emit(Player1Turn());
      }
      else{
        emit(Player2SelectWrongSquare());
      }
      from.nagOne();
      to.nagOne();
    }
  }

  bool isValidMove({required MyPoint start,required MyPoint end,}){
    if(
    end.x!=0||
    abs(start.getLastNumber(arr: boardz))<=abs(end.getLastNumber(arr: boardz))
    )
    {return false;}

    return true;
  }

  void movePiece(){
    if(isValidMove(start: from,end: to)){
      to.insertNumber(arr: boardz, num: from.getLastNumber(arr: boardz));
      from.popNumber(arr: boardz);
    }
  }

  void movePieceFromTo({required MyPoint start,required MyPoint end,}){
    if(isValidMove(start: start,end: end)){
      end.insertNumber(arr: boardz, num: start.getLastNumber(arr: boardz));
      start.popNumber(arr: boardz);
    }
  }

  bool player1wins(){
    if(
      q(y: 0,z: 0)>0&&q(y: 1,z: 0)>0&&q(y: 2,z: 0)>0&&q(y: 3,z: 0)>0
    ||q(y: 0,z: 1)>0&&q(y: 1,z: 1)>0&&q(y: 2,z: 1)>0&&q(y: 3,z: 1)>0
    ||q(y: 0,z: 2)>0&&q(y: 1,z: 2)>0&&q(y: 2,z: 2)>0&&q(y: 3,z: 2)>0
    ||q(y: 0,z: 3)>0&&q(y: 1,z: 3)>0&&q(y: 2,z: 3)>0&&q(y: 3,z: 3)>0

    ||q(y: 0,z: 0)>0&&q(y: 0,z: 1)>0&&q(y: 0,z: 2)>0&&q(y: 0,z: 3)>0
    ||q(y: 1,z: 0)>0&&q(y: 1,z: 1)>0&&q(y: 1,z: 2)>0&&q(y: 1,z: 3)>0
    ||q(y: 2,z: 0)>0&&q(y: 2,z: 1)>0&&q(y: 2,z: 2)>0&&q(y: 2,z: 3)>0
    ||q(y: 3,z: 0)>0&&q(y: 3,z: 1)>0&&q(y: 3,z: 2)>0&&q(y: 3,z: 3)>0

    ||q(y: 0,z: 0)>0&&q(y: 1,z: 1)>0&&q(y: 2,z: 2)>0&&q(y: 3,z: 3)>0
    ||q(y: 0,z: 3)>0&&q(y: 1,z: 2)>0&&q(y: 2,z: 1)>0&&q(y: 3,z: 0)>0
    )
    {return true;}
    return false;
  }

  bool player2wins(){
    if(
          q(y: 0,z: 0)<0&&q(y: 1,z: 0)<0&&q(y: 2,z: 0)<0&&q(y: 3,z: 0)<0
        ||q(y: 0,z: 1)<0&&q(y: 1,z: 1)<0&&q(y: 2,z: 1)<0&&q(y: 3,z: 1)<0
        ||q(y: 0,z: 2)<0&&q(y: 1,z: 2)<0&&q(y: 2,z: 2)<0&&q(y: 3,z: 2)<0
        ||q(y: 0,z: 3)<0&&q(y: 1,z: 3)<0&&q(y: 2,z: 3)<0&&q(y: 3,z: 3)<0

        ||q(y: 0,z: 0)<0&&q(y: 0,z: 1)<0&&q(y: 0,z: 2)<0&&q(y: 0,z: 3)<0
        ||q(y: 1,z: 0)<0&&q(y: 1,z: 1)<0&&q(y: 1,z: 2)<0&&q(y: 1,z: 3)<0
        ||q(y: 2,z: 0)<0&&q(y: 2,z: 1)<0&&q(y: 2,z: 2)<0&&q(y: 2,z: 3)<0
        ||q(y: 3,z: 0)<0&&q(y: 3,z: 1)<0&&q(y: 3,z: 2)<0&&q(y: 3,z: 3)<0

        ||q(y: 0,z: 0)<0&&q(y: 1,z: 1)<0&&q(y: 2,z: 2)<0&&q(y: 3,z: 3)<0
        ||q(y: 0,z: 3)<0&&q(y: 1,z: 2)<0&&q(y: 2,z: 1)<0&&q(y: 3,z: 0)<0
    )
    {return true;}
    return false;
  }

  double getLastNumber({required MyPoint point}){return boardz[point.x][point.y][point.z].last;}

  double q({required int y,required int z}){return boardz[0][y][z].last;}

  void popNumber({required MyPoint point}){
    if(getLastNumber(point: point)==0){return;}
    boardz[point.x][point.y][point.z].removeLast();
  }

  void insertNumber({required MyPoint point,required double num}){
    boardz[point.x][point.y][point.z].add(num);
  }



  void api1(){

  }
}
