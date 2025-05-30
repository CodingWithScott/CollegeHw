# Scott Felch
# 3 March 2010
# CS 110 S
# 8-3 Date Printer
# This program will accept a string from the user containing a date in the
# form mm/dd/yyyy. It will print the date in the form November 25, 1987.

def main():
    # First I'll explain the purpose of the program to the user.
    print 'This program will convert a date from mm/dd/yyyy to written format.'
    calculation()

def calculation():
    # Now I'll gather input and pass the information to another function which
    # does the calculations. 
    numerical_date = raw_input('Please enter a date, in the form of mm/dd/yyyy:   ')  

    # This splits the string into a list of three strings, so I can work with
    # them individually.
    date_list = numerical_date.split('/')
    month = date_list[0]
    date = date_list[1]
    year = date_list[2]

    # This series of if statements will allow us to output the appropriate month
    # in text format. If an invalid number is entered, an error is returned and the
    # user can try again.
    if (month == '01'):
        word_month = 'January'
    elif (month == '02'):
        word_month = 'February'
    elif (month == '03'):
        word_month = 'March'
    elif (month == '04'):
        word_month = 'April'
    elif (month == '05'):
        word_month = 'May'
    elif (month == '06'):
        word_month = 'June'
    elif (month == '07'):
        word_month = 'July'
    elif (month == '08'):
        word_month = 'August'
    elif (month == '09'):
        word_month = 'September'
    elif (month == '10'):
        word_month = 'October'
    elif (month == '11'):
        word_month = 'November'
    elif (month == '12'):
        word_month = 'December'
    else:
        print 'You\'ve entered an invalid month. Please try again.'
        calculation()

    # Now I'll output the results
    print 'You originally entered', numerical_date
    print 'which is the same thing as', word_month, date, ',', year
    
main()
