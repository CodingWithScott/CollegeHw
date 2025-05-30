/*	$Id: builtin.c,v 1.7 2014/10/18 22:16:27 felchs Exp $	*/
#include <string.h>
#include <stdio.h> 
#include <stdlib.h>
#include <unistd.h>	// for chdir(2) 

#include "proto.h"

typedef void (*funcptr) (char**, int);

typedef struct {
	char *name;
	void (*funcptr) (char **argv, int argc);
} bi;

/* Local prototypes */
void aecho 		(char **argv, int argc);
void changedir	(char **argv, int argc);
void envset 	(char **argv, int argc);
void envunset 	(char **argv, int argc);
void my_exit 	(char **argv, int argc);

/* Find and execute the appropriate builtin function. */
int exec_builtin(char **argv, int argc) {
	const int NUM_BUILTINS = 5;
	bi the_builtins[NUM_BUILTINS]; 

	/* Big array of functions, will expand with more and more later. */
	the_builtins[0].name = "aecho";
	the_builtins[0].funcptr = aecho;
	the_builtins[1].name = "cd";
	the_builtins[1].funcptr = changedir;
	the_builtins[2].name = "envset";
	the_builtins[2].funcptr = envset;
	the_builtins[3].name = "envunset";
	the_builtins[3].funcptr = envunset;
	the_builtins[4].name = "exit";
	the_builtins[4].funcptr = my_exit;
	
	/* Search for command in the builtins array, return 1 if found 
	 * or 0 to indicate not found. */
	int ix;
	for (ix = 0; ix < NUM_BUILTINS; ix++){
		if (!strcmp(argv[0], the_builtins[ix].name)){
			the_builtins[ix].funcptr(argv, argc);
			return 1;
		}
	}
	return 0;
}

/* Begin builtin helper functions */
void aecho (char **argv, int argc) {
	int ix;
	int print_newline = 1;

	// Don't try to check argv[1] if it doesn't exist
	 if (argc > 1) {
		if (!(strcmp(argv[1], "-n")))
			print_newline = 0;
	}
	else if (argc == 1) {
		dprintf(1, "\n");
		return;
	}

	// Don't print the "-n" flag
	if (print_newline)
		for (ix = 1; ix < argc; ix++) {
			if (ix != (argc - 1)) {
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
		for (ix = 2; ix < argc; ix++) {
			if (ix != (argc - 1)) {
				dprintf(1, "%s", argv[ix]);	
				dprintf(1, " ");
			}
			else {
				dprintf(1, "%s", argv[ix]);
			}
		}
	}	
}

void changedir (char **argv, int argc) {
	if (argc == 1) {
		if (getenv("HOME"))
			chdir(getenv("HOME"));
		else {
			dprintf(2, "cd: Environment variable HOME not set.\n");
			return;
		}
	}
	else if (argc == 2) {
		if (chdir(argv[1]))
			dprintf(2, "cd: %s: No such file or directory\n", argv[1]);
	}
	else 
		dprintf(2, "usage: cd [dir]\n");
}

void envset (char **argv, int argc) {
	if (argc != 3)
		dprintf(2, "usage: envset name value\n");
	else {
		/* setenv(char *name, char *value, int overwrite)   */
		int error_occured = setenv(argv[1], argv[2], 1); 
		
		if (error_occured)
			dprintf(2, "setenv():\terror");
	}
}

void envunset (char **argv, int argc) {
	if (argc != 2)
		dprintf(2, "usage: envunset name\n");
	else {
		// syntax: setenv(char *name)
		int error_occured = unsetenv(argv[1]); 
		
		if (error_occured)
			dprintf(2, "unsetenv():\terror");
	}


}

void my_exit (char **argv, int argc) {
	int exit_code;
	
	if (argc == 1)
		exit_code = 0;
	else if (argc == 2) 
		exit_code = atoi(argv[1]);
	else {
		dprintf(2, "Usage: exit [optional integer]\n");
		return;
	}
	exit(exit_code);
}