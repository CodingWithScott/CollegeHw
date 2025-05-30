#include "Rectangle.h"
#include <iostream>
using namespace std;

Rectangle::Rectangle()
{	// Default constructor, sets width and length to 0
	width = 0;
	length = 0;
	area = 0;
	perimeter = 0;
}

Rectangle::Rectangle(long w, long l)
{	// Overloaded constructor, accepts arguments for width and length
	width = w;
	length = l;
	area = calcArea();
	perimeter = (width * 2) + (length * 2);
}

long Rectangle::getWidth()
{	// Retrieve width of the rectangle
	return width;
}

long Rectangle::getLength()
{	// Retrieve length of the rectangle
	return length;
}

double Rectangle::calcArea() const
{	// Calculate the area of the rectangle
	return (width * length);
}

void Rectangle::print()
{	// Print out the data for the rectangle object
	cout << "Width:\t\t" << width << "\n";
	cout << "Length:\t\t" << length << "\n";
	cout << "Area:\t\t" << area << "\n";
	cout << "Perimeter:\t" << perimeter << "\n";
}