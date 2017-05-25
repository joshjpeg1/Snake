/**
 * Represents the reverse food on the grid.
 */
public class ReverseFoodSpace extends AFoodSpace {
  /**
   * Constructs a {@code ReverseFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public ReverseFoodSpace(int hiX, int hiY) {
    super(hiX, hiY);
  }
  
  @Override
  public color getColor() {
    return color(#ffff52);
  }
  
  /**
   * Reverses the mapped controls, so up is down, left is right, etc.
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
    return FoodType.REVERSE;
  }
}