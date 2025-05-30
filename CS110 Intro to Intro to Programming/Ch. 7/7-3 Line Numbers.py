# Scott Felch
# 28 February 2010
# CS 110 S
# Exercise 7-3, Line Numbers
# This program will ask the user for the name of a file, then display the
# contents of the file with each line preceded by a line number annd a colon.
# The line numbering will start at 1.

# First I'll explain the purpose of the program to the user
def main():
    print 'This program will display the contents of a file, with line numbers.'
    # Get the file name
    file_name = raw_input('Please enter the name of your file:   ')
    # Open the file
    infile = open(file_name, 'r')
    # Read file contents
    contents = infile.readline()

    line_counter = 1
    while (contents != ''):
        contents = contents.rstrip('\n')
        print line_counter, ':', contents
        line_counter += 1
        contents = infile.readline()

main()
