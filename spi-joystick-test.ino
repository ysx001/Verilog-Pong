#include<SPI.h>

void setup() {
  // put your setup code here, to run once:
  pinMode(10, OUTPUT);
  SPI.begin();
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(10, LOW);
  SPI.beginTransaction(SPISettings(100000, MSBFIRST, SPI_MODE0));
  byte outdata[5];
  outdata[0] = SPI.transfer(0xB);
  for(int i=1; i<5; i++) {
    outdata[i] = SPI.transfer(0x0);
  }
  Serial.println();
  for(int i=0; i<5; i++) {
    Serial.print(outdata[i], HEX);
    Serial.print(" ");
  }
  digitalWrite(10, HIGH);
  delay(1500);
}
