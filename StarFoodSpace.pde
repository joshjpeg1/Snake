/**
 * Represents the decrease food on the grid, which removes the head of the snake.
 */
public class StarFoodSpace extends AFoodSpace {
  private color[] rainbow = {color(#ff3e3e), color(#ffa83e), color(#f8ff3e), color(#3eff6c), color(#3e89ff), color(#b13eff)};
  
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
   * Mutates the list based on the effect of this {@code StarFoodSpace}.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @throws IllegalArgumentException if given snake-list is null or size 0
   */
  public FoodType eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, FoodType ate,
                        int hiX, int hiY) throws IllegalArgumentException {
    return FoodType.STAR;
  }
}