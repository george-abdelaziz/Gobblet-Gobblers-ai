import 'package:ai_project/tmp/minimax.dart';

import 'utils.dart';

testWinning() {
  final board = [
    [
      [0, 4],
      [0, -3],
      [0, 1],
      [0, 2]
    ],
    [
      [0],
      [-1],
      [2],
      [0]
    ],
    [
      [0],
      [2],
      [0],
      [0]
    ],
    [
      [1],
      [-1],
      [0],
      [0]
    ]
  ];
  return isWinningPos(board);
}

void main() {
  print(testWinning());
}
