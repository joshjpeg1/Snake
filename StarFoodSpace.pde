/**
 * Represents the star food on the grid.
 */
public class StarFoodSpace extends AFoodSpace {
  private final color[] rainbow = {color(#ff3e3e), color(#ffa83e), color(#f8ff3e), color(#3eff6c), color(#3e89ff), color(#b13eff)};
  
  /**
   * Constructs a {@code StarFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public StarFoodSpace(int hiX, int hiY) {
    super(hiX, hiY);
  }
  
  @Override
  public color getColor() {
    return this.rainbow[int(random(rainbow.length))];
  }
  
  /**
   * Allows the snake to travel without borders, so the snake ends up on
   * the opposite side when traveling through an edge.
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
    return FoodType.STAR;
  }
}