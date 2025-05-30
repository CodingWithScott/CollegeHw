#	$Id: makefile,v 1.10 2014/12/05 04:18:58 felchs Exp $
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

superclean:
	rm  !arg_parse.c|builtin.c|expand.c|globals.h|makefile|msh.c|proto.h

easteregg:
	@echo "Scotty is so cool!!"
