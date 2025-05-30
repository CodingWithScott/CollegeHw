#ifndef PREFERREDCUSTOMER_H
#define PREFERREDCUSTOMER_H
#include "CustomerData.h"

class PreferredCustomer : public CustomerData
{
	private:
		double purchasesAmount;				// Total amount of purchases made, used to determine discount level
		double discountLevel;				// Percentage of discount the customer gets on purchases
	public:
		PreferredCustomer();				// Default constructor
		/* Overloaded constructor, accepts arguments for lastName, firstName, address, city, 
		state, zip, customer number, mailing list status, and purchase amount */
		PreferredCustomer(string, string, string, string, string, int, string, int, bool, double);
		void setPurchasesAmount(double);	// Set the amount of stuff purchased so far
		double getPurchasesAmount();		// Return the value of total purchases
		double getDiscountLevel();			// Return the discount level the customer has achieved
		virtual void print();				// Print out contents of the PreferredCustomer class
};
#endif