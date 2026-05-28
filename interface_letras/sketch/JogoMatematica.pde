import processing.serial.*;

class JogoMatematica {
  PApplet parent;
  Serial myPort1, myPort2;
  String currentLine = "";
  boolean hasLine = false;
  SoundFile file;
  ExitButton gameExitButton;
  boolean gameRunning = true;

  String[] numberTags = {
    "TAG_0",
    "04 A2 57 9F D9 2A 81",
    "04 BA 3E 9F D9 2A 81",
    "04 EF 43 9F D9 2A 81",
    "04 CB 3E 9F D9 2A 81",
    "04 C3 3E 9F D9 2A 81",
    "04 9A DC 9F D9 2A 81",
    "TAG_7",
    "TAG_8",
    "TAG_9"
  };

  int num1;
  int num2;
  int resultado;
  int respostaAtual = -1;
  String operacao;


  JogoMatematica(PApplet parent, Serial myPort1, Serial myPort2) {
    this.parent = parent;
    this.myPort1 = myPort1;
    this.myPort2 = myPort2;
  }


  void setup() {
    gameExitButton = new ExitButton(840, 620, 120, 50, "MENU", parent.color(255, 90, 90), parent.color(255, 130, 130));
    novaConta();
  }


  void run() {
    if (!gameRunning) return;
    drawBackground();
    drawTitle();
    drawInstruction();
    drawMathCard();
    drawConta();
    drawResposta();
    drawTagInfo();
    gameExitButton.display();
  }


  void drawBackground() {
    for (int i = 0; i < parent.height; i++) {
      float inter = map(i, 0, parent.height, 0, 1);
      color c = lerpColor(color(220, 210, 210), color(210, 220, 220), inter);
      parent.stroke(c);
      parent.line(0, i, parent.width, i);
    }
  }


  void drawTitle() {
    parent.textAlign(CENTER, CENTER);
    parent.textSize(44);
    parent.fill(120);
    parent.fill(0);
    parent.text("Jogo da Matemática", parent.width/2, 60);
  }


  void drawInstruction() {
    parent.fill(0);
    parent.textAlign(CENTER);
    parent.textSize(24);
    parent.text("Resolve a conta usando as peças RFID", parent.width/2, 120);
  }


  void drawMathCard() {
    parent.pushMatrix();
    parent.translate(parent.width/2, 320);
    parent.rectMode(CENTER);
    parent.noStroke();
    parent.popMatrix();
    parent.rectMode(CORNER);
  }


  void drawConta() {
    parent.textAlign(CENTER, CENTER);
    parent.textSize(70);
    parent.fill(0);
    parent.text(num1 + " " + operacao + " " + num2 + " = ?", parent.width/2, 320);
  }


  void drawResposta() {
    parent.textAlign(CENTER);
    parent.textSize(32);
    parent.fill(40);

    if (respostaAtual != -1) {
      parent.text("Resposta: " + respostaAtual, parent.width/2, 500);
    }
  }


  void drawTagInfo() {
    parent.textAlign(CENTER);
    parent.textSize(18);
    parent.fill(40);
    parent.text("Última tag: " + (hasLine ? currentLine : "nenhuma"), parent.width/2, 560);
  }


  void handleSerialData(Serial p) {
    try {
      String line = p.readStringUntil('\n');
      if (line != null) {
        line = line.trim();
        if (line.length() != 0 || !line.equals("B")) {
          currentLine = line.substring(2);
          println("Recebido: " + currentLine);
          hasLine = true;
          verificarResposta(currentLine);
        }
      }
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }


  void verificarResposta(String tag) {
    int resposta = obterNumeroDaTag(tag);
    respostaAtual = resposta;
    println("Resposta: " + resposta);

    // correta
    if (resposta == resultado) {
      if (myPort2 != null) {
        myPort2.write("C\n");
      }
      parent.delay(1000);
      respostaAtual = -1;
      novaConta();
    }

    // errada
    else {
      if (myPort2 != null) {
        myPort2.write("E\n");
      }
      parent.delay(1000);
    }
    hasLine = false;
  }


  int obterNumeroDaTag(String tag) {
    for (int i = 0; i < numberTags.length; i++) {
      if (tag.equals(numberTags[i])) {
        return i;
      }
    }
    return -1;
  }


  void novaConta() {
    int tipo = int(parent.random(2));

    // soma
    if (tipo == 0) {
      do {
        num1 = int(parent.random(1, 10));
        num2 = int(parent.random(1, 10));
        resultado = num1 + num2;
      }
      while (resultado > 10);
      operacao = "+";
    }

    // subtração
    else {
      num1 = int(parent.random(1, 10));
      num2 = int(parent.random(1, 10));
      if (num2 > num1) {
        int temp = num1;
        num1 = num2;
        num2 = temp;
      }
      resultado = num1 - num2;
      operacao = "-";
    }
  }


  void mousePressed() {
    if (gameExitButton.isOver()) {
      gameRunning = false;
      MainMenu mainMenu = (MainMenu) parent;
      mainMenu.returnToMenu();
    }
  }
  

  void stop() {
    gameRunning = false;
  }
}
