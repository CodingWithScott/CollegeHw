# Scott Felch
# 3 February 2010
# CS 110 S
# Exercise 5.5, Average Rainfall
# This program will accept a user-inputted number of years, and then
# use nested loops to ask for the number of inches of rainfall for each month,
# for each year. At the end the program will output the total number of months,
# total inches of rainfall, and average rainfall per month for the entire
# period.

def main():
    # First I'll explain the purpose of the program to the user, and
    # gather input.
    print 'This program will calculate total and average rainfall over a set amount of time.'
    num_years = input('How many years of rainfall are we going to analyze?  ')
    # In case the user enters a decimal for some reason, I'll convert to an int.
    num_years = int(num_years)
    # Take this information and pass it to the calculations function
    calculations (num_years)

def calculations(num_years):
    # I'll make variables to use as counters for years and months
    total_rainfall = 0

    for year_counter in range(num_years):
        for month_counter in['January', 'February', 'March', 'April', 'May', 'June', 'July',
                             'August', 'September', 'October', 'November', 'December']:
            print 'The current month is', month_counter
            month_rainfall = input('Please enter rainfall for the month:  ')
            total_rainfall += month_rainfall
            
    # Compute average rainfall by dividing total rainfall by number of months
    average_rainfall = total_rainfall / (num_years * 12)
    # Print out all the resulting information, formatted nicely
    print '\n'
    print 'The total number of years counted was: ', num_years
    print 'The total number of months was:  ', (num_years * 12)
    print 'The total rainfall was: ', total_rainfall, 'inches.'
    print 'The average monthly rainfall was:', average_rainfall, 'inches.'

main()
