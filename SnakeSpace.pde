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
  public color getColor() {
    if (head) {
      return color(#2cff5e);
    }
    return color(#0edd48);
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