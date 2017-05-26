/**
 * Represents a slime space on the grid.
 */
public final class SlimeSpace extends ASpace {
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
  public color getColor() {
    return color(#0edd48, 120);
  }
}