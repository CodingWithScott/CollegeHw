/*	$Id: msh.c,v 1.26 2014/11/16 00:12:27 felchs Exp $	*/
/* CS 352 -- Mini Shell!  
 *   Scotty Felch
 *   Fall 2014
 *   Assignment 5
 * 
 *   Original source:
 *   Sept 21, 2000,  Phil Nelson
 *   Modified April 8, 2001 
 *   Modified January 6, 2003
 *
 */

#include <ctype.h>		/* used for isdigit(3) */
#include <errno.h>
#include <signal.h>		/* used for sig_atomic_t data type */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#include "globals.h"	/* shared data between files */
#include "proto.h"		/* shared function prototypes */

/* Constants */ 
#define LINELEN 200000
#define DONTWAIT 0
#define WAIT 1
#define STDOUT 1

/* Accessing globals */
int    interactive_mode;
int    last_exit_value;	
int    m_argc;			/* Number of arguments passed into msh */
char **m_argv;			/* Arguments passed into msh */
__sig_atomic_t sigint_occurred;

/* Local prototypes */ 
void catch_signal (int sig);

/* Debug control */
int msh_debug = 0;

/* Shell main */
int main (int terminal_argc, char **terminal_argv) {
	char buffer [LINELEN] = "";
	char prompt [LINELEN] = "";	
	interactive_mode = 1;
	FILE* input_stream = stdin;
	m_argc = terminal_argc;		/* Store # of terminal args in globals.h */
	m_argv = terminal_argv;		/* Store terminal args in globals.h */
	sigint_occurred = 0;

	/* User prompt is gathered from env variable, defaults to "% " otherwise */
	if (getenv("P1"))
		strcat(prompt, getenv("P1"));
	else
		strcat(prompt, "%");

	/* Assign script input, if applicable. */
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

	/* Establish signal handler for SIGINT signals. */
	signal(SIGINT, catch_signal);

	while(!sigint_occurred) {
		/* prompt and get line */
		if (interactive_mode) fprintf (stderr, "%s ", prompt);
		if (fgets (buffer, LINELEN, input_stream) != buffer)
			break;

		/* Get rid of \n at end of buffer. */
		int len = strlen(buffer);
		if (buffer[len-1] == '\n')
			buffer[len-1] = 0;

		/* Detect comment sentinal char and replace with null */
		int in_quote = 0;			/* In quotes = disregard comment # */
		int ix;
		for (ix = 0; ix < len; ix++) {
			if (buffer[ix] == '\"') 
				in_quote = !in_quote;
			if (!in_quote && buffer[ix] == '#' && buffer[ix-1] != '$' ) {
				buffer[ix] = 0;
				break;
			}
		}

		/* Run it ... */
		// int child_pid = processline (buffer, STDOUT, WAIT);
		(void) processline (buffer, STDOUT, WAIT);
		// printf("msh: child_pid == %d\n", child_pid);
	}

	if (!feof(input_stream))
		perror ("read");

	fclose(input_stream);	/* Clean the kitchen */
	return 0;				/* Burn the house down */
}

/* Return values:			
	-1 == error
	 0 == successful completion of builtin or syscall
	>0 == pid of child on which to wait */
int processline (char *line, int outfd, int should_wait) {
	char **argv; 			/* Array of strings populated by arg_parse() */
	char expline [LINELEN];	/* String to be populated with expanded variables */
	int num_args;
	int	status;				/* Holds return value of wait(3) */
	int was_builtin = 0;
	pid_t  cpid;

	int expand_failed = expand(line, expline, LINELEN);
	if (expand_failed) 
		return -1;

	if (msh_debug) printf("processline expanded, expline:\t|%s|\n", expline);
	/* Get rid of \n at end of buffer. */
	int len = strlen(expline);
	if (expline[len-1] == '\n')
		expline[len-1] = 0;
	if (msh_debug) printf("processline expanded, expline:\t|%s|\n", expline);



	num_args = arg_parse(expline, &argv);
	if (num_args <= 0)
		return 0;

	/* Execute builtin if possible, otherwise fork off */ 
	was_builtin = exec_builtin(argv, num_args, STDOUT);

	if (was_builtin) {
		free(argv);
		return 0;
	}
	else {
		/* Start a new process to do the job. */
		cpid = fork();
		if (cpid < 0) {
			perror ("fork");
			return -1;
		}
		
		/* Check for who we are! */
		if (cpid == 0) {
			/* We are the child! */
			/* redirect STDOUT to point to write end of pipe 
			 * goes away when child dies */
			if (outfd != STDOUT) {
				dup2(outfd, 1);
				close(outfd);
			}

			execvp(argv[0], argv);
			perror ("exec");
			exit (127);
		}
		
		free(argv);

		/* Either wait on child or return child pid */
		if (should_wait) {
			/* Have the parent wait for child to complete */
			if (wait(&status) < 0){
			  perror ("wait");
			  return -1;
			}

			if (WIFEXITED(status))
				last_exit_val = WEXITSTATUS(status);
			else
				last_exit_val = 127;
		}
		else
			return cpid;
	}

	return 0;
}

void catch_signal (int sig) {
	sigint_occurred = 1;
	signal(sig, catch_signal);
}