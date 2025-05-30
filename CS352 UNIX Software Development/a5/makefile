#	$Id: makefile,v 1.8 2014/10/22 12:09:39 felchs Exp $
# Tutorial:     http://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/
CC=clang
CFLAGS=-g -Wall
DEPS = globals.h proto.h
OBJ = arg_parse.o builtin.o expand.o msh.o 

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

msh: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

clean:
	rm -rf $(OBJ) msh

easteregg:
	@echo "Scotty is so cool!!"