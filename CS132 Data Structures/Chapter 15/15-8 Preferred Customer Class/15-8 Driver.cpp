// Scott Felch
// 1 November 2010
// Exercise 15-8, Preferred Customer class
#include "PersonData.h"
#include "CustomerData.h"
#include "PreferredCustomer.h"
#include <iostream>
using namespace std;

int main()
{
	cout << "This program will first demonstrate the PersonData class.\n\n";
	// Create a regular old PersonData class
	PersonData person1("Felch", "Scott", "187 N Carpenter Rd", "Snohomish", "WA", 98290, "425-334-1234");
	person1.print();

	// Create a CustomerData class and print out the results
	CustomerData customer1("Felch", "Scott", "187 N Carpenter Rd", "Snohomish", "WA", 98290, "425-334-1234", 12345, true);
	customer1.print();
	
	// Create a PreferredCustomer class using $5000.90 as the argument, and print out the results
	double pamount;
	cout << "\nPlease enter the purchased amount:   ";
	cin >> pamount;
	PreferredCustomer preferred1("Felch", "Scott", "187 N Carpenter Rd", "Snohomish", "WA", 98290, "425-334-1234", 12345, true, pamount);
	cout << "\n";
	preferred1.print();
	return 0;

	// My class constructors got bigger and bigger with class, because I wanted each to class be able to print out everything
	// But I'm not sure I went about this the right way.
}