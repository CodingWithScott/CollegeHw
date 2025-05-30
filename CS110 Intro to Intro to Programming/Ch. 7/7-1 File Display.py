# Scott Felch
# 22 February 2010
# CS 110 S
# Exercise 7.1, Prime Number List
# This program will open a file called "numbers.txt" containing a series
# of integers, and display all these integers on the screen.

def main():
    # Open the numbers.txt file
    numbers_file = open('numbers.txt', 'r')
    
    for line in numbers_file:
        line = line.rstrip('\n')
        print line
main()
