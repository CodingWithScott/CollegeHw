// Test program for sizeof on ints in 64-bit and 32-bit.
// I think they're the same but I'm just verifying that here.

int main(void) {
	printf("The size of an int (in bytes) on a 64-bit machine:  ");
	printf("%i", sizeof(int)); printf("\n");

	return 0;
}
