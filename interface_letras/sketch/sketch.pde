import processing.serial.*;
import processing.sound.*;

Serial myPort;
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
  "../alphabet/a.mp3","../alphabet/b.mp3","../alphabet/c.mp3","../alphabet/d.mp3",
  "../alphabet/e.mp3","../alphabet/f.mp3","../alphabet/g.mp3","../alphabet/h.mp3",
  "../alphabet/i.mp3","../alphabet/j.mp3","../alphabet/l.mp3",
  "../alphabet/m.mp3","../alphabet/n.mp3","../alphabet/o.mp3","../alphabet/p.mp3",
  "../alphabet/q.mp3","../alphabet/r.mp3","../alphabet/s.mp3","../alphabet/t.mp3",
  "../alphabet/u.mp3","../alphabet/v.mp3","../alphabet/x.mp3","../alphabet/z.mp3"
};

int chosenTag;
color bgColor = color(0);

void setup() {
  size(800, 600);
  textSize(24);
  fill(255);

  printArray(Serial.list());

  String portName = Serial.list()[2]; // adjust if needed
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
  myPort.clear();

  startNewRound(); // ✅ initialize first round
}

void draw() {
  background(bgColor);
  fill(255);

  text("Serial Game Interface", 20, 40);
  text("Correct tag: " + pieceNames[chosenTag], 20, 90);
  text("Last read: " + (hasLine ? currentLine : "Waiting for data..."), 20, 140);
  text("Sound played: " + audios[chosenTag], 20, 190);

  if (hasLine) {
    if (currentLine.equals(tags[chosenTag])) {
      background(0, 200, 0);
      fill(255);
      text("Status: CORRECT", 20, 240);
      myPort.write("C\n");
      delay(2000);
      startNewRound();
    } else {
      background(200, 0, 0);
      fill(255);
      text("Status: WRONG", 20, 240);
      myPort.write("E\n");
      delay(2000);
    }
  }

  text("currentLine: '" + currentLine + "'", 20, 290);
}

void startNewRound() {
  chosenTag = int(random(tags.length));
  hasLine = false;
  currentLine = "";

  file = new SoundFile(this, audios[chosenTag]);
  file.play();
}

void serialEvent(Serial p) {
  try {
    String line = p.readStringUntil('\n');
    if (line != null) {
      line = trim(line);
      if (line.length() == 0) return;

      currentLine = line;  // ✅ store received tag
      hasLine = true;      // ✅ mark as received

      println("Received: " + currentLine); // debug
    }
  } catch (Exception e) {
    e.printStackTrace();
  }
}
