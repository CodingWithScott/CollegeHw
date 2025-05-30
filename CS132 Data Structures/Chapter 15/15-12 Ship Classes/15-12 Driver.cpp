// Scott Felch
// Exercise 15-12, Ship Derived Classes
#include <iostream>
#include "Ship.h"
#include "CruiseShip.h"
#include "CargoShip.h"
using namespace std;

int main()
{
	Ship* fun_array[3];	// Create an array of pointers to 3 different kinds of ships
	fun_array[0] = new Ship("SS Ship", "2010");	// Create a new Ship named SS Ship, made in 2010
	fun_array[1] = new CruiseShip("SS Rich People", "2009", 5000);	// Create a cruise ship that holds 5000 people
	fun_array[2] = new CargoShip("SS Carry Lots O Stuff", "2005", 4000);	// Create a cargo ship that holds 4000 tons of stuff
	
	cout << "This program will manage different kinds of ships.\n";

	// Output each ship and its info
	for (int count = 0; count < 3; count++)
	{
		fun_array[count]->print();
		cout << "\n";
	}
	
	return 0;
}