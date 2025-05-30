// Scott Felch
// 29 April 2010
// CS 131, Keith Laidig
// Midterm problem #3

#include <iostream>

int current_number = 1;			// The number to be output, starting at 1.
int row_length = 1;				// How long this row will be before forming a new line
int counter = 0;				// Counter to keep track of how many digits have been printed on this line so far

int main()
{
	// Outer loop will increment the designated line length through each iteration, quitting when it hits 28.
	while (current_number < 29)
	{
		/* Inner loop will output digits one at a time until it reaches an end of the row, it prints a 
		carriage return and then increases row length for the next row. */
		while (counter < row_length)
		{
		std::cout << current_number << "  ";
		current_number++;
		counter++;
		}
		// Reset counter, print carriage return, and increase row length to prepare for the next iteration.
		counter = 0;
		std::cout << "\n";
		row_length++;
	}

	// End program
	return 0;
}

