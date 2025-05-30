// Scott Felch
// 22 April 2010
// CS 131, Keith Laidig
// Exercise 6-2
/* This program will accept a numerical grade and output the corresponding letter grade. Unlike
exercise 6-1, this will also include a + or - modifier on a grade. For example, an 83% would be a B-
instead of B. */

#include <iostream>
#include <string>

float num_grade;				/* Numerical grade, provided by user. I made it a float in case a user 
								gets a decimal in their grade, like 85.7%. */
std::string let_grade;			// Letter grade to be output

int main()
{
	// First I explain to the user the purpose of the program and gather their input.
	std::cout << "This program will convert your numerical grade to a letter grade.\n";
	std::cout << "Please enter the numerical grade:    ";
	std::cin >> num_grade;

	// Next I determine what letter grade they will receive
	if (num_grade >= 98)
		let_grade = "A+";
	else if (num_grade >= 94)
		let_grade = "A";
	else if (num_grade >= 91)
		let_grade = "A-";
	else if (num_grade >= 88)
		let_grade = "B+";
	else if (num_grade >= 84)
		let_grade = "B";
	else if (num_grade >= 81)
		let_grade = "B-";
	else if (num_grade >= 78)
		let_grade = "C+";
	else if (num_grade >= 74)
		let_grade = "C";
	else if (num_grade >= 71)
		let_grade = "C-";
	else if (num_grade >= 68)
		let_grade = 'D+';
	else if (num_grade >= 64)
		let_grade = 'D';
	else if (num_grade >= 61)
		let_grade = 'D-';
	else if (num_grade >= 0)
		let_grade = 'F';
	else
		std::cout << "Invalid entry. Please enter a number greater than 0.";

	// Now output the results
	std::cout << "Your letter grade is " << let_grade << "\n\n";

	return (0);
}