# Scott Felch
# 8 February 2010
# CS 110 S
# Exercise 6.3, Maximum of Two Values
# This program will accept user input of two integers, pass them to a function
# as an argument, and then display whichever number is larger.

def main():
    # First I will explain to the user the function of the program...
    print 'This program will tell you which of two numbers are larger.'
    # ...gather user input...
    num1 = input('Please enter the first number:  ')
    num2 = input('Cool. Now the second number:  ')
    # and ensure the numbers are integers. 
    num1 = int(num1)
    num2 = int(num2)
    # I'll call upon another function which compares num1 and num2, then
    # 
    bigger_num = which_is_bigger(num1, num2)

    print 'You entered', num1, 'and', num2
    print 'The larger of the two numbers is', bigger_num

def which_is_bigger(num1, num2):
    # This will determine which number is larger and return it to main()
    # and assign it to the variable 'bigger_num'.
    if (num1 > num2):
        return num1
    else:
        return num2

main()
