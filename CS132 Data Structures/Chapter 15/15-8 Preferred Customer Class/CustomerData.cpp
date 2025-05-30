#include "CustomerData.h"
#include <iostream>
#include <string>
using namespace std;

CustomerData::CustomerData()
{	// Default constructor, blank customerNumber and mailingList preference
	customerNumber = 0;
	mailingList = false;
}

CustomerData::CustomerData(string ln, string fn, string ad, string ci, string st, int zi, string ph, int cn, bool ml) : PersonData()
{	// Overloaded constructor, accepts user values for customerNumber and mailingList
	// Inherits functions to set values
	customerNumber = cn;
	mailingList = ml;
	setLastName(ln);
	setFirstName(fn);
	setAddress(ad);
	setCity(ci);
	setState(st);
	setZip(zi);
	setPhone(ph);
}

void CustomerData::setCustomerNumber(int cn)
{	// Mutator to set customerNumber
	customerNumber = cn;
}

void CustomerData::setMailingList(bool ml)
{	// Mutator to set mailingList
	mailingList = ml;
}

int CustomerData::getCustomerNumber()
{	// Accessor to retrieve customerNumber
	return customerNumber;
}

string CustomerData::getMailingList()
{	/* Accessor to retrieve mailingList. Returns a string saying "subscribed" or "unsubscribed"
	 instead of a boolean value of 1 or 0. More user-friendly and pretty this way. */
	string status;
	if (mailingList == 0)
		status = "Unsubscribed";
	else if (mailingList == 1)
		status = "Subscribed";
	return status;
}

void CustomerData::print()
{	// Print out contents of CustomerData
	cout << "CustomerData class contents:\n";
		cout << "\tLast name:\t" << getLastName() << endl;
	cout << "\tFirst name:\t" << getFirstName() << endl;
	cout << "\tAddress:\t" << getAddress() << endl;
	cout << "\tCity:\t\t" << getCity() << endl;
	cout << "\tState:\t\t" << getState() << endl;
	cout << "\tZip:\t\t" << getZip() << endl;
	cout << "\tPhone number:\t" << getPhone() << "\n\n";
	cout << "\tCustomer number:\t" << getCustomerNumber() << endl;
	cout << "\tMailing list status:\t" << getMailingList() << endl;
}
