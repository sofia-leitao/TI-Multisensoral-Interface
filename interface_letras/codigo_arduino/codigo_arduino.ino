#include <SPI.h>
#include <MFRC522.h>

#define SS_PIN 10
#define RST_PIN 9

MFRC522 rfid(SS_PIN, RST_PIN);

// LEDs
int ledCorreto = 6;
int ledErro = 7;

void setup() { 
  Serial.begin(9600);
  SPI.begin();
  rfid.PCD_Init();

  pinMode(ledCorreto, OUTPUT);
  pinMode(ledErro, OUTPUT);
}

void loop() {

  if ( !rfid.PICC_IsNewCardPresent())
    return;

  if ( !rfid.PICC_ReadCardSerial())
    return;

  // Envia UID para o Processing
  printHex(rfid.uid.uidByte, rfid.uid.size);
  Serial.println("");

  rfid.PICC_HaltA();
}


// RECEBER COMANDO DO PROCESSING (LEDs)
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


// imprimir UID
void printHex(byte *buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}