/**
 * The main tab for the snake game.
 */
 
public static final int BOARD = 50;
public int spaceSize;

public ArrayList<SnakeSpace> snake;
public FoodSpace food;
public ArrayList<TurnSpace> turns;

public boolean snakeAte;
public boolean gameOver;

/**
 * Sets up the program.
 */
void setup() {
  size(1000, 1000);
  frameRate(10);
  spaceSize = width / BOARD;
  init();
}

/**
 * Initializes/Resets the world back to its original state.
 */
void init() {
  snake = new ArrayList<SnakeSpace>();
  snake.add(new SnakeSpace(1, 1));
  food = new FoodSpace(BOARD, BOARD);
  turns = new ArrayList<TurnSpace>();
  snakeAte = false;
  gameOver = false;
}

/**
 * Draws the current state of the game.
 */
void draw() {
  background(0);
  gameOver = isGameOver();
  if (gameOver) {
    endScreen();
  } else {
    update();
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
}

/**
 * Helper to the draw() function. Updates and draws the current game state.
 */
void update() {
  ArrayList<TurnSpace> toRemove = new ArrayList<TurnSpace>();
  food.drawSpace();
  for (SnakeSpace s : snake) {
    s.drawSpace();
    for (TurnSpace t : turns) {
      if (s.turn(t) && snake.indexOf(s) == snake.size() - 1) {
        toRemove.add(t);
      }
    }
    if (s.samePosition(food)) {
      food = new FoodSpace(BOARD, BOARD);
      snakeAte = true;
    }
    if (!snakeAte) {
      s.move();
    }
  }
  for (TurnSpace t : toRemove) {
    turns.remove(t);
  }
  if (snakeAte) {
    snake.add(0, new SnakeSpace(snake.get(0).x, snake.get(0).y, snake.get(0).direction));
    snake.get(0).move();
    snakeAte = false;
  }
}

/**
 * Adds a new turning space if a directional key is pressed, or
 * resets the world if R is pressed and game is over.
 */
void keyPressed() {
  SnakeSpace head = snake.get(0);
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        turns.add(new TurnSpace(head.x, head.y, Direction.DIR_UP));
        break;
      case DOWN:
        turns.add(new TurnSpace(head.x, head.y, Direction.DIR_DOWN));
        break;
      case LEFT:
        turns.add(new TurnSpace(head.x, head.y, Direction.DIR_LEFT));
        break;
      case RIGHT:
        turns.add(new TurnSpace(head.x, head.y, Direction.DIR_RIGHT));
        break;
      default:
        break;
    }
  } else if (gameOver && (key == 'r' || key == 'R')) {
    init();
  }
}

/**
 * Decides whether the game is over or not.
 *
 * @return true if the game is over, false otherwise
 */
boolean isGameOver() {
  for (int i = 1; i < snake.size(); i++) {
    if (snake.get(i).equals(snake.get(0))) {
      return true;
    }
  }
  return snake.get(0).outOfBounds(BOARD - 1, BOARD - 1);
}