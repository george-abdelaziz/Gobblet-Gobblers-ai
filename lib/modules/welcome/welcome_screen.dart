import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/gobblet/cubit/cubit.dart';
import '../../layout/gobblet/cubit/states.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome Screen',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            )
        );
      },
    );
  }
}
