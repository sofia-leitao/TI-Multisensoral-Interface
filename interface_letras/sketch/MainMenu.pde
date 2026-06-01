import processing.serial.*;
import processing.sound.*;

MenuButton letrasButton;
MenuButton matButton;
MenuButton coresButton;
MenuButton torresButton;
ExitButton exitButton;

JogoLetras jogoLetras;
JogoMatematica jogoMatematica;
JogoCores jogoCores;
JogoTorres jogoTorres;

int screenState = 0;

Serial myPort1, myPort2;

PFont titleFont;
PFont instructionFont;
PFont cardFont;
PFont buttonFont;

void setup() {

  fullScreen();
  smooth(8);

  titleFont = createFont("Fredoka-Medium", int(height * 0.07));
  instructionFont = createFont("Nunito", int(height * 0.03));
  cardFont = createFont("Fredoka", int(height * 0.07));
  buttonFont = createFont("Fredoka-Medium", int(height * 0.07));

  float btnW = width * 0.46;
  float btnH = height * 0.22;
  
  float gapX = width * 0.03;
  float gapY = height * 0.05;
  
  float centerX = width / 2;
  float centerY = height * 0.50;
  
  float startX = centerX - btnW - gapX/2;
  float startY = centerY - btnH -gapY/2;

  letrasButton = new MenuButton(
    startX, startY, btnW, btnH,
    "Jogo das Letras",
    color(76, 201, 240),
    color(120, 220, 250),
    titleFont
    );

  matButton = new MenuButton(
    startX + btnW + gapX, startY, btnW, btnH,
    "Jogo da Matemática",
    color(255, 209, 102),
    color(255, 225, 152),
    titleFont
    );

  coresButton = new MenuButton(
    startX, startY + btnH + gapY, btnW, btnH,
    "Jogo das Cores",
    color(255, 65, 107),
    color(255, 120, 150),
    titleFont
    );

  torresButton = new MenuButton(
    startX + btnW + gapX, startY + btnH + gapY, btnW, btnH,
    "Jogo das Torres",
    color(98, 199, 89),
    color(140, 220, 130),
    titleFont
    );

  float exitW = width * 0.08;
  float exitH = height * 0.06;

  exitButton = new ExitButton(
    width - exitW - width * 0.02,
    height - exitH - height * 0.02,
    exitW, exitH,
    "Sair",
    color(255, 0, 0),
    color(255, 10, 10),
    buttonFont
    );

  printArray(Serial.list());

  if (Serial.list().length > 4) {
    String portName1 = Serial.list()[4];
    myPort1 = new Serial(this, portName1, 9600);
    myPort1.bufferUntil('\n');
    myPort1.clear();

    String portName2 = Serial.list()[3];
    myPort2 = new Serial(this, portName2, 9600);
    myPort2.bufferUntil('\n');
    myPort2.clear();
  }

  jogoLetras = null;
  jogoMatematica = null;
  jogoCores = null;
  jogoTorres = null;
}

void draw() {

  if (screenState == 0) {

    drawBackground();
    drawTitle();

    letrasButton.display();
    matButton.display();
    coresButton.display();
    torresButton.display();
    exitButton.display();
  }
  else if (screenState == 1 && jogoLetras != null) {
    jogoLetras.run();
  }
  else if (screenState == 1 && jogoMatematica != null) {
    jogoMatematica.run();
  }
  else if (screenState == 1 && jogoCores != null) {
    jogoCores.run();
  }
  else if (screenState == 1 && jogoTorres != null) {
    jogoTorres.run();
  }
}

void drawBackground() {
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(color(240, 248, 255), color(240, 248, 255), inter);
    stroke(c);
    line(0, i, width, i);
  }
}

void drawTitle() {
  textAlign(CENTER, CENTER);
  textFont(titleFont);

  fill(0);

  text(
    "Jogos Educativos",
    width / 2, height * 0.10
    );
}

void serialEvent(Serial p) {
  if (screenState == 1 && jogoLetras != null) {
    jogoLetras.handleSerialData(p);
  }
  else if (screenState == 1 && jogoMatematica != null) {
    jogoMatematica.handleSerialData(p);
  }
  else if (screenState == 1 && jogoCores != null) {
    jogoCores.handleSerialData(p);
  }
  else if (screenState == 1 && jogoTorres != null) {
    jogoTorres.handleSerialData(p);
  }
}

void mousePressed() {
  if (screenState == 0) {
    if (letrasButton.isOver()) {
      startLetrasGame();
    }
    if (matButton.isOver()) {
      startMatematicaGame();
    }
    if (coresButton.isOver()) {
      startCoresGame();
    }
    if (torresButton.isOver()) {
      startTorresGame();
    }
    if (exitButton.isOver()) {
      exit();
    }
  }

  else if (screenState == 1 && jogoLetras != null) {
    jogoLetras.mousePressed();
  }

  else if (screenState == 1 && jogoMatematica != null) {
    jogoMatematica.mousePressed();
  }

  else if (screenState == 1 && jogoCores != null) {
    jogoCores.mousePressed();
  }

  else if (screenState == 1 && jogoTorres != null) {
    jogoTorres.mousePressed();
  }
}

void startLetrasGame() {
  jogoLetras = new JogoLetras(this, myPort1, myPort2);
  jogoLetras.setup();
  screenState = 1;
}

void startMatematicaGame() {
  jogoMatematica = new JogoMatematica(this, myPort1, myPort2);
  jogoMatematica.setup();
  screenState = 1;
}

void startCoresGame() {
  jogoCores = new JogoCores(this, myPort1, myPort2);
  jogoCores.setup();
  screenState = 1;
}

void startTorresGame() {
  jogoTorres = new JogoTorres(this, myPort1, myPort2);
  jogoTorres.setup();
  screenState = 1;
}

void returnToMenu() {
  if (jogoLetras != null) {
    jogoLetras.stop();
    jogoLetras = null;
  }
  if (jogoMatematica != null) {
    jogoMatematica.stop();
    jogoMatematica = null;
  }
  if (jogoCores != null) {
    jogoCores.stop();
    jogoCores = null;
  }
  if (jogoTorres != null) {
    jogoTorres.stop();
    jogoTorres = null;
  }

  screenState = 0;
}
