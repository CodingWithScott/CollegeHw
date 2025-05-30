#include <stdio.h>
#include <limits.h>

int main(void)
{
	int wordsize = 0;
	
	wordsize = sizeof(int)<<3;
	printf("Word size:  ");	
	printf("%i", wordsize);
	printf("\n\n");
	
	printf("INT_MIN:  "); printf("%d", INT_MIN); printf("\n");
	printf("INT_MAX:  "); printf("%d", INT_MAX); printf("\n");
    return 0;
}
