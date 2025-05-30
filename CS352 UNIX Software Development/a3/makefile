#	$Id: makefile,v 1.2 2014/10/20 20:15:04 felchs Exp $
# Tutorial:     http://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/
CC=clang
CFLAGS=-g -Wall
DEPS = proto.h
OBJ = arg_parse.o builtin.o expand.o msh.o 

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

msh: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

clean:
	rm -rf $(OBJ) msh

easteregg:
	@echo "Scotty is so cool!!"