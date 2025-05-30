// Scott Felch
// 6 Octobor 2010
// 13-6, Inventory Class. Note to self: p.781 is very useful

#include <iostream>
#include <iomanip>
#include "Inventory.h"
using namespace std;

int main()
{
	// This program will demonstrate the Inventory class
	Inventory VideoGame;	// Construct an Inventory item, all data specified
	VideoGame.setItemNumber(1337);		// Set item number
	VideoGame.setQuantity(100);			// Set quantity of item
	VideoGame.setCost(49.99);			// Set item cost
	VideoGame.setTotalCost();		// Set total item cost

	Inventory Movie;	// Constrct an Inventory item, let default constructor provide blank values

	cout << "The following items are in inventory:\n";
	cout << setprecision(2) << fixed << showpoint;

	// Display data for 1st item
	cout << "Description:	Video Game" << endl;
	cout << "Item number: " << VideoGame.getItemNumber() << endl;
	cout << "Units on hand: " << VideoGame.getQuantity() << endl;
	cout << "Cost: $" << VideoGame.getCost() << endl;
	cout << "Total cost: $" << VideoGame.getTotalCost() << endl;
	
	// Display data for 2nd item
	cout << "Description:	Movie" << endl;
	cout << "Item number: " << Movie.getItemNumber() << endl;
	cout << "Units on hand: " << Movie.getQuantity() << endl;
	cout << "Cost: $" << Movie.getCost() << endl;
	cout << "Total cost: $" << Movie.getTotalCost() << endl;
}
	
