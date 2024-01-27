import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class WinScreen extends StatelessWidget {
  const WinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GameCubit cubit = GameCubit.get(context);
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Player ${cubit.winner} Wins',
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              color: Colors.deepPurpleAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Restart'),
              onPressed: () {
                cubit.restart();
              },
            ),
          ],
        ));
      },
    );
  }
}
