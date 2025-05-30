#ifndef CARGOSHIP_H
#define CARGOSHIP_H
#include "Ship.h"
#include <iostream>
#include <string>
using namespace std;

class CargoShip : public Ship
{
	private:
		int capacity;					// Carrying capacity of the ship in tons
	public:
		CargoShip();					// Default constructor
		CargoShip(string, string, int);	// Overloaded constructor, accepts an argument for capacity of ship
		void setName(string);			// Mutator to set the name of the ship
		void setYear(string);			// Mutator to set the year of the ship
		void setCapacity(int);			// Mutator to set the capacity of the ship (in tons)
		string getName();				// Accessor to get the name of the ship
		string getYear();				// Accessor to get the year of the ship
		int getCapacity();				// Accessor to get the capacity of the ship (in tons)
		virtual void print();			// Function to print the data of the CargoShip class
};
#endif