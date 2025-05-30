# Scott Felch
# 20 January 2010
# CS 110 S
# Exercise 3.3
# This program will accept a user defined value of property, and then
# calculate the recommended amount of insurance coverage.

# First I will explain the purpose of the program and gather user input.
def main():
    print 'Real estate experts advise having an insurance plan which will cover up to 80% of the total cost of replacing a property'
    property_value = input('Please enter the value of the property, in dollars: ')
    # Ensure property value is a float for calculations to be accurate.
    float(property_value)
    calculation (property_value)

# Now I will perform calculations and display output.
def calculation(property_value):
    coverage = property_value * 0.80000
    print 'The recommended amount of insurance coverage is: $%.2f ' % coverage

main()
