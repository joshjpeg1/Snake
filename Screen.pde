public class Screen {
  private ScreenText header;
  private ArrayList<ScreenText> body;
  private ArrayList<ScreenButton> buttons;
  private static final int SECTION_PADDING = ScreenText.PADDING * 2;
  
  private final color white = color(255);
  private final color ground = color(#2d0e05);
  private final color blue = color(#3a7cef);
  private final color red = color(#ff3b4a);
  private final color green = color(#0edd48);
  private final color gray = color(#afafaf);
  
  public Screen(String hText, ArrayList<String> bText, ArrayList<String> btns, ArrayList<GameState> actions) {
    if (hText == null
        || bText == null || bText.contains(null)
        || btns == null || btns.contains(null)
        || actions == null || actions.contains(null) || actions.size() != btns.size()) {
      throw new IllegalArgumentException();
    }
    createHeader(hText);
    createText(bText);
    createButtons(btns, actions);
  }
  
  private void createHeader(String hText) {
    this.header = new ScreenText(width/2, height/2, hText, white, 80);
  }
  
  private void createText(ArrayList<String> bText) {
    this.body = new ArrayList<ScreenText>();
    int top = int(height/2) + int(this.header.getHeight()/2) + SECTION_PADDING;
    int x = width/2;
    for (String t : bText) {
      ScreenText next = new ScreenText(0, 0, t, blue, 30);
      next = new ScreenText(x, top + (next.getHeight() / 2) + ScreenText.PADDING, t, blue, 30);
      top += next.getHeight();
      this.body.add(next);
    }
  }
  
  public void setBody(ArrayList<String> bText) {
    this.createText(bText);
  }
  
  private void createButtons(ArrayList<String> btns, ArrayList<GameState> actions) {
    this.buttons = new ArrayList<ScreenButton>();
    int x = width/2;
    int top = int(height/2) + int(this.header.getHeight()/2) + SECTION_PADDING;
    for (ScreenText t : this.body) {
      top += t.getHeight();
    }
    top += SECTION_PADDING;
    for (String s : btns) {
      boolean inFocus = (btns.indexOf(s) == 0);
      ScreenButton next = new ScreenButton(x, top + ScreenText.PADDING, s, gray, 30,
          inFocus, green, actions.get(btns.indexOf(s)));
      top += next.getHeight();
      this.buttons.add(next);
    }
  }
  
  public void display() {
    header.display();
    for (ScreenText t : this.body) {
      t.display();
    }
    for (ScreenButton b : this.buttons) {
      b.display();
    }
  }
  
  public void update(boolean up) {
    int which = -1;
    for (int i = 0; i < buttons.size(); i++) {
      if (buttons.get(i).getFocus()) {
        which = i;
      }
      buttons.get(i).setFocus(false);
    }
    if (which >= 0) {
      which += ((up) ? -1 : 1);
      if (which > buttons.size() - 1) {
        buttons.get(0).setFocus(true);
      } else if (which < 0) {
        buttons.get(buttons.size() - 1).setFocus(true);
      } else {
        buttons.get(which).setFocus(true);
      }
    } else {
      buttons.get(0).setFocus(true);
    }
  }
  
  public void update(int mX, int mY) {
    int newFocus = -1;
    int oldFocus = -1;
    for (int i = 0; i < buttons.size(); i++) {
      if (buttons.get(i).getFocus()) {
        oldFocus = i;
      }
      buttons.get(i).setFocus(false);
      if (buttons.get(i).hover(mX, mY)) {
        newFocus = i;
      }
    }
    if (newFocus >= 0) {
      buttons.get(newFocus).setFocus(true);
    } else {
      buttons.get(oldFocus).setFocus(true);
    }
  }
  
  public GameState useButton() {
    for (ScreenButton b : this.buttons) {
      if (b.getFocus() && (mousePressed && b.hover(mouseX, mouseY))) {
        resetFocus();
        return b.getAction();
      }
    }
    return null;
  }
  
  private void resetFocus() {
    for (ScreenButton b : buttons) {
      b.setFocus(false);
    }
    if (buttons.size() > 0) {
      buttons.get(0).setFocus(true);
    }
  }
}