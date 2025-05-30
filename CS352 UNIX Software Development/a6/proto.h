/*	$Id: proto.h,v 1.11 2014/12/03 03:16:36 felchs Exp $	*/
/* Prototypes */

/* arg_parse.c */
int arg_parse (char *line, 
			   char ***argvp);

/* builtin.c */
int exec_builtin (char **argv, 
				  int num_args, 
				  int infd, 
				  int outfd, 
				  int errfd);		

/* expand.c */
int expand (char *orig, 
			char *new, 
			int newsize);

/* msh.c */
void kill_zombies (void);
int processline  (char *line, 
				  int infd, 
				  int outfd, 
				  int errfd, 
				  int flag);