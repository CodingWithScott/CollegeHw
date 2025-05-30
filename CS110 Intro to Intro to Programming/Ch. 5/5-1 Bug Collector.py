# Scott Felch
# 1 February 2010
# CS 110 S
# Exercise 5.1, Bug Collector
# A bug collector collects bugs every day for a week. This program will
# keep a running tally of how many bugs he has collected.


# First I will introduce the user to the program
def main():
    print 'Welcome to Bug Master 2K10!'
    print 'This program will keep track of how many bugs you\'ve collected.'

    # Open the bug tracking function
    bug_master()

def bug_master():
    # This will be a variable to represent the day of the week. For sake of
    # simplicity, I'll just use ints. 0 = Sunday, 1 = Monday, etc.
    day_of_week = 0
    bugs_for_week = 0
    bugs_for_today = 0

    # day_of_week functions as a counter to make sure we're in the first week
    while (day_of_week < 7):
        # Here I'll make a simple if statement to print out what day of the week it is
        if (day_of_week == 0):
            print 'Today is Sunday', '\n'
            day_of_week = day_of_week + 1
        elif (day_of_week == 1):
            print 'Today is Monday', '\n'
            day_of_week = day_of_week + 1
        elif (day_of_week == 2):
            print 'Today is Tuesday', '\n'
            day_of_week = day_of_week + 1
        elif (day_of_week == 3):
            print 'Today is Wednesday', '\n'
            day_of_week = day_of_week + 1
        elif (day_of_week == 4):
            print 'Today is Thursday', '\n'
            day_of_week = day_of_week + 1
        elif (day_of_week == 5):
            print 'Today is Friday', '\n'
            day_of_week = day_of_week + 1
        else:
            print 'Today is Saturday', '\n'
            day_of_week = day_of_week + 1            

        print 'Currently you have ', bugs_for_week, 'bugs so far'
        bugs_for_today = input('How many bugs did you catch today?  ')
        bugs_for_week = bugs_for_week + bugs_for_today

    print 'The total number of bugs you caught for the week is:  ', bugs_for_week

main()

