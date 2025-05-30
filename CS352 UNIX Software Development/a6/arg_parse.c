/*	$Id: arg_parse.c,v 1.12 2014/12/02 04:05:55 felchs Exp $	*/
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#include "proto.h"

/* 1st loop counts num of args, 2nd loop adds null chars 
   and assigns pointers in argv */
int arg_parse(char *line, char ***argvp) {
	int num_args = 0;
	int num_quotes = 0;
	int curr_arg_num = 0;
	int len = strlen(line);

	/* FSM states */
	enum state_type {
		START,
		NOT_IN_QUOTE_IN_WORD,
		NOT_IN_QUOTE_NOT_IN_WORD,
		IN_QUOTE_NOT_IN_WORD,
		IN_QUOTE_IN_WORD
	};
	enum state_type state = START;	

	// printf("arg_parse received line:\t|%s|\n", line);

	/* Loop 1/2: Count the number of args. Double quotes can be used to 
	 * 			 string together multiple words into a single arg. */
	int ix = 0;
	for (ix = 0; ix < len; ix++) {
		if (state == START) {
			if (line[ix] == ' ') { /* eat whitespace */ }
			else if (line[ix] == '"') {
				num_quotes++;
				num_args++;
				state = IN_QUOTE_NOT_IN_WORD;
			}
			else { /* any char besides whitespace or quotes */
				num_args++;
				state = NOT_IN_QUOTE_IN_WORD;
			}
		}
		else if (state == NOT_IN_QUOTE_IN_WORD) {
			if (line[ix] == ' ') 
				state = NOT_IN_QUOTE_NOT_IN_WORD;				
			else if (line[ix] == '"') {
				num_quotes++;
				state = IN_QUOTE_IN_WORD;
			}
			else { /* eat up any other chars */ }
		}
		else if (state == NOT_IN_QUOTE_NOT_IN_WORD) {
			if (line[ix] == ' ') { /* eat whitespace */ }
			else if (line[ix] == '"') {
				num_quotes++;
				num_args++;
				state = IN_QUOTE_NOT_IN_WORD;
			}
			else /* any other char */  {
				num_args++;
				state = NOT_IN_QUOTE_IN_WORD;
			}
		}
		else if (state == IN_QUOTE_NOT_IN_WORD) {
			if (line[ix] == ' ') { /* eat whitespace */ }
			else if (line[ix] == '"'){	// two consecutive quotes, go to start
				num_quotes++;
				state = START;
			}
			else /* any other char */
				state = IN_QUOTE_IN_WORD;
		}
		else if (state == IN_QUOTE_IN_WORD) {
			if (line[ix] == '"') {
				num_quotes++;
				state = NOT_IN_QUOTE_IN_WORD;
			}
			else  { /* eat whitespace or chars */  }
		}
	}

	if ((num_quotes % 2) == 1) {
		fprintf(stderr, "ERROR: Can't have odd number of quotes\n");
		return -1;
	}

	/* Clear prev contents of memory, seems to fix an issue when running
	 * many lines of input in a row. 
	 * Malloced memory for argv includes an additional byte for null sentinel.
	 */
	char **argv = (char**) calloc((num_args + 1), sizeof(char*));	
	if (!argv) {
		fprintf(stderr, "%s\n", "arg_parse:  calloc fatal error, aborting\n");
		return -1;
	}
	*argvp = argv;

	curr_arg_num = 0;
	state = START;

	/* Loop 2/2: Assign pointer to start of each arg and null character to 
	 * 		     end of each individual arg.
	 * Strategy: Assign pointer anytime num_args++ would occur. 
	 *			 Assign 0 anytime transition to state 2 occurs. */
	for (ix = 0; ix < len; ix++) {
		if (state == START) {
			if (line[ix] == ' ') { /* eat whitespace */ }
			else if (line[ix] == '"') {
				argv[curr_arg_num] = &line[ix];
				curr_arg_num++;
				state = IN_QUOTE_NOT_IN_WORD;
			}
			else { /* any char besides whitespace or quotes */
				argv[curr_arg_num] = &line[ix];
				curr_arg_num++;
				state = NOT_IN_QUOTE_IN_WORD;
			}
		}
		else if (state == NOT_IN_QUOTE_IN_WORD) {
			if (line[ix] == ' ') {
				line[ix] = 0;
				state = NOT_IN_QUOTE_NOT_IN_WORD;				
			}
			else if (line[ix] == '"') {
				state = IN_QUOTE_IN_WORD;
			}
			else { /* eat up any other chars */ }
		}
		else if (state == NOT_IN_QUOTE_NOT_IN_WORD) {
			if (line[ix] == ' ') { /* eat whitespace */ }
			else if (line[ix] == '"') {
				argv[curr_arg_num] = &line[ix];
				curr_arg_num++;
				state = IN_QUOTE_NOT_IN_WORD;
			}
			else /* any other char */  {
				argv[curr_arg_num] = &line[ix];
				curr_arg_num++;
				state = NOT_IN_QUOTE_IN_WORD;
			}
		}
		else if (state == IN_QUOTE_NOT_IN_WORD) {
			if (line[ix] == ' ') { /* eat whitespace */ }

			else if (line[ix] == '"'){	
				ix++;
				line[ix] = 0;	
				state = NOT_IN_QUOTE_NOT_IN_WORD;
			}
			else /* any other char */
				state = IN_QUOTE_IN_WORD;
		}
		else if (state == IN_QUOTE_IN_WORD) {
			if (line[ix] == '"')
				state = NOT_IN_QUOTE_IN_WORD;
			else  { /* eat whitespace or chars */  }
		}
	}

	// Is this there a more efficient implementation of this?
	int arg_ix, read_ix;
	int write_ix = 0;
	for (arg_ix = 0; arg_ix < num_args; arg_ix++) {
		len = strlen(argv[arg_ix]);
		// Increment read index always, only increment write index on non-quote
		for (read_ix = 0; read_ix < len; read_ix++) {
			if (argv[arg_ix][read_ix] != '"') {
				argv[arg_ix][write_ix] = argv[arg_ix][read_ix];
				write_ix++;
			}
		}
		argv[arg_ix][write_ix] = 0;
		write_ix = 0;
	}

	// for(arg_ix = 0; arg_ix < num_args; arg_ix++) 
	// 	printf("argv[%d]:\t|%s|\n", arg_ix, argv[arg_ix]);

	return num_args;
}
