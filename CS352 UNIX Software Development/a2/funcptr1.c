/* Function pointer example program! */

#include <stdio.h>

typedef void (*funcptr) (int);

void func1 ( int a ) 
{
  printf ("I'm func1 with argument of %d.\n", a);
}

void func2 ( int a ) 
{
  printf ("I'm func2 with argument of %d.\n", a);
}

int main ()
{
  funcptr flist[] = {func1, func2};

  int i;

  for (i = 0; i < 2; i++)
    flist[i](i);

  return 0;
}

