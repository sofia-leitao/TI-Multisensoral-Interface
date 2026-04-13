void drawMathGame() {

  background(140, 70, 160);

  drawBackButton();

  fill(255);
  textSize(40);
  text("Resolve!", width/2, 100);

  // card
  fill(170, 100, 190);
  rect(200, 150, 600, 350, 30);

  // operação
  textSize(80);
  text("2 + 3 = ?", width/2, 300);

  // apoio visual
  for (int i = 0; i < 5; i++) {
    fill(255);
    ellipse(300 + i*60, 420, 30, 30);
  }

  // personagem
  image(dino, 230, 330, 120, 120);
}
