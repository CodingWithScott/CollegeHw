/*	$Id: expand.c,v 1.22 2014/11/04 03:48:37 felchs Exp $	*/
#include <ctype.h>		/* needed to define isdigit(3) */
#include <dirent.h>		/* needed to define readdir(3) */
#include <string.h>
#include <stdio.h> 
#include <stdlib.h>		
#include <sys/types.h>	/* needed to define size_t, pid_t, etc */
#include <unistd.h> 	/* needed to define getcwd(3), getpid(2) */

#include "globals.h"	/* shared data between files */
#include "proto.h"		/* shared function prototypes */
#define LINELEN 1024

#define _GNU_SOURCE		/* needed to prototype get_curren_dir_name(void) */

/* Local prototypes */
int ends_with	 (char *str,  char *suffix);
int exp_curly  	 (char *line, char *expline, int *r_ix, int *w_ix);
int exp_digit  	 (char *line, char *expline, int *r_ix, int *w_ix);
int exp_dollar 	 (char *line, char *expline, int *r_ix, int *w_ix);
int exp_question (char *line, char *expline, int *r_ix, int *w_ix);
int exp_pound    (char *line, char *expline, int *r_ix, int *w_ix);
int exp_star	 (char *line, char *expline, int *r_ix, int *w_ix);
int seek		 (char *line, int *r_ix, char *mode);
int str_replace  (char *expline, char *value, int *w_ix);

/* Define loop states */
enum state_type { 
	NORMAL, 
	DIGIT,
	DOLLAR,
};

int expand(char *line, char *expline, int newsize) {
	int r_ix = 0;						// Read/write indices  
	int w_ix = 0;
	enum state_type state = NORMAL;		// Was previous char a $ ?
	int len = strlen(line);

	for (r_ix = 0; r_ix < len; r_ix++) {
		if (state == NORMAL) {
			if (line[r_ix] == '$')
				state = DOLLAR;
			else if (line[r_ix] == '*') {
				/* Found a * but it was escaped, aka * literal. 
				 * Erase preceding \ from expline and then write the * */
				if (line[r_ix-1] == '\\'){
					w_ix--;
					expline[w_ix] = line[r_ix];
					w_ix++;
				}
				else {
					if (exp_star(line, expline, &r_ix, &w_ix) != 0)
						return -1;
				}
			}
			else {
				expline[w_ix] = line[r_ix];
				w_ix++;	
				expline[w_ix] = 0;	// Append 0 to avoid printing garbage chars
			}
		}
		else if (state == DOLLAR) {
			if (line[r_ix] == '{')  {
				if (exp_curly(line, expline, &r_ix, &w_ix) != 0)	
					return -1;
			}
			else if (line[r_ix] == '$')  {
				if (exp_dollar(line, expline, &r_ix, &w_ix) != 0) 	
					return -1;
			}
			else if (line[r_ix] == '#')  {
				if (exp_pound(line, expline, &r_ix, &w_ix) != 0) 	
					return -1;
			}
			else if (line[r_ix] == '?') {
				if (exp_question(line, expline, &r_ix, &w_ix) != 0) 	
					return -1;
			}
			else if (isdigit(line[r_ix])) {
				if (exp_digit(line, expline, &r_ix, &w_ix) != 0) 	
					return -1;
			}
			else {
				/* False positive, curr char is not a sentinel, record prev 
				 * char and continue. */
				expline[w_ix] = line[r_ix-1];
				w_ix++;
				expline[w_ix] = line[r_ix];
				w_ix++;
			}
			state = NORMAL;
		}
	}

	return 0;	// Nothing failed, hooray!
}

/* Expand an environment variable -- denoted as ${NAME} -- to its value. */
int exp_curly (char *line, char *expline, int *r_ix, int *w_ix) {
	(*r_ix)++;	/* Point to first char of name, instead of open curly */
	char *name = line + *r_ix;	/* String to hold environment variable name 
	                             * to send to getenv(3) sys call */
	char *value;

	/* Seek to ending curly. Return error value if hit EOL before curly */
	if (seek(line, r_ix, "curly")) {
		fprintf (stderr, "msh: no matching }\n");
		return -1;
	}

	line[*r_ix] = 0;
	value = getenv(name);
	line[*r_ix] = '}';

	if (str_replace(expline, value, w_ix)) {
		fprintf (stderr, "msh: curly expansion too long\n");
		return -1;
	}

	return 0;
}

/* Expand $n (n = digit) to corresponding command line argument. */
int exp_digit(char *line, char *expline, int *r_ix, int *w_ix) {
	char *n = line + *r_ix;			/* n to be expanded */
	char *value;					/* Value for m_argv[n] */
	int   n_with_offset = atoi(n) + shift_offset + 1;	// why the 1?

	(void) seek(line, r_ix, "digit");
	(*r_ix)--;	// what is this??? 

	/* interactive mode -> $0 equals ./msh */
	if (interactive_mode && atoi(n) == 0)
		value = m_argv[0];	
	/* script mode -> $0 equals script name */
	else if (atoi(n) == 0)
		value = m_argv[1];
	/* n will never be out of lower bounds, out of upper bands is ignored */
	else if (n_with_offset > m_argc - 1)
		value = "";
	else 
		value = m_argv[n_with_offset];

	if (str_replace(expline, value, w_ix)) {
		fprintf (stderr, "msh: digit expansion too long\n");
		return -1;
	}

	return 0;
}

/* Expand $$ into msh pid, an unsigned int */
int exp_dollar(char *line, char *expline, int *r_ix, int *w_ix) {
	const int MAX_PID_LENGTH = 10;	/* Max size of a pid (2^32) 10 digits */
	pid_t pid = getpid();			/* Integer representation of pid */
	char value[MAX_PID_LENGTH];		/* String to hold pid */
	sprintf(value, "%d", pid);		/* Convert pid to string */

	if (str_replace(expline, value, w_ix)) {
		fprintf (stderr, "msh: digit expansion too long\n");
		return -1;
	}

	return 0;
}

/* Expand $? into base 10 ascii value of last exit command */
int exp_question (char *line, char *expline, int *r_ix, int *w_ix) {
	const int MAX_EXIT_VAL_LENGTH = 3;	/* Max exit value is 255 */
	char value[MAX_EXIT_VAL_LENGTH];
	sprintf(value, "%d", last_exit_val);

	if (str_replace(expline, value, w_ix)) {
		fprintf (stderr, "msh: digit expansion too long\n");
		return -1;
	}

	return 0;
}

/* Expand $# into number of command line arguments */
int exp_pound (char *line, char *expline, int *r_ix, int *w_ix) {
	char 	num_args_str[4];
	int 	num_args;

	if (interactive_mode)
		num_args = 1;
	else
		num_args = (m_argc - shift_offset - 1);

	/* m_argc - 1 since ./msh isn't counted, unlike terminal_args */
	sprintf(num_args_str, "%d", num_args);

	if (str_replace(expline, num_args_str, w_ix)) {
		fprintf (stderr, "msh: pound expansion too long\n");
		return -1;
	}

	return 0;
}

/* Expand wildcard * into list of all files matching the descriptor in the 
 * current working directory. 
 * Got help for opendir: http://bit.ly/1FFkcw0   */
int exp_star (char *line, char *expline, int *r_ix, int *w_ix) {
	char 	cwd[LINELEN];		/* Current working directory */
	char 	*suffix = "";		/* Optional suffix to wildcard, ie *.c */
	DIR 	*dirp;				/* Directory pointery */
	struct 	dirent *dp;			/* Struct with info about current directory */
	int 	match_found = 0;	/* Print literal * if no matches apply */
	char 	temp;				/* Hold a char while inserting null */

	/* Handle errors retrieving working directory */
	if (getcwd(cwd, sizeof(cwd)) != NULL) { /* continue silently */ }
	else {
		fprintf(stderr, "msh: error retrieving working directory \n");
		return -1;
	}

	/* Handle errors opening working directory for reading structs */
	if ((dirp = opendir(cwd)) == NULL) {
		fprintf(stderr, "msh: error opening working directory \n");
		return -1;
	}

	/* If next char isn't whitespace or EOL then seek to end of suffix */
	if (((line[(*r_ix) + 1]) != 0) && (!isspace(line[(*r_ix) + 1]))) {
		suffix = line + *r_ix + 1;
		seek (line, r_ix, "star");
		temp = line[*r_ix];
		line[*r_ix] = 0;
	}

	/* Have suffix stored now. Check for validity */
	if (suffix[strlen(suffix) - 1] == '/') {
		fprintf(stderr, "msh: suffix can not end in /\n");
		if (closedir(dirp))
			fprintf(stderr, "msh: error closing working directory\n");
		return -1;
	}

	/* Suffix is valid. Now either print all files... */ 
	do {
		if ((dp = readdir(dirp)) != NULL) {
			if (dp->d_name[0] != '.'){ 
				if (!suffix) {
					match_found = 1;
					strcat(expline, dp->d_name);
					strcat(expline, " ");
				}
				/* ...or print files with matching suffix. */
				else if (suffix) {
					if (ends_with(dp->d_name, suffix)) {
						match_found = 1;
						strcat(expline, dp->d_name);
						strcat(expline, " ");
					}
				}
			}
		}

	} while (dp != NULL);


	if (!match_found) {
		strcat(expline, "*");
		strcat(expline, suffix);
	}

	if (suffix) line[*r_ix] = temp;

	if (closedir(dirp))
		fprintf(stderr, "msh: error closing working directory\n");
	
	return 0;
}

/* ************************************************************************** 
 * ******* 						Helper functions 					 ********
 * ************************************************************************** */

/* Helper function from Stack Overflow http://bit.ly/1yZGoix */
int ends_with(char *str, char *suffix) {
    if (!str || !suffix)
        return 0;
    size_t lenstr = strlen(str);
    size_t lensuffix = strlen(suffix);
    if (lensuffix >  lenstr)
        return 0;
    return strncmp(str + lenstr - lensuffix, suffix, lensuffix) == 0;
}

/* Seek to sentinel char or EOL */ 
int seek (char *line, int *r_ix, char *mode) {
	if (strcmp(mode, "digit") == 0) {
		while(isdigit(line[*r_ix])) 
			(*r_ix)++;
	}
	else if (strcmp(mode, "curly") == 0) {
		while(line[*r_ix] != '}') {
			(*r_ix)++;
			if (line[*r_ix] == 0) 
				return -1; 	/* It broke (closing curly not found) */
		}
	}
	else if (strcmp(mode, "star") == 0) {
		while((line[*r_ix] != 0) && (!isspace(line[*r_ix]))) 
			(*r_ix)++;
	}

	return 0;			/* Sentinel found without error */ 
}

/* Process substring replacement in expline */
int str_replace(char *expline, char *value, int *w_ix) {
	/* Don't attempt replacement if value is empty string */
	if (!value) {
		return 0;
	}
	/* Expansion overflow detection */
	else if (strlen(expline) + strlen(value) > LINELEN) {
		return -1;
	}
	else {
		strcat(expline, value);
		/* Incr write index by length of value */
		*w_ix = *w_ix + strlen(value);	
	}

	return 0;
}