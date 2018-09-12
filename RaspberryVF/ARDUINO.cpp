#ifndef _ARDUINO_H
#define _ARDUINO_H
#include <iostream>
#include <wiringPi.h>
#include <wiringSerial.h>
#include <cstring>
#include <cstdlib>
#include "DATABASE.cpp"

class ARDUINO {
	public:
		ARDUINO( void ){
		};
		
		bool begin( void ){
			int len;
			_ser = serialOpen("/dev/ttyACM0",9600);
			if(_ser < 0)
				return false;
			delay(2000);
			
			serialClose(_ser);
			return true;
			
		};
			
		void getData( double data[15] ){
			char aux[MAX];
			int len;
			double teste;
			
			for(int i = 0; i < 15; i++){
				data[i] = 0;
			}
			
			_ser = serialOpen("/dev/ttyACM0",9600);
			
			serialPutchar(_ser, '0');
			delay(10);
			len = serialDataAvail(_ser);			
			for (int i = 0; i < len; i++)
				aux[i] = serialGetchar (_ser);
			delay(10);
			serialFlush (_ser);
			delay(10);
			if (node == 1)
				data[tout] = atof(aux);
			else
				data[tin] = atof(aux);
			empty(aux);
			
			serialPutchar(_ser, '1');
			delay(10);
			len = serialDataAvail(_ser);			
			for (int i = 0; i < len; i++)
				aux[i] = serialGetchar (_ser);
			delay(10);
			serialFlush (_ser);
			delay(10);
			data[co2] = atof(aux);
			empty(aux);
			
			serialPutchar(_ser, '2');
			delay(10);
			len = serialDataAvail(_ser);			
			for (int i = 0; i < len; i++)
				aux[i] = serialGetchar (_ser);
			delay(10);
			serialFlush (_ser);
			delay(10);
			data[voc] = atof(aux);
			empty(aux);
			
			serialPutchar(_ser, '3');
			delay(10);
			len = serialDataAvail(_ser);			
			for (int i = 0; i < len; i++)
				aux[i] = serialGetchar (_ser);
			delay(10);
			serialFlush (_ser);
			delay(10);
			data[noise] = atof(aux);
			empty(aux);
			
			if (node == 3){
				serialPutchar(_ser, '4');
				delay(10);
				len = serialDataAvail(_ser);			
				for (int i = 0; i < len; i++)
					aux[i] = serialGetchar (_ser);
				delay(10);
				serialFlush (_ser);
				delay(10);
				data[full] = atof(aux);
				empty(aux);
				
				serialPutchar(_ser, '5');
				delay(10);
				len = serialDataAvail(_ser);			
				for (int i = 0; i < len; i++)
					aux[i] = serialGetchar (_ser);
				delay(10);
				serialFlush (_ser);
				delay(10);
				data[ir] = atof(aux);
				empty(aux);
				
				serialPutchar(_ser, '6');
				delay(10);
				len = serialDataAvail(_ser);			
				for (int i = 0; i < len; i++)
					aux[i] = serialGetchar (_ser);
				delay(10);
				serialFlush (_ser);
				delay(10);
				data[lux] = atof(aux);
				empty(aux);
			}
			
			else if(node == 1){
				serialPutchar(_ser, 'A');
				delay(10);
				len = serialDataAvail(_ser);			
				for (int i = 0; i < len; i++)
					aux[i] = serialGetchar (_ser);
				delay(10);
				serialFlush (_ser);
				delay(10);
				data[tin] = atof(aux);
				empty(aux);
			}
			
			
			serialPutchar(_ser, 'D');
			delay(100);
			
			serialClose(_ser);
		};
		
		void empty(char * array){
			memset(array, ' ', MAX-1);
			array[MAX] = '\0';
		}
			
	private:
		int _ser;
};

#endif
