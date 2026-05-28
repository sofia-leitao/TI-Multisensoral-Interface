class MenuButton {
  int x, y, w, h;
  String label;

  color normalColor;
  color hoverColor;

  color textColor = color(255);

  boolean over;

  float anim = 0;
 
  MenuButton(int x, int y, int w, int h, String label, color normalColor, color hoverColor) {
    this.x = x;
    this.y = y;

    this.w = w;
    this.h = h;

    this.label = label;

    this.normalColor = normalColor;
    this.hoverColor = hoverColor;
  }


  void display() {
    update();

    if (over) {
      anim = lerp(anim, 1, 0.12);
    } else {
      anim = lerp(anim, 0, 0.12);
    }

    pushMatrix();
    float scaleValue = 1 + anim * 0.04;
    translate(x + w/2, y + h/2);
    scale(scaleValue);
    rectMode(CENTER);
    noStroke();

    // sombra suave
    fill(0, 60);
    rect(0, 8, w, h, 30);

    // cor animada
    color currentColor = lerpColor(normalColor, hoverColor, anim);

    // botão principal
    fill(currentColor);
    rect(0, 0, w, h, 30);

    // detalhe topo
    fill(255, 35);
    rect(0, -h/4, w - 20, h/2.8, 20);

    // linha inferior
    fill(255, 30);
    rect(0, h/2 - 6, w - 30, 4, 10);

    // ícone lateral
    fill(255, 40);
    ellipse(-w/2 + 35, 0, 18, 18);

    // texto
    textAlign(CENTER, CENTER);
    textSize(24);
    fill(255);
    text(label, 10, 0);
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
