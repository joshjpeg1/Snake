/**
 * The main tab for the snake game.
 */
 
public int spaceSize;
public static final int BOARD = 50;

public ArrayList<SnakeSpace> snake;
public FoodSpace food;
public ArrayList<TurnSpace> turns;
public boolean snakeAte;
public boolean gameOver;

// Setup function
void setup() {
  size(1000, 1000);
  frameRate(10);
  spaceSize = width / BOARD;
  reset();
}

// Draw function
void draw() {
  background(0);
  gameOver = isGameOver();
  if (gameOver) {
    fill(255);
    textAlign(CENTER);
    textSize(100);
    text("game over", width/2, height/2);
  } else {
    update();
  }
}

void reset() {
  snake = new ArrayList<SnakeSpace>();
  snake.add(new SnakeSpace(1, 1));
  food = new FoodSpace(BOARD, BOARD);
  turns = new ArrayList<TurnSpace>();
  snakeAte = false;
  gameOver = false;
}

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
    reset();
  }
}

boolean isGameOver() {
  for (int i = 1; i < snake.size(); i++) {
    if (snake.get(i).equals(snake.get(0))) {
      return true;
    }
  }
  return snake.get(0).outOfBounds(BOARD - 1, BOARD - 1);
}

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