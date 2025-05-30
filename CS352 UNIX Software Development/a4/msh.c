/*	$Id: msh.c,v 1.19 2014/11/04 03:48:37 felchs Exp $	*/
/* CS 352 -- Mini Shell!  
 *   Scotty Felch
 *   Fall 2014
 *   Assignment 4
 * 
 *   Original source:
 *   Sept 21, 2000,  Phil Nelson
 *   Modified April 8, 2001 
 *   Modified January 6, 2003
 *
 */

#include <ctype.h>		/* used for isdigit(3) */
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#include "globals.h"	/* shared data between files */
#include "proto.h"		/* shared function prototypes */

/* Constants */ 
#define LINELEN 1024

/* Accessing globals */
int    interactive_mode;
int    last_exit_value;	
int    m_argc;			/* Number of arguments passed into msh */
char **m_argv;			/* Arguments passed into msh */

/* Shell main */
int main (int terminal_argc, char **terminal_argv) {
	char buffer [LINELEN];
	interactive_mode = 1;
	FILE* input_stream = stdin;
	m_argc = terminal_argc;		/* Store # of terminal args in globals.h */
	m_argv = terminal_argv;		/* Store terminal args in globals.h */


	if (m_argc > 1) {
		/* Open input file specified in 2nd arg, read only mode.
		 * Error in opening returns NULL and sets errno. */
		if (!(input_stream = fopen(m_argv[1], "r"))) {
			fprintf(stderr, "Invalid input script specified, aborting\n");
			exit(127);
		}
		else
			interactive_mode = 0;
	}

	while (1) {
		/* prompt and get line */
		if (interactive_mode) fprintf (stderr, "%% ");
		if (fgets (buffer, LINELEN, input_stream) != buffer)
			break;

		/* Get rid of \n at end of buffer. */
		int len = strlen(buffer);
		if (buffer[len-1] == '\n')
			buffer[len-1] = 0;

		/* Run it ... */
		processline (buffer);
	}

	if (!feof(input_stream))
		perror ("read");

	fclose(input_stream);	/* Clean the kitchen */
	return 0;				/* Burn the house down */
}


void processline (char *line) {
	char **argv; 			/* Array of strings populated by arg_parse() */
	char expline [LINELEN];	/* String to be populated with expanded variables */
	int num_args;
	int	status;
	int was_builtin = 0;
	pid_t  cpid;

	int expand_failed = expand(line, expline, LINELEN);
	if (expand_failed) 
		return;

	num_args = arg_parse(expline, &argv);
	if (num_args <= 0)
		return;

	/* Execute builtin if possible, otherwise fork off */ 
	was_builtin = exec_builtin(argv, num_args);
	if (was_builtin) 
		free(argv);
	else {
		/* Start a new process to do the job. */
		cpid = fork();
		if (cpid < 0) {
			perror ("fork");
			return;
		}
		
		/* Check for who we are! */
		if (cpid == 0) {
			/* We are the child! */
			execvp(argv[0], argv);
			perror ("exec");
			exit (127);
		}
		
		free(argv);

		/* Have the parent wait for child to complete */
		if (wait (&status) < 0){
		  perror ("wait");
		}
		// last_exit_val = WEXITSTATUS(status);

		if (WIFEXITED(status))
			last_exit_val = WEXITSTATUS(status);
		else
			last_exit_val = 127;
	}
}
