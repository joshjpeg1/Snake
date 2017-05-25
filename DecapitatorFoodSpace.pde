/**
 * Represents the decapitator food on the grid.
 */
public class DecapitatorFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code DecapitatorFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public DecapitatorFoodSpace(int hiX, int hiY) {
    super(hiX, hiY);
  }
  
  @Override
  public color getColor() {
    return color(#ff3b4a);
  }
  
  /**
   * Removes the head of the given snake.
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
    snake.remove(0);
    snake.get(0).setHead(true);
    return FoodType.DECAPITATOR;
  }
}