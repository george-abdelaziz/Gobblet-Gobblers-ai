import 'package:ai_project/layout/gobblet/cubit/cubit.dart';
import 'package:ai_project/models/my_classes.dart';
import 'package:flutter/material.dart';

Widget? piece({
  required BuildContext context,
  required MyPoint point,
}) {
  GameCubit cubit = GameCubit.get(context);
  double size = point.getLastNumber(arr: cubit.board);
  if (size == 0) {
    return null;
  }
  Color color;
  size = 20 * size;
  if (size > 0) {
    color = Colors.red;
  } else {
    size = -size;
    color = Colors.lightBlueAccent;
  }
  if (point.x == cubit.from.x &&
      point.y == cubit.from.y &&
      point.z == cubit.from.z) {
    color = Colors.greenAccent;
  }
  return Center(
    child: MaterialButton(
      height: size,
      color: color,
      textColor: Colors.white,
      shape: const CircleBorder(),
      onPressed: () {
        var cubit = GameCubit.get(context);
        cubit.plays(point: point);
      },
    ),
  );
}

Widget square({
  required BuildContext context,
  required MyPoint point,
}) {
  Color color = Colors.black12;
  if (point.x == 0) {
    if ((point.y + point.z) % 2 == 0) {
      color = Colors.white;
    } else {
      color = Colors.black;
    }
  }
  return InkWell(
    onTap: () {
      GameCubit cubit = GameCubit.get(context);
      cubit.plays(point: point);
    },
    child: Center(
      child: Container(
        height: 100,
        width: 100,
        color: color,
        child: piece(context: context, point: point),
      ),
    ),
  );
}

Widget player(BuildContext context, int player) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Player ${player == 1 ? 1 : 2}',
            style: const TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black)),
                    child: square(
                        context: context, point: MyPoint(x: player, z: 0))),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black)),
                    child: square(
                        context: context, point: MyPoint(x: player, z: 1))),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black)),
                    child: square(
                        context: context, point: MyPoint(x: player, z: 2))),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget board(BuildContext context,) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        decoration:
        BoxDecoration(border: Border.all(width: 2, color: Colors.black)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                square(
                  context: context,
                  point: MyPoint(
                    y: 0,
                    z: 0,
                  ),
                ),
                square(
                  context: context,
                  point: MyPoint(
                    y: 0,
                    z: 1,
                  ),
                ),
                square(
                  context: context,
                  point: MyPoint(
                    y: 0,
                    z: 2,
                  ),
                ),
                square(
                  context: context,
                  point: MyPoint(
                    y: 0,
                    z: 3,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                square(
                  context: context,
                  point: MyPoint(
                    y: 1,
                    z: 0,
                  ),
                ),
                square(
                  context: context,
                  point: MyPoint(
                    y: 1,
                    z: 1,
                  ),
                ),
                square(
                  context: context,
                  point: MyPoint(
                    y: 1,
                    z: 2,
                  ),
                ),
                square(
                  context: context,
                  point: MyPoint(
                    y: 1,
                    z: 3,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                square(
                  context: context,
                  point: MyPoint(
                    y: 2,
                    z: 0,
                  ),
                ),
                square(
                  context: context,
                  point: MyPoint(
                    y: 2,
                    z: 1,
                  ),
                ),
                square(
                  context: context,
                  point: MyPoint(
                    y: 2,
                    z: 2,
                  ),
                ),
                square(
                  context: context,
                  point: MyPoint(
                    y: 2,
                    z: 3,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                square(
                  context: context,
                  point: MyPoint(
                    y: 3,
                    z: 0,
                  ),
                ),
                square(
                  context: context,
                  point: MyPoint(
                    y: 3,
                    z: 1,
                  ),
                ),
                square(
                  context: context,
                  point: MyPoint(
                    y: 3,
                    z: 2,
                  ),
                ),
                square(
                  context: context,
                  point: MyPoint(
                    y: 3,
                    z: 3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}