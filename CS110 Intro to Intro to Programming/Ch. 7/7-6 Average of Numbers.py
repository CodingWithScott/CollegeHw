# Scott Felch
# 1 March 2010
# CS 110 S
# 7-6 Average of Numbers
# This program will assume a file called avgnumbers.txt contains a series of
# integers, and calculate the average of all the numbers. 

def main():
    infile = open('avgnumbers.txt', 'r')
    current_number = infile.readline()
    total = 0
    num_of_ints = 0
    
    while (current_number != ''):
        current_number = float(current_number)
        total = total + current_number
        current_number = infile.readline()
        num_of_ints += 1

    average = total / num_of_ints
    print 'There were', num_of_ints, 'numbers in the file.'
    print 'The total value of the numbers in the file is: ', total
    print 'The average of all the numbers was: ', average
    
main()
