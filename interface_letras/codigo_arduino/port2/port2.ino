#include <SPI.h>
#include <MFRC522.h>

// RFID
#define SS_1 10
#define RST_1 9

MFRC522 rfid1(SS_1, RST_1);

// LED RGB
#define LED_R 6
#define LED_G 7
#define LED_B 3

// botão
int botao = 4;

int buttonState;
int lastButtonState = LOW;

unsigned long lastDebounceTime = 0;
unsigned long debounceDelay = 50;


void setup() {
  Serial.begin(9600);

  SPI.begin();

  rfid1.PCD_Init();

  pinMode(LED_R, OUTPUT);
  pinMode(LED_G, OUTPUT);
  pinMode(LED_B, OUTPUT);

  pinMode(botao, INPUT_PULLUP);
}


void loop() {
  lerRFID(rfid1);

  int reading = !digitalRead(botao);

  // debounce
  if (reading != lastButtonState) {
    lastDebounceTime = millis();
  }

  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (reading != buttonState) {
      buttonState = reading;
      if (buttonState) {
        Serial.println("B");
      }
    }
  }

  lastButtonState = reading;
}


void lerRFID(MFRC522 &rfid) {
  if (!rfid.PICC_IsNewCardPresent()) return;
  if (!rfid.PICC_ReadCardSerial()) return;
  printHex(rfid.uid.uidByte, rfid.uid.size);
  Serial.println();
  rfid.PICC_HaltA();
}


void serialEvent() {
  String comando = Serial.readStringUntil('\n');
  comando.trim();
  
  // correto
  if (comando == "C") {
    for (int i = 0; i < 5; i++) {
      verde();
      delay(200);
      apagarLED();
      delay(200);
    }
  }
  // erro
  else if (comando == "E") {
    for (int i = 0; i < 5; i++) {
      vermelho();
      delay(200);
      apagarLED();
      delay(200);
    }
  }
  // vermelho
  else if (comando == "R") {
    vermelho();
  }
  // verde
  else if (comando == "G") {
    verde();
  }
  // azul
  else if (comando == "B") {
    azul();
  }

  else if (comando == "A") {
    apagarLED();
  }
}


void vermelho() {
  digitalWrite(LED_R, HIGH);
  digitalWrite(LED_G, LOW);
  digitalWrite(LED_B, LOW);
}


void verde() {
  digitalWrite(LED_R, LOW);
  digitalWrite(LED_G, HIGH);
  digitalWrite(LED_B, LOW);
}


void azul() {
  digitalWrite(LED_R, LOW);
  digitalWrite(LED_G, LOW);
  digitalWrite(LED_B, HIGH);
}


void apagarLED() {
  digitalWrite(LED_R, LOW);
  digitalWrite(LED_G, LOW);
  digitalWrite(LED_B, LOW);
}


void printHex(byte *buffer, byte bufferSize) {
  Serial.print("2-");
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}