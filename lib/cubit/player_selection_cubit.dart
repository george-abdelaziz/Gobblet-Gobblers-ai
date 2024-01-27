import 'package:ai_project/agents/agent.dart';
import 'package:ai_project/agents/alphabeta.dart';
import 'package:ai_project/agents/minimax.dart';
import 'package:ai_project/cubit/player_selection_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerSlectionCubit extends Cubit<PlayerSelectionState> {
  PlayerSlectionCubit() : super(PlayerSelectionInitialState());
  Agent? player1;
  Agent? player2;

  void selectPlayer1(String value) {
    emit(Player1Selected(value));
  }

  void selectPlayer2(String value) {
    emit(Player2Selected(value));
  }

  Agent _createAgent(String agentType) {
    switch (agentType) {
      case 'MiniMax':
        return MiniMax(3);
      case 'AlphaBeta':
        return AlphaBeta(3);
      case 'AlphaBetaPruning':
        // TODO: not implemented
        throw Exception("not implemented");
      // return AlphaBetaPruning(3);
      default:
        throw Exception('Invalid agent type: $agentType');
    }
  }

  void setAgent(String agentType, int player) {
    switch (player) {
      case 1:
        player1 = _createAgent(agentType);
        break;
      case 2:
        player2 = _createAgent(agentType);
        break;
      default:
        throw Exception('Invalid player: $player');
    }
  }
}
