# Scott Felch
# 27 January 2010
# CS 110 S
# Exercise 4.7, Body Mass Index Program Enhancement
# This program will accept user input for their height and weight, and
# calculate their BMI (body mass index). It will then tell them if they
# are considered underweight, optimal, or overweight. The calculations
# are assuming the user has a sedentary lifestyle.
# Underweight = <18.5, optimal = 18.5-25, overweight = >25

# First I will gather user input
height = input('Hello. How  tall are you, in inches? ')
weight = input('Great. Now how much do you weigh, in pounds? ')

# Now perform BMI calculation
bmi = (weight * 703.00) / (height**2.0)
# Determine if the BMI indicates overweight, underweight, or optimal
if (bmi < 18.5):
    bmi_message = 'Uh oh! You are underweight! You should eat more.'
elif (18.5 <= bmi <= 25):
    bmi_message = 'Congratulations, you have a healthy BMI!'
else: bmi_message = 'Oh no! Unfortunately you\'re overweight. Time to hit the gym!'

# Print the results
print 'Your BMI is: ', bmi
print bmi_message
