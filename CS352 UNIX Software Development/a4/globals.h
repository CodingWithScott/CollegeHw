/* $Id: globals.h,v 1.6 2014/10/31 05:27:22 felchs Exp $ */

/* Data shared across files */
extern int   interactive_mode;	/* 0 = input routed from scrip 
								 * 1 = input from stdin
								 * Referenced: expand.c, msh.c */ 

extern int   last_exit_val;		/* 0 = successful builtin
								 * 1 = failed builtin
								 * 127 = other failure 
								 * Referenced: builtin.c, expand.c, msh.c */

extern int    m_argc;			/* # of arguments passed into msh 
								 * Referenced: expand.c, msh.c */

extern char **m_argv;			/* Argument vector passed into msh 
								 * Referenced: expand.c, msh.c */

extern int 	 shift_offset;		/* Offset of arguments set by shift builtin 
								   Referenced: builtin.c, expand.c */