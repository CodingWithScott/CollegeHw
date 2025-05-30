# Scott Felch
# 10 February 2010
# CS 110 S
# Exercise 6.9, Prime Number List
# This program will print all of the prime numbers from 1 to 100.

def main():
    print 'This program will show you all of the prime numbers from 1 to 100.'
    raw_input('Are you ready?  Press [enter] to continue')
    print_dat_prime()

def is_prime(counter):
    # If a number is less than two, it's not prime, can quit testing here.
    if (counter < 2):
        return False
    # Even numbers are not prime, I can quit testing here.
    elif (counter % 2 == 0):
        return False
    else:
        for divisor in range(3, counter, 2):
            if (counter % divisor == 0):
                return False
    # If number has passed all other tests, it must be prime.
    return True

def print_dat_prime():
    for counter in range(1, 100):
        if (is_prime(counter) == False):
            print counter, '\t not prime'
        else:
            print counter, '\t prime number'
            
main()
