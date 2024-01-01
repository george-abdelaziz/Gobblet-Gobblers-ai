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
          child: Column(
            children: [
              Text('Player Selection Screen'),
            ],
          ),
        );
      },
    );
  }
}