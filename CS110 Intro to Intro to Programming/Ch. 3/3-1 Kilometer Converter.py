# Scott Felch
# 20 January 2010
# CS 110 S
# Exercise 3.1
# This program will accept a user defined number of kilometers
# and convert to miles.

# First I'll explain to the user the purpose of the program and gather input.
def main():
    print 'This program will convert kilometers into miles.'
    kilometers = input('Please enter the distance in kilometers: ')
    # In case the user enters a whole number, I'll convert it to a float
    # to ensure accurate calculations.
    float(kilometers)
    conversion (kilometers)

# Here is where the computation is done
def conversion(kilometers):
    miles = kilometers * 0.6214
    print 'The distance in miles is: ', miles

main()
