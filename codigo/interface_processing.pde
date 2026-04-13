import processing.serial.*;

Serial myPort;
String currentLine = "";
boolean hasLine = false;

// Change this to the correct RFID tag value used in your game.
String correctTag = "04 67 DC 9F D9 2A 81";
int portIndex = 2; // matches the Python code selecting the 3rd available port

color bgColor;

void setup() {
  size(800, 600);
  smooth();
  background(0);
  textSize(24);
  textAlign(LEFT, TOP);
  fill(255);

  String[] ports = Serial.list();
  println("Available serial ports:");
  for (int i = 0; i < ports.length; i++) {
    println(i + ": " + ports[i]);
  }

  if (ports.length <= portIndex) {
    println("Error: Port at index " + portIndex + " not found.");
    println("Please change portIndex or connect the device.");
    noLoop();
    return;
  }

  println("Using port: " + ports[portIndex]);
  myPort = new Serial(this, ports[portIndex], 9600);
  myPort.bufferUntil('\n');
  bgColor = color(0);
}

void draw() {
  background(bgColor);
  fill(255);
  text("Serial Game Interface", 20, 20);
  text("Correct tag: " + correctTag, 20, 70);
  text("Last read: " + (hasLine ? currentLine : "Waiting for data..."), 20, 120);
  text("Status: " + (hasLine ? (currentLine.equals(correctTag) ? "CORRECT" : "WRONG") : "No data yet"), 20, 170);
  text("currentLine: '" + currentLine + "'", 20, 220);
}

void serialEvent(Serial p) {
  String line = p.readStringUntil('\n');
  if (line != null) {
    line = trim(line);
    if (line.length() == 0) {
      return;
    }

    currentLine = line;
    hasLine = true;

    if (currentLine.equals(correctTag)) {
      bgColor = color(0, 200, 0);
    } else {
      bgColor = color(200, 0, 0);
    }

    println("Read: " + currentLine + " => " + (currentLine.equals(correctTag) ? "CORRECT" : "WRONG"));
  }
}
