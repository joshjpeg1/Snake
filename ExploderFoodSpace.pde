/**
 * Represents the exploder food on the grid.
 */
public class ExploderFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code ExploderFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public ExploderFoodSpace() {
    super();
  }
  
  @Override
  public color getColor() {
    return color(#3a7cef);
  }
  
  /**
   * When eaten, the exploder food explodes and creates a random amount of
   * {@code DefaultFoodSpace}s to appear across the map.
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
    int willRun = int(random(10)) + 1;
    for (int i = 0; i < willRun; i++) {
      foods.add(new DefaultFoodSpace());
    }
    return FoodType.EXPLODER;
  }
}