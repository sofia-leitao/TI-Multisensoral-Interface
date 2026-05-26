import processing.sound.*;
import processing.serial.*;

class JogoMatematica {

  PApplet parent;
  Serial myPort;

  String currentLine = "";

  boolean hasLine = false;

  SoundFile file;

  ExitButton gameExitButton;

  boolean gameRunning = true;

  String[] numberTags = {

    "TAG_0", //0
    "04 A2 57 9F D9 2A 81", //1
    "04 BA 3E 9F D9 2A 81", //2
    "04 EF 43 9F D9 2A 81", //3
    "04 CB 3E 9F D9 2A 81", //4
    "04 C3 3E 9F D9 2A 81", //5
    "04 9A DC 9F D9 2A 81", //6
    "TAG_7", //7
    "TAG_8", //8
    "TAG_9" //9
  };

  int num1;
  int num2;

  int resultado;

  // resposta lida no sensor
  int respostaAtual = -1;

  String operacao;

  color bgColor = color(0);

  JogoMatematica(PApplet parent, Serial myPort) {

    this.parent = parent;
    this.myPort = myPort;
  }

  void setup() {

    gameExitButton = new ExitButton(
      710,
      550,
      70,
      40,
      "MENU",
      parent.color(150, 0, 0),
      parent.color(200, 0, 0)
    );

    novaConta();
  }

  void run() {

    if (!gameRunning) return;

    parent.background(bgColor);

    parent.fill(255);

    parent.textAlign(CENTER);

    // título
    parent.textSize(30);

    parent.text(
      "Jogo da Matemática",
      parent.width / 2,
      70
    );

    // instruções
    parent.textSize(26);

    parent.text(
      "Resolve a conta usando as peças RFID",
      parent.width / 2,
      130
    );

    // conta
    parent.textSize(80);

    parent.text(
      num1 + " " + operacao + " " + num2 + " = ?",
      parent.width / 2,
      320
    );

    // resposta colocada no sensor
    parent.textSize(40);

    if (respostaAtual != -1) {

      parent.text(
        "Resposta: " + respostaAtual,
        parent.width / 2,
        420
      );
    }

    // última tag
    parent.textSize(18);

    parent.text(
      "Última tag: " +
      (hasLine ? currentLine : "Nenhuma"),
      parent.width / 2,
      520
    );

    gameExitButton.display();
  }

  void handleSerialData(Serial p) {

    try {

      String line = p.readStringUntil('\n');

      if (line == null) return;

      line = line.trim();

      if (line.length() == 0) return;

      currentLine = line;

      hasLine = true;

      println("Recebido: " + currentLine);

      verificarResposta(currentLine);

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

      bgColor = parent.color(0, 180, 0);

      if (myPort != null) {

        myPort.write("C\n");
      }

      parent.delay(1500);

      bgColor = parent.color(0);

      respostaAtual = -1;

      novaConta();
    }

    // errada
    else {

      bgColor = parent.color(180, 0, 0);

      if (myPort != null) {

        myPort.write("E\n");
      }

      parent.delay(1500);

      bgColor = parent.color(0);
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

    // SOMA
    if (tipo == 0) {

      do {

        num1 = int(parent.random(1, 10));

        num2 = int(parent.random(1, 10));

        resultado = num1 + num2;

      }
      while (resultado > 10);

      operacao = "+";
    }

    // SUBTRAÇÃO
    else {

      num1 = int(parent.random(1, 10));

      num2 = int(parent.random(1, 10));

      // garante resultado positivo
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
