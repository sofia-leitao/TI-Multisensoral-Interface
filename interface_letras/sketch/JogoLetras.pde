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
    "../alphabet/a.mp3",
    "../alphabet/b.mp3",
    "../alphabet/c.mp3",
    "../alphabet/d.mp3",
    "../alphabet/e.mp3",
    "../alphabet/f.mp3",
    "../alphabet/g.mp3",
    "../alphabet/h.mp3",
    "../alphabet/i.mp3",
    "../alphabet/j.mp3",
    "../alphabet/l.mp3",
    "../alphabet/m.mp3",
    "../alphabet/n.mp3",
    "../alphabet/o.mp3",
    "../alphabet/p.mp3",
    "../alphabet/q.mp3",
    "../alphabet/r.mp3",
    "../alphabet/s.mp3",
    "../alphabet/t.mp3",
    "../alphabet/u.mp3",
    "../alphabet/v.mp3",
    "../alphabet/x.mp3",
    "../alphabet/z.mp3"
  };

  int chosenTag;
  ExitButton gameExitButton;
  boolean gameRunning = true;


  JogoLetras(PApplet parent, Serial myPort1, Serial myPort2) {
    this.parent = parent;
    this.myPort1 = myPort1;
    this.myPort2 = myPort2;
  }


  void setup() {
    gameExitButton = new ExitButton(840, 620, 120, 50, "MENU", parent.color(255, 90, 90), parent.color(255, 130, 130));
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
      color c = lerpColor(color(220, 210, 210), color(210, 220, 220), inter);
      parent.stroke(c);
      parent.line(0, i, parent.width, i);
    }
  }


  void drawTitle() {
    parent.textAlign(CENTER, CENTER);
    parent.textSize(44);
    
    // texto
    parent.fill(0);
    parent.text("Jogo das Letras", parent.width/2, 60);
  }


  void drawLetterCard() {
    parent.pushMatrix();
    parent.translate(parent.width/2, 290);
    parent.rectMode(CENTER);

    // letra
    parent.fill(0);
    parent.textAlign(CENTER, CENTER);
    parent.textSize(100);
    parent.text(pieceNames[chosenTag], 0, -10);
    parent.popMatrix();
    parent.rectMode(CORNER);
  }


  void drawInstructions() {
    parent.textAlign(CENTER);
    parent.fill(0);
    parent.textSize(24);
    parent.text("Passa a letra correta no RFID", parent.width/2, 470);
    parent.textSize(18);
    parent.text("Carrega no botão para ouvir o som novamente", parent.width/2, 510);
  }


  void drawLastTag() {
    parent.textAlign(LEFT);
    parent.fill(40);
    parent.textSize(18);
    parent.text("Última tag: " + (hasLine ? currentLine : "nenhuma"), 30, 650);
  }


  void handleSerialData(Serial p) {
    try {
      String line = p.readStringUntil('\n');
      if (line != null) {
        line = line.trim();
        if (line.length() == 0) return;
        currentLine = line;
        // replay
        if (currentLine.equals("B")) {
          hasLine = false;
          if (file != null) {
            file.play();
          }
        } else {
          currentLine = line.substring(2);
          hasLine = true;
        }
        println("Received in game: " + currentLine);
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
