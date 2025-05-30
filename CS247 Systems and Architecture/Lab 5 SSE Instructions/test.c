// Test program for vector stuff
int main(void) 
{
	/* Vector containing 4 integers to be used for a single instruction. 
	Vector_size = 16 because it contains four 4-byte ints	*/
	typedef int v4si __attribute__ ((vector_size (16)));

	union u_tag {				// Union type is called "u_tag"
		v4si vector;			// Vector used for performing SIMD operations
		int my_numbers[4];		// Array of 4 ints that can be easily modified, then accessed as a vector later
		pixel *destination;		// Will be a copy of the source pixel passed in, aligned to first part of union


	} u;						// Union of type "u_tag" is called "u";
	
	

	int butthole;	// It's a counter, deal with it
	
	for (butthole = 0; butthole < 4; butthole++) 
		u.my_numbers[butthole] = 0;
		
	for (butthole = 0; butthole < 4; butthole++) {
		printf("%d", u.my_numbers[butthole]); 
		printf("\n");
	}
	
//	u.destination = dst;
	destination = dst;		
	
	
	/* Process one row at a time, grab 32 columns in that row. */
	//	for (i = 0; i < dim; i+=32)
	for (i = 0; i < dim; i+=4)
	{
		for (j = 0; j < dim; j++) 
		{
			*u.destination     = src[(i+ 0 + vec)*(dim)+(j)];	// 1 line = 4 operations, theoretically
			*u.(destination+1) = src[(i+ 1 + vec)*(dim)+(j)];
			*u.(destination+2) = src[(i+ 2 + vec)*(dim)+(j)];
			*u.(destination+3) = src[(i+ 3 + vec)*(dim)+(j)];
			
		}
	}
	
	return 0;
}
