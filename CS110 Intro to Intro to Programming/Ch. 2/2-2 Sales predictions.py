# Scott Felch
# 11 January 2009, Monday
# CS 110 S
# Chapter 2, problem 2
# This program will output projected profits for a
# company based on sales numbers.

# Setting up variables for calculations, start out with 0 value as a placeholder
totalSales = 0.0
profit = 0.00

# Display instructions for user
print 'Total profit for the quarter is expected to be 23 percent of total sales'
totalSales = input('How much is total revenue for sales this quarter? ')
profit = totalSales * 0.23
print 'Total profit for the quarter should be approximately $%.2f' % profit
