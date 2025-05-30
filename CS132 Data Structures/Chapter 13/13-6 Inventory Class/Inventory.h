// Specification file for the Inventory class, using constructors.
#ifndef EMPLOYEECLASS_H
#define EMPLOYEECLASS_H

#include <string>

class Inventory
{
	private:
		int item_number;	// Inventory item's number
		int quantity;		// Amount of given item on hand
		double cost;		// Wholesale cost of the item
		double total_cost;	// Total inventory cost of the item (total_cost = quantity * cost)

	public:
		Inventory(int item_number, double cost, int quantity);	/* Constructor 
									accepting item number, cost, and quantity. */
		Inventory();	// Default constructor which accepts all blank entries
		void setItemNumber(int item_number);
		void setQuantity(int quant);
		void setCost(double cost);
		void setTotalCost();
		int getItemNumber();	// Get item ID number
		int getQuantity();		// Get item quantity
		double getCost();		// Get item individual cost
		double getTotalCost();	// Get total item cost (quantity * cost)

};
#endif