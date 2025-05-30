# Scott Felch
# 20 January 2010
# CS 110 S
# Exercise 3.4
# This program will accept user input for invidual costs of owning a car
# (car payment, insurance, gas, oil, tires, maintenance), then display monthly
# total and yearly total of owning the car.

# First I will gather user input.
payment = input('Please enter the amount of the monthly car payment: ')
insurance = input('Please enter the amount of monthly insurance payment: ')
gas = input('Please enter the amount of monthly gas costs: ')
oil = input('Please enter the amount of monthly oil costs: ')
tires = input('Please enter the amount of monthly tires costs: ')
maint = input('Please enter the amount of monthly maintenance costs: ')

# Now I will perform calculations and display output.
monthly_total = payment + insurance + gas + oil + tires + maint
yearly_total = monthly_total * 12.00

print 'The total monthly cost of owning the vehicle will be $%.2f' % monthly_total
print 'The total annual cost of owning the vehicle will be $%.2f' % yearly_total
