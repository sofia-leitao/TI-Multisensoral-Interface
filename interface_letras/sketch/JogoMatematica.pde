import processing.serial.*;

class JogoMatematica {
  PApplet parent;
  Serial myPort1, myPort2;
  String currentLine = "";
  boolean hasLine = false;
  SoundFile file;
  ExitButton gameExitButton;
  boolean gameRunning = true;

  String[] numberTags1 = {
    "04 74 A8 9F D9 2A 81",
    "04 A2 57 9F D9 2A 81",
    "04 BA 3E 9F D9 2A 81",
    "04 EF 43 9F D9 2A 81",
    "04 CB 3E 9F D9 2A 81",
    "04 C3 3E 9F D9 2A 81",
    "04 9A DC 9F D9 2A 81",
    "04 BF E5 9F D9 2A 81",
    "04 DF C5 9F D9 2A 81",
    "04 D8 3B 9F D9 2A 81"
  };
  
  String[] numberTags2 = {
    "04 7C 71 9F D9 2A 81",
    "04 69 DC 9F D9 2A 81",
    "04 63 53 9F D9 2A 81",
    "04 29 D2 9F D9 2A 81",
    "04 DB 3E 9F D9 2A 81",
    "04 C6 73 9F D9 2A 81",
    "04 BF 3E 9F D9 2A 81",
    "04 62 53 9F D9 2A 81",
    "04 5C CC 9F D9 2A 81",
    "04 68 2F 9F D9 2A 81"
  };

  int num1, num2, resultado, reader;
  int respostaAtual = -1;
  String operacao, tag; 
  String[] resposta;


  JogoMatematica(PApplet parent, Serial myPort1, Serial myPort2) {
    this.parent = parent;
    this.myPort1 = myPort1;
    this.myPort2 = myPort2;
    this.resposta = new String[3];
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
    parent.text("Resolve a conta usando as peças RFID, quando tiver colocado as peças carregue no botão para fazer a sua verificação.\n Caso o resultado tenha menos de 3 algarismos preencha os espaços à sua esquerda com 0.", parent.width/2, 120);
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
        if (line.length() != 0 && !line.equals("B")) {
          processarTag(line);
        } else if (line.equals("B")) {
          verificarResposta();
        }
      }
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  
  
  void processarTag(String line) {
    tag = line.substring(3);
    reader = int(line.substring(0,1));
    resposta[reader] = tag;
    println("Recebido: \"" + tag);
  }


  void verificarResposta() {
    println("resultado: " + str(resultado));
    println("resposta: " +  resposta[0] + " | " + resposta[1] + " | " + resposta[2]);
    int n_algarismos = countDigits(resultado);
    println("digitos: " + str(n_algarismos));
    
    if (n_algarismos == 1) {
      if ((resposta[0].equals(numberTags1[0]) || resposta[0].equals(numberTags2[0])) && 
         (resposta[1].equals(numberTags1[0]) || resposta[1].equals(numberTags2[0]))  && 
         (resposta[2].equals(numberTags1[resultado%10]) || resposta[2].equals(numberTags2[resultado%10]))) {
        if (myPort2 != null) {
            myPort2.write("C\n");
        }
        novaConta();
      } else {
        if (myPort2 != null) {
            myPort2.write("E\n");
        }
      }
    } else if (n_algarismos == 2) {
      if ((resposta[0].equals(numberTags1[0]) || resposta[0].equals(numberTags2[0])) && 
         (resposta[1].equals(numberTags1[int(resultado/10)]) || resposta[1].equals(numberTags2[int(resultado/10)])) && 
         (resposta[2].equals(numberTags1[resultado%10]) || resposta[2].equals(numberTags2[resultado%10]))) {
        if (myPort2 != null) {
            myPort2.write("C\n");
        }
        novaConta();
      } else {
        if (myPort2 != null) {
            myPort2.write("E\n");
        }
      }
    } else {
      if ((resposta[0].equals(numberTags1[int(resultado/100)]) || resposta[0].equals(numberTags2[int(resultado/100)])) && 
          (resposta[1].equals(numberTags1[int(resultado/10)]) || resposta[1].equals(numberTags2[int(resultado/10)])) && 
          (resposta[2].equals(numberTags1[resultado%10]) || resposta[2].equals(numberTags2[resultado%10]))) {
        if (myPort2 != null) {
            myPort2.write("C\n");
        }
        novaConta();
      } else {
        if (myPort2 != null) {
            myPort2.write("E\n");
        }
      }
    }
    hasLine = false;
  }


  void novaConta() {
    if (resposta == null) {
      resposta = new String[3];
    }
    int tipo = int(parent.random(2));
    
    resposta[0] = "0";
    resposta[1] = "0";
    resposta[2] = "0";
    
    // soma
    if (tipo == 0) {
      do {
        num1 = int(parent.random(1, 50));
        num2 = int(parent.random(1, 50));
        resultado = num1 + num2;
      }
      while (resultado > 10);
      operacao = "+";
    }

    // subtração
    else {
      num1 = int(parent.random(1, 100));
      num2 = int(parent.random(1, 100));
      if (num2 > num1) {
        int temp = num1;
        num1 = num2;
        num2 = temp;
      }
      resultado = num1 - num2;
      operacao = "-";
    }
  }
  
  
  int countDigits(int number) {
    return str(abs(number)).length();
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
