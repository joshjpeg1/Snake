import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Random; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class snake extends PApplet {

/**
 * The main tab for the snake game.
 *
 * @author       Joshua Pensky
 * @title        Snake
 * @description  A game where users play as a snake, maneuvering around the map and themself
                 to get food and become larger.
 * @version      1.1
 */

public static final int BOARD_SIZE = 50;
public int spaceSize;
public SnakeModel model;

/**
 * Sets up the program.
 */
public void setup() {
  
  spaceSize = width / BOARD_SIZE;
  model = new SnakeModel();
}

/**
 * Draws the current state of the game.
 */
public void draw() {
  model.update();
}

/**
 * Handles a key pressed when the program is running.
 */
public void keyPressed() {
  model.keyHandler();
}

/**
 * Handles a mouse press when the program is running.
 */
public void mousePressed() {
  model.mouseHandler();
}
/**
 * Represents a food space on the grid.
 */
public abstract class AFoodSpace extends ASpace {
  /**
   * Constructs a {@code AFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public AFoodSpace() {
    super(0, 0);
    randomSpace(snake.BOARD_SIZE, snake.BOARD_SIZE);
  }
  
  /**
   * Assigns this {@code AFoodSpace} a random position on the grid.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public void randomSpace(int hiX, int hiY) {
    this.x = PApplet.parseInt(random(hiX));
    this.y = PApplet.parseInt(random(hiY));
  }
  
  @Override
  public int getColor() {
    return color(234);
  }
  
  /**
   * Mutates the list based on the effect of this {@code AFoodSpace}.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @param foods       a list of {@code FoodSpace}s currently on the map
   * @param ate         the last type of food the snake has eaten
   * @param hiX         the upper-bound of the x-position
   * @param hiY         the upper-bound of the y-position
   * @throws IllegalArgumentException if given snake list is null or size 0, or if foods list is null
   * @return the FoodType representation of this food
   */
  public abstract FoodType eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, FoodType ate,
                                 int hiX, int hiY) throws IllegalArgumentException;
}
/**
 * Represents a space on the grid.
 */
public abstract class ASpace {
  protected int x;
  protected int y;
  
  /**
   * Constructs an {@code ASpace}.
   * 
   * @param x     the x-position
   * @param y     the y-position
   */
  public ASpace(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  @Override
  public boolean equals(Object that) {
    if (this == that) {
      return true;
    }
    if (!(that instanceof ASpace)) {
      return false;
    }
    return this.samePosition((ASpace) that);
  }
  
  @Override
  public int hashCode() {
    return (x * 1000) + y;
  }
  
  /**
   * Checks whether this {@code ASpace} is at the same position of the given one.
   *
   * @return true if the same position, false otherwise
   * @throws IllegalArgumentException if given {@code ASpace} is null
   */
  public boolean samePosition(ASpace other) throws IllegalArgumentException {
    if (other == null) {
      throw new IllegalArgumentException("Cannot be same position as null.");
    }
    return this.x == other.x && this.y == other.y;
  }
  
  /**
   * Returns the color of this {@code ASpace}.
   *
   * @return the space color
   */
  public int getColor() {
    return color(127);
  }
  
  /**
   * Draws the space on the grid.
   */
  public void drawSpace() {
    noStroke();
    fill(getColor());
    rect(this.x * spaceSize, this.y * spaceSize,
         spaceSize, spaceSize);
  }
}
/**
 * Represents the decapitator food on the grid.
 */
public class DecapitatorFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code DecapitatorFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public DecapitatorFoodSpace() {
    super();
  }
  
  @Override
  public int getColor() {
    return color(0xffff3b4a);
  }
  
  /**
   * Removes the head of the given snake.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @param foods       a list of {@code FoodSpace}s currently on the map
   * @param ate         the last type of food the snake has eaten
   * @param hiX         the upper-bound of the x-position
   * @param hiY         the upper-bound of the y-position
   * @throws IllegalArgumentException if given snake list is null or size 0, or if foods list is null
   * @return the FoodType representation of this food
   */
  public FoodType eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, FoodType ate,
                        int hiX, int hiY) throws IllegalArgumentException {
    if (snake == null || snake.size() == 0 || foods == null) {
      throw new IllegalArgumentException("Invalid lists passed.");
    }
    snake.remove(0);
    snake.get(0).setHead(true);
    return FoodType.DECAPITATOR;
  }
}
/**
 * Represents the default food on the grid.
 */
public class DefaultFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code DefaultFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public DefaultFoodSpace() {
    super();
  }
  
  /**
   * Adds a new head to the given snake, replacing the old one.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @param foods       a list of {@code FoodSpace}s currently on the map
   * @param ate         the last type of food the snake has eaten
   * @param hiX         the upper-bound of the x-position
   * @param hiY         the upper-bound of the y-position
   * @throws IllegalArgumentException if given snake list is null or size 0, or if foods list is null
   * @return the FoodType representation of this food
   */
  public FoodType eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, FoodType ate,
                        int hiX, int hiY) throws IllegalArgumentException {
    if (snake == null || snake.size() == 0 || foods == null) {
      throw new IllegalArgumentException("Invalid lists passed.");
    }
    for (SnakeSpace s : snake) {
      s.setHead(false);
    }
    SnakeSpace newHead = new SnakeSpace(snake.get(0).x, snake.get(0).y, snake.get(0).direction);
    newHead.setHead(true);
    newHead.move(ate, hiX, hiY);
    snake.add(0, newHead);
    if (!ate.equals(FoodType.EXPLODER)) {
      foods.add(0, new DefaultFoodSpace());
    }
    return FoodType.DEFAULT;
  }
}
/**
 * Represents directions on a grid.
 */
public enum Direction {
  DIR_UP, DIR_DOWN, DIR_LEFT, DIR_RIGHT, STILL;
  
  /**
   * Checks whether it's a valid to turn in the given direction.
   *
   * @return true if a valid turn, false otherwise
   * @throws IllegalArgumentException if given {@code Direction} is null
   */
  public boolean validTurn(Direction other) throws IllegalArgumentException {
    if (other == null) {
      throw new IllegalArgumentException("Cannot validate null.");
    } else if (this.equals(STILL)) {
      return true;
    } else if (this.equals(DIR_UP) || this.equals(DIR_DOWN)) {
      return other.equals(DIR_LEFT) || other.equals(DIR_RIGHT);
    } else {
      return other.equals(DIR_UP) || other.equals(DIR_DOWN);
    }
  }
}
/**
 * Represents the exploder food on the grid.
 */
public class ExploderFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code ExploderFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public ExploderFoodSpace() {
    super();
  }
  
  @Override
  public int getColor() {
    return color(0xff3a7cef);
  }
  
  /**
   * When eaten, the exploder food explodes and creates a random amount of
   * {@code DefaultFoodSpace}s to appear across the map.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @param foods       a list of {@code FoodSpace}s currently on the map
   * @param ate         the last type of food the snake has eaten
   * @param hiX         the upper-bound of the x-position
   * @param hiY         the upper-bound of the y-position
   * @throws IllegalArgumentException if given snake list is null or size 0, or if foods list is null
   * @return the FoodType representation of this food
   */
  public FoodType eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, FoodType ate,
                        int hiX, int hiY) throws IllegalArgumentException {
    if (snake == null || snake.size() == 0 || foods == null) {
      throw new IllegalArgumentException("Invalid lists passed.");
    }
    int willRun = PApplet.parseInt(random(10)) + 1;
    for (int i = 0; i < willRun; i++) {
      foods.add(new DefaultFoodSpace());
    }
    return FoodType.EXPLODER;
  }
}
/**
 * Represents the fast food on the grid.
 */
public class FastFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code FastFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public FastFoodSpace() {
    super();
  }
  
  @Override
  public int getColor() {
    return color(0xffffb452);
  }
  
  /**
   * Doubles the speed of the game.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @param foods       a list of {@code FoodSpace}s currently on the map
   * @param ate         the last type of food the snake has eaten
   * @param hiX         the upper-bound of the x-position
   * @throws IllegalArgumentException if given snake list is null or size 0, or if foods list is null
   * @return the FoodType representation of this food
   */
  public FoodType eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, FoodType ate,
                        int hiX, int hiY) throws IllegalArgumentException {
    if (snake == null || snake.size() == 0 || foods == null) {
      throw new IllegalArgumentException("Invalid lists passed.");
    }
    frameRate(SnakeModel.defaultFrameRate * 3);
    return FoodType.FAST;
  }
}
/**
 * Represents the different types of food.
 */
 

 
public static enum FoodType {
  DEFAULT(1), DECAPITATOR(2), FAST(3),
  SLOW(3), EXPLODER(5), SLIMER(5),
  REVERSE(5), STAR(12);
  
  private int spawnRate;
  
  private FoodType(int spawnRate) {
    this.spawnRate = spawnRate;
  }
  
  public boolean willSpawn() {
    Random rand = new Random();
    return rand.nextInt(this.spawnRate) < 1;
  }
}
/**
 * Represents the different states of the program/game.
 */
public enum GameState {
  START, INSTRUCTIONS, PLAYING, GAME_OVER;
}
/**
 * Represents the reverse food on the grid.
 */
public class ReverseFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code ReverseFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public ReverseFoodSpace() {
    super();
  }
  
  @Override
  public int getColor() {
    return color(0xffffff52);
  }
  
  /**
   * Reverses the mapped controls, so up is down, left is right, etc.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @param foods       a list of {@code FoodSpace}s currently on the map
   * @param ate         the last type of food the snake has eaten
   * @param hiX         the upper-bound of the x-position
   * @param hiY         the upper-bound of the y-position
   * @throws IllegalArgumentException if given snake list is null or size 0, or if foods list is null
   * @return the FoodType representation of this food
   */
  public FoodType eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, FoodType ate,
                        int hiX, int hiY) throws IllegalArgumentException {
    if (snake == null || snake.size() == 0 || foods == null) {
      throw new IllegalArgumentException("Invalid lists passed.");
    }
    return FoodType.REVERSE;
  }
}
/**
 * Represents a slime space on the grid.
 */
public class SlimeSpace extends ASpace {
  /**
   * Constructs a {@code SlimeSpace}.
   *
   * @param x       the x-position
   * @param y       the y-position
   */
  public SlimeSpace(int x, int y) {
    super(x, y);
  }
  
  @Override
  public int getColor() {
    return color(0xff0edd48, 120);
  }
}
/**
 * Represents the slimer food on the grid.
 */
public class SlimerFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code SlimerFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public SlimerFoodSpace() {
    super();
  }
  
  @Override
  public int getColor() {
    return color(0xff79ff83);
  }
  
  /**
   * Leaves a trail of slime behind the snake, which will kill it if run into.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @param foods       a list of {@code FoodSpace}s currently on the map
   * @param ate         the last type of food the snake has eaten
   * @param hiX         the upper-bound of the x-position
   * @param hiY         the upper-bound of the y-position
   * @throws IllegalArgumentException if given snake list is null or size 0, or if foods list is null
   * @return the FoodType representation of this food
   */
  public FoodType eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, FoodType ate,
                        int hiX, int hiY) throws IllegalArgumentException {
    if (snake == null || snake.size() == 0 || foods == null) {
      throw new IllegalArgumentException("Invalid lists passed.");
    }return FoodType.SLIMER;
  }
}
/**
 * Represents the slow food on the grid.
 */
public class SlowFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code SlowFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public SlowFoodSpace() {
    super();
  }
  
  @Override
  public int getColor() {
    return color(0xffad7eff);
  }
  
  /**
   * Halves the speed of the game.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @param foods       a list of {@code FoodSpace}s currently on the map
   * @param ate         the last type of food the snake has eaten
   * @param hiX         the upper-bound of the x-position
   * @param hiY         the upper-bound of the y-position
   * @throws IllegalArgumentException if given snake list is null or size 0, or if foods list is null
   * @return the FoodType representation of this food
   */
  public FoodType eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, FoodType ate,
                        int hiX, int hiY) throws IllegalArgumentException {
    if (snake == null || snake.size() == 0 || foods == null) {
      throw new IllegalArgumentException("Invalid lists passed.");
    }
    frameRate(SnakeModel.defaultFrameRate / 3);
    return FoodType.SLOW;
  }
}
/**
 * Represents the model, or logic, of the game.
 */
public class SnakeModel {
  public static final int defaultFrameRate = 20;
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
    frameRate(defaultFrameRate);
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
    switch (gameState) {
      case START:
        //updateStart();
        break;
      case INSTRUCTIONS:
        //updateInstructions();
        break;
      case PLAYING:
        isGameOver();
        updatePlaying();
        break;
      case GAME_OVER:
        //updateGameOver();
        break;
      default:
        throw new IllegalStateException("State of game does not exist.");
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
    FoodType which = FoodType.values()[PApplet.parseInt(random(FoodType.values().length))];
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
/**
 * Represents a snake's space on the grid.
 */
public class SnakeSpace extends ASpace {
  private boolean head;
  private Direction direction;
  
  /**
   * Constructs a {@code SnakeSpace}.
   *
   * @param x     the x-position
   * @param y     the y-position
   */
  public SnakeSpace(int x, int y) {
    super(x, y);
    this.head = false;
    this.direction = Direction.STILL;
  }
  
  /**
   * Constructs a {@code SnakeSpace}.
   *
   * @param x      the x-position
   * @param y      the y-position
   * @param dir    the direction of the snake
   * @throws IllegalArgumentException if the given {@code Direction} is null
   */
  public SnakeSpace(int x, int y, Direction dir) throws IllegalArgumentException {
    super(x, y);
    if (dir == null) {
      throw new IllegalArgumentException("Invalid direction.");
    }
    this.head = false;
    this.direction = dir;
  }
  
  @Override
  public void drawSpace() {
    drawSnake(null);
  }
  
  /**
   * Draws the snake on the grid, with colors depending on which
   * food it ate.
   *
   * @param ate      the type of food this snake has eaten
   */
  public void drawSnake(FoodType ate) {
    noStroke();
    if (ate == null) {
      fill(getColor());
    } else {
      switch (ate) {
        case DECAPITATOR:
          fill(new DecapitatorFoodSpace().getColor());
          break;
        case STAR:
          fill(new StarFoodSpace().getColor());
          break;
        case REVERSE:
          fill(new ReverseFoodSpace().getColor());
          break;
        case FAST:
          fill(new FastFoodSpace().getColor());
          break;
        case SLOW:
          fill(new SlowFoodSpace().getColor());
          break;
        default:
          fill(getColor());
      }
    }
    rect(this.x * spaceSize, this.y * spaceSize,
         spaceSize, spaceSize);
  }
  
  /**
   * Returns the color of this {@code SnakeSpace}.
   *
   * @return the space color
   */
  @Override
  public int getColor() {
    if (head) {
      return color(0xff2cff5e);
    }
    return color(0xff0edd48);
  }
  
  /**
   * If true, sets the snake space to be the "head" of the snake. Otherwise,
   * sets the snake space to be the "body."
   */
  public void setHead(boolean isHead) {
    if (isHead) {
      this.head = true;
    } else {
      this.head = false;
    }
  }
  
  /**
   * Checks whether this {@code ASpace} is at the same position of the given one.
   *
   * @return true if the same position, false otherwise
   * throws IllegalStateException if direction is not up, down, left, or right
   */
  public void move(FoodType ate, int hiX, int hiY) throws IllegalStateException {
    switch (direction) {
      case DIR_UP:
        this.y -= 1;
        break;
      case DIR_DOWN:
        this.y += 1;
        break;
      case DIR_LEFT:
        this.x -= 1;
        break;
      case DIR_RIGHT:
        this.x += 1;
        break;
      case STILL:
        break;
      default:
        throw new IllegalStateException("Cannot move that way.");
    }
    if (ate.equals(FoodType.STAR) || ate.equals(FoodType.REVERSE)) {
      if (this.x < 0) {
        this.x = hiX;
      } else if (this.x > hiX) {
        this.x = 0;
      }
      if (this.y < 0) {
        this.y = hiY;
      } else if (this.y > hiY) {
        this.y = 0;
      }
    }
  }
  
  /**
   * Turns a snake if the same position of the given {@code TurnSpace} and
   * is a valid turn.
   *
   * @param t      the space that a snake can turn
   * @return true if the {@code TurnSpace} is at the same position as the snake, false otherwise
   * @throws IllegalArgumentException if the given {@code TurnSpace} is null
   */
  public boolean turn(TurnSpace t) throws IllegalArgumentException {
    if (t == null) {
      throw new IllegalArgumentException("Cannot turn that way.");
    }
    if (t.samePosition(this)) {
      if (this.direction.validTurn(t.direction)) {
        this.direction = t.direction;
      }
      return true;
    }
    return false;
  }
  
  /**
   * Checks whether this {@code SnakeSpace} is out of the given boundaries
   *
   * @param hiX    the high boundary for x
   * @param hiY    the high boundary for y
   * @return true if the snake is out of bounds, false otherwise
   */
  public boolean outOfBounds(int hiX, int hiY) {
    return this.x < 0 || this.x > hiX || this.y < 0 || this.y > hiY;
  }
}
/**
 * Represents the view of the game.
 */
public class SnakeView {
  private final int white = color(255);
  private final int ground = color(0xff2d0e05);
  private final int blue = color(0xff3a7cef);
  private final int red = color(0xffff3b4a);
  private final int green = color(0xff0edd48);
  private final int gray = color(0xffafafaf);
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
/**
 * Represents the star food on the grid.
 */
public class StarFoodSpace extends AFoodSpace {
  private final int[] rainbow = {color(0xffff3e3e), color(0xffffa83e), color(0xfff8ff3e), color(0xff3eff6c), color(0xff3e89ff), color(0xffb13eff)};
  
  /**
   * Constructs a {@code StarFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public StarFoodSpace() {
    super();
  }
  
  @Override
  public int getColor() {
    return this.rainbow[PApplet.parseInt(random(rainbow.length))];
  }
  
  /**
   * Allows the snake to travel without borders, so the snake ends up on
   * the opposite side when traveling through an edge.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @param foods       a list of {@code FoodSpace}s currently on the map
   * @param ate         the last type of food the snake has eaten
   * @param hiX         the upper-bound of the x-position
   * @param hiY         the upper-bound of the y-position
   * @throws IllegalArgumentException if given snake list is null or size 0, or if foods list is null
   * @return the FoodType representation of this food
   */
  public FoodType eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, FoodType ate,
                        int hiX, int hiY) throws IllegalArgumentException {
    if (snake == null || snake.size() == 0 || foods == null) {
      throw new IllegalArgumentException("Invalid lists passed.");
    }
    return FoodType.STAR;
  }
}
/**
 * Represents a turning space on the grid.
 */
public class TurnSpace extends ASpace {
  protected Direction direction;
  /**
   * Constructs a {@code TurnSpace}.
   *
   * @param x       the x-position
   * @param y       the y-position
   * @param dir     the direction of the turn
   */
  public TurnSpace(int x, int y, Direction dir) {
    super(x, y);
    if (dir == null) {
      throw new IllegalArgumentException("Invalid direction.");
    }
    this.direction = dir;
  }
}
  public void settings() {  size(1000, 1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "snake" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
