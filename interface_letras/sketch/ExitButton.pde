class ExitButton {
  float x, y, w, h;
  String label;

  color normalColor;
  color hoverColor;

  boolean over;

  PFont font;

  ExitButton(
    float x, float y, float w, float h,
    String label,
    color normalColor, color hoverColor, PFont font) 
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.normalColor = normalColor;
    this.hoverColor = hoverColor;
    this.over = false;
    this.font = font;
  }

  void display() {
    update();
   

    float radius = h * 0.35;
    pushMatrix();
    translate(x + w/2, y + h/2);
    rectMode(CENTER);
    noStroke();

    // sombra
    fill(0, 70);
    rect(0, h * 0.12, w, h, radius);

    color currentColor = over ? hoverColor : normalColor;

    // botão
    fill(currentColor);
    rect(0, 0, w, h, radius);
    stroke(255, 60);
    strokeWeight(max(2, h * 0.03));
    noFill();
    rect(0, 0, w, h, radius);
    noStroke();

    // texto
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(h * 0.38);
    text(label, 0, 0);
    textFont (buttonFont);

    popMatrix();

    rectMode(CORNER);
    textAlign(LEFT, BASELINE);
  }

  void update() {
    over =
      mouseX >= x &&
      mouseX <= x + w &&
      mouseY >= y &&
      mouseY <= y + h;
  }

  boolean isOver() {
    return over;
  }
}
