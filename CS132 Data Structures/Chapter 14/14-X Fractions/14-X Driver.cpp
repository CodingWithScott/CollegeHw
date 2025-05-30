// Scott Felch
/* Exercise 14-X. This program will add, subtract, multiply and divide fractions
using overloaded operators. */
#include <iostream>
#include "Fraction.h"
using namespace std;

int main()
{
	int num = 0;		// Numerator
	int den = 0;		// Denominator
	Fraction answer;	// Fraction that will be the resulting answer
	//Fraction test(8, 4);
	//cout << test << endl;

	cout << "This program will help you make computations with fractions.\n";
	cout << "First, let me know what numbers you'll be working with.\n\n";
	cout << "For fraction #1...\n";
	cout << "Please enter the numerator:\t";
	cin >> num;
	cout << "Please enter the denominator:\t";
	cin >> den;
	Fraction frac1(num, den);	// Call the constructor to make fraction #1

	cout << "\nFor fraction #2...\n";
	cout << "Please enter the numerator:\t";
	cin >> num;
	cout << "Please enter the denominator:\t";
	cin >> den;
	Fraction frac2(num, den);	// Call the constructor to make fraction #2

	int user_operator;	// User's choice of what math operation to do
	cout << "\nOkay, now we can do some math!\n";
	cout << "1. Add (+)\n";
	cout << "2. Subtract (-)\n";
	cout << "3. Multiply (*)\n";
	cout << "4. Divide (\\)\n";
	cout << "5. Exit program\n";
	cin >> user_operator;

	while (user_operator != 5)
	{
		if (user_operator == 1)	
		{	// Perform addition
			answer = frac1 + frac2;
			break;
		}
		else if (user_operator == 2)
		{	// Perform subtraction
			answer = frac1 - frac2;
			break;
		}
		else if (user_operator == 3)
		{	// Perform multiplication
			answer = frac1 * frac2;
			break;
		}
		else if (user_operator == 4)
		{	// Perform division
			answer = frac1 / frac2;
			break;
		}
		else if (user_operator == 5)
			break;	// Exit program without performing a calculation
	}

	cout << "Fraction 1:\t" << frac1 << "\n";
	cout << "Fraction 2:\t" << frac2 << "\n";
	cout << "Answer:\t\t" << answer << "\n\n";
	cout << "Well that was fun!\n\n";

	return 0;
}