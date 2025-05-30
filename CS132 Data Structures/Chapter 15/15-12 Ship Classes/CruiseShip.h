#ifndef CRUISESHIP_H
#define CRUISESHIP_H
#include "Ship.h"
#include <string>
#include <iostream>
using namespace std;

class CruiseShip : public Ship
{
	private:
		int passengers;						// Number of passengers the ship can hold

	public:
		CruiseShip();						// Default constructor
		CruiseShip(string, string, int);	// Overloaded constructor, accepts int for max number of passengers
		void setName(string);				// Mutator to set the name of the ship
		void setYear(string);				// Mutator to set the year of the ship
		void setPassengers(int);			// Mutator to set the number of passengers the ship can hold
		string getName();					// Accessor to retrieve the name of the ship
		string getYear();					// Accessor to retrieve the year of the ship
		int getPassengers();				// Accessor to retrieve the number of passengers the ship can hold
		virtual void print();				// Print out the cruise ship's information
};
#endif