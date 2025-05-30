# Scott Felch
# 25 January 2010
# CS 110 S
# Exercise 4.3, Mass and Weight
# This program will ask the user to input an object's mass, and will
# calculate the weight. If the object weighs more than 1000 newtons, a
# message will display saying the object is too heavy. If the object weighs
# less than 10 newtons, an error will display saying the object is too light.

# First I will introduce the program to the user and gather their input
def main():
    print 'This program will calculate an object\'s weight, given the mass.'
    mass = input('Please enter the mass, in kilograms:  ')
    # I'll make sure the number is a float, so calculations are accurate.
    float(mass)
    # Now that I have the information, I'll pass the variable off to the
    # conversion function
    convert(mass)

# The conversion function is where math will be done
def convert(mass):
    # First I'll do the conversion
    weight = mass * 9.8
    # If the final weight is too high or too low, the program will spit out
    # an error.
    if (weight > 1000.0):
        print 'Sorry, that object is too heavy. Please try again with a smaller mass.'
    if (weight < 10.0):
        print 'Sorry, that object is too light. Please try again with a larger mass.'
    # If the number is valid, then I will display the result.
    if (10.0 < weight < 1000.0):
        print 'The weight of the object in newtons is:  ', weight

main()

# Hooray we're done! :D
