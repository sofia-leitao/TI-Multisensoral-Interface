import processing.sound.*;

class JogoLetras {
  // para termos hierarquia com o MainMenu
  PApplet parent;
  Serial myPort;
  String currentLine = "";
  boolean hasLine = false;
  SoundFile file;
  
  String[] pieceNames = {
    "A","B","C","D","E","F","G","H","I","J","L","M",
    "N","O","P","Q","R","S","T","U","V","X","Z"
  };
  
  String[] tags = {
    "04 13 56 9F D9 2A 81", "04 AA 34 9F D9 2A 81", "04 56 56 9F D9 2A 81",
    "04 E3 3E 9F D9 2A 81", "04 7B 3E 9F D9 2A 81", "04 36 4B 9F D9 2A 81",
    "04 DC 3E 9F D9 2A 81", "04 EE 34 9F D9 2A 81", "04 75 E3 9F D9 2A 81",
    "04 4B DD 9F D9 2A 81", "04 54 DD 9F D9 2A 81", "04 4C DD 9F D9 2A 81",
    "04 93 57 9F D9 2A 81", "04 35 DA 9F D9 2A 81", "04 48 CC 9F D9 2A 81",
    "04 68 3E 9F D9 2A 81", "04 D4 3E 9F D9 2A 81", "04 8B 42 9F D9 2A 81",
    "04 D2 3E 9F D9 2A 81", "04 86 DE 9F D9 2A 81", "04 8A DC 9F D9 2A 81",
    "04 53 33 9F D9 2A 81", "04 9F A6 9F D9 2A 81"
  };
  
  String[] audios = {
    "../alphabet/a.mp3","../alphabet/b.mp3","../alphabet/c.mp3","../alphabet/d.mp3",
    "../alphabet/e.mp3","../alphabet/f.mp3","../alphabet/g.mp3","../alphabet/h.mp3",
    "../alphabet/i.mp3","../alphabet/j.mp3","../alphabet/l.mp3","../alphabet/m.mp3",
    "../alphabet/n.mp3","../alphabet/o.mp3","../alphabet/p.mp3","../alphabet/q.mp3",
    "../alphabet/r.mp3","../alphabet/s.mp3","../alphabet/t.mp3","../alphabet/u.mp3",
    "../alphabet/v.mp3","../alphabet/x.mp3","../alphabet/z.mp3"
  };
  
  int chosenTag;
  color bgColor = color(0);
  ExitButton gameExitButton;
  boolean gameRunning = true;
  
  JogoLetras(PApplet parent, Serial myPort) {
    this.parent = parent;
    this.myPort = myPort;
  }
  
  void setup() {
    gameExitButton = new ExitButton(710, 550, 70, 40, "MENU", parent.color(150, 0, 0), parent.color(200, 0, 0));
    startNewRound();
  }
  
  void run() {
    if (!gameRunning) return;
    
    parent.background(bgColor);
    
    parent.fill(255);
    parent.textSize(24);
    parent.text("Jogo das Letras - Passa a peça correta no sensor !!", 20, 40);
    parent.text("Letra: " + pieceNames[chosenTag], 20, 100);
    parent.text("Se quiseres ouvir o som de novo carrega no botão !!", 20, 150);
    parent.text("Última tag lida: " + (hasLine ? currentLine : "Ainda não foi lido nada"), 20, 200);
    
    gameExitButton.display();
  }
  
  void handleSerialData(Serial p) {
    try {
      String line = p.readStringUntil('\n');
      if (line != null) {
        line = line.trim();
        if (line.length() == 0) return;
  
        currentLine = line;  
        if (currentLine.equals("B")) {
          hasLine = false;
          if (file != null) file.play();
        } else {
          currentLine = line.substring(2);
          hasLine = true;
        }
        println("Received in game: " + currentLine); 
      }
      
      if (hasLine) {
        if (currentLine.equals(tags[chosenTag])) {
          bgColor = parent.color(0, 200, 0);
          parent.delay(2000);
          bgColor = parent.color(0);
          startNewRound();
        } else {
          bgColor = parent.color(200, 0, 0);
          parent.delay(2000);
          bgColor = parent.color(0);
          if (file != null) file.play();
        }
      }
    } catch (Exception e) {
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
