#ifndef CUSTOMERDATA_H
#define CUSTOMERDATA_H
#include "PersonData.h"
using namespace std;

class CustomerData : public PersonData
{
	private:
		int customerNumber;		// Customer's ID number
		bool mailingList;		// Bool to store whether or not customer wishes to subscribe to mailing list

	public:
		CustomerData();					// Default constructor
		/* Overloaded constructor, accepts arguments for lastName, firstName, address, city, 
		state, zip, customer number, mailing list status */
		CustomerData(string, string, string, string, string, int, string, int, bool);		
		void setCustomerNumber(int);	// Set customer ID number
		void setMailingList(bool ml);	// Set customer's mailing list preference
		int getCustomerNumber();		// Retrieve customer's ID number
		string getMailingList();		// Retrieve customer's mailing list preference
		virtual void print();			// Print out contents of customer class
};
#endif