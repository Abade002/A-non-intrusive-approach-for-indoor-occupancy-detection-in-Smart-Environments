#include "BUTTON.cpp"
#include "THERMISTOR.cpp"
#include "DATABASE.cpp"
#include "ARDUINO.cpp"

#include <iostream>
#include <cmath>
#include <wiringPi.h>

using namespace std;

int main(){
	
	string data[MAX];
	// Test GPIO setup
	if(wiringPiSetup() < 0){
	cout << "ERROR: wiringPiSetup()" <<endl;
		return -1;
	}
		
	cout << "\n" << endl;
	cout << "*Start" << endl;
	
	//INIT ARDUINO
	ARDUINO arduino;
	if(arduino.begin())
		cout << "**ARDUINO: SUCCESS :) !" << endl;
	else{
		cout << "**ARDUINO: INSUCCESS :( !" << endl;
		return -1;
	}
	
	//INIT THERMISTOR
	THERMISTOR pcf;
	if(node == 1){
		if(pcf.begin())
			cout << "**THERMISTOR: SUCCESS :) !" << endl;
		else{
			cout << "**THERMISTOR: INSUCCESS :( !" << endl;
			return -1;
		}
	}
	
	//INIT BUTTON
	BUTTON button;
	if(node == 1){
		if(button.begin())
			cout << "**BUTTON: SUCCESS :) !" << endl;
		else{
			cout << "**BUTTON: INSUCCESS :( !" << endl;
			return -1;
		}
	}
	
	//INIT DATABASE
	DATABASE db;
	
	int cont = 0;
	double dataAux[MAX];
	for (int i = 0; i < MAX; i++)
		dataAux[i] = 0;
	bool ok = false;
	
	cout << "***Wait a few minutes!" << endl;
	
	while(1){
		
		if(node == 1)
			button.update();
		
		if(db.load()){
			double datar[15];
			arduino.getData(datar); 
			// Mean value = (old_value * num_samples + new_value) / (num_samples+1)
			dataAux[tin] = (datar[tin] + (dataAux[tin] * cont)) / (cont + 1);
			if(node == 1)
				dataAux[tout] = (datar[tout] + (dataAux[tout] * cont)) / (cont + 1);	
			dataAux[co2] = (datar[co2] + (dataAux[co2] * cont)) / (cont + 1);
			dataAux[voc] = (datar[voc] + (dataAux[voc] * cont)) / (cont + 1);
			dataAux[noise] = (20*log10(datar[noise]) + (dataAux[noise] * cont)) / (cont + 1);
			
			if(node == 1){
				dataAux[pcfin] = (pcf.getTemperature(2) + (dataAux[pcfin] * cont)) / (cont + 1);
				dataAux[pcfout] = (pcf.getTemperature(1) + (dataAux[pcfout] * cont)) / (cont + 1);
				dataAux[nr] = (button.getNumRoom() + (dataAux[nr] * cont)) / (cont + 1);
			}
			if(node == 3){
				dataAux[full] = (datar[full] + (dataAux[full] * cont)) / (cont + 1);
				dataAux[ir] = (datar[ir] + (dataAux[ir] * cont)) / (cont + 1);
				dataAux[lux] = (datar[lux] + (dataAux[lux] * cont)) / (cont + 1);
			}
						
			cont ++;
		}
		
		if(db.save()){
			data[dt] = db.actual_time(0);
			if(node == 1)
				dataAux[nr] = round(dataAux[nr]);
			for (int i = 1; i < MAX; i++)
				data[i] = to_string(dataAux[i]);
			db.backup(data);
			db.file(data);
			cont = 0;
			for (int i = 0; i < MAX; i++)
				dataAux[i] = 0;
		}	
	}
			
	return 0;
}