# Scott Felch
# 3 February 2010
# CS 110 S
# Exercise 5.7, Pennies for Pay
# This program will calculate the amount of money a person would earn if
# his salary is 1 penny the first day, 2 pennies the second day, 4 pennies
# the third day, etc. The number of days will be user defined. The program
# will then output a table showing the salary for each day, and the total
# salary paid.

# First I'll explain the purpose of the program to the user, and gather input
def main():
    print 'This program will calculate salary for a person if they are'
    print 'paid 1 penny on their first day and their salary doubles everyday. \n'
    num_days = input('How many days of work would you like to do?   ')
    # Ensure the number of days is a whole number
    num_days = int(num_days)
    # Take this info and hand it to the calculations function
    fun_part(num_days)

def fun_part(num_days):
    counter = 0
    # I'm setting up the initial value as 0.005, this way pay is represented in
    # dollars instead of pennies, and I can tell the program to double 'pay'
    # every time it goes through the loop, and the first time it doubles will result
    # in 1 penny, which is our starting point.
    pay = 0.005
    total = 0.0
    # Print table headings
    print 'Day\tPay'
    print '---------------------'
    while (counter < num_days):
        counter += 1
        pay = 2 * pay
        total += pay
        print counter, '\t$%.2f' % pay

    print '\nThe total salary was: $%.2f' % total
    
main()
