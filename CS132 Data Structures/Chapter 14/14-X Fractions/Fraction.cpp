#include "Fraction.h"
#include <iostream>
using namespace std;

// Default constructor, creates a Fraction type class with the values 0/0
Fraction::Fraction()
{
	num = 0;
	den = 0;
}
/* Overloaded constructor, creates a Fraction type class. Takes two ints, n = numerator
d = denominator	*/
Fraction::Fraction(int n, int d)	
{
	num = n;
	den = d;
}

int Fraction::getNum()	// Return the numerator of a fraction
{
	return num;
}

int Fraction::getDen()	// Return the denominator of a fraction
{
	return den;
}

Fraction Fraction::operator +(Fraction &frac2)
{
	Fraction temp;		// Temporary fraction instance to hold frac1 during computations
	Fraction temp2;		// Temporary fraction instance to hold frac2 during computations
	int common_den;		// Common denominator for the two fractions
	int com_den_div;	/* Common denominator divisor. Number to multiply both numerator and denominator by to 
			get the common denominator. For example, if the fraction is 1/2 and the CD is 8, both top and bottom
			would be multiplied by 4 to reach the common denominator. 4 = com_den_div */

	// Determine common denominator by multiplying the two denominators, will worry about simplifying later
	// For the sake of the examples in comments, I'll use fractions 1/2 and 1/4
	common_den = this->den * frac2.den;		// Ex:	2 * 4 = common denominator of 8
	com_den_div = common_den / this->den;	// Ex:	8 / 2 = common denominator divisor of 4
	//cout << "common denominator = " << common_den << endl;
	//cout << "common denominator divisor = " << com_den_div << endl;
	temp.num = this->num * com_den_div;	// Ex: 1 * 4 = 4
	temp.den = this->den * com_den_div;	// Ex: 2 * 4 = 8
	// 1/4 has now become 2/8
	
	com_den_div = common_den / frac2.den;	// Ex:	8 / 4 = 2
	temp2.num = frac2.num * com_den_div;	// Ex: 1 * 4 = 8
	temp2.den = frac2.den * com_den_div;	// Ex: 2 * 4 = 8
	// 1/2 has now become 4/8

	temp.den = common_den;
	temp.num = temp.num + temp2.num;		// Ex: 1/2 + 1/4 became 4/8 + 2/8 = 6/8

	temp = simplify();	// Ex: 6/8 becomes 3/4
	return temp;
}

Fraction Fraction::operator -(Fraction &frac2)
{
	Fraction temp;		// Temporary function to hold Fraction operator +(Fraction, Fraction)
	int common_den;		// Common denominator for the two fractions
	int com_den_div;	/* Common denominator divisor. Number to multiply both numerator and denominator by to 
			get the common denominator. For example, if the fraction is 1/2 and the CD is 8, both top and bottom
			would be multiplied by 4 to reach the common denominator. 4 = com_den_div */

	// Determine common denominator by multiplying the two denominators, will worry about simplifying later
	// For the sake of the examples in comments, I'll use fractions 1/2 and 1/4
	common_den = this->den * frac2.den;		// Ex:	2 * 4 = common denominator of 8
	com_den_div = common_den / this->den;	// Ex:	8 / 2 = common denominator divisor of 4
	//cout << "common denominator = " << common_den << endl;
	//cout << "common denominator divisor = " << com_den_div << endl;
	this->num = this->num * com_den_div;	// Ex: 1 * 4 = 4
	this->den = this->den * com_den_div;	// Ex: 2 * 4 = 8
	// 1/4 has now become 2/8
	
	com_den_div = common_den / frac2.den;	// Ex:	8 / 4 = 2
	frac2.num = frac2.num * com_den_div;	// Ex: 1 * 4 = 8
	frac2.den = frac2.den * com_den_div;	// Ex: 2 * 4 = 8
	// 1/2 has now become 4/8

	temp.den = common_den;
	temp.num = this->num - frac2.den;	// Ex: 1/2 - 1/4 became 4/8 - 2/8 = 2/8

	temp = simplify();	// Call simplify function prior to returning value 
	return temp;	// Ex: 2/8 becomes 1/4
}

Fraction Fraction::operator *(Fraction &frac2)
{
	Fraction temp;	// Temporary variable to hold Fraction while using the * operator

	temp.num = this->num * frac2.num;
	temp.den = this->den * frac2.den;

	temp = simplify();	// Call simplify function prior to returning value
	return temp;	// Ex: 2/8 becomes 1/4
}

// This function is almost identical to the multiplication function, except the second fraction is flipped
Fraction Fraction::operator /(Fraction &frac2)
{
	Fraction temp;	// Temporary variable to hold Fraction while using the / operator

	temp.num = this->num * frac2.den;
	temp.den = this->den * frac2.num;

	temp = simplify();	// Call simplify function prior to returning value
	return temp;	// Ex: 2/8 becomes 1/4
}

// Blatantly and shamelessly plagiarized from http://www.gidforums.com/t-20416.html
// Simplify operation receives a fraction by reference and returns the simplified fraction
 //Trying Euclidian method below...
Fraction Fraction::simplify()
{	// Ex: 4/8 becomes 1/2
	int div;	// Number to divide top and bottom by
	int count;	// Counter to be used in a for loop

	if (num < den)
		div = den;
	else
		div = num;
	for (count = div; count > 0; count--)
	{
		if ((num % count == 0) && (den % count == 0))
		{
			num = num / count;
			den = den / count;
		}
	}
	return *this;	// Return simplified fraction
}	

// Overloading the << operator for easier output
ostream &operator << (ostream &strm, const Fraction &frac)
{
	strm << frac.num << "/" << frac.den;
	return strm;
}