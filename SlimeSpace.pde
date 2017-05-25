/**
 * Represents a turning space on the grid.
 */
public class SlimeSpace extends ASpace {
  /**
   * Constructs a {@code TurnSpace}.
   *
   * @param x       the x-position
   * @param y       the y-position
   * @param dir     the direction of the turn
   */
  public SlimeSpace(int x, int y) {
    super(x, y);
  }
  
  @Override
  public color getColor() {
    return color(#0edd48, 120);
  }
}