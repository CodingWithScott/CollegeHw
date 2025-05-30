# Scott Felch
# 8 February 2010
# CS 110 S
# Exercise 6.7, Odd/Even Counter
# This program will generate 100 random integers, and keep a tally of how
# many are even and how many are odd.

# This calls a library which allows me to use the "random" function, which
# isn't a part of Python by default.
import random

def main():
    print 'This program is going to generate 100 random integers, and then'
    print 'show you how many were even and how many were odd.'
    counter = 0
    num_odd = 0
    num_even = 0
    while (counter < 100):
        # The counter will make the loop execute 100 times.
        counter += 1
        # A random number between 1 and 100.
        number = random.randint(1, 100)
        if (number % 2 == 0):
            num_even += 1
        else:
            num_odd += 1

    print 'The total number of even numbers was:  ', num_even
    print 'The total number of odd numbers was:  ', num_odd
    print 'That was a total of this many numbers:  ', (num_odd + num_even)

    yay_lets_do_it_again = 'n'
    yay_lets_do_it_again = raw_input('Would you like to do it again? (y/n)')
    if (yay_lets_do_it_again == 'y' or yay_lets_do_it_again == 'Y'):
        main()
    elif (yay_lets_do_it_again == 'n' or yay_lets_do_it_again == 'N'):
        print 'Big gulps, huh? Welp, see you later!'

main()
