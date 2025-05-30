# Scott Felch
# 1 February 2010
# CS 110 S
# Exercise 5.3, Budget Analysis
# The program asks a user to enter an amount of money they have budgeted
# for the month. Then the program will have the user enter in their expenses
# for the month and keep a running total, asking the user to continue at
# the end of each loop. At the end of the program it will display if
# the user is over budget or under budget.

# First I'll introduce the user to the program and gather their initial budget
def main():
    print 'Hello! Welcome to Budget Master 3000!'
    monthly_budget = input('How much money do you have to work with for the month?  ')
    # Ensure the number is a float for proper calculations, even if user entered an int
    monthly_budget = float(monthly_budget)
    # Call the function which performs calculations, handing off the user defined budget
    budget_calculations(monthly_budget)

def budget_calculations():
    # Create a conditional variable to get started with the budget loop
    shall_we_continue = 'y'
    num_of_expenses = 0
    current_expense = 0
    total = 0.0
    
    while (shall_we_continue == 'y'):
        # I'll put in a counter so the user knows which expense they're on
        num_of_expenses = num_of_expenses + 1
        print 'You are on expense #: ', (num_of_expenses = num_of_expenses + 1)
        current_expense = input('How much did this expense cost?  ')
        total = total + current_expense

        # Check to see if user has any more expenses, or if they're done adding
        shall_we_continue = raw_input('Do you have any more expenses? (Type \'y\' to continue)')

    # Now that I'm done adding expenses I can check if user went over their budget or not
    if (total > monthly_budget):
        print 'Uhoh! You spent more money than you have! Your bank gave you nasty overdraft charges.'
    else :
        print 'Hooray! Your frugality paid off, you didn\'t go broke this month!'

        

main()
