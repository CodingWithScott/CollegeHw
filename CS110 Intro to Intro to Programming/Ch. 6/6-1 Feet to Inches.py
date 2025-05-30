# Scott Felch
# 8 February 2010
# CS 110 S
# Exercise 6.1, Feet to Inches
# This program will accept a user input for number of feet, and output
# the number of inches.

def main():
    # First I'll explain the purpose of the program to the user, and
    # gather input.
    print 'This program will convert feet to inches.'
    num_feet = input('Please enter the number of feet:  ')
    # I'll pass the number of feet to another function which performs
    # the calculation and returns the number of inches.
    num_inches = feet_to_inches(num_feet)

    print num_feet, 'is equivalent to', num_inches, 'inches.'

def feet_to_inches(num_feet):
    num_inches = num_feet * 12.0
    return num_inches

main()
