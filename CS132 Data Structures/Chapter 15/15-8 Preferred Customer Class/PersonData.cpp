/* PersonData implementation file. A lot of short, simple functions that could have been inline
but I like having multiple files. */
#include "PersonData.h"	
#include <string>
using namespace std;

PersonData::PersonData()
{	// Default constructor, sets all values to empty values
	lastName = "";
	firstName = "";
	address = "";
	city = "";
	state = "";
	zip = 0;
	phone = "";
}

PersonData::PersonData(string ln, string fn, string ad, string ci, string st, int z, string ph)
{	// Overloaded constructor, accepts values for all variables
	lastName = ln;
	firstName = fn;
	address = ad;
	city = ci;
	state = st;
	zip = z;
	phone = ph;
}

void PersonData::setLastName(string ln)
{	// Mutator to set last name
	lastName = ln;
}
void PersonData::setFirstName(string fn)
{	// Mutator to set first name
	firstName = fn;
}
void PersonData::setAddress(string ad)
{	// Mutator to set address
	address = ad;
}
void PersonData::setCity(string ci)
{	// Mutator to set city
	city = ci;
}
void PersonData::setState(string st)
{	// Mutator to set state
	state = st;
}
void PersonData::setZip(int zi)
{	// Mutator to set zip code
	zip = zi;
}
void PersonData::setPhone(string ph)
{	// Mutator to set phone number
	phone = ph;
}
string PersonData::getLastName()	
{	// Accessor to retrieve last name
	return lastName;
}
string PersonData::getFirstName()
{	// Accessor to retrieve first name
	return firstName;
}
string PersonData::getAddress()
{	// Accessor to retrieve address
	return address;
}
string PersonData::getCity()
{	// Accessor to retrieve city
	return city;
}
string PersonData::getState()
{	// Accessor to retrieve state
	return state;
}
int PersonData::getZip()
{	// Accessor to retrieve zip code
	return zip;
}
string PersonData::getPhone()
{	// Accessor to retrieve phone number
	return phone;
}
void PersonData::print()
{	// Function to print out the contents of the PersonData class
	cout << "PersonData class contents:\n";
	cout << "\tLast name:\t" << getLastName() << endl;
	cout << "\tFirst name:\t" << getFirstName() << endl;
	cout << "\tAddress:\t" << getAddress() << endl;
	cout << "\tCity:\t\t" << getCity() << endl;
	cout << "\tState:\t\t" << getState() << endl;
	cout << "\tZip:\t\t" << getZip() << endl;
	cout << "\tPhone number:\t" << getPhone() << "\n\n";
}