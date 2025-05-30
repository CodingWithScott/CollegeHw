// Implementation file for Inventory		
// Mutator functions
#include "Inventory.h"

void Inventory::setItemNumber(int item_num)
{
	item_number = item_num;
}
void Inventory::setQuantity(int quant)
{
	quantity = quant;
}
void Inventory::setCost(double c)
{
	cost = c;
}
void Inventory::setTotalCost()
{
	total_cost = quantity * cost;
}
int Inventory::getItemNumber()		// Get item's ID number
{	return item_number;	}
int Inventory::getQuantity()		// Get item quantity
{	return quantity;	}
double Inventory::getCost()		// Get item individual cost
{	return cost;		}
double Inventory::getTotalCost()	// Get total item cost (quantity * cost)
{	return total_cost;	}

// Constructor #1, default constructor, everything set to 0
Inventory::Inventory()
{
	item_number = 0;
	quantity = 0;
	cost = 0.0;
	total_cost = 0.0;
}
// Constructor #2, accepts item_number, cost, and quantity as arguments
Inventory::Inventory(int item_num, double cost, int quant)
{
	item_number = item_num;
	quantity = quant;
	cost = cost;
	setTotalCost();
}