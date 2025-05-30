// Scott Felch
// 6 April 2010
// CS 131, Keith Laidig
// Exercise 4-1
// This program is going to print out my name, social security number, and date of birth.

#include <iostream>

// Since we can't use strings yet, here I'm establishing variables for each individual letter of my first name...
char letter_s = 'S';
char letter_c = 'c';
char letter_o = 'o';
char letter_t = 't';

// Middle name... (excluding characters already in my first name)
char letter_a = 'A';
char letter_n = 'n';
char letter_h = 'h';
char letter_y = 'y';

// Last name...
char letter_f = 'F';
char letter_e = 'e';
char letter_l = 'l';

// And birth month (cuz it looks better outputting in characters than in all numbers, in my opinion)
char letter_N = 'N';
char letter_v = 'v';
char letter_m = 'm';
char letter_b = 'b';
char letter_r = 'r';

// I'm using ints to hold the values for my birth date and birth year.
int bdate = 25;
int byear = 1987;

int main()
{
	// Now begins the tedious process of outputting everything manually one character at a time.
	std::cout << "My name is " << letter_s << letter_c << letter_o << letter_t << letter_t << ' ' <<
		letter_a << letter_n << letter_t << letter_h << letter_o << letter_n << letter_y << ' ' <<
		letter_f << letter_e << letter_l << letter_c << letter_h << '\n';
	std::cout << "My date of birth is " << bdate << ' ' << letter_N << letter_o << letter_v << letter_e << letter_m
		<< letter_b << letter_e << letter_r << ' ' << byear << '\n';

	return (0);
}