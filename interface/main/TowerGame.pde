void drawBlocksGame() {

  background(220, 200, 220);

  drawBackButton();

  fill(0);
  textSize(40);
  text("Constrói igual!", width/2, 100);

  // card
  fill(240);
  rect(200, 150, 600, 350, 30);

  // blocos simples
  fill(255, 100, 100);
  rect(420, 260, 40, 40);

  fill(100, 200, 255);
  rect(460, 260, 40, 40);

  fill(100, 255, 150);
  rect(440, 220, 40, 40);

  // personagem
  image(dino, 230, 330, 120, 120);
}
