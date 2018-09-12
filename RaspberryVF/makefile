CC = g++
CFLAGS = -Wall -g
INCLUDES = -I.
LFLAGS =
SRCS = BUTTON.cpp THERMISTOR.cpp DATABASE.cpp ARDUINO.cpp main.cpp
DEPS =
OBJS = $(SRCS:.cpp=.o)
LIBS = -lwiringPi -lmysqlclient -lm -std=c++11
MAIN = main

.PHONY: depend clean

all:	$(MAIN)
	@echo  Simple compiler named mycc has been compiled

$(MAIN): $(OBJS) 
	$(CC) $(CFLAGS) $(INCLUDES) -o $(MAIN) $(OBJS) $(LFLAGS) $(LIBS)
	
.c.o:
	$(CC) $(CFLAGS) $(INCLUDES) -c $<  -o $@

clean:
	$(RM) *.o *~ $(MAIN)

depend: $(SRCS)
	makedepend $(INCLUDES) $^
	
remove:
	rm -f backup.txt
	
play:
	clear
	sudo ./main
