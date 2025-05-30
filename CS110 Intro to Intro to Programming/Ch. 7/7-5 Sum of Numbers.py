# Scott Felch
# 1 March 2010
# CS 110 S
# 7-5 Sum of Numbers
# This program will assume a file called sumnumbers.txt contains a series of
# integers, and add up the sum of all the numbers in the file.

def main():
    infile = open('sumnumbers.txt', 'r')
    current_number = infile.readline()
    total = 0
    
    while (current_number != ''):
        current_number = int(current_number)
        total = total + current_number
        current_number = infile.readline()

    print 'The total value of the numbers in the file is: ', total

main()
