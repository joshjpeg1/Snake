/**
 * Represents a snake's space on the grid.
 */
public class SnakeSpace extends ASpace {
  private final color headColor = color(#9de83d);
  private final color bodyColor = color(#7abc1d);
  
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
    this.fillColor = bodyColor;
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
    this.fillColor = bodyColor;
  }
  
  /**
   * If true, sets the snake space to be the "head" of the snake. Otherwise,
   * sets the snake space to be the "body."
   */
  public void setHead(boolean isHead) {
    if (isHead) {
      this.head = true;
      this.fillColor = headColor;
    } else {
      this.head = false;
      this.fillColor = bodyColor;
    }
  }
  
  /**
   * Checks whether this {@code ASpace} is at the same position of the given one.
   *
   * @return true if the same position, false otherwise
   * throws IllegalStateException if direction is not up, down, left, or right
   */
  public void move() throws IllegalStateException {
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