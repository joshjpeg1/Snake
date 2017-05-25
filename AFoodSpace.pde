/**
 * Represents a food space on the grid.
 */
public abstract class AFoodSpace extends ASpace {
  /**
   * Constructs a {@code AFoodSpace}.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public AFoodSpace() {
    super(0, 0);
    randomSpace(snake.BOARD_SIZE, snake.BOARD_SIZE);
  }
  
  /**
   * Assigns this {@code AFoodSpace} a random position on the grid.
   *
   * @param hiX   the upper-bound of the x-position
   * @param hiY   the upper-bound of the y-position
   */
  public void randomSpace(int hiX, int hiY) {
    this.x = int(random(hiX));
    this.y = int(random(hiY));
  }
  
  @Override
  public color getColor() {
    return color(234);
  }
  
  /**
   * Mutates the list based on the effect of this {@code AFoodSpace}.
   *
   * @param snake       a list of {@code SnakeSpace}s representing a snake
   * @param foods       a list of {@code FoodSpace}s currently on the map
   * @param ate         the last type of food the snake has eaten
   * @param hiX         the upper-bound of the x-position
   * @param hiY         the upper-bound of the y-position
   * @throws IllegalArgumentException if given snake list is null or size 0, or if foods list is null
   * @return the FoodType representation of this food
   */
  public abstract FoodType eatEffect(ArrayList<SnakeSpace> snake, ArrayList<AFoodSpace> foods, FoodType ate,
                                 int hiX, int hiY) throws IllegalArgumentException;
}