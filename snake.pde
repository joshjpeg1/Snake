/**
 * The main tab for the snake game.
 *
 * @author       Joshua Pensky
 * @title        Snake
 * @description  A game where users play as a snake, maneuvering around the map and themself
                 to get food and become larger.
 * @version      1.0.3
 */
 
public static final int BOARD_SIZE = 50;
public int spaceSize;
public GameState gameState;

public color blue;
public color ground;

public ArrayList<SnakeSpace> snake;
public FoodSpace food;
public ArrayList<TurnSpace> turns;

public boolean snakeAte;
public boolean gameOver;
public int highScore;

/**
 * Sets up the program.
 */
void setup() {
  size(1000, 1000);
  frameRate(15);
  blue = color(#5ddaff);
  ground = color(#2d0e05);
  gameState = GameState.PLAYING;
  spaceSize = width / BOARD_SIZE;
  highScore = 1;
  init();
}

/**
 * Initializes/Resets the world back to its original state.
 */
void init() {
  snake = new ArrayList<SnakeSpace>();
  SnakeSpace head = new SnakeSpace(1, 1);
  head.setHead(true);
  snake.add(head);
  food = new FoodSpace(BOARD_SIZE, BOARD_SIZE);
  turns = new ArrayList<TurnSpace>();
  snakeAte = false;
}

/**
 * Draws the current state of the game.
 */
void draw() {
  background(ground);
  isGameOver();
  switch (gameState) {
    case START:
      //startScreen();
      break;
    case INSTRUCTIONS:
      //instructionsScreen();
      break;
    case PLAYING:
      playingScreen();
      break;
    case GAME_OVER:
      endScreen();
      break;
    default:
      throw new IllegalStateException("State of game does not exist.");
  }
}

/**
 * Helper to the draw() function. Draws the end screen state.
 */
void endScreen() {
  fill(255);
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
  fill(255);
  textSize(20);
  padding += 30;
  text("score: " + snake.size(), width/2, height/2 + padding);
  textSize(20);
  padding += 30;
  text("press C to continue", width/2, height/2 + padding);
}

/**
 * Helper to the draw() function. Updates and draws the current game state.
 */
void playingScreen() {
  ArrayList<TurnSpace> removeTurns = new ArrayList<TurnSpace>();
  food.drawSpace();
  for (SnakeSpace s : snake) {
    s.drawSpace();
    for (TurnSpace t : turns) {
      if (s.turn(t) && snake.indexOf(s) == snake.size() - 1) {
        removeTurns.add(t);
      }
    }
    if (s.samePosition(food)) {
      food = new FoodSpace(BOARD_SIZE, BOARD_SIZE);
      snakeAte = true;
    }
    if (!snakeAte) {
      s.move();
    }
  }
  for (TurnSpace t : removeTurns) {
    turns.remove(t);
  }
  if (snakeAte) {
    for (SnakeSpace s : snake) {
      s.setHead(false);
    }
    SnakeSpace head = new SnakeSpace(snake.get(0).x, snake.get(0).y, snake.get(0).direction);
    head.setHead(true);
    head.move();
    snake.add(0, head);
    snakeAte = false;
  }
  textAlign(RIGHT);
  fill(255);
  if (snake.size() > highScore) {
    fill(blue);
  }
  textSize(20);
  text("Length: " + snake.size(), width - 20, 40);
}

/**
 * Adds a new turning space if a directional key is pressed, or
 * resets the world if R is pressed and game is over.
 */
void keyPressed() {
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

void keyHandlePlaying() {
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

void keyHandleGameOver() {
  if (key == 'c' || key == 'C') {
    if (snake.size() > highScore) {
      highScore = snake.size();
    }
    gameState = GameState.PLAYING;
    init();
  }
}

/**
 * Adds a new turn to the turns list, if not the same direction of the snake head
 * or position of the last turn.
 *
 * @throws IllegalArgumentException if the given {@code TurnSpace} is null
 */
void addNewTurn(TurnSpace t) {
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
 * Decides whether the game is over or not.
 *
 * @return true if the game is over, false otherwise
 */
boolean isGameOver() {
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