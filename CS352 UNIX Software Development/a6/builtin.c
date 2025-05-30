/*	$Id: builtin.c,v 1.24 2014/12/02 04:05:55 felchs Exp $	*/
#include <grp.h>			/* for gid and uids */
#include <pwd.h>
#include <string.h>
#include <stdio.h> 
#include <stdlib.h>
#include <sys/stat.h>		/* for sstat() */
#include <sys/types.h>		/* for gid and uids */
#include <time.h> 			/* for sstat() */
#include <unistd.h>			/* for chdir(2) */

#include "globals.h"
#include "proto.h"

#define LINELEN 1024

/* Function pointer type declaration */
typedef void (*funcptr) (char**, int);

/* Function name + ptr declaration */
typedef struct {
	char *name;
	void (*funcptr) (char **argv, int argc, int infd, int outfd, int errfd);
} bi;

/* Local prototypes */
void aecho 		(char **argv, int argc, int infd, int outfd, int errfd);
void changedir	(char **argv, int argc, int infd, int outfd, int errfd);
void envset 	(char **argv, int argc, int infd, int outfd, int errfd);
void envunset 	(char **argv, int argc, int infd, int outfd, int errfd);
void my_exit 	(char **argv, int argc, int infd, int outfd, int errfd);
void read_name 	(char **argv, int argc, int infd, int outfd, int errfd);
void shift		(char **argv, int argc, int infd, int outfd, int errfd);
void sstat		(char **argv, int argc, int infd, int outfd, int errfd);
void unshift	(char **argv, int argc, int infd, int outfd, int errfd);

/* Access globals */
int last_exit_val;
int shift_offset = 0;

/* Find and execute the appropriate builtin function. */
int exec_builtin(char **argv, int argc, int infd, int outfd, int errfd) {
	const int NUM_BUILTINS = 9;
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
	the_builtins[5].name = "read";
	the_builtins[5].funcptr = read_name;
	the_builtins[6].name = "shift";
	the_builtins[6].funcptr = shift;
	the_builtins[7].name = "sstat";
	the_builtins[7].funcptr = sstat;
	the_builtins[8].name = "unshift";
	the_builtins[8].funcptr = unshift;

	/* Search for command in the builtins array, return 1 if found 
	 * or 0 to indicate not found. */
	int ix;
	for (ix = 0; ix < NUM_BUILTINS; ix++){
		if (!strcmp(argv[0], the_builtins[ix].name)){
			the_builtins[ix].funcptr(argv, argc, infd, outfd, errfd);
			return 1;
		}
	}
	return 0;
}

/* Copycat of echo */
void aecho (char **argv, int argc, int infd, int outfd, int errfd) {
	int ix;
	int print_newline = 1;

	/* Don't try to check argv[1] if it doesn't exist */
	 if (argc > 1) {
		if (!(strcmp(argv[1], "-n")))
			print_newline = 0;
	}
	else if (argc == 1) {
		dprintf(outfd, "\n");
		last_exit_val = 0;
		return;
	}

	/* Don't print the "-n" flag */
	if (print_newline)
		for (ix = 1; ix < argc; ix++) {
			if (ix != (argc - 1)) {
				dprintf(outfd, "%s", argv[ix]);	
				dprintf(outfd, " ");
			}
			else {
				dprintf(outfd, "%s", argv[ix]);
				if (print_newline) 
				dprintf(outfd, "\n");		
			}
		}
	else {
		for (ix = 2; ix < argc; ix++) {
			if (ix != (argc - 1)) {
				dprintf(outfd, "%s", argv[ix]);	
				dprintf(outfd, " ");
			}
			else {
				dprintf(outfd, "%s", argv[ix]);
			}
		}
	}	
	last_exit_val = 0;
}

/* Change working directory */
void changedir (char **argv, int argc, int infd, int outfd, int errfd) {
	if (argc == 1) {
		if (getenv("HOME")) {
			chdir(getenv("HOME"));
			last_exit_val = 0;
		}
		else {
			dprintf (errfd, "cd: Environment variable HOME not set.\n");
			last_exit_val = 1;
			return;
		}
	}
	else if (argc == 2) {
		if (chdir(argv[1])) {
			dprintf (errfd, "cd: %s: No such file or directory\n", argv[1]);
			last_exit_val = 1;
		}
	}
	else {
		dprintf (errfd, "usage: cd [dir]\n");
		last_exit_val = 1;
	}
}

/* Set process environment variable */
void envset (char **argv, int argc, int infd, int outfd, int errfd) {
	if (argc != 3) {
		dprintf (errfd, "usage: envset name value\n");
		last_exit_val = 1;
	}
	else {
		/* setenv(char *name, char *value, int overwrite)   */
		if (setenv(argv[1], argv[2], 1)) {
			dprintf (errfd, "setenv():\terror\n");
			last_exit_val = 1;
		}
	}

	last_exit_val = 0;
}

/* Clear process environment variable */
void envunset (char **argv, int argc, int infd, int outfd, int errfd) {
	if (argc != 2) {
		dprintf(errfd, "usage: envunset name\n");
		last_exit_val = 1;
	}
	else {
		/* syntax: setenv(char *name) */
		if (unsetenv(argv[1])) {
			dprintf(errfd, "unsetenv():\terror\n");
			last_exit_val = 1;
		}
	}

	last_exit_val = 0;
}

/* Call exit(P) */
void my_exit (char **argv, int argc, int infd, int outfd, int errfd) {
	int exit_code;
	
	if (argc == 1)
		exit_code = 0;
	else if (argc == 2) 
		exit_code = atoi(argv[1]);
	else {
		dprintf(errfd, "Usage: exit [optional integer]\n");
		last_exit_val = 1;
		return;
	}
	last_exit_val = 0;
	exit(exit_code); 
}

/* Set an entire line of input to an environment variable */
void read_name (char **argv, int argc, int infd, int outfd, int errfd) {
	char name[LINELEN] = "";
	char value[LINELEN] = "";

	/* Check for proper usage */
	if (argc != 2) {
		fprintf(stderr, "Usage: read variable-name\n");
		last_exit_val = 1;
		return;
	}

	/* Store the name */
	strcat(name, argv[1]);
	// fprintf(stdout, "\n");

	/* Capture an entire line of input into value using fgets(3).
	 * Syntax:	char *fgets(char *s, int size, FILE *stream);  */
	if (fgets(value, LINELEN, stdin) == 0) {
		fprintf(stderr, "read():\tfgets error\n");
		last_exit_val = 1;
	}

	/* Trim the newline before storing in environment. */
	int len = strlen(value);
	if (value[len-1] == '\n')
		value[len-1] = 0;

	/* Assign the environment variable 
	 * Syntax:  setenv(char *name, char *value, int overwrite)  */
	if (setenv(name, value, 1)) {
		dprintf(errfd, "read_name():\tsetenv error\n");
		last_exit_val = 1;
	}

	last_exit_val = 0;
}

/* Add offset n so parameter i becomes i+n */
void shift (char **argv, int argc, int infd, int outfd, int errfd) {
	int n;
	/* Check shift was called with correct number of args */
	if (argc == 1)
		n = 1;
	else if (argc == 2) 
		n = atoi(argv[1]);
	else {
		fprintf(stderr, "Usage: shift [n]\n");
		last_exit_val = 1;
		return;
	}

	/* Check value for n is usable */
	if ((n < 1) || (n >= m_argc)) {
		fprintf(stderr, "Usage: 1 <= n <= num_args\n");
		last_exit_val = 1;
		return;
	}

	shift_offset = shift_offset + n;

	last_exit_val = 0;
}

/* For one or more specified files print out: filename, username, groupname, 
 * permission list (ex: -rwx--x--x), number of links, size in bytes, and 
 * modification time. */
void sstat (char **argv, int argc, int infd, int outfd, int errfd) {
	int 		ix;
	struct 		stat st;	

	const int 	MAX_TIME_SIZE = 50;
	char 		time_str[MAX_TIME_SIZE];

	if (argc == 1){
		fprintf(stderr, "stat: no files to stat\n");
		return;
	}

	for (ix = 1; ix < argc; ix++) {
		if (stat(argv[ix], &st) == -1) {
			perror("stat");
			last_exit_val = 1;
			return;
		}
		printf("%s ", argv[ix]);							/* filename */

		if (getpwuid(st.st_uid))
			printf("%s ", getpwuid(st.st_uid)->pw_name);	/* username */
		else {
			fprintf(stderr, "stat: getpwuid() error\n");		
			last_exit_val = 1;
			return;
		}
		if (getgrgid(st.st_gid))
			printf("%s ", getgrgid(st.st_gid)->gr_name);	/* groupname */
		else{
			fprintf(stderr, "stat: getgrgid() error\n");		
			last_exit_val = 1;
			return;
		}

		printf((S_ISDIR(st.st_mode) ? "d" : "-"));		/* is directory? */
		printf((st.st_mode & S_IRUSR) ? "r" : "-");		/* user readable */
		printf((st.st_mode & S_IWUSR) ? "w" : "-");		/* user writable */
		printf((st.st_mode & S_IXUSR) ? "x" : "-");		/* user exec */
		printf((st.st_mode & S_IRGRP) ? "r" : "-");		/* group readable */
		printf((st.st_mode & S_IWGRP) ? "w" : "-");		/* group writable */
		printf((st.st_mode & S_IXGRP) ? "x" : "-");		/* group executable */
		printf((st.st_mode & S_IROTH) ? "r" : "-");		/* other readable */
		printf((st.st_mode & S_IWOTH) ? "w" : "-");		/* other writable */
		printf((st.st_mode & S_IXOTH) ? "x" : "-");		/* other executable */
		printf(" %d ", (int) st.st_nlink);				/* # of links */
		printf("%d ", (int) st.st_size);				/* size in bytes */

		struct tm *tmp = localtime(&st.st_mtime); 
		strftime(time_str, MAX_TIME_SIZE, "%a %b %e %H:%M:%S %Y", tmp);
		printf("%s", time_str);
		printf("\n");
		fflush(stdout);	// is this unnecessary after the printf("\n") ?
	}

	last_exit_val = 0;
}

/* Remove n offset from global offset */
void unshift (char **argv, int argc, int infd, int outfd, int errfd) {
	int n;
	
	/* Check shift was called with correct number of args */
	if (argc == 1) {
		shift_offset = 0;
		return;
	}
	else if (argc == 2) 
		n = atoi(argv[1]);
	else {
		fprintf(stderr, "Usage: unshift [n]\n");
		last_exit_val = 1;
		return;
	}

	/* Check value for n is usable */
	if ((n < 1) || (n >= shift_offset)) {
		fprintf(stderr, "Usage: 1 <= n <= shift_offset\n");
		last_exit_val = 1;
		return;
	}

	shift_offset = shift_offset - n;	
	last_exit_val = 0;
}