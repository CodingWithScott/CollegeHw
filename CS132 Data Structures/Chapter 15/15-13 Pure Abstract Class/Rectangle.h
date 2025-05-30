#ifndef RECTANGLE_H
#define RECTANGLE_H
#include "BasicShape.h"

class Rectangle : public BasicShape
{
	private:
		long width;							// Width of the rectangle
		long length;						// Length of the rectangle
		long area;							// Area of the rectangle
		long perimeter;						// Perimeter of the rectangle
	public:
		Rectangle();						// Default constructor
		Rectangle(long, long);				// Overloaded constructor, accepts values for width and length
		long getWidth();					// Retrieve width of the rectangle
		long getLength();					// Retrieve length of the rectangle
		virtual double calcArea() const;		// Overriden calcArea function, defined in Rectangle.cpp
		void print();						// Print out the data for the rectangle object
};
#endif