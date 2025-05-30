# Scott Felch
# 25 January 2010
# CS 110 S
# Exercise 4.5, Software Sales
# A software company sells a package that retails for $99. Quantity discounts
# are given as follows: 10-19 = 20% discount, 20-49 copies = 30% discount,
# 50-99 copies = 40% discount, 100+ copies = 50% discount.

def main():
    # First I'll introduce the user to the program and gather their input
    print 'This program will help you determine the price of your software order, including discount.'
    copies = input('How many copies of software would you like to order?  ')
    # Next I'll pass the information on to the calculations function
    calculations(copies)

def calculations(copies):
    # If the user purchases less than 10 copies, they will pay full price for the software.
    # If they enter a number <0 the program returns an error message.
    if (copies <= 0):
        print 'Sorry, please enter a number greater than 0.'
        input ('How many copies of the software would you like to order?  ')
    # The discount is set to 0, or in other words they're paying 100% price.
    elif (copies <= 9):
        discount_rate = 0.00
    # If the user purchases 10 to 19 copies, they will get a 20% discount, or in other
    # words they're paying 80% of full price.
    elif (10 <= copies <= 19):
        discount_rate = 0.20
    elif (20 <= copies <= 49):
        discount_rate = 0.30
    elif (50 <= copies <= 99):
        discount_rate = 0.40
    else:
        discount_rate = 0.50

    # The price before discount = copies purchased x $99 each
    initial_price = copies * 99.00
    total_discount = discount_rate * initial_price
    grandtotal = initial_price - total_discount

    # Now I'll print the output and format it nicely
    print 'You have purchased ', copies, ' copies of the software.'
    print 'The subtotal of your order is:  %.2f' % initial_price
    print 'The discount rate is: ', discount
    print 'You saved a total of:  $%.2f' % total_discount
    print 'Your grand total comes to:  $%.2f' % grandtotal

main()
