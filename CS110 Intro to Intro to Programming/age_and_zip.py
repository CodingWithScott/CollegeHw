# Scott A Felch, CS 110 S
#
# This program will output the user's age and zip code, both of which are read
# from the keyboard.

age = input('What is your age? ')
zip_code = input('What is your zip code? ')
name = raw_input('What is your name? ')
hometown = raw_input('What is your hometown? ')

# now print out the results

print 'My name is', name, 'and I am from the town of', hometown
print ' I am', age, 'years old and I live in the', zip_code, 'zip code.'

finish = input('Hit enter to exit...')
