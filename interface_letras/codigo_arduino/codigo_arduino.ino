#include <SPI.h>
#include <MFRC522.h>

// RFID
#define SS_1 10
#define RST_1 9

#define SS_2 8
#define RST_2 9

#define SS_3 5

MFRC522 rfid1(SS_1, RST_1);
MFRC522 rfid2(SS_2, RST_2);
MFRC522 rfid3(SS_3, RST_2);

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
  rfid2.PCD_Init();
  rfid3.PCD_Init();

  pinMode(LED_R, OUTPUT);
  pinMode(LED_G, OUTPUT);
  pinMode(LED_B, OUTPUT);

  pinMode(botao, INPUT_PULLUP);

  apagarLED(); // é necessario ?? (penso q nao)
}

void loop() {

  lerRFID(rfid1);
  lerRFID(rfid2);
  lerRFID(rfid3);

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

  // feedback visual
  azul();
  delay(300);
  apagarLED();
  rfid.PICC_HaltA();
}



void serialEvent() {

  String comando = Serial.readStringUntil('\n');

  comando.trim();

  // correto
  if (comando == "C") {
    verde();
    delay(2000);
    apagarLED();
  }

  // erro
  else if (comando == "E") {
    vermelho();
    delay(2000);
    apagarLED();
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

}

// =========================
// CORES
// =========================

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

  for (byte i = 0; i < bufferSize; i++) {

    Serial.print(buffer[i] < 0x10 ? " 0" : " ");

    Serial.print(buffer[i], HEX);
  }
}