public class ScreenText {
  protected final int x;
  protected final int y;
  protected final String value;
  protected final color fill;
  protected final int fontSize;
  public static final int PADDING = 15;
  public static final int LEADING = 15;
  
  public ScreenText(int x, int y, String value, color fill, int fontSize) throws IllegalArgumentException {
    this.x = x;
    this.y = y;
    this.value = value;
    this.fill = fill;
    this.fontSize = fontSize;
  }
  
  public int getHeight() {
    int lines = 1;
    for (int i = 0; i < this.value.length(); i++) {
      lines += (this.value.charAt(i) == '\n') ? 1 : 0;
    }
    return (this.fontSize * lines) + ((lines > 0) ? (LEADING * (lines - 1)) : 0) + (2 * PADDING);
  }
  
  public int getWidth() {
    textSize(this.fontSize);
    return int(textWidth(this.value)) + (2 * PADDING);
  }
  
  public void display() {
    textAlign(CENTER, BOTTOM);
    textSize(this.fontSize);
    textLeading(this.fontSize + LEADING);
    fill(this.fill);
    text(this.value, this.x, this.y);
  }
}