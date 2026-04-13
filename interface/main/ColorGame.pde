void drawColorGame() {

  background(255, 220, 150);

  drawBackButton();

  fill(0);
  textSize(40);
  text("Encontra a cor!", width/2, 100);

  // card central
  fill(255, 170, 0);
  rect(200, 150, 600, 350, 30);

  // objeto (ex: sol)
  fill(255);
  ellipse(width/2, 300, 150, 150);

  fill(0);
  textSize(26);
  text("Onde está o amarelo?", width/2, 470);

  // personagem
  image(dino, 220, 330, 120, 120);
}
