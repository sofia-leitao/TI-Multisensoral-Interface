#include <SPI.h>
#include <MFRC522.h>

// RFID 1
#define SS_1 10
#define RST_1 9

// RFID 2
#define SS_2 8
#define RST_2 5

MFRC522 rfid1(SS_1, RST_1);
MFRC522 rfid2(SS_2, RST_2);

// LEDs
int ledCorreto = 6;
int ledErro = 7;

// botao
int botao = 5;
int buttonState;            
int lastButtonState = LOW;  
unsigned long lastDebounceTime = 0;
unsigned long debounceDelay = 50; 


void setup() { 
  Serial.begin(9600);
  SPI.begin();

  rfid1.PCD_Init();
  rfid2.PCD_Init();

  pinMode(ledCorreto, OUTPUT);
  pinMode(ledErro, OUTPUT);
  pinMode(botao, INPUT_PULLUP);
}


void loop() {
  lerRFID(rfid1);
  lerRFID(rfid2);

  int reading = !digitalRead(botao);

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

  if (comando == "C") {
    digitalWrite(ledCorreto, HIGH);
    digitalWrite(ledErro, LOW);

    delay(2000);
    digitalWrite(ledCorreto, LOW);
  } 
  else if (comando == "E") {
    digitalWrite(ledErro, HIGH);
    digitalWrite(ledCorreto, LOW);

    delay(2000);
    digitalWrite(ledErro, LOW);
  }
}


void printHex(byte *buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}