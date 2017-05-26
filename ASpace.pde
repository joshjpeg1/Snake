/**
 * Represents a space on the grid.
 */
public abstract class ASpace {
  protected int x;
  protected int y;
  
  /**
   * Constructs an {@code ASpace}.
   * 
   * @param x     the x-position
   * @param y     the y-position
   */
  public ASpace(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  @Override
  public boolean equals(Object that) {
    if (this == that) {
      return true;
    }
    if (!(that instanceof ASpace)) {
      return false;
    }
    return this.samePosition((ASpace) that);
  }
  
  @Override
  public int hashCode() {
    return (x * 1000) + y;
  }
  
  /**
   * Checks whether this {@code ASpace} is at the same position of the given one.
   *
   * @return true if the same position, false otherwise
   * @throws IllegalArgumentException if given {@code ASpace} is null
   */
  public boolean samePosition(ASpace other) throws IllegalArgumentException {
    if (other == null) {
      throw new IllegalArgumentException("Cannot be same position as null.");
    }
    return this.x == other.x && this.y == other.y;
  }
  
  /**
   * Returns the color of this {@code ASpace}.
   *
   * @return the space color
   */
  public color getColor() {
    return color(127);
  }
  
  /**
   * Draws the space on the grid.
   */
  public void drawSpace() {
    noStroke();
    fill(getColor());
    rect(this.x * spaceSize, this.y * spaceSize,
         spaceSize, spaceSize);
  }
}