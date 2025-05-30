// Scott Felch
// 13 April 2010
// CS 131, Keith Laidig
// Exercise 5-2
/* This program will accept a user input for the radius of a sphere, then calculate the total volume
assuming the formula:		volume = (4/3) * pi * r^3	*/

#include <iostream>

/* I put pi in as a constant since it won't be changing at any point and it looks less messy
in the calculations part of the code. */
float PI = 3.141592653589;
float radius;
float volume;

int main()
{
	// First I'll explain to the user the purpose of the program and gather their input
	std::cout << "This program will calculate the volume a sphere for you, given the radius.\n";
	std::cout << "Please enter the radius of the sphere in centimeters:   ";
	std::cin >> radius;

	/* Now I'll perform the calculation. I put in radius times itself three times instead
	of using the power function because Keith asked us to. */
	volume = (4.0/3.0) * PI * radius * radius * radius; 

	// Now output the results
	std::cout << "The volume of that sphere is " << volume << " cubic centimeters\n\n";

	return(0);
}