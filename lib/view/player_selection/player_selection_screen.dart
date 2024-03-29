import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/game_cubit.dart';
import '../../cubit/states.dart';
import '../../models/my_classes.dart';

class PlayerSelectionScreen extends StatelessWidget {
  const PlayerSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameStates>(
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
                  onSelected: (String? s) {
                    if (s == '0') {
                      cubit.playerType1 = PlayerType.human;
                    } else if (s == '1') {
                      cubit.playerType1 = PlayerType.minmax;
                    } else if (s == '2') {
                      cubit.playerType1 = PlayerType.alpa;
                    } else if (s == '3') {
                      cubit.playerType1 = PlayerType.iter;
                    }
                    cubit.type1 = Selected.selected;
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
                  visible: cubit.playerType1 != PlayerType.human &&
                      cubit.playerType1 != PlayerType.iter,
                  child: DropdownMenu(
                    dropdownMenuEntries: const [
                      DropdownMenuEntry<String>(
                          label: 'Very Easy', value: 'Very Easy'),
                      DropdownMenuEntry<String>(label: 'Easy', value: 'Easy'),
                      DropdownMenuEntry<String>(
                          label: 'Normal', value: 'Normal'),
                      DropdownMenuEntry<String>(
                          label: 'Difficult', value: 'Difficult'),
                    ],
                    hintText: 'Player 1',
                    onSelected: (String? s) {
                      if (s == 'Very Easy') {
                        cubit.difficultyLevelForAI1 = 1;
                      }
                      if (s == 'Easy') {
                        cubit.difficultyLevelForAI1 = 2;
                      } else if (s == 'Normal') {
                        cubit.difficultyLevelForAI1 = 3;
                      } else if (s == 'Difficult') {
                        cubit.difficultyLevelForAI1 = 4;
                      }
                      cubit.level1 = Selected.selected;
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
                  onSelected: (String? s) {
                    if (s == '0') {
                      cubit.playerType2 = PlayerType.human;
                    } else if (s == '1') {
                      cubit.playerType2 = PlayerType.minmax;
                    } else if (s == '2') {
                      cubit.playerType2 = PlayerType.alpa;
                    } else if (s == '3') {
                      cubit.playerType2 = PlayerType.iter;
                    }
                    cubit.type2 = Selected.selected;
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
                  visible: cubit.playerType2 != PlayerType.human &&
                      cubit.playerType1 != PlayerType.iter,
                  child: DropdownMenu(
                    dropdownMenuEntries: const [
                      DropdownMenuEntry<String>(
                          label: 'Very Easy', value: 'Very Easy'),
                      DropdownMenuEntry<String>(label: 'Easy', value: 'Easy'),
                      DropdownMenuEntry<String>(
                          label: 'Normal', value: 'Normal'),
                      DropdownMenuEntry<String>(
                          label: 'Difficult', value: 'Difficult'),
                    ],
                    hintText: 'Player 2',
                    onSelected: (String? s) {
                      if (s == 'Easy') {
                        cubit.difficultyLevelForAI2 = 2;
                      } else if (s == 'Very Easy') {
                        cubit.difficultyLevelForAI2 = 1;
                      } else if (s == 'Normal') {
                        cubit.difficultyLevelForAI2 = 3;
                      } else if (s == 'Difficult') {
                        cubit.difficultyLevelForAI2 = 4;
                      }
                      cubit.level2 = Selected.selected;
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
