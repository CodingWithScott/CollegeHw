/* Arglist.c -- list all arguments! */

#include <stdio.h>

int
main (int argc, char **argv)
{
  int i;

  printf ("Arglist: argc = %d\n\n", argc);
  
  for (i=0; i<argc; i++)
    printf ("Arg %d: '%s'\n", i, argv[i]);
  
  return 0;
}
