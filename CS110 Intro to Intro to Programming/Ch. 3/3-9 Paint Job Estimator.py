# Scott Felch
# 20 January 2010
# CS 110 S
# Exercise 3.9
# This program will provide an estimate for costs of painting a house, given
# user input for price of paint and amount of wallspace to be painted. The
# company charges $20/hour for labor, every 115 square feet of wallspace
# requires 8 hours of labor and one gallon of paint. The data
# outputted will be: number of gallons of paint required, hours of labor
# required, cost of paint, cost of labor, total cost of job. 

# First I will gather user input
def main():
    print 'Hello. This program will generate a cost estimate for your paint job.'
    wallspace = input('Please enter the number of square feet to be painted: ')
    paint_price_per_can = input('Please enter the price of paint per gallon: ')
    # Before passing variables off to the next function, I'll make sure they
    # are both floats.
    float(wallspace)
    float(paint_price_per_can)
    calculations (wallspace, paint_price_per_can)

# This function performs all the calculations for the data, and passes the
# info to the last function...
def calculations(wallspace, paint_price_per_can):
    hours_of_labor = (wallspace / 115.00) * 8
    total_paint_cans = wallspace / 115.00
    labor_cost = hours_of_labor * 20.00
    total_paint_cost = total_paint_cans * paint_price_per_can
    total_cost_of_job = labor_cost + total_paint_cost
    results (hours_of_labor, total_paint_cans, labor_cost, total_paint_cost, total_cost_of_job)

# And this function exists solely to output the data in a nice format.
def results(hours_of_labor, total_paint_cans, labor_cost, total_paint_cost, total_cost_of_job):
    print 'The total number of gallons of paint required is: %.2f' % total_paint_cans
    print 'The number of hours of labor required will be: %.2f' % hours_of_labor
    print 'The cost of paint will be: $%.2f' % total_paint_cost
    print 'The cost of labor will be: $%.2f' % labor_cost
    print 'The total cost of the job will be: $%.2f' % total_cost_of_job

main()
