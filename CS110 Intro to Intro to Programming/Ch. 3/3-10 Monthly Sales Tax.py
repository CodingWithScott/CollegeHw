# Scott Felch
# 21 January 2010
# CS 110 S
# Exercise 3-10
# This program will accept user input for total sales for a month, then
# calculate and output amount of county sales tax (2%), state sales tax (4%),
# and total sales tax.

# First I will gather user input
print 'Hello. This program will calculate your sales tax.'
sales = input('Please enter the total number of sales for the month: ')

# Now I will perform calculations and display output
county_tax = sales * 0.0200
state_tax = sales * 0.0400
total_tax = county_tax + state_tax

print 'The county tax comes to $%.2f ' % county_tax
print 'The state tax comes to $%.2f ' % state_tax
print 'The total tax comes to $%.2f ' % total_tax
