#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

int main ()
{
  int i;
  struct stat sb;
  for (i = 0; i < 1024; i++ )
    if (fstat(i,&sb) >= 0) 
      printf ("FD %d is open\n", i);
  return 0;
}
