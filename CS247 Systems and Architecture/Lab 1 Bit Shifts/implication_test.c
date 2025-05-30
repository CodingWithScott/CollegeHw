// Test program for Implication

int implication(int x, int y) {
    return !x | y;
}


int main(void) {
//	int poop = tr

	printf("implication(0,0):  "); 
	printf("%i", implication(0,0)); printf("\n"); 
	printf("implication(0,1):  "); 
	printf("%i", implication(0,1)); printf("\n"); 
	printf("implication(1,0):  "); 
	printf("%i", implication(1,0)); printf("\n"); 
	printf("implication(1,1):  "); 
	printf("%i", implication(1,1)); printf("\n"); 

	return 0;
}
