import 'package:ai_project/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/game_cubit.dart';
import '../cubit/game_states.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = GameCubit.get(context);
        //@greybeast
        return SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MaterialButton(
                  color: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('GET OUT'),
                  onPressed: () {
                    cubit.restart();
                  },
                ),
                playerRepo(context, 1),
                board(context),
                playerRepo(context, 2),

                // player1(context, 2),
                // player2(context),
              ],
            ),
          ),
        );
      },
    );
  }
}
