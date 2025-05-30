# Scott Felch
# 13 January 2010, Wednesday
# CS 110 S
# Chapter 2, problem 9
# This program will convert temperatures from Celsius to Fahrenheit.

# First I'll explain the purpose of the program to the user and gather data.
print 'This program will convert a Celsius temperature into Fahrenheit.'
celsius = input('Please give the temperature in Celsius: ')

# Now perform the calculation and display output.
fahrenheit = ((9/5) * celsius) + 32
print 'The temperature in Fahrenheit is: ', fahrenheit, 'degrees'
