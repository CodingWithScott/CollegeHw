// Scott Felch
// 13 April 2010
// CS 131, Keith Laidig
// Exercise 5-3
/* This program will accept user input for a rectangle's height and width, then print 
out the perimeter. */

#include <iostream>

// Declare my variables. I'll use floats instead of ints, in case the user likes to use decimal places.
float width;		// Width of the rectangle in centimeters
float height;		// Height of the rectangle in centimeters
float perim;	// Perimeter of the rectangle in centimeters

int main()
{
	// First I'll explain to the user the purpose of the program and gather input
	std::cout << "This program will calculate the perimeter of a rectangle for you.\n";
	std::cout << "Please enter the rectangle's width:\t";
	std::cin >> width;
	std::cout << "Please enter the rectangle's height:\t";
	std::cin >> height;

	// Now perform the calculation
	perim = 2 * (width + height);

	// And output the result
	std::cout << "\nThe perimeter of the rectangle is " << perim << " centimeters.\n\n";

	return (0);
}