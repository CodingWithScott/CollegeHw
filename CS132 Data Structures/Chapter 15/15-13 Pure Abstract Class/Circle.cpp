#include "Circle.h"
#include <iostream>
using namespace std;

Circle::Circle()
{	// Default constructor, initializes values to defaults
	centerX = 0;
	centerY = 0;
	radius = 0.0;
}

Circle::Circle(long cx, long cy, double r)
{	// Overloaded constructor, accepts values for center X coordinate, center Y coordinate, and radius
	centerX = cx;
	centerY = cy;
	radius = r;
}

long Circle::getCenterX()
{	// Retrieve value of center X coordinate
	return centerX;
}

long Circle::getCenterY()
{	// Retrieve value of center Y coordinate
	return centerY;
}

double Circle::calcArea() const	// Overloaded calcArea function, the base calcArea is a pure virtual function
{	// Calculate area of the circle
	return (3.14159 * radius * radius);
}

void Circle::print()
{	// Print out the data relating to the Circle class
	cout << "Center:\t\t(" << centerX << ", " << centerY << ")\n";
	cout << "Radius:\t\t" << radius << "\n";
	cout << "Area:\t\t" << calcArea() << "\n";
}