import processing.serial.*;

class JogoTorres {

  PApplet parent;
  Serial myPort;

  String currentLine = "";

  boolean hasLine = false;

  String[][] tags = {

    {"2", "1", "0"},
    {"0", "1", "2"},
    {"1", "0", "2"},
    {"2", "0", "1"},
    {"0", "1", "2"},
    {"2", "1", "0"}
  };

  String[] instrucoes = {

    "Ao olhar pelo lado esquerdo da caixa\nsó consegues ver 1 torre.",

    "Ao olhar pelo lado direito da caixa\nsó consegues ver 1 torre.",

    "Ao olhar pelo lado esquerdo da caixa\nconsegues ver 2 torres.",

    "Ao olhar pelo lado direito da caixa\nconsegues ver 2 torres.",

    "Ao olhar pelo lado esquerdo da caixa\ntodas as torres têm de ser visíveis.",

    "Ao olhar pelo lado direito da caixa\ntodas as torres têm de ser visíveis."
  };

  String instrucaoEscolhida;

  String[] resposta;

  int reader;

  String tag;

  int rand;

  ExitButton gameExitButton;

  boolean gameRunning = true;

  // =====================================================

  JogoTorres(PApplet parent, Serial myPort) {

    this.parent = parent;

    this.myPort = myPort;

    this.resposta = new String[3];
  }

  // =====================================================

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

  // =====================================================

  void run() {

    if (!gameRunning) return;

    drawBackground();

    drawTitle();

    drawInstruction();

    drawTowerCard();

    drawTagInfo();

    gameExitButton.display();
  }

  // =====================================================
  // BACKGROUND
  // =====================================================

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


    parent.fill(0);

    parent.text(
      "Jogo das Torres",
      parent.width/2,
      60
      );
  }


  void drawInstruction() {

    parent.fill(0);

    parent.textAlign(CENTER);

    parent.textSize(24);

    parent.text(
      "Coloca as torres na ordem correta",
      parent.width/2,
      120
      );
  }


  void drawTowerCard() {

    parent.pushMatrix();

    parent.translate(parent.width/2, 340);

    parent.rectMode(CENTER);

    parent.noStroke();

    // texto
    parent.fill(0);

    parent.textAlign(CENTER, CENTER);

    parent.textSize(28);

    parent.text(
      instrucaoEscolhida,
      0,
      -20
      );

    parent.textSize(20);

    parent.fill(70);

    parent.text(
      "Depois pressiona o botão",
      0,
      70
      );

    parent.popMatrix();

    parent.rectMode(CORNER);
  }


  void drawTagInfo() {

    parent.textAlign(CENTER);

    parent.textSize(18);

    parent.fill(40);

    parent.text(
      "Última tag: "
      + (hasLine ? currentLine : "nenhuma"),
      parent.width/2,
      590
      );
  }


  void handleSerialData(Serial p) {

    try {

      String line =
        p.readStringUntil('\n');

      if (line != null) {

        line = line.trim();

        if (line.length() != 0) {

          // botão pressionado
          if (line.equals("B")) {

            processarResposta();
          }

          // leitura RFID
          else {

            currentLine = line;

            println(
              "Recebido: "
              + currentLine
              );

            hasLine = true;

            processarTag(currentLine);
          }
        }
      }
    }

    catch(Exception e) {

      e.printStackTrace();
    }
  }


  void processarTag(String line) {

    tag =
      line.substring(2);

    reader =
      int(line.substring(0,1));

    if (resposta[reader] == null ||
      resposta[reader].equals("0") ||
      !resposta[reader].equals(tag)) {

      resposta[reader] = tag;
    }
  }


  void processarResposta() {

    boolean correct = true;

    for (int i = 0; i < 3; i++) {

      if (!resposta[i].equals(tags[rand][i])) {

        correct = false;

        if (myPort != null) {

          myPort.write("E\n");
        }
      }
    }

    if (correct) {

      if (myPort != null) {

        myPort.write("C\n");
      }
    }

    parent.delay(1000);

    startNewRound();
  }


  String normalizeTag(String t) {

    t = t.replace("\r", "");

    t = t.replace("\n", "");

    t = t.trim();

    return t;
  }


  void startNewRound() {

    if (resposta == null) {

      resposta = new String[3];
    }

    rand =
      int(parent.random(0, 6));

    instrucaoEscolhida =
      instrucoes[rand];

    resposta[0] = "0";

    resposta[1] = "0";

    resposta[2] = "0";

    currentLine = "";

    hasLine = false;
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
  }
}
