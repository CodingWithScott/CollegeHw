// Scott Felch
// 8 April 2010
// CS 131, Keith Laidig
// Exercise 4-3
/* This program will computer the area and perimeter of a rectangle 3 inches wide by 5 inches long.*/

#include <iostream>

int height = 3;		// The height of the rectangle in inches, as provided in the original problem.
int width = 5;		// The width of the rectangle in inches, as provided in the original problem.
int area;			// An empty variable which will be used to hold the area of the rectangle, once computed.
int perimeter;		// An empty variable which will be used to hold the perimeter of the rectangle, once computed.

int main()
{
	// Compute the perimeter and height...
	perimeter = 2 * (height + width);
	area = height * width;
	
	// And output the results in a tidy fashion
	std::cout << "Height: \t" << height << '\n';
	std::cout << "Width: \t\t" << width << '\n';
	std::cout << "Area: \t\t" << area << '\n';
	std::cout << "Perimeter: \t" << perimeter << "\n\n";

	return (0);
}