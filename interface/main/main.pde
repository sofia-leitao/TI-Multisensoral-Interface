PImage dino, abc, numbers, colors, blocks;
PFont font;

int screen = 0;
float fade = 0;
boolean transitioning = false;
int nextScreen = 0;

void setup() {
  size(1000, 650);

  // imagens
  dino = loadImage("dino.png");
  abc = loadImage("abc.png");
  numbers = loadImage("123.png");
  colors = loadImage("colors.png");
  blocks = loadImage("blocks.png");

 

  textAlign(CENTER, CENTER);
}
void draw() {

  if (screen == 0) drawMenu();
  if (screen == 1) drawLetterGame();
  if (screen == 2) drawMathGame();
  if (screen == 3) drawColorGame();
  if (screen == 4) drawBlocksGame();

  drawTransition();
}

void mousePressed() {

  // botão voltar
  if (screen != 0 && mouseX < 140 && mouseY < 70) {
    startTransition(0);
    return;
  }

  if (screen == 0) {
    if (over(150,150,320,180)) startTransition(1);
    if (over(530,150,320,180)) startTransition(2);
    if (over(150,370,320,180)) startTransition(3);
    if (over(530,370,320,180)) startTransition(4);
  }
}
