/*	$Id: proto.h,v 1.7 2014/10/22 07:32:40 felchs Exp $	*/

/* Prototypes */
int arg_parse (char *line, char ***argvp);			// arg_parse.c
int exec_builtin(char **argv, int num_args);		// builtin.c
int expand(char *orig, char *new, int newsize);		// expand.c
void processline (char *line);						// msh.c
