import processing.serial.*;
import processing.sound.*;

class JogoCores {

  PApplet parent;
  Serial myPort;

  String currentLine = "";

  boolean hasLine = false;

  SoundFile file;

  String[] colorNames = {
    "VERMELHO",
    "VERDE",
    "AZUL"
  };

  String[][] tags = {

    // vermelho
    {
      "04 4A DD 9F D9 2A 81",
      "04 76 E3 9F D9 2A 81"
    },

    // verde
    {
      "04 DF 42 9F D9 2A 81",
      "04 E1 42 9F D9 2A 81"
    },

    // azul
    {
      "04 67 2F 9F D9 2A 81",
      "04 D5 42 9F D9 2A 81"
    }
  };

  color[] displayColors = {

    color(255, 70, 70),
    color(70, 220, 120),
    color(70, 150, 255)
  };

  int chosenColor;

  ExitButton gameExitButton;

  boolean gameRunning = true;


  JogoCores(PApplet parent, Serial myPort) {

    this.parent = parent;
    this.myPort = myPort;
  }


  void setup() {

    gameExitButton = new ExitButton(
      840,
      620,
      120,
      50,
      "MENU",
      parent.color(255, 90, 90),
      parent.color(255, 130, 130)
      );

    startNewRound();
  }


  void run() {

    if (!gameRunning) return;

    drawBackground();

    drawTitle();

    drawInstruction();

    drawColorCard();

    drawColorName();

    drawTagInfo();

    gameExitButton.display();
  }



  void drawBackground() {

    for (int i = 0; i < parent.height; i++) {

      float inter =
        map(i, 0, parent.height, 0, 1);

      color c = lerpColor(
        color(220, 210, 210),
        color(210, 220, 220),
        inter
        );

      parent.stroke(c);

      parent.line(0, i, parent.width, i);
    }
  }

  void drawTitle() {

    parent.textAlign(CENTER, CENTER);

    parent.textSize(44);

    // sombra
    parent.fill(120);

    parent.text(
      "Jogo das Cores",
      parent.width/2 + 3,
      63
      );

    // texto principal
    parent.fill(0);

    parent.text(
      "Jogo das Cores",
      parent.width/2,
      60
      );
  }



  void drawInstruction() {

    parent.fill(0);

    parent.textAlign(CENTER);

    parent.textSize(24);

    parent.text(
      "Passa o objeto da cor correta no RFID",
      parent.width/2,
      120
      );
  }


  void drawColorCard() {

    parent.pushMatrix();

    parent.translate(parent.width/2, 320);

    parent.rectMode(CENTER);



    // cartão principal
    parent.fill(displayColors[chosenColor]);

    parent.rect(0, 0, 300, 200, 28);

    // brilho
    parent.fill(255, 40);
        parent.noStroke();


    parent.rect(0, -45, 240, 50, 20);

    parent.popMatrix();

    parent.rectMode(CORNER);
  }


  void drawColorName() {

    parent.textAlign(CENTER);

    parent.textSize(42);

    parent.fill(0);

    parent.text(
      colorNames[chosenColor],
      parent.width/2,
      500
      );
  }


  void drawTagInfo() {

    parent.textAlign(LEFT);

    parent.textSize(18);

    parent.fill(40);

    parent.text(
      "Última tag: "
      + (hasLine ? currentLine : "nenhuma"),
      30,
      650
      );
  }


  void handleSerialData(Serial p) {

    try {

      String line =
        p.readStringUntil('\n');

      if (line != null) {

        line = line.trim();

        if (line.length() != 0 ||
          !line.equals("B")) {

          currentLine =
            line.substring(2);

          println(
            "Recebido: "
            + currentLine
            );

          hasLine = true;

          processarTag(currentLine);
        }
      }
    }

    catch(Exception e) {

      e.printStackTrace();
    }
  }


  void processarTag(String tag) {

    if (tagCorreta(tag, chosenColor)) {

      myPort.write("C\n");

      parent.delay(1000);

      startNewRound();
    }

    else {

      myPort.write("E\n");

      parent.delay(1000);
    }

    hasLine = false;
  }

  String normalizeTag(String t) {

    t = t.replace("\r", "");

    t = t.replace("\n", "");

    t = t.trim();

    return t;
  }

  boolean tagCorreta(String tag, int cor) {

    for (String t : tags[cor]) {

      if (tag.equals(t)) {

        return true;
      }
    }

    return false;
  }

  void startNewRound() {

    chosenColor =
      int(parent.random(colorNames.length));

    currentLine = "";

    hasLine = false;

    enviarCorLED(chosenColor);
  }

  void enviarCorLED(int cor) {

    if (myPort == null) return;

    switch(cor) {

    case 0:
      myPort.write("R\n");
      break;

    case 1:
      myPort.write("G\n");
      break;

    case 2:
      myPort.write("B\n");
      break;
    }
  }

  void mousePressed() {

    if (gameExitButton.isOver()) {

      gameRunning = false;

      MainMenu mainMenu =
        (MainMenu) parent;

      mainMenu.returnToMenu();
    }
  }

  void stop() {

    gameRunning = false;

    if (file != null) {

      file.stop();
    }
  }
}
