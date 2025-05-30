/* Function pointer example program! */

#include <stdio.h>

typedef void (*funcptr) (int);

typedef struct { 
	char *name;
	void (*funcptr) (int number);
} ex_struct_type;

void func1 ( int a ) 
{
  printf ("I'm func1 with argument of %d.\n", a);
}

void func2 ( int a ) 
{
  printf ("I'm func2 with argument of %d.\n", a);
}

void func3 ( int num) {
	printf("This is func3, yo. You entered %d\n", num);
}

int main ()
{
  funcptr flist[2];

  flist[0] = func1;
  flist[1] = func2;

  // int i;
  // for (i = 0; i < 2; i++)
  //   flist[i](i);

  ex_struct_type ex_struct;
  ex_struct.name = "Bob";
  ex_struct.funcptr = &func3;

  ex_struct.funcptr(696969);

  return 0;
}

