/**
 * Represents the decrease food on the grid, which removes the head of the snake.
 */
public class DecreaseFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code DefaultFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public DecreaseFoodSpace(int hiX, int hiY) {
    super(hiX, hiY);
  }
  
  @Override
  public color getColor() {
    return color(#ff3b4a);
  }
  
  /**
   * Mutates the list based on the effect of this {@code DefaultFoodSpace}.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @throws IllegalArgumentException if given snake-list is null or size 0
   */
  public void eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, int hiX, int hiY)
                        throws IllegalArgumentException {
    if (snake == null || snake.size() == 0) {
      throw new IllegalArgumentException("Invalid snake passed.");
    }
    if (snake.size() > 1) {
      snake.remove(0);
      snake.get(0).setHead(true);
    }
  }
}