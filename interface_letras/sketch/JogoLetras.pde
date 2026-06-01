import processing.serial.*;
import processing.sound.*;

class JogoLetras {
  PApplet parent;
  Serial myPort1, myPort2;
  String currentLine = "";
  boolean hasLine = false;
  SoundFile file;

  String[] pieceNames = {
    "A","B","C","D","E","F","G","H","I","J","L","M",
    "N","O","P","Q","R","S","T","U","V","X","Z"
  };

  String[] tags = {
    "04 13 56 9F D9 2A 81",
    "04 AA 34 9F D9 2A 81",
    "04 56 56 9F D9 2A 81",
    "04 E3 3E 9F D9 2A 81",
    "04 7B 3E 9F D9 2A 81",
    "04 36 4B 9F D9 2A 81",
    "04 DC 3E 9F D9 2A 81",
    "04 EE 34 9F D9 2A 81",
    "04 75 E3 9F D9 2A 81",
    "04 4B DD 9F D9 2A 81",
    "04 54 DD 9F D9 2A 81",
    "04 4C DD 9F D9 2A 81",
    "04 93 57 9F D9 2A 81",
    "04 35 DA 9F D9 2A 81",
    "04 48 CC 9F D9 2A 81",
    "04 68 3E 9F D9 2A 81",
    "04 D4 3E 9F D9 2A 81",
    "04 8B 42 9F D9 2A 81",
    "04 D2 3E 9F D9 2A 81",
    "04 86 DE 9F D9 2A 81",
    "04 8A DC 9F D9 2A 81",
    "04 53 33 9F D9 2A 81",
    "04 9F A6 9F D9 2A 81"
  };

 String[] audios = {
    "../Letras/A.mp3",
    "../Letras/B.mp3",
    "../Letras/C.mp3",
    "../Letras/D.mp3",
    "../Letras/E.mp3",
    "../Letras/F.mp3",
    "../Letras/G.mp3",
    "../Letras/H.mp3",
    "../Letras/I.mp3",
    "../Letras/J.mp3",
    "../Letras/L.mp3",
    "../Letras/M.mp3",
    "../Letras/N.mp3",
    "../Letras/O.mp3",
    "../Letras/P.mp3",
    "../Letras/Q.mp3",
    "../Letras/R.mp3",
    "../Letras/S.mp3",
    "../Letras/T.mp3",
    "../Letras/U.mp3",
    "../Letras/V.mp3",
    "../Letras/X.mp3",
    "../Letras/Z.mp3"
  };

String getNomeTag(String uid) {
  for (int i = 0; i < tags.length; i++) 
  {
    if (uid.equals(tags[i])) {
      return pieceNames[i];
    }
  }
  return uid;
}

  int chosenTag;
  ExitButton gameExitButton;
  boolean gameRunning = true;

  JogoLetras(PApplet parent, Serial myPort1, Serial myPort2) {
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
     color(255, 59, 48),
     color(255, 120, 120),
     buttonFont
  );

  startNewRound();
}

  void run() {
    if (!gameRunning) return;
    drawBackground();
    drawTitle();
    drawLetterCard();
    drawInstructions();
    drawLastTag();
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
    "Jogo das Letras",
    parent.width / 2,
    parent.height * 0.14
  );
}

  void drawLetterCard() {
    parent.textFont (cardFont);
    parent.pushMatrix();
    parent.translate(
      parent.width / 2,
      parent.height * 0.52
    );
  
    parent.textAlign(CENTER, CENTER);
    parent.fill(0);
    parent.textSize(parent.height * 0.24);
    parent.text(pieceNames[chosenTag], 0, 0);
  
    parent.popMatrix();
  }

  void drawInstructions() {
    parent.textFont (instructionFont);
    parent.textAlign(CENTER);
    parent.fill(0);
    parent.textSize(parent.height * 0.03);
    parent.text(
      "Coloca a letra correta no sensor",
      parent.width / 2,
      parent.height * 0.28
    );
    parent.textSize(parent.height * 0.022);
    parent.text(
      "Carrega no botão para ouvir o som novamente",
      parent.width / 2,
      parent.height * 0.32
    );
  }

  void drawLastTag() {
    parent.textFont (instructionFont);
    parent.textAlign(LEFT);
    parent.fill(40);
    parent.textSize(parent.height * 0.02);
  
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
        if (line.length() == 0) return;
        currentLine = line;
        // replay som
        if (currentLine.equals("B")) {
          hasLine = false;
          if (file != null) {
            file.play();
          }
        } else {
          currentLine = line.substring(3);
          hasLine = true;
        }
        println("Recebido: \"" + currentLine);
      }
      if (hasLine) {
        if (currentLine.equals(tags[chosenTag])) {
          parent.delay(1000);
          if (myPort2 != null) {
            myPort2.write("C\n");
          }
          startNewRound();
        }
        else {
          parent.delay(1000);
          if (myPort2 != null) {
            myPort2.write("E\n");
          }
          if (file != null) {
            file.play();
          }
        }
      }
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }

  void startNewRound() {
    chosenTag = int(parent.random(tags.length));
    hasLine = false;
    currentLine = "";
    if (audios[chosenTag] != null) {
      file = new SoundFile(parent, audios[chosenTag]);
      file.play();
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
    if (file != null) {
      file.stop();
    }
    gameRunning = false;
  }
}
