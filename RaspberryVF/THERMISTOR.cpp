#ifndef _THERMISTOR_H
#define _THERMISTOR_H

#include <wiringPiI2C.h>
#include <wiringPi.h>
#include <cstdint>
#include <cmath>
#include <iostream>

class THERMISTOR {
	public:
		THERMISTOR( void ){
			_addr = 0x48;
			_r1 = 10000;
			_vin = 3.034;
			_adcr = 255;
			_bcoef = 3977;
			_tempNominal = 25;
			_thermistorNominal = 10000;	
		};
		
		bool begin( void ){
			if((_fd = wiringPiI2CSetup(_addr)) < 0)
				return false;
			
			return true;
			
		};
		
		double getTemperature( int ch ){
			int adcVal;
			double vout, r2;
			double temp;
			
			// Mean value = (old_value * num_samples + new_value) / (num_samples+1)
			for(int i = 0; i < 10; i++){ // 10 samples -> 100ms
				wiringPiI2CReadReg8(_fd, _addr + ch); 
				adcVal = (wiringPiI2CReadReg8(_fd, _addr + ch) + (adcVal * i)) / (i + 1);
				delay(10);
			}
		
			
			vout = ((double)adcVal/(double)_adcr)*_vin;
			r2 = _r1 * (vout/(_vin-vout));
			
			//Beta Factor
			temp = log(r2/_thermistorNominal)/_bcoef;
			temp += 1/(_tempNominal + 273.15);
			temp = 1/temp;
			temp = temp - 273.15;
			
			return temp;	
		}
		
	private:
		uint8_t _addr;
		uint8_t _ch;
		int _fd;
		double _r1;
		double _vin;
		double _adcr;
		double _a, _b, _c;
		double _bcoef;
		double _tempNominal;
		double _thermistorNominal;
};

#endif