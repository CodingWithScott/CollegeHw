#include "FunArray.h"
#include <iostream>
using namespace std;

FunArray::FunArray(int arr_size)
{
	fun_array = new double[arr_size];	// Create a dynamically sized array with user inputted array size
	array_size = arr_size;
	initialize();
}

FunArray::~FunArray()
{
	delete [] fun_array;	// Delete teh whole thing
}

double FunArray::getHighest()		// Determine highest number in array and return that value
{
	double highest_num = fun_array[0];
	for (int count = 0; count < array_size; count++)
	{
		if (highest_num < fun_array[count])
			highest_num = fun_array[count];
	}
	return highest_num;
}

double FunArray::getLowest()	// Determine lowest number in array and return that value
{
	double lowest_num = fun_array[0];
	for (int count = 0; count < array_size; count++)
	{
		if (lowest_num > fun_array[count])
			lowest_num = fun_array[count];
	}
	return lowest_num;
}

void FunArray::setNumber(int location, double number)
{
	/*	commented out error checking, error checking done in Driver program now
	if ((location < 0) || (location >= array_size))
		cout << "Error: Out of bounds\n";
	else */
		fun_array[location] = number;
}

int FunArray::search(double number)
{
	int index = -1;		// Index of where the number is found
	bool found = false;	// Flag of whether the number is found in the array or not
	int counter = 0;	// Keeps track of where we are in the array

	while (!found && (counter < array_size))
	{
		if (fun_array[counter] == number)
		{	
			found = true;
			index = counter;
		}
		counter++;
	}
	return index;

}

double FunArray::getAverage()
{
	double total = 0;	
	double average = 0;

	for (int count = 0; count < array_size; count++)
		total += fun_array[count];

	if (array_size > 0)
		average = total / array_size;

	return average;
}


void FunArray::printArray()
{
	for (int count = 0; count < array_size; count++)
		cout << fun_array[count] << "  ";
}

void FunArray::initialize()	// Initialize everything in the array to 0
{
	for (int count = 0; count < array_size; count++)	
		fun_array[count] = 0.0;
}

double FunArray::getSpecific(int location)	// Return a specific value in the array
{
	double number = 0;
	number = fun_array[location];
	return number;
}