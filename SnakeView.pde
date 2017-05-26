import java.util.Arrays;

/**
 * Represents the view of the game.
 */
public class SnakeView {
  public static final int defaultFrameRate = 15;
  private final color white = color(255);
  private final color ground = color(#2d0e05);
  private final color blue = color(#3a7cef);
  private final PFont pixeled = createFont("Pixeled.ttf", 20);
  private PShape cursor;
  
  private Screen start = new Screen("snake",
      new ArrayList<String>(),
      new ArrayList<String>(Arrays.asList("play", "instructions")),
      new ArrayList<GameState>(Arrays.asList(GameState.PLAYING, GameState.INSTRUCTIONS)));
      
  private Screen instruct = new Screen("instructions",
      new ArrayList<String>(Arrays.asList("use arrow keys to\nmove the snake\nand eat food", "don't hit the\nwalls or yourself")),
      new ArrayList<String>(Arrays.asList("back")),
      new ArrayList<GameState>(Arrays.asList(GameState.START)));
      
  private Screen gameOver = new Screen("game\nover",
      new ArrayList<String>(Arrays.asList("high score: 0", "score: 0")),
      new ArrayList<String>(Arrays.asList("continue", "exit")),
      new ArrayList<GameState>(Arrays.asList(GameState.PLAYING, GameState.START)));
  
  //private ArrayList<Button> startBtns = new ArrayList<Button>();
  //private ArrayList<Button> instructBtns = new ArrayList<Button>();
  //private ArrayList<Button> gameOverBtns = new ArrayList<Button>();
    /*int x, int y, String value, boolean focus, color defaultColor,
                color focusColor*/
  
  /**
   * Constructs a {@code SnakeView} object.
   */
  public SnakeView() {
    frameRate(30);
    cursor = loadShape("snake.svg");
    textFont(pixeled);
  }
  
  /**
   * Displays the current game, depending on the game state.
   *
   * @param gs           the current state of the game
   * @param snake        a list representing the snake
   * @param foods        a list of all foods currently in game
   * @param slime        a list of all slime blocks in the game
   * @param ate          the type of food the snake last ate
   * @param highScore    the current high score
   */
  public void display(GameState gs, ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods,
                      ArrayList<SlimeSpace> slime, FoodType ate, int highScore) {
    background(ground);
    switch (gs) {
      case START:
        frameRate(30);
        displayStart();
        break;
      case INSTRUCTIONS:
        frameRate(30);
        displayInstructions();
        break;
      case PLAYING:
        frameRate(defaultFrameRate);
        displayPlaying(snake, foods, slime, ate, highScore);
        break;
      case GAME_OVER:
        frameRate(30);
        displayGameOver(snake, highScore);
        break;
      default:
        throw new IllegalStateException("State of game does not exist.");
    }
  }
  
  public void updateScreen(GameState gs, boolean up) {
    if (gs.equals(GameState.START)) {
      start.update(up);
    } else if (gs.equals(GameState.GAME_OVER)) {
      gameOver.update(up);
    } else if (gs.equals(GameState.INSTRUCTIONS)) {
      instruct.update(up);
    }
  }
  
  public void updateScreen(GameState gs, int mX, int mY) {
    if (gs.equals(GameState.START)) {
      start.update(mX, mY);
    } else if (gs.equals(GameState.GAME_OVER)) {
      gameOver.update(mX, mY);
    } else if (gs.equals(GameState.INSTRUCTIONS)) {
      instruct.update(mX, mY);
    }
  }
  
  public GameState useButton(GameState gs) {
    GameState action = null;
    if (gs.equals(GameState.START)) {
      action = start.useButton();
    } else if (gs.equals(GameState.GAME_OVER)) {
      action = gameOver.useButton();
    } else if (gs.equals(GameState.INSTRUCTIONS)) {
      action = instruct.useButton();
    }
    if (action != null) {
      return action;
    }
    return gs;
  }
  
  /**
   * Displays the start screen of the game.
   */
  public void displayStart() {
    start.display();
    shape(cursor, mouseX, mouseY);
  }
  
  public void displayInstructions() {
    instruct.display();
    shape(cursor, mouseX, mouseY);
  }
  
  /**
   * Displays the current playing state of the game.
   *
   * @param snake        a list representing the snake
   * @param foods        a list of all foods currently in game
   * @param slime        a list of all slime blocks in the game
   * @param ate          the type of food the snake last ate
   * @param highScore    the current high score
   */
  public void displayPlaying(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods,
                             ArrayList<SlimeSpace> slime, FoodType ate, int highScore) {
    for (AFoodSpace f : foods) {
      f.drawSpace();
    }
    if (ate.equals(FoodType.SLIMER)) {
      slime.add(new SlimeSpace(snake.get(snake.size() - 1).x, snake.get(snake.size() - 1).y));
    }
    for (SlimeSpace sl : slime) {
      sl.drawSpace();
    }
    for (SnakeSpace s : snake) {
      s.drawSnake(ate);
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
   * Displays the game over screen of the game.
   *
   * @param snake        a list representing the snake
   * @param highScore    the current high score
   */
  public void displayGameOver(ArrayList<SnakeSpace> snake, int highScore) {
    String highscoreText;
    if (snake.size() > highScore) {
      highscoreText = "NEW HIGH SCORE: " + snake.size();
    } else {
      highscoreText = "high score: " + highScore;
    }
    
    gameOver.setBody(new ArrayList<String>(Arrays.asList(highscoreText, "score: " + snake.size())));
    gameOver.display();
    shape(cursor, mouseX, mouseY);
  }
}