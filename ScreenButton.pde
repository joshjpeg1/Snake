/**
 * Represents a button on a screen.
 */
public class ScreenButton extends ScreenText {
  private boolean focus;
  private final color focusFill;
  private final GameState action;
  
  /**
   * Constructs a {@code ScreenButton} object.
   *
   * @param x           the x-position of the button
   * @param y           the y-position of the button
   * @param value       the text value of the button
   * @param fill        the fill color of the button
   * @param fontSize    the font size of the button
   * @param focus       true if the button is in focus, false otherwise
   * @param focusFill   the fill color of the button when in focus
   * @param action      the {@code GameState} that the button takes the user to on click/enter
   * @throws IllegalArgumentException if either the value or action parameters are null
   */
  public ScreenButton(int x, int y, String value, color fill, int fontSize, boolean focus, color focusFill, GameState action) throws IllegalArgumentException {
    super(x, y, value, fill, fontSize);
    if (action == null) {
      throw new IllegalArgumentException("Cannot accept null action.");
    }
    this.focus = focus;
    this.focusFill = focusFill;
    this.action = action;
  }
  
  @Override
  public void display() {
    textAlign(CENTER);
    textSize(this.fontSize);
    if (focus) {
      fill(this.focusFill);
    } else {
      fill(this.fill);
    }
    text(this.value, this.x, this.y);
  }
  
  /**
   * Returns the current state of the button's focus.
   *
   * @return true if this button is in focus, false otherwise
   */
  public boolean getFocus() {
    return this.focus;
  }
  
  /**
   * Sets the current state of the button's focus.
   *
   * @param inFocus      true to set button to in focus, false otherwise
   */
  public void setFocus(boolean inFocus) {
    if (inFocus) {
      this.focus = true;
    } else {
      this.focus = false;
    }
  }
  
  /**
   * Checks if the mouse is hovering this button.
   *
   * @return true if the mouse is hovering above, false otherwise
   */
  public boolean hover(int mX, int mY) {
    int h = this.getHeight() / 2;
    int w = this.getWidth() / 2;
    return mY > this.y - h && mY < this.y + h
        && mX > this.x - w && mX < this.x + w;
  }
  
  /**
   * Returns the action of this button.
   *
   * @return this button's action
   */
  public GameState getAction() {
    return this.action;
  }
}