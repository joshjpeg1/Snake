/**
 * Represents directions on a grid.
 */
public enum Direction {
  DIR_UP, DIR_DOWN, DIR_LEFT, DIR_RIGHT, STILL;
  
  /**
   * Checks whether it's a valid to turn in the given direction.
   *
   * @return true if a valid turn, false otherwise
   * @throws IllegalArgumentException if given {@code Direction} is null
   */
  boolean validTurn(Direction other) throws IllegalArgumentException {
    if (other == null) {
      throw new IllegalArgumentException("Cannot validate null.");
    } else if (this.equals(STILL)) {
      return true;
    } else if (this.equals(DIR_UP) || this.equals(DIR_DOWN)) {
      return other.equals(DIR_LEFT) || other.equals(DIR_RIGHT);
    } else {
      return other.equals(DIR_UP) || other.equals(DIR_DOWN);
    }
  }
}