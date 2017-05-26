public class ScreenButton extends ScreenText {
  private boolean focus;
  private final color focusFill;
  private final GameState action;
  
  public ScreenButton(int x, int y, String value, color fill, int fontSize, boolean focus, color focusFill, GameState action) throws IllegalArgumentException {
    super(x, y, value, fill, fontSize);
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
  
  public boolean getFocus() {
    return this.focus;
  }
  
  public void setFocus(boolean inFocus) {
    if (inFocus) {
      this.focus = true;
    } else {
      this.focus = false;
    }
  }
  
  public boolean hover(int mX, int mY) {
    int h = this.getHeight() / 2;
    int w = this.getWidth() / 2;
    return mY > this.y - h && mY < this.y + h
        && mX > this.x - w && mX < this.x + w;
  }
  
  public GameState getAction() {
    return this.action;
  }
}