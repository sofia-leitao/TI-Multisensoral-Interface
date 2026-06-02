// ligar porto 2 num porto menor q o porto 1 !!
// ex: porto2 - 1300 e porto1 - 1400

#include <MFRC522v2.h>
#include <MFRC522DriverSPI.h>
#include <MFRC522DriverPinSimple.h>
#include <MFRC522Debug.h>

MFRC522DriverPinSimple ss_1_pin(4); // Configurable, take an unused pin, only HIGH/LOW required, must be different to SS 2.
MFRC522DriverPinSimple ss_2_pin(5); // Configurable, take an unused pin, only HIGH/LOW required, must be different to SS 1.

MFRC522DriverSPI driver_1{ss_1_pin};
MFRC522DriverSPI driver_2{ss_2_pin};

MFRC522 readers[]{driver_1, driver_2};   // Create MFRC522 instance.

/**
 * Initialize.
 */
void setup() {
  Serial.begin(115200);  // Initialize serial communications with the PC for debugging.
  while (!Serial);     // Do nothing if no serial port is opened (added for Arduinos based on ATMEGA32U4).
  
  for (MFRC522 reader : readers) {
    reader.PCD_Init(); // Init each MFRC522 card.
    //todo: check if needed
    // MFRC522Debug::PCD_DumpVersionToSerial(reader, Serial);
  }
}

/**
 * Main loop.
 */
void loop() {
  // Look for new cards - use index-based loop instead of range-based
  for (int readerIndex = 0; readerIndex < 2; readerIndex++) {
    MFRC522& reader = readers[readerIndex];  // Get reference to current reader
    
    if (reader.PICC_IsNewCardPresent() && reader.PICC_ReadCardSerial()) {
      Serial.print(String(readerIndex + 1) + "-"); 
      
      MFRC522Debug::PrintUID(Serial, reader.uid);
      Serial.println();
      
      //MFRC522::PICC_Type piccType = reader.PICC_GetType(reader.uid.sak);
      //Serial.println(MFRC522Debug::PICC_GetTypeName(piccType));
      
      // Halt PICC
      reader.PICC_HaltA();
      // Stop encryption on PCD
      reader.PCD_StopCrypto1();
    }
  }
}
