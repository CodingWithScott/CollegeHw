# Scott Felch
# 11 January 2009, Monday
# CS 110 S
# Chapter 2, problem 4
# This program will calculate the price of 5 items a customer is
# purchasing in a store before tax, the sales tax alone,
# and then the grand total.

# Gather user information
print 'Hello. This program will show you the total cost of your purchases'
item1 = input('Please enter the price of the 1st item: ')
item2 = input('Please enter the price of the 2nd item: ')
item3 = input('Please enter the price of the 3rd item: ')
item4 = input('Please enter the price of the 4th item: ')
item5 = input('Please enter the price of the 5th item: ')

subtotal = (item1 + item2 + item3 + item4 + item5)
tax = subtotal * 0.06
grandtotal = subtotal + tax

print 'Your subtotal is $%.2f' % subtotal
print 'The amount of tax is $%.2f' % tax
print 'The grand total comes to $%.2f' % grandtotal
