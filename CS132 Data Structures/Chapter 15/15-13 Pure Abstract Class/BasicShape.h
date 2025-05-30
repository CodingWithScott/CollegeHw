/* Header file for the BasicShape abstract class. Area is a double, getArea is declared inline,
calcArea is a pure virtual function and will be declared in derived classes later. */
#ifndef BASICSHAPE_H
#define BASICSHAPE_H

class BasicShape
{
	private:
		double area;				// Area of the shape
	public:
		double getArea()			// Retrieve area of the shape
			{ return area; }
		virtual double calcArea() const = 0;	/* Pure virtual function, will calculate area of the shape
											in derived classes. */
};


#endif