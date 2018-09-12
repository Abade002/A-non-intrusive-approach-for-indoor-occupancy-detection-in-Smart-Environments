#include <Wire.h>  // Library which contains functions to have I2C Communication
#include<stdlib.h>
#include <string.h>
#include "Adafruit_CCS811.h"
#include "Adafruit_MCP9808.h"

#define _noise A0
#define MAX 10

char op = 'D';
float data[MAX];
int cont = 0;
long start = 0;   
long finish = 0;
long interval = 500;

Adafruit_MCP9808 tempsensor = Adafruit_MCP9808();
Adafruit_CCS811 ccs;

void setup() {
  // put your setup code here, to run once:

  Serial.begin(9600);
  while(!Serial);

  //INIT MCP9808
  if (!tempsensor.begin()) {
    Serial.println("***MCP9808: INSUCESS!");
    while (1);
  }
  else
    Serial.println("***MCP9808: SUCESS!");
    
  //INIT CCS811
  if(!ccs.begin()){
    Serial.println("***CCS811: INSUCESS!");
    while(1);
  }
  else
    Serial.println("***CCS811: SUCESS!");
    
  while(!ccs.available());
  ccs.setTempOffset(tempsensor.readTempC() - 25.0);
  Serial.println("****CCS811: Ready!");

  Serial.println("**Arduino: OK");
    
}

void loop() {
  if(op == 'E'){
    for(int cont=0; cont<10; cont++){
      data[0] = (tempsensor.readTempC() + (data[0] * cont)) / (cont + 1);
      ccs.setEnvironmentalData(50, tempsensor.readTempC());
      if(!ccs.readData()){
        data[1] = (ccs.geteCO2() + (data[1] * cont)) / (cont + 1);
        data[2] = (ccs.getTVOC() + (data[2] * cont)) / (cont + 1);
      }
      else{
        data[1] = (data[1] + (data[1] * cont)) / (cont + 1);
        data[2] = (data[2] + (data[2] * cont)) / (cont + 1);
      } 
      data[3] = (analogRead(_noise) + (data[3] * cont)) / (cont +1 ); 
    }
    delay(100);
  }

  serialread();
  serialwrite();
}

void serialread(){
  if (Serial.available() > 0) {
    op = Serial.read();
  }
}

void serialwrite(){
  switch(op){
    case '0': 
      Serial.println(data[0],4);
      op = 'F';
      break;
    case '1': 
      Serial.println(data[1],4);
      op = 'F';
      break;
     case '2': 
      Serial.println(data[2],4);
      op = 'F';
      break;
     case '3': 
      Serial.println(data[3],4);
      op = 'F';
      break;
     case 'D':
      for(int i=0; i < MAX; i++)
        data[i] = 0;
      //Serial.println("Arduino: delete");
      op = 'E';
      break; 
     case 'E':
      //Serial.println("Arduino: start");
      op = 'F';
      break;  
     case 'F': 
      break;  
  }  
}

