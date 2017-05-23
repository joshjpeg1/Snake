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
public SnakeModel model;

/**
 * Sets up the program.
 */
void setup() {
  size(1000, 1000);
  spaceSize = width / BOARD_SIZE;
  model = new SnakeModel();
  
}

/**
 * Draws the current state of the game.
 */
void draw() {
  model.update();
}

/**
 * Handles a key pressed when the program is running.
 */
void keyPressed() {
  model.keyHandler();
}

/**
 * Handles a mouse press when the program is running.
 */
void mousePressed() {
  model.mouseHandler();
}