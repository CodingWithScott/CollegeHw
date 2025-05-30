#include "PreferredCustomer.h"
#include <iostream>
using namespace std;

PreferredCustomer::PreferredCustomer() : CustomerData()
{	// Default constructor for PreferredCustomer class
	purchasesAmount = 0.0;
}

PreferredCustomer::PreferredCustomer(string ln, string fn, string ad, string ci, string st, int zi, string ph, int cn, bool ml, double pa) : CustomerData()
{	// Overloaded constructor for PreferredCustomer class
	setMailingList(ml);
	setLastName(ln);
	setFirstName(fn);
	setAddress(ad);
	setCity(ci);
	setState(st);
	setZip(zi);
	setPhone(ph);
	setCustomerNumber(cn);

	// Error checking to make sure the user enters a positive amount for "purchasesAmount"
	bool valid = false;
	if (pa > 0)
		valid = true;
	while (!valid)
	{
		cout << "Purchase amount can't be negative. Please enter positive purchase amount:  ";
		cin >> purchasesAmount;
		if (pa > 0)
			valid = true;
	}
	purchasesAmount = pa;
}

void PreferredCustomer::setPurchasesAmount(double pa)
{	// Set purchase amount
	purchasesAmount = pa;
}

double PreferredCustomer::getPurchasesAmount()
{	// Return purchase amount
	return purchasesAmount;
}

double PreferredCustomer::getDiscountLevel()
{	// Determine amount of discount level 
	if (purchasesAmount < 500)	
		discountLevel = 0;		// Less than $500 in purchases gets no discount
	else if (purchasesAmount >= 500 && purchasesAmount < 1000)
		discountLevel = 0.05;	// $500 or more in purchases gets 5% discount
	else if (purchasesAmount >= 1000 && purchasesAmount < 1500)
		discountLevel = 0.06;	// $1000 or more in purchases gets 6% discount
	else if (purchasesAmount >= 1500 && purchasesAmount < 2000)
		discountLevel = 0.07;	// $1500 or more in purchases gets 7% discount
	else if (purchasesAmount >= 2000)
		discountLevel = 0.10;	// $2000 or more in purchases gets 10% discount
	
	return discountLevel;
}

void PreferredCustomer::print()
{	// Print out contents of CustomerData using accessor functions
	cout << "PreferredCustomer class contents:\n";
		cout << "\tLast name:\t" << getLastName() << endl;
	cout << "\tFirst name:\t" << getFirstName() << endl;
	cout << "\tAddress:\t" << getAddress() << endl;
	cout << "\tCity:\t\t" << getCity() << endl;
	cout << "\tState:\t\t" << getState() << endl;
	cout << "\tZip:\t\t" << getZip() << endl;
	cout << "\tPhone number:\t" << getPhone() << "\n\n";
	cout << "\tCustomer number:\t" << getCustomerNumber() << endl;
	cout << "\tMailing list status:\t" << getMailingList() << "\n\n";
	cout << "\tPurchases amount:\t" << "$" << getPurchasesAmount() << endl;
	cout << "\tDiscount level:\t\t" << (getDiscountLevel() * 100) << "%" << endl;
}
