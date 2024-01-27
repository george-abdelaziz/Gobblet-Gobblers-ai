import 'package:ai_project/agents/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/game_cubit.dart';
import '../cubit/game_states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (BuildContext context, GameState state) {
        kprint(state);
      },
      builder: (BuildContext context, GameState state) {
        final cubit = BlocProvider.of<GameCubit>(context);

        return Scaffold(
          appBar: AppBar(title: const Text('Gobblet')),
          body: cubit.screens[cubit.screenIndex],
        );
      },
    );
  }
}
