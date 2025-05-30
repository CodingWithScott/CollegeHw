#include "CargoShip.h"
#include <iostream>
using namespace std;

CargoShip::CargoShip()	
{	// Default constructor, blank carrying capacity
	capacity = 0;
}

CargoShip::CargoShip(string n, string y, int c) : Ship(n, y)	
{	// Overloaded constructor, accepts user value for name, year, and capacity
	capacity = c;
}

void CargoShip::setName(string n)	
{	// Mutator to set the name of the cargo ship
	Ship::setName(n);
}

void CargoShip::setYear(string y)	
{	// Mutator to set the year of the cargo ship
	Ship::setYear(y);
}

string CargoShip::getName()	
{	// Accessor to retrieve name of the cargo ship
	return Ship::getName();
}

string CargoShip::getYear()	
{	// Accessor to retrieve the year of the cargo ship
	return Ship::getYear();
}

void CargoShip::print()	
{	// Function to print out the cargo ship's information
	cout << "Ship information:\n";
	cout << "\tName:  " << getName() << endl;
	cout << "\tYear:  " << getYear() << endl;
	cout << "\tCapacity:  " << capacity << endl;
}