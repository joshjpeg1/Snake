/**
 * Represents the view of the game.
 */
public class SnakeView {
  private final color white = color(255);
  private final color ground = color(#2d0e05);
  private final color blue = color(#3a7cef);
  private final color red = color(#ff3b4a);
  private final color green = color(#0edd48);
  private final color gray = color(#afafaf);
  private final PFont pixeled = createFont("Pixeled.ttf", 20);
  
  /**
   * Constructs a {@code SnakeView} object.
   */
  public SnakeView() {
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
        displayStart();
        break;
      case INSTRUCTIONS:
        //displayInstructions();
        break;
      case PLAYING:
        displayPlaying(snake, foods, slime, ate, highScore);
        break;
      case GAME_OVER:
        displayGameOver(snake, highScore);
        break;
      default:
        throw new IllegalStateException("State of game does not exist.");
    }
  }
  
  /**
   * Displays the start screen of the game.
   */
  public void displayStart() {
    fill(white);
    textAlign(CENTER);
    textSize(100);
    text("snake", width/2, height/2);
    fill(green);
    textSize(20);
    text("click to start", width/2, height/2 + 40);
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
}