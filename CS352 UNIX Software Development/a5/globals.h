/* $Id: globals.h,v 1.8 2014/11/12 23:33:49 felchs Exp $ */

/* Data shared across files */

/* 0 = input routed from script
 * 1 = input from stdin
 * Referenced: expand.c, msh.c */ 
extern int interactive_mode;	

/* 0 = successful builtin
 * 1 = failed builtin
 * 127 = other failure 
 * Referenced: builtin.c, expand.c, msh.c */
extern int last_exit_val;		

/* # of arguments passed into msh 
 * Referenced: expand.c, msh.c */
extern int m_argc;			

/* Argument vector passed into msh 
 * Referenced: expand.c, msh.c */
extern char **m_argv;			

/* Offset of arguments set by shift builtin 
 * Referenced: builtin.c, expand.c */
extern int 	 shift_offset;		

/* Flag noting that a SIGINT was intercepted. sig_atomic_t is an integer that
 * is guaranteed to be handled atomically in operations.
 * Referenced: msh.c */
extern __sig_atomic_t sigint_occurred;	

/* Constants for making WAIT/NOTWAIT more readable */
#define NOTWAIT 0
#define WAIT 1