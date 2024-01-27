abstract class PlayerSelectionState {}

class PlayerSelectionInitialState extends PlayerSelectionState {}

class Player1Selected extends PlayerSelectionState {
  final String value;
  Player1Selected(this.value);
}

class Player2Selected extends PlayerSelectionState {
  final String value;
  Player2Selected(this.value);
}
