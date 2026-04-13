import processing.serial.*;
import processing.sound.*;

Serial myPort;
String currentLine = "";
boolean hasLine = false;

// Peças (nomes)
String[] pieceNames = {
  "A","B","C","D","E","F","G","H","I","J","K","L","M",
  "N","O","P","Q","R","S","T","U","V","X","Z"
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
  "04 53 33 9F D9 2A 81",
  "04 9F A6 9F D9 2A 81"
};

// 🎧 Audios (FIXED)
String[] audios = {
  "alphabet/a.mp3","alphabet/b.mp3","alphabet/c.mp3","alphabet/d.mp3",
  "alphabet/e.mp3","alphabet/f.mp3","alphabet/g.mp3","alphabet/h.mp3",
  "alphabet/i.mp3","alphabet/j.mp3","alphabet/k.mp3","alphabet/l.mp3",
  "alphabet/m.mp3","alphabet/n.mp3","alphabet/o.mp3","alphabet/p.mp3",
  "alphabet/q.mp3","alphabet/r.mp3","alphabet/s.mp3","alphabet/t.mp3",
  "alphabet/u.mp3","alphabet/v.mp3","alphabet/x.mp3","alphabet/z.mp3"
};

// 🔊 Sounds preload
SoundFile[] sounds;

// Ordem aleatória
int[] order;
int currentIndex = 0;

int portIndex = 2;
color bgColor;

// 🔘 Button
int btnX;
int btnY;

void setup() {
  size(800, 600);
  textSize(24);
  fill(255);

  // 🔊 Load sounds
  sounds = new SoundFile[audios.length];
  for (int i = 0; i < audios.length; i++) {
    sounds[i] = new SoundFile(this, audios[i]);
  }

  // Random order
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

  // Button position
  btnX = width - 200;
  btnY = 20;
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

  // Draw button
  drawReplayButton();
}

void drawReplayButton() {
  int btnW = 120;
  int btnH = 50;
  boolean hover = mouseX > btnX && mouseX < btnX + btnW && mouseY > btnY && mouseY < btnY + btnH;

  fill(hover ? color(100, 200, 255) : color(70, 150, 220));
  rect(btnX, btnY, btnW, btnH, 10);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("🔊 Replay", btnX + btnW/2, btnY + btnH/2);

  textAlign(LEFT, BASELINE); // reset
}

void mousePressed() {
  if (currentIndex >= order.length) return;

  int idx = order[currentIndex];
  int btnW = 120;
  int btnH = 50;

  boolean overButton = mouseX > btnX && mouseX < btnX + btnW &&
                       mouseY > btnY && mouseY < btnY + btnH;

  if (overButton) {
    sounds[idx].stop();
    sounds[idx].play();
  }
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

      sounds[idx].stop();
      sounds[idx].play();

      currentIndex++;

    } else {
      bgColor = color(200, 0, 0);
      println("ERRADO! Esperado: " + pieceNames[idx]);
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
