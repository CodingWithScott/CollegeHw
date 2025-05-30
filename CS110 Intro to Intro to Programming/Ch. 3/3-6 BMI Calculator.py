# Scott Felch
# 20 January 2010
# CS 110 S
# Exercise 3.6
# This program will accept user input for their height and weight, and
# calculate their BMI (body mass index).

# First I will gather user input
height = input('Hello. How  tall are you, in inches? ')
weight = input('Great. Now how much do you weigh, in pounds? ')

# Now perform calculations and display output
bmi = (weight * 703.00) / (height**2.0)
print 'Your BMI is: ', bmi
