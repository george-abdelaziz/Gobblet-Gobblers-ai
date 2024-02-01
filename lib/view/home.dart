import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return GameCubit();
      },
      child: BlocConsumer<GameCubit, GameStates>(
        listener: (BuildContext context, GameStates state) async {
          var cubit = GameCubit.get(context);
          if (state is BattleOfTheAIs) {
            cubit.aiBattle();
          }
          if (state is AIPlayed) {
            cubit.ai();
          }
        },
        builder: (BuildContext context, GameStates state) {
          var cubit = GameCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Gobblet Gobblers'),
            ),
            body: cubit.screens[cubit.screenIndex],
          );
        },
      ),
    );
  }
}
