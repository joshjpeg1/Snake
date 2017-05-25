/**
 * Represents the model, or logic, of the game.
 */
public class SnakeModel {
  public static final int defaultFrameRate = 20;
  private final color white = color(255);
  private final color ground = color(#2d0e05);
  private final color blue = color(#3a7cef);
  private final color red = color(#ff3b4a);
  private final color green = color(#0edd48);
  private final color gray = color(#afafaf);
  private final PFont pixeled = createFont("Pixeled.ttf", 20);
  private final int[] mappedKeys = {UP, DOWN, LEFT, RIGHT};
  private final int[] revMappedKeys = {DOWN, UP, RIGHT, LEFT};
  private final int foodSpawnWait = 750;
  private final int foodDespawnWait = 4000;
  private final int foodEffectWait = 6000;
  
  
  private ArrayList<SnakeSpace> snake;
  private ArrayList<SlimeSpace> slime;
  private ArrayList<AFoodSpace> foods;
  private ArrayList<TurnSpace> turns;
  private GameState gameState;
  private int highScore;
  
  
  private boolean reverseMapping;
  private int effectTimer;
  private int spawnTimer;
  private int despawnTimer;
  private FoodType ate = FoodType.DEFAULT;
  
  /**
   * Constructs a model of the game snake and starts the program.
   */
  public SnakeModel() {
    frameRate(defaultFrameRate);
    highScore = 1;
    textFont(pixeled);
    gameState = GameState.START;
  }
  
  /**
   * Initializes/Resets the world back to its original state.
   */
  private void init() {
    reverseMapping = false;
    spawnTimer = 0;
    despawnTimer = 0;
    effectTimer = 0;
    gameState = GameState.PLAYING;
    if (snake != null && snake.size() > highScore) {
      highScore = snake.size();
    }
    slime = new ArrayList<SlimeSpace>();
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
    updateTimer();
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
    if (ate.equals(FoodType.SLIMER)) {
      slime.add(new SlimeSpace(snake.get(snake.size() - 1).x, snake.get(snake.size() - 1).y));
    }
    for (SlimeSpace sl : slime) {
      sl.drawSpace();
    }
    for (SnakeSpace s : snake) {
      s.drawSnake(ate);
      for (TurnSpace t : turns) {
        if (s.turn(t) && snake.indexOf(s) == snake.size() - 1) {
          removeTurns.add(t);
        }
      }
      s.move(ate, BOARD_SIZE - 1, BOARD_SIZE - 1);
    }
    eatFood(eaten);
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
   * Helper to the updatePlaying() function.
   * Checks if the spawn timer is finished, and if so, spawns a new food on the board.
   * Checks if the despawn timer is finished, and if so, despawns all special foods from the board.
   * Checks if the effect timer is finished, and if so, removes the special effect from the snake and game.
   * If not for any of the above, it starts the timer at the appropriate time.
   */
  private void updateTimer() {
    if (snake.size() >= 5) {
      if (spawnTimer == 0) {
        spawnTimer = millis();
      } else if (millis() - spawnTimer >= foodSpawnWait) {
        spawnTimer = 0;
        if (randomFood() && foods.size() == 2) {
          despawnTimer = millis();
        }
      }
    }
    if (millis() - despawnTimer >= foodDespawnWait) {
      for (int i = 1; i < foods.size(); i++) {
        foods.remove(i);
      }
      if (ate.equals(FoodType.EXPLODER)) {
        ate = FoodType.DEFAULT;
      }
      despawnTimer = 0;
    }
    if (!ate.equals(FoodType.DEFAULT) && millis() - effectTimer >= foodEffectWait) {
      ate = FoodType.DEFAULT;
      effectTimer = 0;
      reverseMapping = false;
      frameRate(defaultFrameRate);
      slime = new ArrayList<SlimeSpace>();
    }
  }
  
  /**
   * Helper to the updateTimer() function. Randomly spawns a random type of food on the map.
   *
   * @return true if a food is spawned, false otherwise
   */
  private boolean randomFood() {
    FoodType which = FoodType.values()[int(random(FoodType.values().length))];
    if (which.willSpawn()) {
      switch (which) {
        case DECAPITATOR:
          foods.add(new DecapitatorFoodSpace(BOARD_SIZE, BOARD_SIZE));
          break;
        case REVERSE:
          foods.add(new ReverseFoodSpace(BOARD_SIZE, BOARD_SIZE));
          break;
        case EXPLODER:
          foods.add(new ExploderFoodSpace(BOARD_SIZE, BOARD_SIZE));
          break;
        case STAR:
          foods.add(new StarFoodSpace(BOARD_SIZE, BOARD_SIZE));
          break;
        case FAST:
          foods.add(new FastFoodSpace(BOARD_SIZE, BOARD_SIZE));
          break;
        case SLOW:
          foods.add(new SlowFoodSpace(BOARD_SIZE, BOARD_SIZE));
          break;
        case SLIMER:
          foods.add(new SlimerFoodSpace(BOARD_SIZE, BOARD_SIZE));
          break;
        default:
          break;
      }
      return true;
    }
    return false;
  }
  
  /**
   * Helper to the updatePlaying() function.
   * Handles eaten food effects and starts the effect timer.
   * Restarts the despawn timer if over.
   * Removes the eaten food from the foods list.
   */
  private void eatFood(AFoodSpace eaten) {
    if (eaten != null) {
      FoodType change = eaten.eatEffect(snake, foods, ate, BOARD_SIZE, BOARD_SIZE);
      if (!change.equals(FoodType.DEFAULT)) {
        ate = change;
        effectTimer = millis();
        if (ate.equals(FoodType.REVERSE)) {
          reverseMapping = true;
        } else if (ate.equals(FoodType.EXPLODER)) {
          despawnTimer = millis();
        }
      }
      foods.remove(eaten);
    }
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
    int[] keys = mappedKeys;
    if (reverseMapping) {
     keys = revMappedKeys;
    }
    if (key == CODED) {
      if (keyCode == keys[0]) {
          addNewTurn(new TurnSpace(head.x, head.y, Direction.DIR_UP));
      } else if (keyCode == keys[1]) {
          addNewTurn(new TurnSpace(head.x, head.y, Direction.DIR_DOWN));
      } else if (keyCode == keys[2]) {
          addNewTurn(new TurnSpace(head.x, head.y, Direction.DIR_LEFT));
      } else if (keyCode == keys[3]) {
          addNewTurn(new TurnSpace(head.x, head.y, Direction.DIR_RIGHT));
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
    for (SlimeSpace s : slime) {
      if (!over && snake.get(0).samePosition(s)) {
        over = true;
      }
    }
    if (over || snake.get(0).outOfBounds(BOARD_SIZE - 1, BOARD_SIZE - 1) || snake.size() == 0) {
      gameState = GameState.GAME_OVER;
      return true;
    }
    return false;
  }
}