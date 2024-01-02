abstract class GameStates {}

class GameInitialState extends GameStates {}

class SquareClicked extends GameStates {}

class PlayersNotSelected extends GameStates {}

//indicates that the game haz started
class GameStarted extends GameStates {}

/////////////

class SomeoneMove extends GameStates {}

////////
//for hoomanz
//for player 1
class Player1Turn extends GameStates {}

class Player1Frist extends GameStates {}

class Player1SelectWrongSquare extends GameStates {}

class Player1Win extends GameStates {}

//for player 2
class Player2Turn extends GameStates {}

class Player2Frist extends GameStates {}

class Player2SelectWrongSquare extends GameStates {}

class Player2Win extends GameStates {}

//for AIz
class AI1Played extends GameStates {}

class AI2Played extends GameStates {}



