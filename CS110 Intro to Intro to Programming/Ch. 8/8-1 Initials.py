# Scott Felch
# 1 March 2010
# CS 110 S
# 8-1 Initials
# This program will accept a string for a person's first, middle and last name,
# then display their first, middle, and last initials.

def main():
    # First I introduce the program to the user and gather their input.
    print 'This program will tell you what your initials are.'
    full_name = raw_input('Please enter your full name:   ')

    # This takes the string full_name and splits it into a list of strings
    # of the individual names.
    name_list = full_name.split()

    # This takes the strings from within the full_name list and makes them
    # their own individual strings.
    first_name = name_list[0]
    middle_name = name_list[1]
    last_name = name_list[2]

    # This creates new variables to store the initials from the substrings.
    first_initial = first_name[0:1]
    middle_initial = middle_name[0:1]
    last_initial = last_name[0:1]

    # Here I'll make all the initials upper case, just in case they aren't
    # already since it looks better that way.
    first_initial = first_initial.upper()
    middle_initial = middle_initial.upper()
    last_initial = last_initial.upper()

    # Now I'll output the results
    print 'Your full name is', full_name
    print 'Your initials are', first_initial, middle_initial, last_initial
    
main()
