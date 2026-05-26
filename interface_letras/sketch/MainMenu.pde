import processing.serial.*;
import processing.sound.*;

MenuButton letrasButton;
MenuButton matButton;
MenuButton coresButton;
ExitButton exitButton;
JogoLetras jogoLetras;
JogoMatematica jogoMatematica;
JogoCores jogoCores;
int screenState = 0; // 0 = menu, 1 = game
Serial myPort;

void setup() {
  size(800, 600);
  
letrasButton = new MenuButton(
  width/2 - 120,
  height/2 - 60,
  240,
  60,
  "Jogo das Letras",
  color(50),
  color(100)
);

matButton = new MenuButton(
  width/2 - 120,
  height/2 + 20,
  240,
  60,
  "Jogo da Matemática",
  color(50),
  color(100)
);

coresButton = new MenuButton(
  width/2 - 120,
  height/2 + 100,
  240,
  60,
  "Jogo das Cores",
  color(50),
  color(100)
);

exitButton = new ExitButton(
  width - 100,
  height - 60,
  80,
  40,
  "Sair",
  color(50),
  color(100)
);
  
  printArray(Serial.list());
  if (Serial.list().length > 2) {
    String portName = Serial.list()[2];
    myPort = new Serial(this, portName, 9600);
    myPort.bufferUntil('\n');
    myPort.clear();
  }
  
  jogoLetras = null;
  jogoMatematica = null;
  jogoCores = null;
}

void draw() {
  if (screenState == 0) {
    background(0);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize (42);
    text("Jogos Educativos", width/2, 100);
    letrasButton.display();
    matButton.display();
    coresButton.display();
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
}

// ao receber informação chama a classe do jogo ativo para lidar com ela
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
}

void startLetrasGame() {
  jogoLetras = new JogoLetras(this, myPort);
  jogoLetras.setup();
  screenState = 1;
}
void startMatematicaGame() {
  jogoMatematica = new JogoMatematica(this, myPort);
  jogoMatematica.setup();
  screenState = 1;
}
void startCoresGame() {
  jogoCores = new JogoCores(this, myPort);
  jogoCores.setup();
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
  screenState = 0;
}
