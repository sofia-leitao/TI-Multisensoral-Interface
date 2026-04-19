class ExitButton {
  int x, y, w, h;
  String label;
  color normalColor;
  color hoverColor;
  boolean over;
  
  ExitButton(int x, int y, int w, int h, String label, color normalColor, color hoverColor) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.normalColor = normalColor;
    this.hoverColor = hoverColor;
    this.over = false;
  }
  
  void display() {
    update();
    
    if (over) {
      fill(hoverColor);
    } else {
      fill(normalColor);
    }
    
    rect(x, y, w, h, 10);
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(16);
    text(label, x + w/2, y + h/2);
    textAlign(LEFT, BASELINE);
  }
  
  void update() {
    over = (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h);
  }
  
  boolean isOver() {
    return over;
  }
}
