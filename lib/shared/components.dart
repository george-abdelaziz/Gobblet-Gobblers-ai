import 'package:ai_project/cubit/game_cubit.dart';
import 'package:ai_project/models/board_point.dart';
import 'package:ai_project/widgets/piece.dart';
import 'package:flutter/material.dart';

Widget square({
  required BuildContext context,
  required BoardPoint point,
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
        child: Piece(point: point),
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
                        context: context, point: BoardPoint(x: player, z: 0))),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black)),
                    child: square(
                        context: context, point: BoardPoint(x: player, z: 1))),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black)),
                    child: square(
                        context: context, point: BoardPoint(x: player, z: 2))),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget boardp(
  BuildContext context,
) {
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
                  point: BoardPoint(
                    y: 0,
                    z: 0,
                  ),
                ),
                square(
                  context: context,
                  point: BoardPoint(
                    y: 0,
                    z: 1,
                  ),
                ),
                square(
                  context: context,
                  point: BoardPoint(
                    y: 0,
                    z: 2,
                  ),
                ),
                square(
                  context: context,
                  point: BoardPoint(
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
                  point: BoardPoint(
                    y: 1,
                    z: 0,
                  ),
                ),
                square(
                  context: context,
                  point: BoardPoint(
                    y: 1,
                    z: 1,
                  ),
                ),
                square(
                  context: context,
                  point: BoardPoint(
                    y: 1,
                    z: 2,
                  ),
                ),
                square(
                  context: context,
                  point: BoardPoint(
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
                  point: BoardPoint(
                    y: 2,
                    z: 0,
                  ),
                ),
                square(
                  context: context,
                  point: BoardPoint(
                    y: 2,
                    z: 1,
                  ),
                ),
                square(
                  context: context,
                  point: BoardPoint(
                    y: 2,
                    z: 2,
                  ),
                ),
                square(
                  context: context,
                  point: BoardPoint(
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
                  point: BoardPoint(
                    y: 3,
                    z: 0,
                  ),
                ),
                square(
                  context: context,
                  point: BoardPoint(
                    y: 3,
                    z: 1,
                  ),
                ),
                square(
                  context: context,
                  point: BoardPoint(
                    y: 3,
                    z: 2,
                  ),
                ),
                square(
                  context: context,
                  point: BoardPoint(
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
