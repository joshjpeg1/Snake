/**
 * Represents the decrease food on the grid, which removes the head of the snake.
 */
public class ExploderFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code DecapitatorFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public ExploderFoodSpace(int hiX, int hiY) {
    super(hiX, hiY);
  }
  
  @Override
  public color getColor() {
    return color(#3a7cef);
  }
  
  /**
   * Mutates the list based on the effect of this {@code DecapitatorFoodSpace}.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @throws IllegalArgumentException if given snake-list is null or size 0
   */
  public FoodType eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, FoodType ate,
                        int hiX, int hiY) throws IllegalArgumentException {
    if (foods == null) {
      throw new IllegalArgumentException("Invalid foods list passed.");
    }
    int willRun = int(random(10)) + 1;
    for (int i = 0; i < willRun; i++) {
      foods.add(new DefaultFoodSpace(hiX, hiY));
    }
    return FoodType.EXPLODER;
  }
}