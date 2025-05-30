#ifndef PERSONDATA_H
#define PERSONDATA_H
#include <iostream>
#include <string>
using namespace std;

class PersonData
{
	private:
		string lastName;			// String to hold person's last name
		string firstName;			// String to hold person's first name
		string address;				// String to hold person's home address
		string city;				// String to hold person's city
		string state;				// String to hold person's state
		int zip;					// Integer to hold person's zip code
		string phone;				// String to hold person's telephone number
	public:
		PersonData();				// Default constructor
		// Overloaded constructor, accepts arguments for lastName, firstName, address, city, state, zip and phone
		PersonData(string, string, string, string, string, int, string);	
		void setLastName(string);	// Mutator to set last name
		void setFirstName(string);	// Mutator to set first name
		void setAddress(string);	// Mutator to set address
		void setCity(string);		// Mutator to set city
		void setState(string);		// Mutator to set state
		void setZip(int);			// Mutator to set zip code
		void setPhone(string);		// Mutator to set phone number
		string getLastName();		// Accessor to retrieve last name
		string getFirstName();		// Accessor to retrieve first name
		string getAddress();		// Accessor to retrieve address
		string getCity();			// Accessor to retrieve city
		string getState();			// Accessor to retrieve state
		int getZip();				// Accessor to retrieve zip code
		string getPhone();			// Accessor to retrieve phone number
		virtual void print();		// Function to print out the contents of the PersonData class
};

#endif