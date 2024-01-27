import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class PlayerSelectionScreen extends StatelessWidget {
  const PlayerSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GameCubit.get(context);
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Player Selection Screen',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownMenu(
                  dropdownMenuEntries: const [
                    DropdownMenuEntry<String>(label: 'Human', value: '0'),
                    DropdownMenuEntry<String>(label: 'minmax', value: '1'),
                    DropdownMenuEntry<String>(
                        label: 'alpha-beta pruning', value: '2'),
                    DropdownMenuEntry<String>(
                        label: 'alpha-beta pruning with iterative deepening',
                        value: '3'),
                  ],
                  hintText: 'Player 1',
                  onSelected: (String? value) {
                    cubit.player1Type = value!;
                    cubit.emit(Player1Selected());
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  maintainSize: false,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: cubit.player1Type != '0' && cubit.player1Type != '',
                  child: DropdownMenu(
                    dropdownMenuEntries: const [
                      DropdownMenuEntry<String>(label: 'Easy', value: '1'),
                      DropdownMenuEntry<String>(label: 'Medium', value: '2'),
                      DropdownMenuEntry<String>(label: 'Hard', value: '2'),
                    ],
                    hintText: 'Player 1',
                    onSelected: (String? value) {
                      cubit.difficultyLevelForAI1 = value!;
                      cubit.emit(Player1DifficultySelected());
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownMenu(
                  dropdownMenuEntries: const [
                    DropdownMenuEntry<String>(label: 'Human', value: '0'),
                    DropdownMenuEntry<String>(label: 'minmax', value: '1'),
                    DropdownMenuEntry<String>(
                        label: 'alpha-beta pruning', value: '2'),
                    DropdownMenuEntry<String>(
                        label: 'alpha-beta pruning with iterative deepening',
                        value: '3'),
                  ],
                  hintText: 'Player 2',
                  onSelected: (String? value) {
                    cubit.player2Type = value!;
                    cubit.emit(Player2Selected());
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  maintainSize: false,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: cubit.player2Type != '0' && cubit.player2Type != '',
                  child: DropdownMenu(
                    dropdownMenuEntries: const [
                      DropdownMenuEntry<String>(label: 'Easy', value: '1'),
                      DropdownMenuEntry<String>(label: 'Medium', value: '2'),
                      DropdownMenuEntry<String>(label: 'Hard', value: '2'),
                    ],
                    hintText: 'Player 1',
                    onSelected: (String? value) {
                      cubit.difficultyLevelForAI2 = value!;
                      cubit.emit(Player2DifficultySelected());
                    },
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
                  child: const Text('Next'),
                  onPressed: () {
                    cubit.playerSelectionDone();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
