// Scott Felch
// 3 March 2012
// CSCI 247
// Week 8 Written HW, problem 5.19

void *memset(void *s, int c, size_t n);

/* Basic implementation of memset */
void *basic_memset(void *s, int c, size_t n) {
	size_t cnt = 0;
	unsigned char *schar = s;
	while (cnt < n) {
		*schar++ = (unsigned char) c;
		cnt++;
	}
	return s;
}

/* More gooder version that I wrote */
/* S = starting point to begin writing at 
   C = number to get last byte from 
   N = how many bytes to write over, so range is from mem locations S to S+N */
void *memset(void *s, int c, size_t n) {
	
	/* Isolate right-most byte of C by shitting left 24 bits, then right 24 
	bits. Will be all 0s except right-most byte. */
	int byte_to_repeat_temp = c << 24;
		byte_to_repeat_temp = byte_to_repeat_temp >> 24;
		
	/* Store byte_to_repeat in a char so it's only 1 byte long. Doing this 
	before the loop should mean it's only done once, not typecasting every 
	time a loop iterates. */ 
	char byte_to_repeat = byte_to_repeat_temp;
		
	int k = sizeof(long);	/* If a long is 8 bytes then this is a 
		64-bit machine. If it's 4 bytes, then it's a 32-bit machine. */

	int remainder = n % k; /* This is how many single byte writes will have to 
		be done before able to K-sized (4 or 8 bytes) writes at a time. */
		
	unsigned long stamp = byte_to_repeat;	/* This is the long word
		which will be filled up with 4 or 8 copies of byte_to_repeat.
		It's like a big rubber stamp smashing all over the memory range. */
		
	/* These OR statements will repeat the byte_to_repeat pattern throughout 
	   the stamp. */
	if (k == 8) {	// 64-bit
		stamp = stamp | stamp << 8 | stamp << 16 | stamp << 24 | stamp << 32 |
			stamp << 40 | stamp << 48 | stamp << 56;
	}
	else if (k == 4) { // 32-bit 
		stamp = stamp | stamp << 8 | stamp << 16 | stamp << 24;
	} 
	
	/* This set of if statements will take care of the leading bytes in the 
	memory range that are out of alignment, before writing in full multiples 
	of K. It's ugly but it should work. Max remainder could be is 3 on a 32-bit
	system or 7 on a 64-bit system. */
	if (remainder == 1) {
		*s = byte_to_repeat;
	}
	else if (remainder == 2) {
	
	/* Need to write remainder number of bytes 1 byte at a time, after that, 
	can go to unravelled loop form writing K bytes at a time. */ 
	int count = 0;
	while (count < remainder) {
		*s++ = byte_to_repeat;
		count++;
	}
	count = 0;

	/* S has already been incremented to the new starting position so from
	here to the end of the memory segment will be a multiple of K bytes. 
	Depending on whether this is a 32 or 64 bit machine, loop will be unrolled
	to allow 4 or 8 parallel assignments, each containing 4 or 8 instances
	of repeated byte. */
	if (k == 4) {
		while (count < n) {
			*s = stamp;	// 
			*s + 1 = stamp;			// Write to starting location, and in 
			*s+2 = stamp;			// parallel to total of 4 locations at once
			*s+3 = stamp;
			s = s + (4*k);			// Increment pointer by 4*K bytes
			count = count + (4 * k);
		}
	}
	
	else if (k == 8) {
		while (count < n) {
			*s = stamp;	// 
			*s+1 = stamp;			// Write to starting location, and in 
			*s+2 = stamp;			// parallel to total of 8 locations at once
			*s+3 = stamp;
			*s+4 = stamp;
			*s+5 = stamp;
			*s+6 = stamp;
			*s+7 = stamp;
			s = s + (8*k);			// Increment pointer by K bytes
			count = count + (8 * k);
		}
	}
	
	return s;
}
