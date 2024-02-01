import 'package:logger/logger.dart';

double abs(double a) {
  return a > 0 ? a : -a;
}

enum PlayerType { human, minmax, alpa, iter }

enum Selected { selected, not }
