# Scott Felch
# 20 January 2010
# CS 110 S
# Exercise 3.7
# This program will accept user input for amount of fat and carbohydrates
# (in grams) the user has consumed today, then calculate the number of calories
# from each.

# First I will explain the program and gather user input
def main():
    print 'This program will tell you how many calories you have consumed today, based on the amount of fat and carbs consumed.'
    num_of_fat = input('Please enter the number of grams of fat consumed today: ')
    num_of_carb = input('Please enter the number of grams of carbs consumed today: ')
    # Convert both variables to floats to avoid integer multiplication
    float(num_of_fat)
    float(num_of_carb)
    # The number of grams of fat and number of grams of carbs
    # will be passed to the calculation function.
    calculation(num_of_fat, num_of_carb)

# Here the calculation function takes the user input, computes results
# and outputs it to the screen.
def calculation(num_of_fat, num_of_carb):
    cal_from_fat = num_of_fat * 9.0
    cal_from_carb = num_of_carb * 4.0
    totalcal = cal_from_fat + cal_from_carb
    print 'The total number of calories from fat was: %.2f' % cal_from_fat
    print 'The total numer of calories from carbs was: %.2f' % cal_from_carb
    print 'The total number of calories consumed was: %.2f' % totalcal

main()
