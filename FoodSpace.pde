/**
 * Represents a food space on the grid.
 */
public class FoodSpace extends ASpace {
  /**
   * Constructs a {@code FoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public FoodSpace(int hiX, int hiY) {
    super(0, 0);
    randomSpace(hiX, hiY);
    this.fillColor = color(#ff92ea);
  }
  
  /**
   * Assigns this {@code FoodSpace} a random position on the grid.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public void randomSpace(int hiX, int hiY) {
    this.x = int(random(hiX));
    this.y = int(random(hiY));
  }
}