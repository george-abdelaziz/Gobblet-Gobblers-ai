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
        listener: (BuildContext context, GameStates state) {},
        builder: (BuildContext context, GameStates state) {
          var cubit = GameCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Gobblet'),
            ),
            body: cubit.screens[cubit.screenIndex],
          );
        },
      ),
    );
  }
}
