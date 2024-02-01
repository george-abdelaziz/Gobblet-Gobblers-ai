import 'package:ai_project/agents/utils.dart';

class Adapter {
  List<List<List<List<double>>>> b2f(Map<String, dynamic> game, board) {
    List<List<List<List<double>>>> b=[[],[],[]];
    board[0] = _convInt2Double(game['board']);
    board[1][0] = _convListInt2Double(game['p1']);
    board[2][0] = _convListInt2Double(game['p2']);
    return board;
  }

  Map f2b(board) {
    var x = getGameState(_bti(board[0]), _ctd(board[1][0]), _ctd(board[2][0]));
    return x;
  }

  List<List<List<double>>> _convInt2Double(List<List<List>> inputList) {
    List<List<List<double>>> result = [];

    for (List<List> outerList in inputList) {
      List<List<double>> outerResult = [];

      for (List innerList in outerList) {
        List<double> innerResult = [];

        for (int value in innerList) {
          innerResult.add(value.toDouble());
        }

        outerResult.add(innerResult);
      }

      result.add(outerResult);
    }

    return result;
  }

  List<List<double>> _convListInt2Double(List<List> inputList) {
    List<List<double>> result = [];

    for (List innerList in inputList) {
      List<double> innerResult = [];

      for (int value in innerList) {
        innerResult.add(value.toDouble());
      }

      result.add(innerResult);
    }

    return result;
  }

  List<List> _ctd(List<List<double>> inputList) {
    List<List> result = [];
    for (List<double> innerList in inputList) {
      List<int> innerResult = [];
      for (double value in innerList) {
        innerResult.add(value.toInt());
      }
      result.add(innerResult);
    }
    return result;
  }

  List<List<List>> _bti(List<List<List<double>>> inputList) {
    List<List<List>> result = [];
    for (List<List<double>> outerList in inputList) {
      List<List<int>> outerResult = [];
      for (List<double> innerList in outerList) {
        List<int> innerResult = [];
        for (double value in innerList) {
          innerResult.add(value.toInt());
        }
        outerResult.add(innerResult);
      }
      result.add(outerResult);
    }
    return result;
  }
}
