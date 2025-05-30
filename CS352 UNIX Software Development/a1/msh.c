/* CS 352 -- Mini Shell!  
 *   Scotty Felch
 *   Fall 2014
 *   Assignment 1
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

/* Constants */ 
#define LINELEN 1024

/* Prototypes */
void processline (char *line);
char **arg_parse(char *line);

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
	pid_t  cpid;
	int	status;
	
	/* Start a new process to do the job. */
	cpid = fork();
	if (cpid < 0) {
		perror ("fork");
		return;
	}
	
	/* Check for who we are! */
	if (cpid == 0) {
		/* We are the child! */
		argv = arg_parse(line);
		execvp(argv[0], argv);
		free(argv);

		perror ("exec");
		exit (127);
	}
	
	/* Have the parent wait for child to complete */
	if (wait (&status) < 0)
	  perror ("wait");
}
/* 1st loop counts num of args, 2nd loop adds null chars 
   and assigns pointers in argv */
char **arg_parse(char *line) {
	int num_args = 0;
	int curr_arg_num = 0;
	int line_length = strlen(line);
	int state = 0;	
	/* FSM notes:
		State 0 = starting state
		state 1 = in word
		state 2 = not in word
	*/

	/* Loop 1 of 2: Count the number of args */
	int ix = 0;
	for (ix = 0; ix < line_length; ix++) {
		if (state == 0) {
			if (!(line[ix] == ' ')) {
				state = 1;
				num_args++;
			}
			else if (line[ix] == ' ')
				state = 2;
		}
		else if (state == 1) {
			if (!(line[ix] == ' ')) { /* do nothing, just keep reading */ }
			else if (line[ix] == ' ') 
				state = 2;
		}
		else if (state == 2) {
			if (!(line[ix] == ' ')) {
				state = 1;
				num_args++;
			}
			else if (line[ix] == ' ') { /* do nothing, just keep reading */ }
		}
	}

	/* Loop 2 of 2: Assign null character to end of each individual arg.
	 * Identical to previous except addition of behavior in transition from
	 * state 1 to 2. */
	char **argv = (char**) malloc(sizeof(char*) * num_args + 1);	

	state = 0;
	ix = 0;
	for (ix = 0; ix < line_length; ix++) {
		if (state == 0) {
			if (!(line[ix] == ' ')) {
				argv[curr_arg_num] = &line[ix];
				state = 1;
				curr_arg_num++;
			}
			else if (line[ix] == ' ')
				state = 2;
		}
		else if (state == 1) {
			if (!(line[ix] == ' ')) { /* just keep reading chars */ }
			else if (line[ix] == ' '){ 
				line[ix] = 0;
				state = 2;
			}
		}
		else if (state == 2) {
			if (!(line[ix] == ' ')) {
				state = 1;
				argv[curr_arg_num] = &line[ix];
				curr_arg_num++;
			}
			else if (line[ix] == ' ') { /* just keep reading whitespace */ }
		}
	}

	return argv;
}