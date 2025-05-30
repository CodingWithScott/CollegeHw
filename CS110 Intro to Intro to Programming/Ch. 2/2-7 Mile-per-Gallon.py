# Scott Felch
# 12 January 2009, Monday
# CS 110 S
# Chapter 2, problem 7
# This program will take user input for distance traveled and gas
# consumption to calculate miles-per-gallon.

# First I'll explain to the user the purpose of the program.
print 'This program will compute gas mileage for your car.'

# Gather user data, make computations
distance = input('How many miles did you drive? ')
gas = input('How many gallons of gas did you use? ')

mileage = distance / gas

print 'Your milage for the trip was', mileage, 'mpg'
