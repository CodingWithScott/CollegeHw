// Scott Felch
// 13 April 2010
// CS 131, Keith Laidig
// Exercise 5-1
// This program will accept a user input for the temperature in Celsius, and then convert
// it to Fahrenheit.

#include <iostream>

float temp_f;		// Temperature in Fahrenheit
float temp_c;		// Temperature in Celsius

int main()
{
	// Here I'll tell the user I'm looking for the temp in Celsius and let them input that
	std::cout << "Please enter a temperature, in Celsius:   ";
	std::cin >> temp_c;

	// Here I calculate the temperature in Fahrenheit, using the info just given by the user
	temp_f = ((9.0/5.0) * temp_c) + 32;

	// Lastly, output the results
	std::cout << "That temperature in Fahrenheit is " << temp_f << " degrees\n\n";

	return(0);
}