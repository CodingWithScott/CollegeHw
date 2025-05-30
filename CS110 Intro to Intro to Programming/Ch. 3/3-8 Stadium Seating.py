# Scott Felch
# 20 January 2010
# CS 110 S
# Exercise 3.8
# This program will accept user input for number of softball tickets sold,
# for three different categories (class A tickets = $15, class B tickets = $12,
# class C tickets = $9) and calculate the total income for ticket sales.

# First I will gather user input
classa_sold = input('Please enter the total number of class A tickets sold: ')
classb_sold = input('Please enter the total number of class B tickets sold: ')
classc_sold = input('Please enter the total number of class C tickets sold: ')

# Now I will perform calculations and display output.
classa_income = classa_sold * 15.0
classb_income = classb_sold * 12.0
classc_income = classc_sold * 9.0
total_sold = classa_sold + classb_sold + classc_sold
total_income = classa_income + classb_income + classc_income
print 'The total number of tickets sold was: ', total_sold
print 'The total income generated from ticket sales was $%.2f: ' % total_income
