#ifndef FRACTIONS_H
#define FRACTIONS_H
#include <string>
using namespace std;

class Fraction
{
	private:
		int num;	// Numerator
		int den;	// Denominator
	public:
		Fraction();				// Default constructor, sets values to 0
		Fraction(int num, int den);	// Overloaded constructor, receives two ints for numerator and denominator
		void setNum(int);			// Function to set numerator
		int getNum();				// Return value of numerator
		int getDen();				// Return value of denominator

		Fraction operator+ (Fraction &);		// Overloading addition operator, receives a reference to 1 fraction
		Fraction operator- (Fraction &);		// Overloading subtraction operator, receives a reference to 1 fraction
		Fraction operator* (Fraction &);		// Overloading multiplication operator, receives a reference to 1 fraction
		Fraction operator/ (Fraction &);		// Overloading division operator, receives a reference to 1 fraction
		Fraction simplify();	/* Simplify a fraction to its lowest form. 4/8 becomes 1/2, receives
										a reference to 1 fraction */
		friend ostream &operator << (ostream &, const Fraction &);	// Overloading the << operator for easier output

};
#endif

/* Fun stuff to keep around but not use in this program
a operator ++();			// Overloading prefix incrementor
a operator ++(int);			// Overloading postfix incrementor

*/
