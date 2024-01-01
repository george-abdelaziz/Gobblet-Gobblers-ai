import 'package:ai_project/modules/board/board_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class Gobblet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context){
          return GameCubit();
        },
      child: BlocConsumer<GameCubit,GameStates>(
        listener: (BuildContext context, GameStates state) {  },
        builder: (BuildContext context, GameStates state) {
          var cubit = GameCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  'Gobblet'
              ),
            ),
            body: BoardScreen(),
          );
        },
      ),
    );
  }
}
