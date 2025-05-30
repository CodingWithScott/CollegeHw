// Scott Felch
// 22 September 2010
// CS 132, Keith Laidig
/* Assignment 11-4. This program will use a structure to store the following weather data for a month:
total rainfall, high temperature, low temperature, average temperature. The program will have an array
of 12 structures to store data for an entire year. Once run the program will ask the user for input
for the total rainfall, high and low temp, the average temp will be caluclated. Once all data is
entered, the program will calculate and display average monthly rainfall, total rainfall for the
year, highest and lowest temps for the year (and months they occurred in) and the average of all 
the monthly average monthly average temps. Input validation will require that all temperatures are
between -100 and +140 degrees Fahrenheit. */

#include <iostream>
#include <iomanip>
#include <fstream>
using namespace std;

const int LENGTH = 12;		// The program will collect data for 12 months

struct MonthStats
{
	float TotalRain;		// Total rainfall for the month, inches
	float HighTemp;			// Highest temp for the month, in degrees F
	float LowTemp;			// Lowest temp for the month, in degrees F
	float AverageTemp;		// Average of the high and low temps
};

void ReadData(MonthStats [], int);
void DoCalculations(MonthStats [], int);

int main()
{
	MonthStats year[LENGTH];

	// Calls the function which will read input data from a pre-written text file
	ReadData(year, LENGTH);
	DoCalculations(year, LENGTH);

	return 0;
}

void DoCalculations(MonthStats t[], int LENGTH)
{
	float YearTotalRain = 0.0;		// The total amount of rainfall for the year, in inches
	float YearHighestTemp = t[0].HighTemp;		// Highest temp recorded during the year
	float YearLowestTemp = t[0].LowTemp;		// Lowest temp recorded during the year
	
	// This loop adds up all the total rainfall for each month to a single yearly total
	for (int counter = 0; counter < LENGTH; counter++)
	{	YearTotalRain += t[counter].TotalRain;
	}

	// This loop will check each month and see if the highest temp for this month is the highest this year
	for (int counter = 0; counter < LENGTH; counter++)
	{
		cout << t[counter].HighTemp << endl;
		if (t[counter].HighTemp > YearHighestTemp)
		{	YearHighestTemp = t[counter].HighTemp;

		}
	}

	// This loop will check each month and see if the lowest temp for this month is the lowest this year
	for (int counter = 0; counter < LENGTH; counter++)
	{	if (t[counter].LowTemp < YearLowestTemp)
		{	YearLowestTemp = t[counter].LowTemp;
		}
	}

	cout << "The total amount of rainfall for the year is " << YearTotalRain << endl;
	cout << "The year's highest temperature is " << YearHighestTemp << endl;
	cout << "The year's lowest temperature is " << YearLowestTemp << endl;

}

void ReadData(MonthStats s[], int nm)
{
	// Open the prewritten text file
	ifstream inputFile;
	inputFile.open("input.txt");

	// Step through the text file and read each line
	for (int count = 0; count < nm; count++)
	{
		// cout << "Please enter the total rainfall for month " << (count + 1) << ":";
		inputFile >> s[count].TotalRain;

		//cout << "Please enter the highest temperature for month " << (count + 1) << ":";
		inputFile >> s[count].HighTemp;

		//cout << "Please enter the lowest temperature for month " << (count + 1) << ":";
		inputFile >> s[count].LowTemp;

		// Calculate the average temp, doesn't require user input
		s[count].AverageTemp = (s[count].HighTemp + s[count].LowTemp) / 2.0;
	}

}