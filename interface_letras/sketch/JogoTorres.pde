import processing.serial.*;

class JogoTorres {

  PApplet parent;
  Serial myPort;

  String currentLine = "";
  boolean hasLine = false;

  // torre pequena -> media -> grande
  String[][] tags = {
    {"2", "1", "0"},
    {"0", "1", "2"},
    {"1", "0", "2"},
    {"2", "0", "1"},
    {"0", "1", "2"},
    {"2", "1", "0"}
  };
  
  String[] instrucoes = {
    "Ao olhar pelo lado esquerdo da caixa só se pode ser capaz de ver 1 torre.\n",
    "Ao olhar pelo lado direito da caixa só se pode ser capaz de ver 1 torre.\n",
    "Ao olhar pelo lado esquerdo da caixa só se pode ser capaz de ver 2 torres.\n",
    "Ao olhar pelo lado direito da caixa só se pode ser capaz de ver 2 torres.\n",
    "Ao olhar pelo lado esquerdo da caixa todas as torres tem que ser visíveis.\n",
    "Ao olhar pelo lado direito da caixa todas as torres tem que ser visíveis.\n"
  };
  
  String instrucaoEscolhida;
  String[] resposta;
  
  int reader;
  String tag;
  int rand;
  
  color[] displayColors = {
    color(255, 0, 0),
    color(0, 255, 0),
    color(0, 0, 255)
  };

  color bgColor = color(0);
  ExitButton gameExitButton;
  boolean gameRunning = true;


  JogoTorres(PApplet parent, Serial myPort) {
    this.parent = parent;
    this.myPort = myPort;
  }


  void setup() {
    gameExitButton = new ExitButton(
      710, 550,
      70, 40,
      "MENU",
      parent.color(150, 0, 0),
      parent.color(200, 0, 0)
    );

    startNewRound();
  }


  void run() {
    if (!gameRunning) return;
    parent.background(bgColor);
    parent.fill(255);
    parent.textSize(30);
    parent.text("Jogo das Torres", 20, 40);

    parent.textSize(20);
    parent.text("Segue as instruções e coloca os objetos pela ordem correta nos seus respetivos sensores RFID", 20, 90);

    parent.textAlign(LEFT);
    parent.textSize(18);

    parent.text(
      "Última tag: " + (hasLine ? currentLine : "nenhuma"),
      20,
      530
    );

    gameExitButton.display();
  }


  void handleSerialData(Serial p) {
    try {
      String line = p.readStringUntil('\n');
      if (line != null) {
        line = line.trim();
        if (line.length() != 0) {
          if (!line.equals("B")) {
          currentLine = line;
          println("Recebido: " + currentLine);
          hasLine = true;
          processarTag(currentLine); // executar a lógica do jogo
          } else { // botao foi pressionado, queremos ver se as peças estao no sitio correto
            processarResposta();
          }
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  void processarTag(String line) {
    tag = line.substring(2);
    reader = int(line.substring(0,1));
    
    // para nao estarmos sempre a alterar o valor caso o armazenado ja seja esse mesmo
    if (resposta[reader].equals("0") || !resposta[reader].equals(tag)){
      resposta[reader] = tag;
    }
  }
  
  void processarResposta() {
    Boolean correct = true;
    for (int i = 0; i < 3; i++) {
      // resposta errada
      if (!resposta[i].equals(tags[rand][i])){
        if (myPort != null) {
          myPort.write("E\n");
          correct = false;
        }
      }
    }
    // resposta dada esta certa
    if (myPort != null && correct) {
        myPort.write("C\n");
    }
    startNewRound();
  }

  String normalizeTag(String t) {
    t = t.replace("\r", "");
    t = t.replace("\n", "");
    t = t.trim();
    return t;
  }



  void startNewRound() {
    rand = (int) random(0,10);
    instrucaoEscolhida = instrucoes[rand];
    resposta[0] = "0";
    resposta[1] = "0";
    resposta[2] = "0";

    currentLine = "";
    hasLine = false;

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
