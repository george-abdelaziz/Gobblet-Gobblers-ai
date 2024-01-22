class Config {
  static const winning = 200000000.0;
  static const draw = 1500.0;
  static const danger = 500;
  static const alphaBetaDepth = 3;
  static const miniMaxDepth = 3;
  static var initialgame = {"board": board, "p1": set1, "p2": set2};

  static const set1 = [
    [1, 2, 3, 4],
    [1, 2, 3, 4],
    [1, 2, 3, 4],
  ];
  static const set2 = [
    [-1, -2, -3, -4],
    [-1, -2, -3, -4],
    [-1, -2, -3, -4],
  ];
  static const board = [
    [
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0]
    ]
  ];
}
