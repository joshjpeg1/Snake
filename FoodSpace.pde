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
  
  /**
   * Returns the color of this {@code FoodSpace}.
   *
   * @return the space color
   */
  @Override
  public color getColor() {
    return color(#ff92ea);
    /*color[] rainbow = {color(#ff3e3e), color(#ffa83e), color(#f8ff3e), color(#3eff6c), color(#3e89ff), color(#b13eff)};
    return rainbow[int(random(rainbow.length))];*/
  }
}