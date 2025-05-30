#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int
main (int argc, char **argv)
{
  int ppid, argppid;

  if (argc != 2) {
    fprintf (stderr, "Usage: %s ppid\n", argv[0]);
    return 1;
  }

  ppid = getppid();

  argppid = atoi(argv[1]);

  if (ppid == argppid)
    printf ("Arg is ppid!\n");
  else
    printf ("Arg is not ppid!\n");

  return 0;
}
