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