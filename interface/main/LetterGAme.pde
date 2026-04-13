void drawLetterGame() {

  background(120, 180, 220);

  drawBackButton();

  fill(0);
  textSize(40);
  text("Que letra ouves?", width/2, 100);

  // card
  fill(100, 150, 200);
  rect(200, 150, 600, 350, 30);

  // botão som
  fill(200);
  ellipse(width/2, 230, 80, 80);
  fill(0);
  textSize(30);
  text("🔊", width/2, 230);

  // letra
  textSize(180);
  text("A", width/2, 380);

  // personagem
  image(dino, 230, 330, 120, 120);
}
