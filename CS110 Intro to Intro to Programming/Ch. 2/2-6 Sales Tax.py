# Scott Felch
# 12 January 2009, Monday
# CS 110 S
# Chapter 2, problem 6
# This program will add the subtotal of 5 items a shopper purchases,
# calculate sales tax, and provide total cost.

# First I will explain to the user what the program is for.
print 'This program will calculate your subtotal, sales tax, and grand total of items.'

# Then I will gather user data
item1 = input('Cost of item #1: ')
item2 = input('Cost of item #2: ')
item3 = input('Cost of item #3: ')
item4 = input('Cost of item #4: ')
item5 = input('Cost of item #5: ')

# Perform computations and display the resulting information.
subtotal = (item1 + item2 + item3 + item4 + item5)
salestax = subtotal * 0.06
grandtotal = salestax + subtotal

print 'Your subtotal is %.2f' % subtotal
print 'Sales tax is %.2f' % salestax
print 'Your grand total is %.2f' % grandtotal
