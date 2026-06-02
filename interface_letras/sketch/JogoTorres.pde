import processing.serial.*;

class JogoTorres {

  PApplet parent;
  Serial myPort1, myPort2;

  String currentLine = "";
  boolean hasLine = false;

  String[][][] tags = {
    {{"04 6D 2F 9F D9 2A 81", "04 68 DC 9F D9 2A 81", "04 C1 3E 9F D9 2A 81"},{"04 6D 2F 9F D9 2A 81", "04 C1 3E 9F D9 2A 81", "04 68 DC 9F D9 2A 81"}},
    {{"04 C1 3E 9F D9 2A 81", "04 68 DC 9F D9 2A 81", "04 6D 2F 9F D9 2A 81"},{"04 68 DC 9F D9 2A 81", "04 C1 3E 9F D9 2A 81", "04 6D 2F 9F D9 2A 81"}},
    {{"04 68 DC 9F D9 2A 81", "04 C1 3E 9F D9 2A 81", "04 6D 2F 9F D9 2A 81"},{"04 C1 3E 9F D9 2A 81", "04 6D 2F 9F D9 2A 81", "04 68 DC 9F D9 2A 81"}, {"04 68 DC 9F D9 2A 81", "04 6D 2F 9F D9 2A 81", "04 C1 3E 9F D9 2A 81"}},
    {{"04 6D 2F 9F D9 2A 81", "04 C1 3E 9F D9 2A 81", "04 68 DC 9F D9 2A 81"},{"04 C1 3E 9F D9 2A 81", "04 6D 2F 9F D9 2A 81", "04 68 DC 9F D9 2A 81"}, {"04 68 DC 9F D9 2A 81", "04 6D 2F 9F D9 2A 81", "04 C1 3E 9F D9 2A 81"}},
    {{"04 C1 3E 9F D9 2A 81", "04 68 DC 9F D9 2A 81", "04 6D 2F 9F D9 2A 81"}}, 
    {{"04 6D 2F 9F D9 2A 81", "04 68 DC 9F D9 2A 81", "04 C1 3E 9F D9 2A 81"}}
  };

//P: 04 C1 3E 9F D9 2A 81
//M: 04 68 DC 9F D9 2A 81
//G: 04 6D 2F 9F D9 2A 81

  String[] instrucoes = {
    "Ao olhar pelo lado esquerdo da caixa\nsó consegues ver 1 torre.", //GMP, GPM
    "Ao olhar pelo lado direito da caixa\nsó consegues ver 1 torre.", //PMG, MPG
    "Ao olhar pelo lado esquerdo da caixa\nconsegues ver 2 torres.", //MPG, MGP, PGM, MGP
    "Ao olhar pelo lado direito da caixa\nconsegues ver 2 torres.", //MGP, PGM, GPM, 
    "Ao olhar pelo lado esquerdo da caixa\ntodas as torres têm de ser visíveis.", //PMG
    "Ao olhar pelo lado direito da caixa\ntodas as torres têm de ser visíveis." //GMP
  };

  String instrucaoEscolhida;
  String[] resposta;

  int reader;
  String tag;
  int rand;

  ExitButton gameExitButton;
  boolean gameRunning = true;

  JogoTorres(PApplet parent, Serial myPort1, Serial myPort2) {

    this.parent = parent;
    this.myPort1 = myPort1;
    this.myPort2 = myPort2;

    this.resposta = new String[3];
  }

  void setup() {
    float exitW = parent.width * 0.08;
    float exitH = parent.height * 0.06;

    gameExitButton = new ExitButton(
      (int)(parent.width - exitW - parent.width * 0.06),
      (int)(parent.height - exitH - parent.height * 0.06),
      (int)exitW,
      (int)exitH,
      "MENU",
      color(255, 59, 48),
      color(255, 120, 120),
      buttonFont
    );
    startNewRound();
  }
  
  
  String getNomeTag(String uid) {
    if (uid.equals("04 6D 2F 9F D9 2A 81")) {
      return "TORRE GRANDE";
    }
    if (uid.equals("04 68 DC 9F D9 2A 81")) {
      return "TORRE MÉDIA";
    }
    if (uid.equals("04 C1 3E 9F D9 2A 81")) {
      return "TORRE PEQUENA";
    }
    return uid;
  }


  void run() {
    if (!gameRunning) return;

    drawBackground();
    drawTitle();
    drawInstruction();
    drawTowerCard();
    drawTagInfo();

    gameExitButton.display();
  }


  void drawBackground() {
    for (int i = 0; i < parent.height; i++) {
      float inter = map(i, 0, parent.height, 0, 1);
      color c = lerpColor(color(240, 248, 255), color(240, 248, 255), inter);
      parent.stroke(c);
      parent.line(0, i, parent.width, i);
    }
  }


  void drawTitle() {
    parent.textFont (titleFont);
    parent.textAlign(CENTER, CENTER);
    parent.textSize(parent.height * 0.06);
    parent.fill(0);
    parent.text(
      "Jogo das Torres",
      parent.width / 2,
      parent.height * 0.14
    );
  }


  void drawInstruction() {
    parent.textFont (instructionFont);
    parent.fill(0);
    parent.textAlign(CENTER);
    parent.textSize(parent.height * 0.03);
    parent.text(
      "Coloca as torres na ordem correta",
      parent.width / 2,
      parent.height * 0.28
    );
    parent.fill(70);
    parent.textSize(parent.height * 0.025);
    parent.text(
      "Depois pressiona o botão",
      parent.width / 2,
      parent.height * 0.32
    );
  }


  void drawTowerCard() {
    parent.textFont (cardFont);
    parent.pushMatrix();
    parent.translate(
      parent.width / 2,
      parent.height * 0.52
    );

    parent.rectMode(CENTER);
    parent.noStroke();
    parent.fill(0);
    parent.textAlign(CENTER, CENTER);
    parent.textSize(parent.height * 0.06);
    parent.text(instrucaoEscolhida, 0, -20);
    parent.popMatrix();
    parent.rectMode(CORNER);
  }


  void drawTagInfo() {
    parent.textFont (instructionFont);
    parent.textAlign(CENTER);
    parent.textSize(parent.height * 0.02);
    parent.fill(40);
    String textoTag = "nenhuma";

    if (hasLine) {
      textoTag = getNomeTag(tag);
    }
    
    parent.text(
      "Última torre lida: " + textoTag,
      parent.width  * 0.15,
      parent.height * 0.90
    );
  }


  void handleSerialData(Serial p) {
    try {
      String line = p.readStringUntil('\n');
      if (line != null) {
        line = line.trim();
        if (line.length() != 0) {
          if (line.equals("B")) {
            processarResposta();
          }
          else {
            currentLine = line;
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
    tag = line.substring(3);
    reader = int(line.substring(0, 1));
    resposta[reader] = tag;
    println("Recebido: " + tag);
  }


  void processarResposta() {
    boolean correct = true;
    for (int i = 0; i < tags[rand].length; i++) {
      correct = true;
      for (int c = 0; c < 3; c++) {
        if (!resposta[c].equals(tags[rand][i][c])) {
          correct = false;
        }
      }
    }
    if (correct) {
      if (myPort2 != null) {
        myPort2.write("C\n");
        startNewRound();
      }
    }
    else {
      if (myPort2 != null) {
        myPort2.write("E\n");
      }
    }
    parent.delay(1000);
  }


  void startNewRound() {
    if (resposta == null) {
      resposta = new String[3];
    }

    rand = int(parent.random(instrucoes.length));

    instrucaoEscolhida = instrucoes[rand];

    resposta[0] = null;
    resposta[1] = null;
    resposta[2] = null;

    currentLine = "";

    hasLine = false;
  }


  void mousePressed() {
    if (gameExitButton.isOver()) {
      gameRunning = false;
      try {
        parent.getClass()
          .getMethod("returnToMenu")
          .invoke(parent);
      } catch (Exception e) {
        println("Erro ao regressar ao menu.");
      }
    }
  }


  void stop() {
    gameRunning = false;
  }
}
