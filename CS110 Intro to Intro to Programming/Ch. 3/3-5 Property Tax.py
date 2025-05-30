# Scott Felch
# 20 January 2010
# CS 110 S
# Exercise 3.5
# This program will accept user input for actual value of a piece of land,
# then calculate assessed value (assessed value = 60% of actual value)
# and property tax. (Property tax = $0.64 per $100 of assessed value)

# First I will explain the program and gather user input for
# the "actual value" variable...
def main():
    print 'The purpose of this program is to take the actual value of a piece of land, and compute the assessed value and then how much property taxes will cost.'
    actual_value = input('Please enter the actual value of the property: ')
    # Convert actual value to a float to avoid integer errors
    float(actual_value)
    calculations(actual_value)

# Then "actual value" is handed off to this function, which performs
# the calculations and displays the resulting information.
def calculations(actual_value):
    assessed_value = actual_value * 0.6000
    prop_tax = assessed_value * 0.0064
    print 'The assessed value of the property is $%.2f' % assessed_value
    print 'The property tax of the property will be $%.2f' % prop_tax

main()
