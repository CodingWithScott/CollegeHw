/*	$Id: expand.c,v 1.30 2014/11/16 00:12:27 felchs Exp $	*/
#include <ctype.h>		/* needed to define isdigit(3) */
#include <dirent.h>		/* needed to define readdir(3) */
#include <pwd.h>		/* needed to define getpw(3) */
#include <string.h>
#include <stdio.h> 
#include <stdlib.h>		
#include <sys/types.h>	/* needed to define size_t, pid_t, etc */
#include <sys/wait.h>	/* needed to define wait(3) */
#include <unistd.h> 	/* needed to define getcwd(3), getpid(2), read(2) */

#include "globals.h"	/* shared data between files */
#include "proto.h"		/* shared function prototypes */
#define LINELEN 200000

#define _GNU_SOURCE		/* needed to prototype get_curren_dir_name(void) */

/* Local prototypes */
int ends_with	 (char *str,  char *suffix);
int exp_curly  	 (char *line, char *expline, int *r_ix, int *w_ix);
int exp_digit  	 (char *line, char *expline, int *r_ix, int *w_ix);
int exp_dollar 	 (char *line, char *expline, int *r_ix, int *w_ix);
int exp_question (char *line, char *expline, int *r_ix, int *w_ix);
int exp_paran    (char *line, char *expline, int *r_ix, int *w_ix);
int exp_pound    (char *line, char *expline, int *r_ix, int *w_ix);
int exp_star	 (char *line, char *expline, int *r_ix, int *w_ix);
int exp_tilde 	 (char *line, char *expline, int *r_ix, int *w_ix);
int seek		 (char *line, int *r_ix, char *mode);
int str_replace  (char *expline, char *value, int *w_ix);

/* Define loop states */
enum state_type { 
	NORMAL,
	DIGIT,
	DOLLAR,
};

int e_debug = 0;

int expand(char *line, char *expline, int newsize) {
	int r_ix = 0;						/* Read index */
	int w_ix = 0;						/* Write index */
	enum state_type state = NORMAL;		/* Was previous char a dollar? */
	int len = strlen(line);

	if (e_debug) {
		printf("entered expand()\n");
		printf("line:\t|%s|\n", line);
	}

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
			else if (line[r_ix] == '~') {
				if (exp_tilde(line, expline, &r_ix, &w_ix) != 0)	
					return -1;
			}
			else {
				expline[w_ix] = line[r_ix];
				w_ix++;	
				expline[w_ix] = 0;	/* Append 0 to avoid printing garbage */
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
			else if (line[r_ix] == '(') {
				if (exp_paran(line, expline, &r_ix, &w_ix) != 0) 	
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

	return 0;
}

/* Expand an environment variable -- denoted as ${NAME} -- to its value. */
int exp_curly (char *line, char *expline, int *r_ix, int *w_ix) {
	(*r_ix)++;	/* Point to first char of name, instead of open curly */
	char *name = line + *r_ix;	/* String to hold environment variable name 
	                             * to send to getenv(3) sys call */
	char value[LINELEN] = "";

	/* Seek to ending curly. Return error value if hit EOL before curly */
	if (seek(line, r_ix, "curly")) {
		fprintf (stderr, "msh: no matching }\n");
		return -1;
	}

	line[*r_ix] = 0;
	strcat(value, getenv(name));
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

/* Expand things within parans to separate calls to builtins or fork to 
 * system call, results placed back into expline. Data transmitted between 
 * processes with pipes. */
int exp_paran (char *line, char *expline, int *r_ix, int *w_ix) {
	int cmd = *r_ix;	/* Point to first open paran */
	cmd++;				/* Increment to point to start of cmd, not ( */
	int pipefd[2];		/* Int array used for pipe(2)
						   pipefd[0] == read end
						   pidefd[1] == write end */
	pid_t cpid;			/* Child process id generated from pipe() fork */
	ssize_t 
	bytes_read = 0;		/* Num of bytes successfully read from pipe */
	int status;

	// if (e_debug) printf("entered paran\n");

	if (seek(line, r_ix, "paran") < 0) {
		fprintf(stderr, "./msh: missing )\n");
		return -1;
	}

	line[*r_ix] = 0;
	
	if (pipe(pipefd) == -1){
		perror("pipe");
		exit(EXIT_FAILURE);
	}
	// if (e_debug) printf("\tSending to processline() substring:\t|%s|\n", &line[cmd]);

	cpid = processline(&line[cmd], pipefd[1], NOTWAIT);

	/* Read from pipefd[0] until hit EOF */
	while (bytes_read <= 0) {
		/* Amount to read won't exceed remaining space in expline, error if 
		 * attempting to do so. */
		int amt_to_read = LINELEN - strlen(expline);
		if (amt_to_read <= 0)
			return -1;
		// char bufferthing[1000] = "";
		bytes_read = read(pipefd[0], &expline[*w_ix], amt_to_read);
		(*w_ix) = (*w_ix) + bytes_read;

		// bytes_read = read(pipefd[0], bufferthing, amt_to_read);
		// printf("read:\t|%s|\n", bufferthing);
	}

	// if (e_debug)	printf("expline[%d] == |%c|\n", *w_ix - 1, expline[*w_ix-1]);
	if (expline[*w_ix - 1] == '\n') {
		// printf("so, yeah, expline[%d] == \'\\n\'\n", *w_ix-1);
		// expline[*w_ix-1] = 0;
		(*w_ix)--;
	}

	/* If a child was forked, wait for it to finish its job */
	if (cpid > 0) {
		if (wait(&status) < 0){
			perror ("wait");
			return -1;
		}
	}

	line[*r_ix] = ')';

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
					/* Increment write pointer for filename + space */
					*w_ix = *w_ix + strlen(dp->d_name) + 1;
				}
				/* ...or print files with matching suffix. */
				else if (suffix) {
					if (ends_with(dp->d_name, suffix)) {
						match_found = 1;
						strcat(expline, dp->d_name);
						strcat(expline, " ");
						/* Increment write pointer for filename + space */
						*w_ix = *w_ix + strlen(dp->d_name) + 1;
					}
				}
			}
		}

	} while (dp != NULL);


	if (!match_found) {
		strcat(expline, "*");
		strcat(expline, suffix);
		*w_ix = *w_ix + 1 + strlen(suffix);	/* Increment write pointers */
	}

	if (suffix) line[*r_ix] = temp;

	if (closedir(dirp))
		fprintf(stderr, "msh: error closing working directory\n");
	
	return 0;
}

/* Tilde standalone => print current user's working directory 
 * Tilder followed by username => print that user's working directory */
int exp_tilde (char *line, char *expline, int *r_ix, int *w_ix) {
	struct passwd *pwd;		/* Hold a password file entry for a user */
	
	/* "echo ~ " --> Finding my own working directory */
	if (line[*r_ix+1] == ' ' || line[*r_ix+1] == 0) {
		if ((pwd = getpwuid(getuid())) < 0) {
			fprintf(stderr, "expand.c: getpwuid lookup failure\n");
			return -1;
		}
		strcat(expline, pwd->pw_dir);
		*w_ix = *w_ix + strlen(pwd->pw_dir);
	}
	/* "echo ~homie" --> Find a homie's working directory */
	else {
		/* Seek to end of username, store it, use to look up pw file */
		(*r_ix)++; 					/* Read past tilde */
		char *value = &line[*r_ix];
		(void) seek(line, r_ix, "tilde");
		char temp = line[*r_ix];
		line[*r_ix] = 0;

		/* Look up user info by passing username to getpwnam(3)
		 * If username lookup succeeds, strcat the working directory. */
		if ((pwd = getpwnam(value)))
			str_replace(expline, pwd->pw_dir, w_ix);
		/* If it fails, just strcat the original line unchanged. */
		else 
			str_replace(expline, value, w_ix);
		line[*r_ix] = temp;
	}

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
	else if (strcmp(mode, "paran") == 0) {
		int num_parans = 1;			/* L paran --> num_parans++
									   R paran --> num_parans-- */

		(*r_ix)++;					/* read past first paran */
		while(line[*r_ix] != 0) {
			if (line[*r_ix] == '(') {
				num_parans++;
			}
			else if (line[*r_ix] == ')') {
				num_parans--;
				/* Found matching R paran */
				if (num_parans == 0)
					return 0;
			}
			(*r_ix)++;			/* read next char */
		}

		/* Got to EOL without matching R paran, oh no! */
		return -1;
	}
	else if (strcmp(mode, "star") == 0) {
		while((line[*r_ix] != 0) && (!isspace(line[*r_ix]))) 
			(*r_ix)++;
	}
	else if (strcmp(mode, "tilde") == 0) {
		while((line[*r_ix] != 0) && (!isspace(line[*r_ix]))) 
			(*r_ix)++;
	}

	return 0;			/* Sentinel found without error */ 
}

/* Process substring replacement in expline */
int str_replace(char *expline, char *value, int *w_ix) {
	if (e_debug) printf("str_replace adding:\t|%s|\n", value);
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