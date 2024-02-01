import 'package:logger/logger.dart';

class BoardPoint {
  //qwerty[which board][vertical height of the board][horizontal width of the board][n/height of the stack]=double;
  //qwerty[x][y][z][n]=double;
  int x = 0;
  int y = 0;
  int z = 0;

  BoardPoint({this.x = 0, this.y = 0, this.z = 0});

  void zero() {
    x = 0;
    y = 0;
    z = 0;
  }

  void nagOne() {
    x = -1;
    y = -1;
    z = -1;
  }

  void myPrint() {
    print('$x,     $y,     $z');
  }

  double getLastNumber({required List<List<List<List<double>>>> arr}) {
    try {
      if (arr[x][y][z].isEmpty) return 0;
      return arr[x][y][z].last;
    } catch (e) {
      var logger = Logger();
      logger.f(e);
    }
    return 0;
  }

  void popNumber({required List<List<List<List<double>>>> arr}) {
    if (getLastNumber(arr: arr) == 0) {
      return;
    }
    arr[x][y][z].removeLast();
  }

  void insertNumber(
      {required List<List<List<List<double>>>> arr, required double num}) {
    arr[x][y][z].add(num);
  }
}
