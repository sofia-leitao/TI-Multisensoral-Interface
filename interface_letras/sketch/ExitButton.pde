class ExitButton {
  int x, y, w, h;
  String label;
  color normalColor;
  color hoverColor;
  boolean over;
  float anim = 0;

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
      anim = lerp(anim, 1, 0.15);
    } else {
      anim = lerp(anim, 0, 0.15);
    }
    
    pushMatrix();
    translate(x + w/2, y + h/2);
    scale(1 + anim * 0.05);
    rectMode(CENTER);
    noStroke();

    // sombra
    fill(0, 70);
    rect(0, 6, w, h, 18);

    // cor animada
    color currentColor = lerpColor(normalColor, hoverColor, anim);

    // botão principal
    fill(currentColor);
    rect(0, 0, w, h, 18);

    // brilho topo
    fill(255, 35);
    rect(0, -h/4, w - 10, h/2.5, 12);

    // borda
    stroke(255, 60);
    strokeWeight(2);
    noFill();
    rect(0, 0, w, h, 18);
    noStroke();

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(16);
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
