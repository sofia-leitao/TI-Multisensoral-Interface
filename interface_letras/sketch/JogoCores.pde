import processing.serial.*;

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
  //vermelho
    {
      "04 4A DD 9F D9 2A 81", //maça
      "04 76 E3 9F D9 2A 81" //coração
    },
  //verde
    {
      "04 DF 42 9F D9 2A 81",//arvore
      "04 E1 42 9F D9 2A 81"//sapo
    },
  //azul
    {
      "04 67 2F 9F D9 2A 81",//gota
      "04 D5 42 9F D9 2A 81"//peixe
    }
  };

  color[] displayColors = {
    color(255, 0, 0),
    color(0, 255, 0),
    color(0, 0, 255)
  };

  int chosenColor;
  color bgColor = color(0);

  ExitButton gameExitButton;

  boolean gameRunning = true;


  JogoCores(PApplet parent, Serial myPort) {
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
    parent.text("Jogo das Cores", 20, 40);
    parent.textSize(20);
    parent.text("Passa o objeto da cor correta no RFID", 20, 90);
    parent.fill(displayColors[chosenColor]);
    parent.rect(250, 170, 300, 220, 20);

    parent.fill(255);
    parent.textAlign(CENTER);
    parent.textSize(42);

    parent.text(colorNames[chosenColor], parent.width / 2, 470);

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
        if (line.length() != 0 || !line.equals("B")) {
          currentLine = line.substring(2);
          println("Recebido: " + currentLine);
          hasLine = true;
          processarTag(currentLine); // executar a lógica do jogo
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
}

void processarTag(String tag) {
  if (tagCorreta(tag, chosenColor)) {
    bgColor = parent.color(0, 180, 0);
    myPort.write("C\n");
    parent.delay(1500);
    bgColor = parent.color(0);
    startNewRound();
  } else {
    bgColor = parent.color(180, 0, 0);
    myPort.write("E\n");
    parent.delay(1500);
    bgColor = parent.color(0);
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
      if (tag.equals(t)) return true;
    }
    return false;
  }


  void startNewRound() {
    chosenColor = int(parent.random(colorNames.length));
    currentLine = "";
    hasLine = false;
    enviarCorLED(chosenColor);
  }

 
  void enviarCorLED(int cor) {
    if (myPort == null) return;
    
    switch(cor) {
      case 0: myPort.write("R\n"); break;
      case 1: myPort.write("G\n"); break;
      case 2: myPort.write("B\n"); break;
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
    if (file != null) file.stop();
  }
}
