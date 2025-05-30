#include "CruiseShip.h"
#include <iostream>
using namespace std;

CruiseShip::CruiseShip()	
{	// Default constructor, blank passenger limit
	passengers = 0;
}


CruiseShip::CruiseShip(string n, string y, int p) : Ship(n, y)
{	// Overloaded constructor, accepts user value for name, year, and passenger capacity
	passengers = p;
}

void CruiseShip::setName(string n)	
{	// Mutator to set the name of the cargo ship
	Ship::setName(n);
}

void CruiseShip::setYear(string y)	
{	// Mutator to set the year of the cargo ship
	Ship::setYear(y);
}

string CruiseShip::getName()	
{	// Accessor to retrieve name of the cargo ship
	return Ship::getName();
}

string CruiseShip::getYear()	
{	// Accessor to retrieve the year of the cargo ship
	return Ship::getYear();
}

void CruiseShip::print()	
{	// Function to print out the cruise ship's information
	cout << "Ship information:\n";
	cout << "\tName:  " << getName() << endl;
	cout << "\tYear:  " << getYear() << endl;
	cout << "\tPassengers:  " << passengers << endl;
}