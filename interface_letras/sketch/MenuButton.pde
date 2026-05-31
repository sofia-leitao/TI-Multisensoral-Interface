class MenuButton {

  float x, y, w, h;

  String label;

  color normalColor;
  color hoverColor;

  color textColor = color(255);

  boolean over;

  float anim = 0;

  MenuButton(float x, float y, float w, float h,
             String label,
             color normalColor,
             color hoverColor) {

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

    float radius = h * 0.40;

    pushMatrix();

    float scaleValue = 1 + anim * 0.04;

    translate(x + w/2, y + h/2);

    scale(scaleValue);

    rectMode(CENTER);
    noStroke();

    // sombra
    fill(0, 60);
    rect(0, h * 0.10, w, h, radius);

    // cor animada
    color currentColor =
      lerpColor(normalColor, hoverColor, anim);

    // botão principal
    fill(currentColor);
    rect(0, 0, w, h, radius);

    // brilho superior
    fill(255, 35);
    rect(
      0,
      -h * 0.25,
      w * 0.90,
      h * 0.35,
      radius * 0.7
    );

    // linha inferior
    fill(255, 30);
    rect(
      0,
      h * 0.42,
      w * 0.85,
      h * 0.05,
      radius * 0.3
    );

    // ícone lateral
    fill(255, 40);

    float iconSize = h * 0.25;

    ellipse(
      -w * 0.42,
      0,
      iconSize,
      iconSize
    );

    // texto
    fill(textColor);
    textAlign(CENTER, CENTER);

    textSize(h * 0.35);

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
