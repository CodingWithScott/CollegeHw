# Scott Felch
# 13 January 2010, Wednesday
# CS 110 S
# Chapter 2, problem 8
# This program will calculate total cost of a meal at a restaurant,
# assuming a 15% tip and 7% sales tax.

# First I will explain to the user what the program is for and gather info.
print 'This program will help you calculate the total cost of your meal.'
subtotal = input('How much did all of your items cost? ')

# Now perform calculations and display output.
tip = subtotal * 0.07
tax = subtotal * 0.15
total = subtotal + tax + tip

print 'Subtotal: $%.2f' % subtotal
print 'Tip: $%.2f' % tip
print 'Tax: $%.2f' % tax
print 'Total: $%.2f' % total
