/**
 * Represents text on a screen.
 */
public class ScreenText {
  protected final int x;
  protected final int y;
  protected final String value;
  protected final color fill;
  protected final int fontSize;
  public static final int PADDING = 15;
  public static final int LEADING = 15;
  
  /**
   * Constructs a {@code ScreenButton} object.
   *
   * @param x           the x-position of the button
   * @param y           the y-position of the button
   * @param value       the text value of the button
   * @param fill        the fill color of the button
   * @param fontSize    the font size of the button
   * @throws IllegalArgumentException if the given value is null
   */
  public ScreenText(int x, int y, String value, color fill, int fontSize) throws IllegalArgumentException {
    if (value == null) {
      throw new IllegalArgumentException("Cannot pass null text value.");
    }
    this.x = x;
    this.y = y;
    this.value = value;
    this.fill = fill;
    this.fontSize = fontSize;
  }
  
  /**
   * Calculates the height of the text, with padding.
   *
   * @returns the height of this text
   */
  public int getHeight() {
    int lines = 1;
    for (int i = 0; i < this.value.length(); i++) {
      lines += (this.value.charAt(i) == '\n') ? 1 : 0;
    }
    return (this.fontSize * lines) + ((lines > 0) ? (LEADING * (lines - 1)) : 0) + (2 * PADDING);
  }
  
  /**
   * Calculates the width of the text, with padding.
   *
   * @returns the width of this text
   */
  public int getWidth() {
    textSize(this.fontSize);
    return int(textWidth(this.value)) + (2 * PADDING);
  }
  
  /**
   * Draws the text onto the sketch.
   */
  public void display() {
    textAlign(CENTER, BOTTOM);
    textSize(this.fontSize);
    textLeading(this.fontSize + LEADING);
    fill(this.fill);
    text(this.value, this.x, this.y);
  }
}