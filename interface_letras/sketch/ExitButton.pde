class ExitButton {
  float x, y, w, h;
  String label;

  color normalColor;
  color hoverColor;

  boolean over;
  float anim = 0;

  ExitButton(float x, float y, float w, float h,
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

    this.over = false;
  }

  void display() {

    update();

    if (over) {
      anim = lerp(anim, 1, 0.15);
    } else {
      anim = lerp(anim, 0, 0.15);
    }

    float radius = h * 0.35;

    pushMatrix();

    translate(x + w/2, y + h/2);

    scale(1 + anim * 0.05);

    rectMode(CENTER);
    noStroke();

    // sombra
    fill(0, 70);
    rect(0, h * 0.12, w, h, radius);

    // cor animada
    color currentColor =
      lerpColor(normalColor, hoverColor, anim);

    // botão principal
    fill(currentColor);
    rect(0, 0, w, h, radius);

    // brilho
    fill(255, 35);
    rect(
      0,
      -h * 0.25,
      w - w * 0.08,
      h * 0.40,
      radius * 0.7
    );

    // borda
    stroke(255, 60);
    strokeWeight(max(2, h * 0.03));
    noFill();
    rect(0, 0, w, h, radius);
    noStroke();

    // texto responsivo
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(h * 0.38);
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
