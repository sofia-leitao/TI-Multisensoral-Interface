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

int screenState = 0; // 0 = menu | 1 = game

Serial myPort1, myPort2;

PFont titleFont;
PFont buttonFont;


void setup() {
  size(1000, 700);
  smooth(8);
  titleFont = createFont("Arial Bold", 56);
  buttonFont = createFont("Arial", 24);

  letrasButton = new MenuButton(width/2 - 180, 180, 360, 70, "Jogo das Letras", color(255, 140, 70), color(255, 180, 100));

  matButton = new MenuButton(width/2 - 180, 280, 360, 70, "Jogo da Matemática", color(70, 170, 255), color(120, 210, 255));

  coresButton = new MenuButton(width/2 - 180, 380, 360, 70, "Jogo das Cores", color(255, 90, 170), color(255, 140, 200));

  torresButton = new MenuButton(width/2 - 180, 480, 360, 70, "Jogo das Torres", color(150, 100, 255), color(190, 150, 255));

  exitButton = new ExitButton(width - 130, height - 70, 100, 45, "Sair", color(255, 80, 80), color(255, 120, 120));

  printArray(Serial.list());

  if (Serial.list().length > 2) {
    String portName1 = Serial.list()[2];
    myPort1 = new Serial(this, portName1, 9600);
    myPort1.bufferUntil('\n');
    myPort1.clear();
    
    String portName2 = Serial.list()[2];
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
    color c = lerpColor(color(220, 210, 210), color(210, 220, 220), inter);
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
    width/2,
    90
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
