#include <string.h>
#include <stdio.h> 
#include <stdlib.h>

#include "proto.h"

typedef void (*funcptr) (char**, int);

typedef struct {
	char *name;
	void (*funcptr) (char **argv, int num_args);
} bi;

void aecho (char **argv, int num_args);
void my_exit (char **argv, int num_args);

/* Find and execute the appropriate builtin function. */
int exec_builtin(char **argv, int num_args) {
	const int NUM_BUILTINS = 2;
	bi the_builtins[NUM_BUILTINS]; 

	/* Big array of functions, will expand with more and more later. */
	the_builtins[0].name = "aecho";
	the_builtins[0].funcptr = aecho;
	the_builtins[1].name = "exit";
	the_builtins[1].funcptr = my_exit;
	
	/* Search for command in the builtins array, return 1 if found 
	 * or 0 to indicate not found. */
	int ix;
	for (ix = 0; ix < NUM_BUILTINS; ix++){
		// printf("Checking ix = %d\n", ix);
		// printf("argv[0]:\t%s\n", argv[0]);
		if (!strcmp(argv[0], the_builtins[ix].name)){
			the_builtins[ix].funcptr(argv, num_args);
			return 1;
		}
	}
	return 0;
}

void aecho (char **argv, int num_args) {
	int ix;
	int print_newline = 1;

	// Don't try to check argv[1] if it doesn't exist
	 if (num_args > 1) {
		if (!(strcmp(argv[1], "-n")))
			print_newline = 0;
	}
	else if (num_args == 1) {
		dprintf(1, "\n");
		return;
	}



	// Don't print the "-n" flag
	if (print_newline)
		for (ix = 1; ix < num_args; ix++) {
			if (ix != (num_args - 1)) {
				dprintf(1, "%s", argv[ix]);	
				dprintf(1, " ");
			}
			else {
				dprintf(1, "%s", argv[ix]);
				if (print_newline) 
				dprintf(1, "\n");		
			}
		}
	else {
		for (ix = 2; ix < num_args; ix++) {
			if (ix != (num_args - 1)) {
				dprintf(1, "%s", argv[ix]);	
				dprintf(1, " ");
			}
			else {
				dprintf(1, "%s", argv[ix]);
			}
		}
	}	
}

void my_exit (char **argv, int num_args) {
	int exit_code;
	
	if (num_args == 1)
		exit_code = 0;
	else if (num_args == 2) 
		exit_code = atoi(argv[1]);
	else {
		printf("Usage: exit [optional integer]\n");
		return;
	}
	exit(exit_code);
}