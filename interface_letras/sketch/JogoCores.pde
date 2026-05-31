import processing.serial.*;

class JogoCores {

  PApplet parent;
  Serial myPort1, myPort2;

  String currentLine = "";
  boolean hasLine = false;

  SoundFile file;

  String[] colorNames = {
    "VERMELHO",
    "VERDE",
    "AZUL"
  };

  String[][] tags = {

    {
      "04 4A DD 9F D9 2A 81",
      "04 76 E3 9F D9 2A 81"
    },

    {
      "04 DF 42 9F D9 2A 81",
      "04 E1 42 9F D9 2A 81"
    },

    {
      "04 67 2F 9F D9 2A 81",
      "04 D5 42 9F D9 2A 81"
    }
  };

String getNomeTag(String uid) {

  for (int cor = 0; cor < tags.length; cor++) {

    for (int i = 0; i < tags[cor].length; i++) {

      if (uid.equals(tags[cor][i])) {
        return colorNames[cor];
      }
    }
  }

  return uid;
}

  color[] displayColors = {
    color(255, 70, 70),
    color(70, 220, 120),
    color(70, 150, 255)
  };

  int chosenColor;

  ExitButton gameExitButton;

  boolean gameRunning = true;

  JogoCores(
    PApplet parent,
    Serial myPort1,
    Serial myPort2
    ) {

    this.parent = parent;
    this.myPort1 = myPort1;
    this.myPort2 = myPort2;
  }

  void setup() {

    float exitW = parent.width * 0.08;
    float exitH = parent.height * 0.06;

    gameExitButton = new ExitButton(
      parent.width - exitW - parent.width * 0.02,
      parent.height - exitH - parent.height * 0.02,
      exitW,
      exitH,
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

      float inter = map(i, 0, parent.height, 0, 1);

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

    float titleSize = parent.height * 0.06;

    parent.textSize(titleSize);

    parent.fill(120);

    parent.text(
      "Jogo das Cores",
      parent.width/2 + 3,
      parent.height * 0.085
      );

    parent.fill(0);

    parent.text(
      "Jogo das Cores",
      parent.width/2,
      parent.height * 0.08
      );
  }

  void drawInstruction() {

    parent.fill(0);

    parent.textAlign(CENTER);

    parent.textSize(parent.height * 0.03);

    parent.text(
      "Passa o objeto da cor correta no RFID",
      parent.width/2,
      parent.height * 0.16
      );
  }

  void drawColorCard() {

    float cardW = parent.width * 0.22;
    float cardH = parent.height * 0.25;

    parent.pushMatrix();

    parent.translate(
      parent.width/2,
      parent.height * 0.42
      );

    parent.rectMode(CENTER);

    parent.fill(displayColors[chosenColor]);

    parent.rect(
      0,
      0,
      cardW,
      cardH,
      cardH * 0.12
      );

    parent.fill(255, 40);

    parent.noStroke();

    parent.rect(
      0,
      -cardH * 0.22,
      cardW * 0.8,
      cardH * 0.25,
      cardH * 0.08
      );

    parent.popMatrix();

    parent.rectMode(CORNER);
  }

  void drawColorName() {

    parent.textAlign(CENTER);

    parent.textSize(parent.height * 0.055);

    parent.fill(0);

    parent.text(
      colorNames[chosenColor],
      parent.width/2,
      parent.height * 0.68
      );
  }

  void drawTagInfo() {

    parent.textAlign(LEFT);

    parent.textSize(parent.height * 0.02);

    parent.fill(40);

    String textoTag = "nenhuma";

if (hasLine) {
  textoTag = getNomeTag(currentLine);
}

parent.text(
  "Última tag: " + textoTag,
  parent.width * 0.02,
  parent.height * 0.95
);
  }

  void handleSerialData(Serial p) {

    try {

      String line = p.readStringUntil('\n');

      if (line != null) {

        line = line.trim();

        if (line.length() != 0 && !line.equals("B")) {

          currentLine = line.substring(3);

          println(
            "Recebido: \"" +
            currentLine
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

      if (myPort2 != null) {
        myPort2.write("C\n");
      }

      parent.delay(1000);

      startNewRound();
    }
    else {

      if (myPort2 != null) {
        myPort2.write("E\n");
      }

      parent.delay(1000);

      enviarCorLED(chosenColor);
    }

    hasLine = false;
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

    if (myPort2 == null) return;

    switch(cor) {

    case 0:
      myPort2.write("R\n");
      break;

    case 1:
      myPort2.write("G\n");
      break;

    case 2:
      myPort2.write("B\n");
      break;
    }
  }

  void mousePressed() {

    if (gameExitButton.isOver()) {

      gameRunning = false;

      returnToMenu();
    }
  }

  void stop() {

    gameRunning = false;

    if (myPort2 != null) {
      myPort2.write("A");
    }

    if (file != null) {
      file.stop();
    }
  }

  void returnToMenu() {

    try {

      if (parent instanceof MainMenu) {
        ((MainMenu)parent).returnToMenu();
      }
    }
    catch(Exception e) {
      println("Erro ao regressar ao menu.");
    }
  }
}
