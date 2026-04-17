import processing.serial.*;

Serial myPort;
String currentLine = "";
boolean hasLine = false;

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

int[] order;
int currentIndex = 0;

int portIndex = 2;

color bgColor = color(255); // branco inicial

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
  textSize(220);

  order = new int[pieceNames.length];
  for (int i = 0; i < order.length; i++) {
    order[i] = i;
  }
  shuffleArray(order);

  String[] ports = Serial.list();
  for (int i = 0; i < ports.length; i++) {
    println(i + ": " + ports[i]);
  }

  myPort = new Serial(this, ports[portIndex], 9600);
  myPort.bufferUntil('\n');
}

void draw() {
  background(bgColor);

  if (currentIndex >= order.length) {
    fill(0);
    textSize(80);
    text("FIM", width/2, height/2);
    return;
  }

  int idx = order[currentIndex];

  fill(0);
  textSize(220);
  text(pieceNames[idx], width/2, height/2);
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

      bgColor = color(0, 200, 0); // verde
      myPort.write("C\n");        // LED correto

      currentIndex++;

      delay(2000);
      bgColor = color(255);

    } else {

      bgColor = color(200, 0, 0); // vermelho
      myPort.write("E\n");        // LED erro

      delay(2000);
      bgColor = color(255);
    }
  }
}

// Shuffle
void shuffleArray(int[] array) {
  for (int i = array.length - 1; i > 0; i--) {
    int j = (int) random(i + 1);
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
}
