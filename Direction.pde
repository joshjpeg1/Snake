/**
 * Represents directions on a grid.
 */
public enum Direction {
  DIR_UP, DIR_DOWN, DIR_LEFT, DIR_RIGHT, STILL;
  
  boolean validTurn(Direction other) {
    if (other == null) {
      throw new IllegalArgumentException();
    }
    if (this.equals(STILL)) {
      return true;
    } else if (this.equals(DIR_UP) || this.equals(DIR_DOWN)) {
      return other.equals(DIR_LEFT) || other.equals(DIR_RIGHT);
    } else {
      return other.equals(DIR_UP) || other.equals(DIR_DOWN);
    }
  }
}