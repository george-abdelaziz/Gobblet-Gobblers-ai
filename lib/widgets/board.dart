import 'package:ai_project/models/board_point.dart';
import 'package:ai_project/shared/components.dart';
import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  const Board({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(width: 2, color: Colors.black)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...() {
                var r = <Widget>[];
                for (var i = 0; i < 4; i++) {
                  var c = <Widget>[];
                  for (var j = 0; j < 4; j++) {
                    c.add(square(
                        context: context, point: BoardPoint(y: i, z: j)));
                  }
                  r.add(Row(children: c));
                }
                return r;
              }(),
            ],
          ),
        ),
      ),
    );
  }
}
