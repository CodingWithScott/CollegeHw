#ifndef CIRCLE_H
#define CIRCLE_H
#include "BasicShape.h"

class Circle : public BasicShape
{
	private:
		long centerX;		// Long integer to hold the X coordinate of circle's center
		long centerY;		// Long integer to hold the Y coordinate of circle's center
		double radius;		// Double to hold the radius of the circle
	public:
		Circle();			// Default constructor, sets values to 0
		Circle(long, long, double);	// Overloaded constructor, accepts values for center coordinates and radius
		long getCenterX();	// Return X coordinate of circle's center
		long getCenterY();	// Return Y coordinate of circle's center
		virtual double calcArea() const;	// Overriden calcArea function, defined in Circle.cpp
		void print();		// Print out data for the circle object
};

#endif