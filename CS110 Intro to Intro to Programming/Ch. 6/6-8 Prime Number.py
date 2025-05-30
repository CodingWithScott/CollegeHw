# Scott Felch
# 10 February 2010
# CS 110 S
# Exercise 6.8, Prime Numbers
# This program will accept a user input integer, and then tell the user
# if it is a prime number or not.

def main():
    # First I'll explain to the user the purpose of the program and gather
    # their input.
    print 'This program will determine if a number is prime or not.'
    number = input('Please enter a number:  ')
    # Only whole numbers can be prime. In case the user doesn't
    # enter a whole number, I'll convert it to an integer.
    number = int(number)
    # I'll take the user-defined number and pass it off to another function
    # where calculations are done.
    prime_result = is_prime(number)
    print 'You entered', number, 'as a number.'
    if (prime_result == False):
        print 'As it turns out, that is not a prime number. Disappointing!'
    elif (prime_result == True):
        print 'Wowie, it looks like that\'s a prime number!'

def is_prime(number):
    # If a number is less than two, it's not prime, can quit testing here.
    if (number < 2):
        return False
    # Even numbers are not prime, I can quit testing here.
    elif (number % 2 == 0):
        return False
    else:
        for divisor in range(3, number, 2):
            if (number % divisor == 0):
                return False
    # If number has passed all other tests, it must be prime.
    return True
main()
