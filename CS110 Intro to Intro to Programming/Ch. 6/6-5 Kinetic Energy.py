# Scott Felch
# 8 February 2010
# CS 110 S
# Exercise 6.5, Kinetic Energy
# This program will accept user input for an object's mass and velocity,
# pass those to a function which will compute the object's kinetic energy,
# then return the results back to the main function and display results.

def main():
    # First I'll explain the purpose of the program to the user and gather input.
    print 'This program will calculate the kinetic energy of an object for you.'
    mass = input('What is the object\'s mass in kilograms?  ')
    velocity = input('What is the object\'s velocity in meters per second?  ')
    # To ensure accurate calculations I'll make sure the numbers are floats.
    mass = float(mass)
    velocity = float(velocity)

    # I'll pass the two values to the 'kinetic_energy' function to
    # perform calculations.
    ke = kinetic_energy (mass, velocity)

    # The variable 'ke' now has the value of the kinetic energy
    print '\n'
    print 'You entered a mass of', mass, 'kilograms.'
    print 'You entered a velocity of', velocity, 'meters per second.'
    print 'The kinetic energy of the object is', ke, 'joules.'

def kinetic_energy(mass, velocity):
    # This is the actual calculation part of the program. KE is a variable
    # that stands for "kinetic energy", not to be confused with the function
    # named kinetic_energy.
    ke = 0.5 * mass * velocity**2
    return ke
    
main()    
