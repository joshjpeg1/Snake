/**
 * Represents the default food on the grid.
 */
public class DefaultFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code DefaultFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public DefaultFoodSpace() {
    super();
  }
  
  /**
   * Adds a new head to the given snake, replacing the old one.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @param foods       a list of {@code FoodSpace}s currently on the map
   * @param ate         the last type of food the snake has eaten
   * @param hiX         the upper-bound of the x-position
   * @param hiY         the upper-bound of the y-position
   * @throws IllegalArgumentException if given snake list is null or size 0, or if foods list is null
   * @return the FoodType representation of this food
   */
  public FoodType eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, FoodType ate,
                        int hiX, int hiY) throws IllegalArgumentException {
    if (snake == null || snake.size() == 0 || foods == null) {
      throw new IllegalArgumentException("Invalid lists passed.");
    }
    for (SnakeSpace s : snake) {
      s.setHead(false);
    }
    SnakeSpace newHead = new SnakeSpace(snake.get(0).x, snake.get(0).y, snake.get(0).direction);
    newHead.setHead(true);
    newHead.move(ate, hiX, hiY);
    snake.add(0, newHead);
    if (!ate.equals(FoodType.EXPLODER)) {
      foods.add(0, new DefaultFoodSpace());
    }
    return FoodType.DEFAULT;
  }
}