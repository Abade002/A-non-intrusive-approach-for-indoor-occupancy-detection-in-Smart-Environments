#ifndef _DATABASE_H
#define _DATABASE_H
#include <mysql/mysql.h>
#include <stdio.h>
#include <string>
#include <iostream>
#include <ctime>
#include <fstream>

#define node 1
#define MAX 15
#define dt 0
#define tin 1
#define tout 2
#define co2 3
#define voc 4
#define noise 5
#define pcfin 6
#define pcfout 7
#define full 8
#define ir 9
#define lux 10
#define nr 14

using namespace std; 

class DATABASE {
	public:
		DATABASE( void ){
			if(node == 1){
				_dbserver = "127.0.0.1";
				_dbpass = "";
			}
			else{
				_dbserver = "10.3.1.130";
				_dbpass = "tfraz1md";
			}

			_dbuser = "root";
			_dbname = "THESISDB";
			_dir = "backup.txt";
		};
		
		bool backup ( string b[] ){
			
			string sql;
			
			const char *dbserver = _dbserver.c_str();
			const char *dbuser = _dbuser.c_str();
			const char *dbpass = _dbpass.c_str();
			const char *dbname = _dbname.c_str();

			// Init MySQL.
			_con = mysql_init(NULL);
			
			cout <<"\n" << actual_time(0) << "\n";
			cout << ">DATABASE: \n";
			// Try to open the database.
			if (mysql_real_connect(_con, dbserver, dbuser, dbpass, 
				  dbname, 0, NULL, 0) == NULL){
					fprintf(stderr, ">>FAILURE: %s\n", mysql_error(_con));
					mysql_close(_con);
			}  
			
			else{
				
				cout << ">>SUCESS: Open and ready to update!\n";
				
				if(node == 1)
					sql = "INSERT INTO node1 VALUES('" + b[dt] + "', " + b[tin] + ", " + b[tout] + ", " + b[co2] + ", " + b[voc] + ", " + b[noise] + ", " + b[pcfin] + ", " + b[pcfout] + ", " + b[nr] + ", 0);";
				else if(node == 2)
					sql = "INSERT INTO node2 VALUES('" + b[dt] + "', " + b[tin] + ", " + b[co2] + ", "
						+ b[voc] + ", " + b[noise] + ");";
				else if(node == 3)
					sql = "INSERT INTO node3 VALUES('" + b[dt] + "', " + b[tin] + ", " + b[co2] + ", "
						+ b[voc] + ", " + b[noise] + ", " + b[full] + ", " + b[ir] + ", " + b[lux] + ");";
				
				if (mysql_query(_con, sql.c_str())) {
					fprintf(stderr, ">>FAILURE: %s\n", mysql_error(_con));
				}
				
				else{
					cout << ">>UPDATED: " << sql << endl;
				}

				printf(">>CLOSE: Database closed sucessfully!\n");
				mysql_close(_con);
			}	
		};
		
		char * actual_time( int op ){

			time_t curtime;
			struct tm *loctime;
			static char buff[50];
			
			// Get the current time.
			curtime = time (NULL);

			// Convert it to local time representation.
			loctime = localtime (&curtime);

			if(op == 0)
				strftime(buff,50,"%F %T",loctime);
			
			else if(op == 1)
				strftime(buff,50,"%M",loctime);
			
			else if(op == 2)
				strftime(buff,50,"%S",loctime);
			
			return buff;
		};
		
		void file( string *b ){
			
			printf("\n%s\n", this->actual_time(0));
			
			const char *dir = _dir.c_str();
			
			ofstream file ("backup.txt", ios::app);
			
			if (file.is_open())
			{
				if(node == 1)
					file << "\n" << b[dt] << " " << b[tin] << " " << b[tout] << " " << b[co2] << " " <<  b[voc] << " " << 
						b[noise] << " " <<  b[pcfin] << " " <<  b[pcfout] << " " << b[nr];
				else if (node == 2)
					file << "\n" << b[dt] << " " << b[tin] << " " << b[co2] << " " <<  b[voc] << " " << b[noise];
				else if (node == 3)
					file << "\n" << b[dt] << " " << b[tin] << " " << b[co2] << " " <<  b[voc] << " " << b[noise]
						<< " " <<  b[full] << " " <<  b[ir] << " " <<  b[lux];
				file.close();
							
				std::cout << ">FILE: The file " << dir << " was updated! " << std::endl;
				std::cout << ">>DATETIME: " << b[dt] << std::endl;
				std::cout << ">>TEMPERATUREIN: " << b[tin] << std::endl;
				if(node == 1){
					std::cout << ">>TEMPERATUREOUT: " << b[tout] << std::endl;
					std::cout << ">>PCFIN: " << b[pcfin] << std::endl;
					std::cout << ">>PCFOUT: " << b[pcfout] << std::endl;
				}
				std::cout << ">>CO2OUT: " << b[co2] << std::endl;
				std::cout << ">>VOCOUT: " << b[voc] << std::endl;
				std::cout << ">>NOISE: " << b[noise] << std::endl;
				if(node == 3){
					std::cout << ">>FULL: " << b[full] << std::endl;
					std::cout << ">>IR: " << b[ir] << std::endl;
					std::cout << ">>LUX: " << b[lux] << std::endl;
				}
				if(node == 1)
					std::cout << ">>NUMROOM: " << b[nr] << std::endl;
			
			}
			else std::cout << ">FILE: Failure :( !" << std::endl;

		};
		
		bool save(){

			static bool saving = false;
				
			if (atoi(this->actual_time(2)) == 0){
				if(saving == false){
					saving = true;
					return true;
				}
			}
			
			else 
				saving = false;
					
			return false;	
		};
		
		bool load(){

			static bool measuring = false;	
				
			if ((atoi(this->actual_time(2)) % 10) == 0 || (atoi(this->actual_time(2)) == 0)){
				if(measuring == false){
					measuring = true;
					return true;
				}
			}
				
			else 
				measuring = false;
					
			return false;	
		};

	private:
		MYSQL *_con;
		string _dbserver;
		string _dbuser;
		string _dbpass;
		string _dbname;
		string _dir;
  
};

#endif

