# Scott Felch
# 11 January 2009, Monday
# CS 110 S
# Chapter 2, problem 3
# This program will calculate number of acres of
# land based on number of square feet.

# Gather information from user
totalspace_squarefeet = input('How much land is there in square feet? ')

# Perform calculation
totalspace_acre = totalspace_squarefeet / 43560.00
print 'The total space in acres is: %.4f' % totalspace_acre
