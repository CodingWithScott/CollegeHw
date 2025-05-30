# Scott Felch
# 1 March 2010
# CS 110 S
# 7-7 Exception Handling
# This program will assume a file called avgnumbers.txt contains a series of
# integers, and calculate the average of all the numbers. It will also
# incorporate exception handling to deal with IOError and ValueError exceptions
# which may be raised.

def main():
    try:
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

    except IOError:
        print 'An error has occurred while opening avgnumbers.txt.'
        print 'Can you make sure the file is there?'

    except ValueError:
        print 'An error has occurred with the data in avgnumbers.txt.'
        print 'Can you make sure all the values are numbers?'
main()
