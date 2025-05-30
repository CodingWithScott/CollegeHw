// Scott Felch
// 8 October 2010
// 13-14 Freezing and Boiling Points

#include <iostream>
#include "Boiling.h"
using namespace std;

//Some reference info...
/*********************************************************************************\
*Substance							Freezing temp (F)			Boiling temp (F) *
*Ethyl Alcohol						-173						172				 *
*Oxygen								-362						-306			 *
*Water								32							212				 *
\*********************************************************************************/

int main()
{
	double user_temperature;		// The temperature the user will be testing
	Boiling whatever;	// object to work with

	cout << "This program will tell you what state some substances are in. Ready?!\n";

	char do_it_again = 'y';
	/* Each time the user inputs a temperature to test, the program will output the state
	of each chemical at that point, and then ask if the user wants to test another temperature. */
	while((do_it_again == 'y') || (do_it_again == 'Y'))
	{
		cout << "Please enter the temperature you'd like to test:   ";
		cin >> user_temperature;

		whatever.set_temp(user_temperature);

		cout << "The following chemicals are freezing:\n";
		if (whatever.isEthylFreezing())
			cout << "Ethyl alcohol is frozen\n";
		if (whatever.isOxygenFreezing())
			cout << "Oxygen is freezing\n";
		if (whatever.isWaterFreezing())
			cout << "Water is freezing\n";

		cout << "-------------------------\n";
		cout << "\nThe following chemicals are boiling:\n";
		if (whatever.isEthylBoiling())
			cout << "Ethyl alcohol is boiling\n";	
		if (whatever.isOxygenBoiling())
			cout << "Oxygen is boiling\n";
		if (whatever.isWaterBoiling())
			cout << "Water is boiling\n";

		cout << "\nDo you want to test another temperature? (Y/N): ";
		cin >> do_it_again;
		cout << "\n";
	}
	cout << "Goodbye!\n";
	return 0;
}
