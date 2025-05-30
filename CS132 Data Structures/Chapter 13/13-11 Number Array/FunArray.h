// Specification file for the FunArray class, using a constructor and deconstructor.
#ifndef FUNARRAY_H
#define FUNARRAY_H

class FunArray
{
	private:
		double *fun_array;	// This is the name of the array that the program will work with
		int array_size;		// User will input an int that determines how big the array will be

	public:
		FunArray(int);	// Constructor to setup the dynamic array, accepts an integer argument to determine size
		~FunArray();	// Destructor to kill the array when we're done with it
		void setArraySize(int);	// Determine how big the array is going to be
		void setNumber(int, double);		/* Set a specific number in the array, passing the 
											location and value to be set as. */
		int search(double);		// Search for a number in the array, user passes a double to find
		double getHighest();	// Search for and return highest number in the array
		double getLowest();		// Search for and return lowest number in the array
		double getAverage();	// Compute and return average of all numbers in the array
		double getSpecific(int location);	// Return a specific value in the array
		void printArray();		// Print out all of the array on the screen
		void initialize();		// Initialize the array to all 0s

};

#endif