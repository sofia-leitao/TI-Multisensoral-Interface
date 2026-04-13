import processing.serial.*;

Serial myPort;
String currentLine = "";
boolean hasLine = false;

// Peças (nomes)
String[] pieceNames = {
  "A","B","C","D","E","F","G","H","I","J","K","L","M",
  "N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
};

// Tags correspondentes
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
  "04 49 CC 9F D9 2A 81",
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
  "04 CA 3E 9F D9 2A 81",
  "04 53 33 9F D9 2A 81",
  "04 CC 3E 9F D9 2A 81",
  "04 9F A6 9F D9 2A 81"
};

// Ordem aleatória (índices)
int[] order;

int currentIndex = 0;

int portIndex = 2;
color bgColor;

void setup() {
  size(800, 600);
  textSize(24);
  fill(255);

  // Criar ordem aleatória
  order = new int[pieceNames.length];
  for (int i = 0; i < order.length; i++) {
    order[i] = i;
  }
  shuffleArray(order);

  println("Ordem aleatória:");
  for (int i = 0; i < order.length; i++) {
    println(pieceNames[order[i]]);
  }

  // Serial
  String[] ports = Serial.list();
  for (int i = 0; i < ports.length; i++) {
    println(i + ": " + ports[i]);
  }

  myPort = new Serial(this, ports[portIndex], 9600);
  myPort.bufferUntil('\n');

  bgColor = color(0);
}

void draw() {
  background(bgColor);

  if (currentIndex >= order.length) {
    text("🎉 JOGO TERMINADO!", 20, 100);
    return;
  }

  int idx = order[currentIndex];

  text("Peça atual: " + pieceNames[idx], 20, 40);
  text("Tag esperada: " + tags[idx], 20, 80);
  text("Lido: " + (hasLine ? currentLine : "Aguardando..."), 20, 120);

  String status = "Sem dados";
  if (hasLine) {
    if (currentLine.equals(tags[idx])) {
      status = "CORRETO";
    } else {
      status = "ERRADO";
    }
  }

  text("Estado: " + status, 20, 160);
}

void serialEvent(Serial p) {
  String line = p.readStringUntil('\n');

  if (line != null) {
    line = trim(line);
    if (line.length() == 0) return;

    currentLine = line;
    hasLine = true;

    int idx = order[currentIndex];

    if (currentLine.equals(tags[idx])) {
      bgColor = color(0, 200, 0);
      println("CORRETO: " + pieceNames[idx]);

      currentIndex++;

    } else {
      bgColor = color(200, 0, 0);
      println("ERRADO! Esperado: " + pieceNames[idx]);
    }
  }
}

// Função para baralhar array (shuffle)
void shuffleArray(int[] array) {
  for (int i = array.length - 1; i > 0; i--) {
    int j = (int) random(i + 1);
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
}
