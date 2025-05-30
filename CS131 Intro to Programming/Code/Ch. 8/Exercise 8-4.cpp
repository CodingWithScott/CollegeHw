// Scott Felch
// 27 April 2010
// CS 131, Keith Laidig
/* Exercise 8-4. This program will print out the multiplication table from 1 to 10, similar to problem 8-1. */

#include <iostream>

int row;		// Variable to keep track of current row.
int column;		// Variable to keep track of current column.

int main()
{
	std::cout << "This program will help you memorize your multiplication tables!\n\n";

	// The outer loop keeps track of which row is being printed. The inner loop executes 10 times, printing
	// each constant, before printing a carriage return, moving to the next row and beginning again. 
	for (row = 1; row < 11; row++)
	{
		for (column = 1; column < 11; column++)
			std::cout << (row * column) << "   ";
		std::cout << "\n";
	}
	// Exit program.
	return 0;
}
