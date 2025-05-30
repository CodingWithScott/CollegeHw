# Scott Felch
# 20 January 2010
# CS 110 S
# Exercise 3.2
# This program will accept a user defined purchase amount, calculate
# county (2%) and state (4%) sales tax for the purchase, display tax individually,
# display total sales tax, and display grand total.

def main():
    # First I'll explain to the user the purpose of the program and gather input.
    print 'This program will help you calculate the amount of sales tax for your purchase.'
    item1 = input('Cost of item #1: ')
    item2 = input('Cost of item #2: ')
    item3 = input('Cost of item #3: ')
    item4 = input('Cost of item #4: ')
    item5 = input('Cost of item #5: ')    
    # Next I'll calculate the subtotal, for the sake of simplicity when passing
    # the parameter to the other functions.
    subtotal = (item1 + item2 + item3 + item4 + item5)
    
    # Run county tax function
    county_tax(subtotal)

    # Run state tax function
    state_tax(subtotal)
def county_tax():
    countyTax = subtotal * 0.0200
    print 'The county sales tax is $%.2f' % countyTax
def state_tax():
    stateTax = subtotal * 0.0400
    print 'The state sales tax is $%.2f' % stateTax

main()
