class MenuButton {

  int x, y, w, h;

  String label;

  color normalColor;
  color hoverColor;

  color textColor = color(255);

  boolean over;

  float scaleFactor = 1.0;

  // animação brilho
  float glowAlpha = 0;

  MenuButton(
    int x,
    int y,
    int w,
    int h,
    String label,
    color normalColor,
    color hoverColor
  ) {

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

    // animação hover
    if (over) {

      scaleFactor = lerp(scaleFactor, 1.06, 0.15);

      glowAlpha = lerp(glowAlpha, 80, 0.12);

    } else {

      scaleFactor = lerp(scaleFactor, 1.0, 0.15);

      glowAlpha = lerp(glowAlpha, 0, 0.12);
    }

    pushMatrix();

    translate(x + w/2, y + h/2);

    scale(scaleFactor);

    rectMode(CENTER);

    noStroke();

    // =========================
    // GLOW
    // =========================

    fill(255, glowAlpha * 0.2);

    rect(0, 0, w + 26, h + 26, 26);

    fill(255, glowAlpha * 0.1);

    rect(0, 0, w + 40, h + 40, 30);

    // =========================
    // SOMBRA
    // =========================

    fill(0, 120);

    rect(6, 8, w, h, 22);

    // =========================
    // BOTÃO
    // =========================

    if (over) {

      fill(hoverColor);

    } else {

      fill(normalColor);
    }

    rect(0, 0, w, h, 22);

    // =========================
    // BRILHO TOPO
    // =========================

    fill(255, 35);

    rect(0, -h/4, w - 18, h/3, 18);

    // =========================
    // BORDA
    // =========================

    stroke(255, 40);

    strokeWeight(2);

    noFill();

    rect(0, 0, w, h, 22);

    noStroke();

    // =========================
    // TEXTO
    // =========================

    fill(0, 80);

    textAlign(CENTER, CENTER);

    textSize(24);

    text(label, 2, 3);

    fill(textColor);

    text(label, 0, 0);

    popMatrix();

    rectMode(CORNER);

    textAlign(LEFT, BASELINE);
  }

  // =========================
  // UPDATE
  // =========================

  void update() {

    over =
      mouseX >= x &&
      mouseX <= x + w &&
      mouseY >= y &&
      mouseY <= y + h;
  }

  // =========================
  // HOVER
  // =========================

  boolean isOver() {

    return over;
  }
}
