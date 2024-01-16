import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/gobblet/cubit/cubit.dart';
import '../../layout/gobblet/cubit/states.dart';

class PlayerSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit=GameCubit.get(context);
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
                const SizedBox(height: 20,),
                DropdownMenu(
                  dropdownMenuEntries: const [
                    DropdownMenuEntry<String>(label: 'Human',value: '0'),
                    DropdownMenuEntry<String>(label: 'minmax',value: '1'),
                    DropdownMenuEntry<String>(label: 'alpha-beta pruning',value: '2'),
                    DropdownMenuEntry<String>(label: 'alpha-beta pruning with iterative deepening',value: '3'),
                  ],
                  hintText: 'Player 1',
                  onSelected: (String? value){
                    cubit.player1=value;
                    // print('${cubit.player1}');
                    cubit.emit(GameStarted());
                  },
                ),
                const SizedBox(height: 20,),
                DropdownMenu(
                  dropdownMenuEntries: const [
                    DropdownMenuEntry<String>(label: 'Human',value: '0'),
                    DropdownMenuEntry<String>(label: 'minmax',value: '1'),
                    DropdownMenuEntry<String>(label: 'alpha-beta pruning',value: '2'),
                    DropdownMenuEntry<String>(label: 'alpha-beta pruning with iterative deepening',value: '3'),
                  ],
                  hintText: 'Player 2',
                  onSelected: (String? value){
                    cubit.player2=value;
                  },
                ),
                const SizedBox(height: 20,),
                MaterialButton(
                  color: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: (){
                    cubit.playerSelectionDone();
                  },
                  child: const Text('Next'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}