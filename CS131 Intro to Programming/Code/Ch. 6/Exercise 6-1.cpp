// Scott Felch
// 22 April 2010
// CS 131, Keith Laidig
// Exercise 6-1
/* This program will accept a numerical grade and output the corresponding letter grade. 
0-60 = F, 61-70 = D, 71-80 = C, 81-90 = B, 91-100 = A. */

#include <iostream>

float num_grade;		// Numerical grade, provided by user
char let_grade;			// Letter grade to be output

int main()
{
	// First I explain to the user the purpose of the program and gather their input.
	std::cout << "This program will convert your numerical grade to a letter grade.\n";
	std::cout << "Please enter the numberical grade:    ";
	std::cin >> num_grade;

	// Next I determine what letter grade they will receive
	if (num_grade >= 91)
		let_grade = 'A';
	else if (num_grade >= 81)
		let_grade = 'B';
	else if (num_grade >= 71)
		let_grade = 'C';
	else if (num_grade >= 61)
		let_grade = 'D';
	else if (num_grade >= 0)
		let_grade = 'F';
	else
		std::cout << "Invalid entry. Please enter a number greater than 0.";

	// Now output the results
	std::cout << "Your letter grade is " << let_grade << "\n\n";

	return (0);
}