# Scott Felch
# 3 March 2010
# CS 110 S
# 8-5 Alphabetic Telephone Number Translator
# This program will accept a user-inputted 10 character telephone number in
# the format xxx-xxx-xxxx. The program will display the telephone number
# with any alphabetic characters that appeared in the origianl translated
# to their numberical equivalent. For example, if the user enters 555-GET-FOOD
# the application will display 555-438-3663.

def main():
    print 'This program will convert alphanumeric phone numbers into numerical'
    print 'phone numbers.'
    alphanum_pho = raw_input('Please enter the telephone number (XXX-XXX-XXXX):   ')

    letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ-0123456789'
    numbers = '22233344455566677778889999-0123456789'

    new_number = ''
    for counter in alphanum_pho:
        index = letters.index(counter.upper())
        new_number += numbers[index]

    print 'You entered the original number as', alphanum_pho
    print 'The numeric version is', new_number
    
main()
    

