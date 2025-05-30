# Scott Felch
# 25 January 2010
# CS 110 S
# Exercise 4.1, Roman Numerals
# This program will ask the user to input a number, and will output the
# Roman numeral version of it.

# First I will explain the purpose of the program to the user, and gather input.
def main():
    print 'This program will convert a number, 1-10, to a Roman numeral.'
    user_number = input('Please enter a number from 1 to 10:  ')
    # Now I pass the number off to the conversion function
    conversion (user_number)

# This is the function where the conversion is performed
def conversion(user_number):
    # If the user's number is between 1-10, then the conversion will be performed.
    # Otherwise we skip to the else statement....
    if (1 <= user_number <= 10):      
        if (user_number == 1):
            print 'The Roman Numeral for your number is:  I'
        if (user_number == 2):
            print 'The Roman Numeral for your number is:  II'    
        if (user_number == 3):
            print 'The Roman Numeral for your number is:  III'
        if (user_number == 4):
            print 'The Roman Numeral for your number is:  IV'
        if (user_number == 5):
            print 'The Roman Numeral for your number is:  V'
        if (user_number == 6):
            print 'The Roman Numeral for your number is:  VI'
        if (user_number == 7):
            print 'The Roman Numeral for your number is:  VII'
        if (user_number == 8):
            print 'The Roman Numeral for your number is:  VIII'
        if (user_number == 9):
            print 'The Roman Numeral for your number is:  IX'
        if (user_number == 10):
            print 'The Roman Numeral for your number is:  X'
    # If a user inputs a number less than 1 or greater than 10, they will get an error
    # and the program will terminate.
    else:
        print 'Sorry, that\'s an invalid number. Please enter a number from 1 to 10.'

main()
