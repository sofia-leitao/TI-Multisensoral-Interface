import processing.serial.*;
import processing.sound.*;

MenuButton startButton;
ExitButton exitButton;
JogoLetras jogoLetras;
int screenState = 0; // 0 = menu, 1 = game
Serial myPort;

void setup() {
  size(800, 600);
  
  startButton = new MenuButton(width/2 - 100, height/2 - 60, 200, 50, "Jogo das Letras", color(50), color(100));
  exitButton = new ExitButton(width - 90, height - 60, 70, 40, "Sair", color(50), color(100));
  
  printArray(Serial.list());
  if (Serial.list().length > 2) {
    String portName = Serial.list()[2];
    myPort = new Serial(this, portName, 9600);
    myPort.bufferUntil('\n');
    myPort.clear();
  }
  
  jogoLetras = null;
}

void draw() {
  if (screenState == 0) {
    background(0);
    fill(255);
    textAlign(CENTER, CENTER);
    startButton.display();
    exitButton.display();
  } 
  else if (screenState == 1 && jogoLetras != null) {
    jogoLetras.run();
  }
}

// ao receber informação chama a classe do jogo ativo para lidar com ela
void serialEvent(Serial p) {
  if (screenState == 1 && jogoLetras != null) {
    jogoLetras.handleSerialData(p);
  }
}

void mousePressed() {
  if (screenState == 0) {
    if (startButton.isOver()) {
      startGame();
    }
    if (exitButton.isOver()) {
      exit();
    }
  }
  else if (screenState == 1 && jogoLetras != null) {
    jogoLetras.mousePressed();
  }
}

void startGame() {
  jogoLetras = new JogoLetras(this, myPort);
  jogoLetras.setup();
  screenState = 1;
}

void returnToMenu() {
  if (jogoLetras != null) {
    jogoLetras.stop();
    jogoLetras = null;
  }
  screenState = 0;
}
