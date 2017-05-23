/**
 * Represents the default food on the grid, with the basic add effect.
 */
public class DefaultFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code DefaultFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public DefaultFoodSpace(int hiX, int hiY) {
    super(hiX, hiY);
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
    for (SnakeSpace s : snake) {
      s.setHead(false);
    }
    SnakeSpace newHead = new SnakeSpace(snake.get(0).x, snake.get(0).y, snake.get(0).direction);
    newHead.setHead(true);
    newHead.move();
    snake.add(0, newHead);
    foods.add(new DefaultFoodSpace(hiX, hiY));
  }
}