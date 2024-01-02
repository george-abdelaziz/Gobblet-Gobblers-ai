import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/gobblet/cubit/cubit.dart';
import '../../layout/gobblet/cubit/states.dart';

class PlayerSelectionScreen extends StatelessWidget {
  //GameCubit cubit=GameCubit.get(context);
  List<DropdownMenuEntry> temp1=[
      DropdownMenuEntry<String>(label: '1',value: '0'),
      DropdownMenuEntry<String>(label: '2',value: '1'),
      DropdownMenuEntry<String>(label: 'alpha-beta pruning',value: '2'),
      DropdownMenuEntry<String>(label: 'alpha-beta pruning with iterative deepening',value: '3'),
    ];
  //if()
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
                Text(
                    'Player Selection Screen',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20,),
                DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry<String>(label: 'Human',value: '0'),
                    DropdownMenuEntry<String>(label: 'minmax',value: '1'),
                    DropdownMenuEntry<String>(label: 'alpha-beta pruning',value: '2'),
                    DropdownMenuEntry<String>(label: 'alpha-beta pruning with iterative deepening',value: '3'),
                  ],
                  //helperText: 'player',
                  hintText: 'Player 1',
                  onSelected: (String? value){
                    cubit.player1=value;
                    cubit.emit(GameStarted());
                  },
                ),
                //DropdownMenu(dropdownMenuEntries:(cubit.player1=='3')?temp1:[],),
                SizedBox(height: 20,),
                DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry<String>(label: 'Human',value: '0'),
                    DropdownMenuEntry<String>(label: 'minmax',value: '1'),
                    DropdownMenuEntry<String>(label: 'alpha-beta pruning',value: '2'),
                    DropdownMenuEntry<String>(label: 'alpha-beta pruning with iterative deepening',value: '3'),
                  ],
                  //helperText: 'player',
                  hintText: 'Player 2',
                  onSelected: (String? value){
                    cubit.player2=value;
                  },
                ),
                SizedBox(height: 20,),
                MaterialButton(
                  child: Text('Next'),
                  color: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: (){
                    cubit.goToGame();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}