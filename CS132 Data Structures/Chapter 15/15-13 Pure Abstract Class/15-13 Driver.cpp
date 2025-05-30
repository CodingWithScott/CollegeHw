// Scott Felch
// 1 November 2010
// Exercise 15-13, Pure Abstract Base Class
#include <iostream>
#include "BasicShape.h"
#include "Circle.h"
#include "Rectangle.h"
using namespace std;

int main()
{
	Circle circle1(5, 10, 11.2);	// Defines a circle with X-coord 5, Y-coord 10, radius 11.2
	Rectangle rectangle1(11, 9);	// Defines a rectangle with width 11, length 9

	// Now output the data from the objects
	cout << "Circle data\n";
	cout << "-------------------\n";
	circle1.print();
	cout << "\n";
	cout << "Rectangle data\n";
	cout << "-------------------\n";
	rectangle1.print();
	cout << "\nWell that was fun! See ya later!\n\n";

	return 0;
}