/**
 * Represents the model, or logic, of the game.
 */
public class SnakeModel {
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
  private SnakeView view = new SnakeView();
  
  /**
   * Constructs a model of the game snake and starts the program.
   */
  public SnakeModel() {
    highScore = 1;
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
    foods.add(new DefaultFoodSpace());
    turns = new ArrayList<TurnSpace>();
  }
  
  /**
   * Draws an update of the model, based on the current game state.
   */
  public void update() {
    view.display(gameState, snake, foods, slime, ate, highScore);
    view.updateScreen(gameState, mouseX, mouseY);
    if (gameState.equals(GameState.PLAYING)) {
      isGameOver();
      updatePlaying();
    }
  }
  
  /**
   * Helper to the update() function. Updates and draws the current playing state.
   */
  private void updatePlaying() {
    updateTimer();
    ArrayList<TurnSpace> removeTurns = new ArrayList<TurnSpace>();
    AFoodSpace eaten = null;
    for (AFoodSpace f : foods) {
      if (eaten == null && snake.get(0).samePosition(f)) {
        eaten = f;
      }
    }
    if (ate.equals(FoodType.SLIMER)) {
      SnakeSpace last = snake.get(snake.size() - 1);
      if (!last.direction.equals(Direction.STILL)) {
        slime.add(new SlimeSpace(last.x, last.y));
      }
    }
    for (SnakeSpace s : snake) {
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
      frameRate(SnakeView.defaultFrameRate);
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
          foods.add(new DecapitatorFoodSpace());
          break;
        case REVERSE:
          foods.add(new ReverseFoodSpace());
          break;
        case EXPLODER:
          foods.add(new ExploderFoodSpace());
          break;
        case STAR:
          foods.add(new StarFoodSpace());
          break;
        case FAST:
          foods.add(new FastFoodSpace());
          break;
        case SLOW:
          foods.add(new SlowFoodSpace());
          break;
        case SLIMER:
          foods.add(new SlimerFoodSpace());
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
   * Handles keys pressed based on the current game state.
   */
  public void keyHandler() {
    if (gameState.equals(GameState.PLAYING)) {
      keyHandlerPlaying();
    } else {
      keyHandlerScreen(); 
    }
  }
  
  /**
   * Helper to the keyHandler() function. Handles keys for the
   * START, INSTRUCTIONS, and GAME_OVER game states.
   */
  private void keyHandlerScreen() {
    if (key == CODED) {
      if (keyCode == UP || keyCode == DOWN) {
        view.updateScreen(gameState, keyCode == UP);
      }
    } else {
      if (key == '\n' || key == '\r') {
        gameState = view.useButton(gameState);
        if (gameState == GameState.PLAYING) {
          init();
        }
      }
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
   * Handles mouse presses based on the current game state.
   */
  public void mouseHandler() {
    if (!gameState.equals(GameState.PLAYING) && mousePressed) {
      gameState = view.useButton(gameState);
      if (gameState == GameState.PLAYING) {
        init();
      }
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