/**
 * Represents the model, or logic, of the game.
 */
public class SnakeModel {
  private ArrayList<SnakeSpace> snake;
  private FoodSpace food;
  private ArrayList<TurnSpace> turns;
  private GameState gameState;
  
  private boolean snakeAte;
  private int highScore;

  private color blue = color(#5ddaff);
  private color ground = color(#2d0e05);
  private color white = color(#ffffff);
  
  /**
   * Constructs a model of the game snake and starts the program.
   */
  public SnakeModel() {
    frameRate(15);
    highScore = 1;
    init();
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
    food = new FoodSpace(BOARD_SIZE, BOARD_SIZE);
    turns = new ArrayList<TurnSpace>();
    snakeAte = false;
  }
  
  /**
   * Draws an update of the model, based on the current game state.
   */
  public void update() {
    background(ground);
    isGameOver();
    switch (gameState) {
      case START:
        //drawStart();
        break;
      case INSTRUCTIONS:
        //drawInstructions();
        break;
      case PLAYING:
        drawPlaying();
        break;
      case GAME_OVER:
        drawGameOver();
        break;
      default:
        throw new IllegalStateException("State of game does not exist.");
    }
  }
  
  /**
   * Helper to the update() function. Draws the end screen state.
   */
  private void drawGameOver() {
    fill(white);
    textAlign(CENTER);
    textSize(100);
    text("game over :(", width/2, height/2);
    int padding = 0;
    fill(blue);
    textSize(20);
    padding = 40;
    if (snake.size() > highScore) {
      text("NEW HIGH SCORE: " + snake.size(), width/2, height/2 + padding);
    } else {
      text("HIGH SCORE: " + highScore, width/2, height/2 + padding);
    }
    fill(white);
    textSize(20);
    padding += 30;
    text("score: " + snake.size(), width/2, height/2 + padding);
    textSize(20);
    padding += 30;
    text("press C to continue", width/2, height/2 + padding);
  }
  
  /**
   * Helper to the update() function. Updates and draws the current game state.
   */
  private void drawPlaying() {
    ArrayList<TurnSpace> removeTurns = new ArrayList<TurnSpace>();
    food.drawSpace();
    for (SnakeSpace s : snake) {
      s.drawSpace();
      for (TurnSpace t : turns) {
        if (s.turn(t) && snake.indexOf(s) == snake.size() - 1) {
          removeTurns.add(t);
        }
      }
      snakeAte = snakeAte || s.samePosition(food);
      if (!snakeAte) {
        s.move();
      }
    }
    for (TurnSpace t : removeTurns) {
      turns.remove(t);
    }
    if (snakeAte) {
      food.eatEffect(snake);
      food = new FoodSpace(BOARD_SIZE, BOARD_SIZE);
      snakeAte = false;
    }
    textAlign(RIGHT);
    fill(white);
    if (snake.size() > highScore) {
      fill(blue);
    }
    textSize(20);
    text("Length: " + snake.size(), width - 20, 40);
  }
  
  /**
   * Handles keys pressed based on the current game state.
   */
  public void keyHandler() {
    switch (gameState) {
      case START:
        break;
      case INSTRUCTIONS:
        break;
      case PLAYING:
        keyHandlePlaying();
        break;
      case GAME_OVER:
        keyHandleGameOver();
        break;
      default:
        throw new IllegalStateException("State of game does not exist.");
    }
  }
  
  /**
   * Helper to the keyHandler() function. Handles keys for the PLAYING game state.
   */
  private void keyHandlePlaying() {
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
  private void keyHandleGameOver() {
    if (key == 'c' || key == 'C') {
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