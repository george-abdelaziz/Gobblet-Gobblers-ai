abstract class GameStates {}

class GameInitialState extends GameStates {}

class GameFinished extends GameStates {}

/////
class Player1Selected extends GameStates {}

class Player2Selected extends GameStates {}

///
class Player1DifficultySelected extends GameStates {}

class Player2DifficultySelected extends GameStates {}

///
class PlayersNotSelected extends GameStates {}

//indicates that the game haz started
class GameStarted extends GameStates {}

/////////////
class SquareClicked extends GameStates {}

class SomeoneMove extends GameStates {}

////////
//for hoomanz
//for player 1
class Player1Turn extends GameStates {}

class Restart extends GameStates {}

class Player1Frist extends GameStates {}

class ShowBoard extends GameStates {}

class Player1SelectWrongSquare extends GameStates {}

class Player1Win extends GameStates {}

//for player 2
class Player2Turn extends GameStates {}

class Player2Frist extends GameStates {}

class Player2SelectWrongSquare extends GameStates {}

class Player2Win extends GameStates {}

//for AIz
class AIPlayed extends GameStates {}

class AI1Played extends GameStates {}

class AI2Played extends GameStates {}

class BattleOfTheAIs extends GameStates {}
