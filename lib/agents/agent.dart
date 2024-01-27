abstract class Agent {
  int depth;
  Agent(this.depth);
  Map calcBestMove(Map gamestate, int plr);
}
