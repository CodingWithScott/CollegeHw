/*	$Id: proto.h,v 1.8 2014/11/12 23:33:49 felchs Exp $	*/

/* Prototypes */
int arg_parse (char *line, char ***argvp);					/* arg_parse.c */
int exec_builtin(char **argv, int num_args, int outfd);		/* builtin.c */
int expand(char *orig, char *new, int newsize);				/* expand.c */
int processline (char *line, int outfd, int wait);			/* msh.c */