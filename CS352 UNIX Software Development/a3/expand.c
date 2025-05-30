/*	$Id: expand.c,v 1.7 2014/10/18 23:27:47 felchs Exp $	*/
#include <string.h>
#include <stdio.h> 
#include <stdlib.h>
#include <sys/types.h>	/* needed for size_t, pid_t, etc */
#include <unistd.h> 	/* needed to define getpid() */

#include "proto.h"
#define LINELEN 1024

/* Local prototypes */
int helper_curly  (char *line, char *expline, int *r_ix, int *w_ix);
int helper_dollar (char *line, char *expline, int *r_ix, int *w_ix);

/* Define loop states */
enum state_type { 
	NORMAL, CURLY, DOLLAR
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
			else {
				expline[w_ix] = line[r_ix];
				w_ix++;	
				expline[w_ix] = 0;	// Append 0 to avoid printing garbage chars
			}
		}
		else if (state == DOLLAR) {
			if (line[r_ix] == '{') {
				if (helper_curly(line, expline, &r_ix, &w_ix) != 0)
					return -1;
				state = NORMAL;
			}
			else if (line[r_ix] == '$') {
				if (helper_dollar(line, expline, &r_ix, &w_ix) != 0)
					return -1;
				state = NORMAL;
			}
			/* False positive, curr char is not a sentinel, record prev char
			 * and continue. */
			else {
				expline[w_ix] = line[r_ix-1];
				w_ix++;
				expline[w_ix] = line[r_ix];
				w_ix++;
				state = NORMAL;
			}
		}
	}

	return 0;	// Nothing failed, hooray!
}


int helper_curly  (char *line, char *expline, int *r_ix, int *w_ix) {
	(*r_ix)++;	/* Point to first char of name, instead of open curly */
	char *name = line + *r_ix;	/* String to hold environment variable name 
	                             * to send to getenv(3) sys call */
	char *value;

	/* Seek to ending curly. Return error value if hit EOL before curly */
	while(line[*r_ix] != '}') {
		(*r_ix)++;
		if (line[*r_ix] == 0) {
			dprintf(2, "msh: no matching }\n");
			return -1;
		}
	}

	line[*r_ix] = 0;
	value = getenv(name);
	line[*r_ix] = '}';

	/* If there's no value for the env variable then just return */ 
	if (value) {
		if (strlen(expline) + strlen(value) > LINELEN) {
			dprintf(2, "msh: expansion too long\n");
			return -1;
		}
		else {
			strcat(expline, value);
			/* Incr write index by length of value */
			*w_ix = *w_ix + strlen(value);	
		}
	}

	return 0;
}

int helper_dollar(char *line, char *expline, int *r_ix, int *w_ix) {
	const int MAX_PID_LENGTH = 10;	/* Max size of a pid (2^32) 10 digits */
	pid_t pid = getpid();			/* Integer representation of pid */
	char pid_str[MAX_PID_LENGTH];	/* String to hold pid */

	sprintf(pid_str, "%d", pid);	/* Convert pid to string */
	int pid_len = strlen(pid_str);	/* Actual size of this pid */

	if (pid_len + strlen(expline) > LINELEN) {
		dprintf(2, "msh: expansion too long\n");
		return -1;
	}

	*w_ix = *w_ix + pid_len;		/* Increment write index by pid length */
	strcat(expline, pid_str);		/* Concat pid to end of expline */ 

	return 0;
}