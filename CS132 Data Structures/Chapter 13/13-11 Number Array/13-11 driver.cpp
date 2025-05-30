// Scott Felch
// 9 October 2010
// Problem 13-11

#include "FunArray.h"
#include <iostream>
using namespace std;



int main()
{
	int array_size;	// How big the FunArray is going to be
	int index_to_store;		// Where a value will be stored	
	double value_to_store;	// What value will be stored

	cout << "This program will create a dynamically sized array of floating point numbers.\n\n";
	cout << "How many values would you like to be in the array?   ";
	cin >> array_size;
	FunArray funarray1(array_size);

	char keep_going = 'y';
	// Populate the array with values until the user decides he's done
	while (keep_going == 'Y' || keep_going == 'y')
	{
		cout << "Please enter an index number to assign to:   ";
		cin >> index_to_store;
		if (index_to_store < 0 || index_to_store >= array_size)
		{
			cout << "ERROR: Index out of bounds!\n";
			cin >> index_to_store;
		}
		else if ((index_to_store >= 0) && (index_to_store < array_size))
		{
			cout << "Please enter a value to assign:   ";
			cin >> value_to_store;
			funarray1.setNumber(index_to_store, value_to_store);
		}
		cout << "Enter another number? (Y/N)   ";
		cin >> keep_going;
	}

	// Now that the array is populated, a menu for the user to select what he'd like to do with it
	int menu_selection;		// Variable to hold the user's choice for navigating menu
	cout << "\nCool, the array is populated! What would you like to do now?\n";
	cout << "1. Get specific number in the array\n";
	cout << "2. Get the maximum number in the array\n";
	cout << "3. Get the lowest number in the array\n";
	cout << "4. Get the average of the array\n";
	cout << "5. Print the whole array\n";
	cout << "6. Quit\n";
	cout << "Make your selection:   ";
	cin >> menu_selection;
	while (menu_selection != 6)
	{
		if (menu_selection == 1)
		{
			int index_selection;
			cout << "What block in the array would you like to access?  ";
			cin >> index_selection;
			cout << "The value in index " << index_selection << " is " << funarray1.getSpecific(index_selection);
		}
		else if (menu_selection == 2)
			cout << "\nThe maximum number in the array is:\t" << funarray1.getHighest() << endl;	
		else if (menu_selection == 3)
			cout << "The lowest number in the array is:\t" << funarray1.getLowest() << endl;	
		else if (menu_selection == 4)
			cout << "The average of the array is:\t\t" << funarray1.getAverage() << endl;	
		else if (menu_selection == 5)
		{
			cout << "\nThis is what the array looks like..\n";
			funarray1.printArray();
		}
		cout << "\n\nWhat would you like to do now?\n";
		cout << "1. Get specific number in the array\n";
		cout << "2. Get the maximum number in the array\n";
		cout << "3. Get the lowest number in the array\n";
		cout << "4. Get the average of the array\n";
		cout << "5. Print the whole array\n";
		cout << "6. Quit\n";
		cout << "Make your selection:   ";
		cin >> menu_selection;
	}

	cout << "\nWell that was fun, thanks for playing!\n";
	return 0;

}