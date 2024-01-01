import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/gobblet/cubit/cubit.dart';
import '../../layout/gobblet/cubit/states.dart';

class WinScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    GameCubit cubit=GameCubit.get(context);
    return BlocConsumer<GameCubit, GameStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Player ${cubit.winner} Wins',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            )
        );
      },
    );  }
}
