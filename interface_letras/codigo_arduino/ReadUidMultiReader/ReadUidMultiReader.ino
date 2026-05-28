#include <SPI.h>
#include <MFRC522.h>

#define RST_PIN         9         
#define SS_1_PIN        7        
#define SS_2_PIN        8          
#define SS_3_PIN        10

#define NR_OF_READERS   1

byte ssPins[] = {SS_1_PIN};

MFRC522 mfrc522[NR_OF_READERS]; 

// LED RGB
#define LED_R 6
#define LED_G 5
#define LED_B 3

// botão
int botao = 4;
int buttonState;
int lastButtonState = LOW;
unsigned long lastDebounceTime = 0;
unsigned long debounceDelay = 50;

/**
 * Initialize.
 */
void setup() {
  Serial.begin(9600); 
  while (!Serial);

  SPI.begin();   

  for (int reader = 0; reader < NR_OF_READERS; reader++) {
    mfrc522[reader].PCD_Init(ssPins[reader], RST_PIN);
  }

  pinMode(LED_R, OUTPUT);
  pinMode(LED_G, OUTPUT);
  pinMode(LED_B, OUTPUT);

  pinMode(botao, INPUT_PULLUP);
}


void loop() {
  for (uint8_t reader = 0; reader < NR_OF_READERS; reader++) {
    if (!mfrc522[reader].PICC_IsNewCardPresent()) continue;
    if (!mfrc522[reader].PICC_ReadCardSerial()) continue;
    
    // encontrou uma tag
    Serial.print(String(reader) + "-");
    printHex(mfrc522[reader].uid.uidByte, mfrc522[reader].uid.size);
    Serial.println();
    
    // azul();
    // delay(300);
    // apagarLED();
    
    mfrc522[reader].PICC_HaltA();
    mfrc522[reader].PCD_StopCrypto1();
  }

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

void serialEvent() {
  String comando = Serial.readStringUntil('\n');
  comando.trim();

  // correto
  if (comando == "C") {
    for (int i = 0; i < 5; i ++) {
      verde();
      delay(200);
      apagarLED();
      delay(200);
    }
  }

  // erro
  else if (comando == "E") {
    for (int i = 0; i < 5; i ++) {
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
}

/**
 * Cores
 */
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