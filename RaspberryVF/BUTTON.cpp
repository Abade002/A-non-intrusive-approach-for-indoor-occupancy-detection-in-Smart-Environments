#ifndef _BUTTON_H
#define _BUTTON_H
#include <wiringPi.h> 
#include <iostream>


class BUTTON {
	public:
		BUTTON( void ){
			_pini = 4;
			_pino = 5;
			_led1 = 3;
			_led2 = 2;
			_led3 = 0;
			_numroom = 0;
		};
		
		bool begin(){
			pinMode(_pini, INPUT);
			pinMode(_pino, INPUT);
			pinMode(_led1, OUTPUT);
			pinMode(_led2, OUTPUT); 
			pinMode(_led3, OUTPUT);
			return true;
		};
		
		void update( void ){
			static int stateIn, stateOut;
			static int lstateIn = LOW, lstateOut = LOW;
			
			static unsigned int lastDebounceTime = 0;  
			static unsigned int debounceDelay = 10;  
			static int readingIn, readingOut;

			readingIn = digitalRead(_pini);
			readingOut = digitalRead(_pino);
			
			if(readingIn != lstateIn){
				lastDebounceTime = millis();
			}
			
			if(readingOut != lstateOut){
				lastDebounceTime = millis();
			}
			
			if ((millis() -  lastDebounceTime) > debounceDelay) {
				if(readingIn != stateIn){
					stateIn = readingIn;
					
					if(stateIn == HIGH && _numroom < 7)
						_numroom++;
				}
				
				if(readingOut != stateOut){
					stateOut = readingOut;	
					
					if(stateOut == HIGH && _numroom > 0)
						_numroom--;
				}

			}

			lstateIn = readingIn;
			lstateOut = readingOut;
			
			switch (_numroom){
				case 0:
				  digitalWrite(_led1, LOW);
				  digitalWrite(_led2, LOW);
				  digitalWrite(_led3, LOW);
				  break;
				case 1:
				  digitalWrite(_led1, HIGH);
				  digitalWrite(_led2, LOW);
				  digitalWrite(_led3, LOW);
				  break;
				case 2:
				  digitalWrite(_led1, LOW);
				  digitalWrite(_led2, HIGH);
				  digitalWrite(_led3, LOW);
				  break;
				case 3:
				  digitalWrite(_led1, HIGH);
				  digitalWrite(_led2, HIGH);
				  digitalWrite(_led3, LOW);
				  break;
				case 4:
				  digitalWrite(_led1, LOW);
				  digitalWrite(_led2, LOW);
				  digitalWrite(_led3, HIGH);
				  break;
				case 5:
				  digitalWrite(_led1, HIGH);
				  digitalWrite(_led2, LOW);
				  digitalWrite(_led3, HIGH);
				  break;
				case 6:
				  digitalWrite(_led1, LOW);
				  digitalWrite(_led2, HIGH);
				  digitalWrite(_led3, HIGH);
				  break;
				case 7:
				  digitalWrite(_led1, HIGH);
				  digitalWrite(_led2, HIGH);
				  digitalWrite(_led3, HIGH);
				  break;
		  }		
		};
		
		int getNumRoom( void ){
			return _numroom;
		}

	private:
		int _pini;
		int _pino;
		int _led1;
		int _led2;
		int _led3;
		int _numroom; 
};

#endif