// Header file for an abstract Ship class
#ifndef SHIP_H
#define SHIP_H
#include <string>
using namespace std;

class Ship
{
	private: 
		string name;			// Name of the ship
		string year;			// Year the ship was manufactured
	public:
		Ship();					// Default constructor
		Ship(string, string);	// Overloaded constructor, accepts a string for name and string for year
		void setName(string);	// Set the name of the ship
		void setYear(string);	// Set the year of the ship
		string getName();		// Retrieve the name of the ship
		string getYear();		// Retrieve the year of the ship
		virtual void print();	// Print function, not used here but will be for CruiseShip and CargoShip
};
#endif