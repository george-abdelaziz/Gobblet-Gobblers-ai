abstract class GameState {}

class GameInitialState extends GameState {}

//
class Player1Selected extends GameState {}

class Player2Selected extends GameState {}

///
class Player1DifficultySelected extends GameState {}

class Player2DifficultySelected extends GameState {}

//
class PlayersNotSelected extends GameState {}

// indicates that the game haz started
class GameStarted extends GameState {}

//
class SquareClicked extends GameState {}

class SomeoneMove extends GameState {}

//
// for hoomanz
// for player 1
class Player1Turn extends GameState {}

class Restart extends GameState {}

class Player1Frist extends GameState {}

class Player1SelectWrongSquare extends GameState {}

class Player1Win extends GameState {}

// for player 2
class Player2Turn extends GameState {}

class Player2Frist extends GameState {}

class Player2SelectWrongSquare extends GameState {}

class Player2Win extends GameState {}

// for AIz
class AIPlayed extends GameState {}

class AI1Played extends GameState {}

class AI2Played extends GameState {}
