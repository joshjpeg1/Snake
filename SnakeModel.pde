/**
 * Represents the model, or logic, of the game.
 */
public class SnakeModel {
  private ArrayList<SnakeSpace> snake;
  private ArrayList<AFoodSpace> foods;
  private ArrayList<TurnSpace> turns;
  private GameState gameState;
  private int highScore;

  private final color white = color(255);
  private final color ground = color(#2d0e05);
  private final color blue = color(#3a7cef);
  private final color red = color(#ff3b4a);
  private final color green = color(#0edd48);
  private final color gray = color(#afafaf);
  private PFont pixeled = createFont("Pixeled.ttf", 20);
  
  /**
   * Constructs a model of the game snake and starts the program.
   */
  public SnakeModel() {
    frameRate(15);
    highScore = 1;
    textFont(pixeled);
    gameState = GameState.START;
  }
  
  /**
   * Initializes/Resets the world back to its original state.
   */
  private void init() {
    gameState = GameState.PLAYING;
    if (snake != null && snake.size() > highScore) {
      highScore = snake.size();
    }
    snake = new ArrayList<SnakeSpace>();
    SnakeSpace head = new SnakeSpace(1, 1);
    head.setHead(true);
    snake.add(head);
    foods = new ArrayList<AFoodSpace>();
    foods.add(new DefaultFoodSpace(BOARD_SIZE, BOARD_SIZE));
    turns = new ArrayList<TurnSpace>();
  }
  
  /**
   * Draws an update of the model, based on the current game state.
   */
  public void update() {
    background(ground);
    switch (gameState) {
      case START:
        updateStart();
        break;
      case INSTRUCTIONS:
        //updateInstructions();
        break;
      case PLAYING:
        isGameOver();
        updatePlaying();
        break;
      case GAME_OVER:
        updateGameOver();
        break;
      default:
        throw new IllegalStateException("State of game does not exist.");
    }
  }
  
  /**
   * Helper to the update() function. Draws the start screen state.
   */
  private void updateStart() {
    fill(white);
    textAlign(CENTER);
    textSize(100);
    text("snake", width/2, height/2);
    fill(green);
    textSize(20);
    text("click to start", width/2, height/2 + 40);
  }
  
  /**
   * Helper to the update() function. Updates and draws the current playing state.
   */
  private void updatePlaying() {
    ArrayList<TurnSpace> removeTurns = new ArrayList<TurnSpace>();
    AFoodSpace eaten = null;
    for (AFoodSpace f : foods) {
      f.drawSpace();
    }
    for (AFoodSpace f : foods) {
      if (eaten == null && snake.get(0).samePosition(f)) {
        eaten = f;
      }
    }
    for (SnakeSpace s : snake) {
      s.drawSpace();
      for (TurnSpace t : turns) {
        if (s.turn(t) && snake.indexOf(s) == snake.size() - 1) {
          removeTurns.add(t);
        }
      }
      s.move();
    }
    if (eaten != null) {
      eaten.eatEffect(snake, foods, BOARD_SIZE, BOARD_SIZE);
      foods.remove(eaten);
    }
    for (TurnSpace t : removeTurns) {
      turns.remove(t);
    }
    textAlign(RIGHT);
    fill(white);
    if (snake.size() > highScore) {
      fill(blue);
    }
    textSize(20);
    text(snake.size(), width - 10, 40);
  }
  
  /**
   * Helper to the update() function. Draws the game over screen state.
   */
  private void updateGameOver() {
    fill(white);
    textAlign(CENTER);
    textSize(100);
    text("game over", width/2, height/2);
    int padding = 0;
    textSize(20);
    padding = 60;
    if (snake.size() > highScore) {
      fill(blue);
      text("NEW HIGH SCORE: " + snake.size(), width/2, height/2 + padding);
    } else {
      fill(gray);
      text("high score: " + highScore, width/2, height/2 + padding);
    }
    fill(gray);
    padding += 40;
    text("score: " + snake.size(), width/2, height/2 + padding);
    padding += 40;
    fill(green);
    text("continue", width/2, height/2 + padding);
  }
  
  /**
   * Handles keys pressed based on the current game state.
   */
  public void keyHandler() {
    if (gameState.equals(GameState.PLAYING)) {
      keyHandlerPlaying();
    } else if (gameState.equals(GameState.GAME_OVER)) {
      keyHandlerGameOver();
    }
  }
  
  /**
   * Helper to the keyHandler() function. Handles keys for the PLAYING game state.
   */
  private void keyHandlerPlaying() {
    SnakeSpace head = snake.get(0);
    if (key == CODED) {
      switch (keyCode) {
        case UP:
          addNewTurn(new TurnSpace(head.x, head.y, Direction.DIR_UP));
          break;
        case DOWN:
          addNewTurn(new TurnSpace(head.x, head.y, Direction.DIR_DOWN));
          break;
        case LEFT:
          addNewTurn(new TurnSpace(head.x, head.y, Direction.DIR_LEFT));
          break;
        case RIGHT:
          addNewTurn(new TurnSpace(head.x, head.y, Direction.DIR_RIGHT));
          break;
        default:
          break;
      }
    }
  }
  
  /**
   * Helper to the keyHandlePlaying() method. Adds a new turn to the turns list,
   * if not the same direction of the snake head or position of the last turn.
   *
   * @throws IllegalArgumentException if the given {@code TurnSpace} is null
   */
  private void addNewTurn(TurnSpace t) throws IllegalArgumentException {
    if (t == null) {
      throw new IllegalArgumentException("Can't add null.");
    }
    if (!t.direction.equals(snake.get(0).direction)) {
      if (turns.size() == 0) {
        turns.add(t);
      } else {
        if (!turns.get(turns.size() - 1).samePosition(t)) {
          turns.add(t);
        }
      }
    }
  }
  
  /**
   * Helper to the keyHandler() function. Handles keys for the GAME_OVER game state.
   */
  private void keyHandlerGameOver() {
    if (key == '\n' || key == '\r') {
      init();
    }
  }
  
  public void mouseHandler() {
    if (gameState.equals(GameState.START)) {
      init();
    }
  }
  
  /**
   * Decides whether the game is over or not.
   *
   * @return true if the game is over, false otherwise
   */
  private boolean isGameOver() {
    boolean over = false;
    for (int i = 1; i < snake.size(); i++) {
      if (!over && snake.get(i).equals(snake.get(0))) {
        over = true;
      }
    }
    if (over || snake.get(0).outOfBounds(BOARD_SIZE - 1, BOARD_SIZE - 1)) {
      gameState = GameState.GAME_OVER;
      return true;
    }
    return false;
  }
}