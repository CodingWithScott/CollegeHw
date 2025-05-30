/* CS 352 -- Mini Shell!  
 *   Scotty Felch
 *   Fall 2014
 *   Assignment 2
 * 
 *   Original source:
 *   Sept 21, 2000,  Phil Nelson
 *   Modified April 8, 2001 
 *   Modified January 6, 2003
 *
 */

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>

#include "proto.h"

/* Constants */ 
#define LINELEN 1024

/* Shell main */
int main (void)
{
	char buffer [LINELEN];
	int	len;

	while (1) {
		/* prompt and get line */
		fprintf (stderr, "%% ");
		if (fgets (buffer, LINELEN, stdin) != buffer)
			break;

		/* Get rid of \n at end of buffer. */
		len = strlen(buffer);
		if (buffer[len-1] == '\n')
			buffer[len-1] = 0;

		/* Run it ... */
		processline (buffer);
	}

	if (!feof(stdin))
		perror ("read");

	return 0;		/* Also known as exit (0); */
}


void processline (char *line)
{
	char **argv; // Array of strings populated by arg_parse()
	int num_args;
	int	status;
	int was_builtin = 0;
	pid_t  cpid;
		
	num_args = arg_parse(line, &argv);
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
			free(argv);
			perror ("exec");
			exit (127);
		}
		
		/* Have the parent wait for child to complete */
		if (wait (&status) < 0)
		  perror ("wait");
	}
}