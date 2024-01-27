import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class Gobblet extends StatelessWidget {
  const Gobblet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (BuildContext context, GameState state) {
        Logger().i(state);
      },
      builder: (BuildContext context, GameState state) {
        var cubit = GameCubit.get(context);
        return Scaffold(
          appBar: AppBar(title: const Text('Gobblet')),
          body: cubit.screens[cubit.currentScreenIndex],
        );
      },
    );
  }
}
