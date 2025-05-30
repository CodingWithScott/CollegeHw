// Scott Felch
// 27 April 2010
// CS 131, Keith Laidig
/* Exercise 8-1. This program will print out an ASCII checkerboard, 8x8 grid. Each 
square is 5 chars wide and 3 chars long. */

#include <iostream>

int column = 0;		// Counter for the column
int row = 0;		// Counter for the row

int main()
{
	// This outer for loop determines which kind of row will be printed out.
	// Every 4th row is a full row, all other rows are empty rows.
	for (row = 0; row < 33; row++)
	{
		if (row % 4 == 0)
		{
			// This loop will print out a full row
			for (column = 0; column < 49; column++)
			{
				if (column % 6 == 0)
					std::cout << '+';
				else
					std::cout << '-';
			}
			std::cout << "\n";
		}
		else
		{
			// This loop will print out an empty row
			for (column = 0; column < 49; column++)
			{
			if (column % 6 == 0)
				std::cout << '|';
			else
				std::cout << ' ';
			}
		std::cout << "\n";
		}
	}
	// Now brag about the results and exit the program.
	std::cout << "\n\n" << "Pretty sweet, huh?" << "\n\n";
	return 0;
}