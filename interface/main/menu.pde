void drawMenu() {

  drawTitle();

  drawCard(150, 150, 320, 180, color(120,180,220), abc, dino, 1);
  drawCard(530, 150, 320, 180, color(140,70,160), numbers, dino, 2);
  drawCard(150, 370, 320, 180, color(255,170,0), colors, dino, 3);
  drawCard(530, 370, 320, 180, color(220,200,220), blocks, dino, 4);
}

void drawCard(int x, int y, int w, int h, color c, PImage icon, PImage character, int id) {

  boolean hover = mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h;

  // animação scale
  float scale = hover ? 1.05 : 1.0;

  // efeito bounce (leve)
  float bounce = hover ? sin(frameCount * 0.2) * 3 : 0;

  pushMatrix();
  translate(x + w/2, y + h/2 + bounce);
  scale(scale);

  // sombra
  fill(0, 40);
  rect(-w/2+5, -h/2+5, w, h, 25);

  // cor
  fill(hover ? lerpColor(c, color(255), 0.2) : c);
  rect(-w/2, -h/2, w, h, 25);

  // icon
  if (icon != null) {
    image(icon, -50, -40, 100, 80);
  }

  // personagem
  if (character != null) {
    image(character, -w/2 + 10, h/2 - 110, 100, 100);
  }

  popMatrix();
}

void drawTitle() {
  fill(150, 60, 20);
  textSize(60);
  text("NOME", 120, 90);
}

void drawGameScreen() {
  fill(0);
  textSize(40);
  text("Jogo " + screen, width/2, height/2);
}

void drawTransition() {
  if (transitioning) {
    fade += 15;

    fill(0, fade);
    rect(0, 0, width, height);

    if (fade >= 255) {
      screen = nextScreen;
      transitioning = false;
      fade = 0;
    }
  }
}

boolean over(int x, int y, int w, int h) {
  return mouseX > x && mouseX < x+w &&
         mouseY > y && mouseY < y+h;
}

void startTransition(int target) {
  transitioning = true;
  nextScreen = target;
}
