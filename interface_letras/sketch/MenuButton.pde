class MenuButton {
  float x, y, w, h;
  String label;
  color normalColor;
  color hoverColor;
  PFont font;
  color textColor = color(255);
  boolean over;

  MenuButton(
    float x, float y, 
    float w, float h,
    String label,
    color normalColor,
    color hoverColor, 
    PFont font
    ){
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.label = label;
      this.normalColor = normalColor;
      this.hoverColor = hoverColor;
      this.font = font;
    }

  void display() {
    update();

    float radius = h * 0.30;

    pushMatrix();

    translate(x + w/2, y + h/2);

    rectMode(CENTER);
    noStroke();

    // sombra
    fill(0, 60);
    rect(0, h * 0.10, w, h, radius);

    // cor
    color currentColor = over ? hoverColor : normalColor;

    // botão
    fill(currentColor);
    rect(0, 0, w, h, radius);

    // brilho
    fill(255, 12);
    rect(
      0,
      -h * 0.25,
      w * 0.90,
      h * 0.35,
      radius * 0.7
    );

    // texto
    fill(textColor);
    textAlign(CENTER, CENTER);
    textSize(h * 0.33);
    text(label, 0, 0);

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
