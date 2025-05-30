#include "Ship.h"
#include <iostream>
using namespace std;

Ship::Ship()	
{	// Default constructor, blank name and year
	name = "";
	year = "";
}

Ship::Ship(string n, string y)	
{	// Overloaded constructor, accepts user values for name and year
	name = n;
	year = y;
}

void Ship::setName(string n)	
{	// Mutator to set the name of the ship
	name = n;
}

void Ship::setYear(string y)	
{	// Mutator to set the year of the ship
	year = y;
}

string Ship::getName()	
{	// Accessor to retrieve name of the ship
	return name;
}

string Ship::getYear()	
{	// Accessor to retrieve the year of the ship
	return year;
}

void Ship::print()	
{	// Function to print out the ship's information
	cout << "Ship information:\n";
	cout << "\tName:  " << name << endl;
	cout << "\tYear:  " << year << endl;
}