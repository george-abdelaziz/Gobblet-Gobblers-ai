import 'package:ai_project/layout/gobblet/cubit/states.dart';
import 'package:ai_project/models/my_classes.dart';
import 'package:ai_project/modules/player_selection/player_selection_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../gobblet.dart';

class GameCubit extends Cubit<GameStates>{

  GameCubit() : super(GameStarted());
  static GameCubit get(context) {return BlocProvider.of(context);}
  init(){}

  bool isHuman1=true;
  bool isHuman2=true;
  bool isPlayer1Turn=true;
  int touch=0;
  int currentScreenIndex=0;
  MyPoint from= MyPoint(x: 0);
  MyPoint to=MyPoint(x: 0);
  List<Widget> screens=[
    PlayerSelectionScreen(),
    Gobblet(),
  ];
  List<String> modes=[
    'minmax',
    'alpha-beta pruning',
    'alpha-beta pruning with iterative deepening '
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
          MyPoint(x:1,y:0,).getLastNumber(arr:boardz)>0&&MyPoint(x:0,y:1,).getLastNumber(arr:boardz)>0&&MyPoint(x:0,y:2,).getLastNumber(arr:boardz)>0&&MyPoint(x:0,y:3,).getLastNumber(arr:boardz)>0
        ||MyPoint(x:1,y:0,).getLastNumber(arr:boardz)>0&&MyPoint(x:1,y:1,).getLastNumber(arr:boardz)>0&&MyPoint(x:1,y:2,).getLastNumber(arr:boardz)>0&&MyPoint(x:1,y:3,).getLastNumber(arr:boardz)>0
        ||MyPoint(x:2,y:0,).getLastNumber(arr:boardz)>0&&MyPoint(x:2,y:1,).getLastNumber(arr:boardz)>0&&MyPoint(x:2,y:2,).getLastNumber(arr:boardz)>0&&MyPoint(x:2,y:3,).getLastNumber(arr:boardz)>0
        ||MyPoint(x:3,y:0,).getLastNumber(arr:boardz)>0&&MyPoint(x:3,y:1,).getLastNumber(arr:boardz)>0&&MyPoint(x:3,y:2,).getLastNumber(arr:boardz)>0&&MyPoint(x:3,y:3,).getLastNumber(arr:boardz)>0

        ||MyPoint(x:0,y:0,).getLastNumber(arr:boardz)>0&&MyPoint(x:1,y:0,).getLastNumber(arr:boardz)>0&&MyPoint(x:2,y:0,).getLastNumber(arr:boardz)>0&&MyPoint(x:3,y:0,).getLastNumber(arr:boardz)>0
        ||MyPoint(x:0,y:1,).getLastNumber(arr:boardz)>0&&MyPoint(x:1,y:1,).getLastNumber(arr:boardz)>0&&MyPoint(x:2,y:1,).getLastNumber(arr:boardz)>0&&MyPoint(x:3,y:1,).getLastNumber(arr:boardz)>0
        ||MyPoint(x:0,y:2,).getLastNumber(arr:boardz)>0&&MyPoint(x:1,y:2,).getLastNumber(arr:boardz)>0&&MyPoint(x:2,y:2,).getLastNumber(arr:boardz)>0&&MyPoint(x:3,y:2,).getLastNumber(arr:boardz)>0
        ||MyPoint(x:0,y:3,).getLastNumber(arr:boardz)>0&&MyPoint(x:1,y:3,).getLastNumber(arr:boardz)>0&&MyPoint(x:2,y:3,).getLastNumber(arr:boardz)>0&&MyPoint(x:3,y:3,).getLastNumber(arr:boardz)>0

        ||MyPoint(x:0,y:0,).getLastNumber(arr:boardz)>0&&MyPoint(x:1,y:1,).getLastNumber(arr:boardz)>0&&MyPoint(x:2,y:2,).getLastNumber(arr:boardz)>0&&MyPoint(x:3,y:3,).getLastNumber(arr:boardz)>0
        ||MyPoint(x:0,y:3,).getLastNumber(arr:boardz)>0&&MyPoint(x:1,y:2,).getLastNumber(arr:boardz)>0&&MyPoint(x:2,y:1,).getLastNumber(arr:boardz)>0&&MyPoint(x:3,y:0,).getLastNumber(arr:boardz)>0

    )
    {return true;}
    return false;
  }

  bool player2wins(){
    if(MyPoint(x:1,y:0,).getLastNumber(arr:boardz)<0&&MyPoint(x:0,y:1,).getLastNumber(arr:boardz)<0&&MyPoint(x:0,y:2,).getLastNumber(arr:boardz)<0&&MyPoint(x:0,y:3,).getLastNumber(arr:boardz)<0
        ||MyPoint(x:1,y:0,).getLastNumber(arr:boardz)<0&&MyPoint(x:1,y:1,).getLastNumber(arr:boardz)<0&&MyPoint(x:1,y:2,).getLastNumber(arr:boardz)<0&&MyPoint(x:1,y:3,).getLastNumber(arr:boardz)<0
        ||MyPoint(x:2,y:0,).getLastNumber(arr:boardz)<0&&MyPoint(x:2,y:1,).getLastNumber(arr:boardz)<0&&MyPoint(x:2,y:2,).getLastNumber(arr:boardz)<0&&MyPoint(x:2,y:3,).getLastNumber(arr:boardz)<0
        ||MyPoint(x:3,y:0,).getLastNumber(arr:boardz)<0&&MyPoint(x:3,y:1,).getLastNumber(arr:boardz)<0&&MyPoint(x:3,y:2,).getLastNumber(arr:boardz)<0&&MyPoint(x:3,y:3,).getLastNumber(arr:boardz)<0

        ||MyPoint(x:0,y:0,).getLastNumber(arr:boardz)<0&&MyPoint(x:1,y:0,).getLastNumber(arr:boardz)<0&&MyPoint(x:2,y:0,).getLastNumber(arr:boardz)<0&&MyPoint(x:3,y:0,).getLastNumber(arr:boardz)<0
        ||MyPoint(x:0,y:1,).getLastNumber(arr:boardz)<0&&MyPoint(x:1,y:1,).getLastNumber(arr:boardz)<0&&MyPoint(x:2,y:1,).getLastNumber(arr:boardz)<0&&MyPoint(x:3,y:1,).getLastNumber(arr:boardz)<0
        ||MyPoint(x:0,y:2,).getLastNumber(arr:boardz)<0&&MyPoint(x:1,y:2,).getLastNumber(arr:boardz)<0&&MyPoint(x:2,y:2,).getLastNumber(arr:boardz)<0&&MyPoint(x:3,y:2,).getLastNumber(arr:boardz)<0
        ||MyPoint(x:0,y:3,).getLastNumber(arr:boardz)<0&&MyPoint(x:1,y:3,).getLastNumber(arr:boardz)<0&&MyPoint(x:2,y:3,).getLastNumber(arr:boardz)<0&&MyPoint(x:3,y:3,).getLastNumber(arr:boardz)<0

        ||MyPoint(x:0,y:0,).getLastNumber(arr:boardz)<0&&MyPoint(x:1,y:1,).getLastNumber(arr:boardz)<0&&MyPoint(x:2,y:2,).getLastNumber(arr:boardz)<0&&MyPoint(x:3,y:3,).getLastNumber(arr:boardz)<0
        ||MyPoint(x:0,y:3,).getLastNumber(arr:boardz)<0&&MyPoint(x:1,y:2,).getLastNumber(arr:boardz)<0&&MyPoint(x:2,y:1,).getLastNumber(arr:boardz)<0&&MyPoint(x:3,y:0,).getLastNumber(arr:boardz)<0

    )
    {return true;}
    return false;
  }

  double getLastNumber({required MyPoint point}){return boardz[point.x][point.y][point.z].last;}

  void popNumber({required MyPoint point}){
    if(getLastNumber(point: point)==0){return;}
    boardz[point.x][point.y][point.z].removeLast();
  }

  void insertNumber({required MyPoint point,required double num}){
    boardz[point.x][point.y][point.z].add(num);
  }
}