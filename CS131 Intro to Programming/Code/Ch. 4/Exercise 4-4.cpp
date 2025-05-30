// Scott Felch
// 8 April 2010
// CS 131, Keith Laidig
// Exercise 4-4
/* This program will print out the word "HELLO" in big block letters where each letter is 7 characters
high and 5 characters wide, just like in exercise 4-2 but bigger and more epic.*/

#include <iostream>

/* I intentionally made all the variables the same length so that when you look at the
code it lines up in the same manner it will when it is compiled. Much easier to edit 
this way. */
char l_h = 'H';		// The letter H
char l_e = 'E';		// The letter E
char l_l = 'L';		// The letter L
char l_o = 'O';		// The letter O
char spc = ' ';		// A space

int main()
{
	// If you look carefully, this gigantic obfuscated hunk of code actually spells out HELLO.	
	std::cout << l_h << l_h << spc << l_h << l_h << '\t' << l_e << l_e << l_e << l_e << l_e << '\t' << l_l << l_l << spc << spc << spc << '\t' << l_l << l_l << spc << spc << spc << '\t' << l_o << l_o << l_o << l_o << l_o << '\n';
	std::cout << l_h << l_h << spc << l_h << l_h << '\t' << l_e << l_e << l_e << l_e << l_e << '\t' << l_l << l_l << spc << spc << spc << '\t' << l_l << l_l << spc << spc << spc << '\t' << l_o << l_o << l_o << l_o << l_o << '\n';
	std::cout << l_h << l_h << spc << l_h << l_h << '\t' << l_e << l_e << spc << spc << spc << '\t' << l_l << l_l << spc << spc << spc << '\t' << l_l << l_l << spc << spc << spc << '\t' << l_o << l_o << spc << l_o << l_o << '\n';
	std::cout << l_h << l_h << l_h << l_h << l_h << '\t' << l_e << l_e << l_e << l_e << spc << '\t' << l_l << l_l << spc << spc << spc << '\t' << l_l << l_l << spc << spc << spc << '\t' << l_o << l_o << spc << l_o << l_o << '\n';
	std::cout << l_h << l_h << spc << l_h << l_h << '\t' << l_e << l_e << spc << spc << spc << '\t' << l_l << l_l << spc << spc << spc << '\t' << l_l << l_l << spc << spc << spc << '\t' << l_o << l_o << spc << l_o << l_o << '\n';
	std::cout << l_h << l_h << spc << l_h << l_h << '\t' << l_e << l_e << l_e << l_e << l_e << '\t' << l_l << l_l << l_l << l_l << l_l << '\t' << l_l << l_l << l_l << l_l << l_l << '\t' << l_o << l_o << l_o << l_o << l_o << '\n';
	std::cout << l_h << l_h << spc << l_h << l_h << '\t' << l_e << l_e << l_e << l_e << l_e << '\t' << l_l << l_l << l_l << l_l << l_l << '\t' << l_l << l_l << l_l << l_l << l_l << '\t' << l_o << l_o << l_o << l_o << l_o << "\n\n";

	return (0);
}