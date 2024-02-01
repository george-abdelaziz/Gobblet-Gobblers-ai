import 'package:ai_project/cubit/game_cubit.dart';
import 'package:ai_project/models/board_point.dart';
import 'package:flutter/material.dart';

class Piece extends StatelessWidget {
  final BoardPoint point;

  const Piece({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    GameCubit cubit = GameCubit.get(context);
    double size = point.getLastNumber(arr: cubit.board);
    if (size == 0) {
      return const SizedBox();
    }
    Color color;
    size = 20 * size;

    color = size > 0 ? Colors.red : Colors.lightBlueAccent;
    size = size.abs();
    if (point.x == cubit.from.x &&
        point.y == cubit.from.y &&
        point.z == cubit.from.z) {
      color = Colors.greenAccent;
    }
    return Center(
      child: MaterialButton(
        height: size + 20,
        color: color,
        shape: const CircleBorder(),
        onPressed: () {
          var cubit = GameCubit.get(context);
          cubit.plays(point: point);
        },
      ),
    );
  }
}
