/* $Id: globals.h,v 1.11 2014/12/05 04:18:58 felchs Exp $ */

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

/* Constants */
#define STDIN 0
#define STDOUT 1
#define STDERR 2

/* Flags */
#define WAIT_PLS 1
#define NO_WAIT_THX 0
#define EXPAND_PLS 2
#define NO_EXPAND_THX 0
#define STMTS_PLS 4
#define NO_STMTS_THX 0