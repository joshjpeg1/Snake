/**
 * Represents a food space on the grid.
 */
public class FoodSpace extends ASpace {
  /**
   * Constructs an {@code TurnSpace}.
   */
  public FoodSpace(int hiX, int hiY) {
    super(0, 0);
    randomSpace(hiX, hiY);
    this.fillColor = color(255, 0, 0);
  }
  
  public void randomSpace(int hiX, int hiY) {
    this.x = int(random(hiX));
    this.y = int(random(hiY));
  }
}