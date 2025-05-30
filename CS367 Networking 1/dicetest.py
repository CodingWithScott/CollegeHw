import random

def dice_roll(how_many):
	die1 = random.randint(1, 10)
	die2 = random.randint(1, 10)
	die3 = random.randint(1, 10)

	if how_many == 2:
		return (die1, die2)
	elif how_many == 3:
		return (die1, die2, die3)



one 	= 0
two 	= 0
three 	= 0
four 	= 0
five 	= 0
six 	= 0
seven 	= 0
eight 	= 0
nine 	= 0
ten		= 0


for count in range(1, 100000000):
	curr_number = random.randint(1,10)
	if curr_number == 1:
		one += 1
	elif curr_number == 2:
		two += 1
	elif curr_number == 3:
		three += 1
	elif curr_number == 4:
		four += 1
	elif curr_number == 5:
		five += 1
	elif curr_number == 6:
		six += 1
	elif curr_number == 7:
		seven += 1
	elif curr_number == 8:
		eight += 1
	elif curr_number == 9:
		nine += 1
	elif curr_number == 10:
		ten += 1

print("one:\t" + str(one))
print("two:\t" + str(two))
print("three:\t" + str(three))
print("four:\t" + str(four))
print("five:\t" + str(five))
print("six:\t" + str(six))
print("seven:\t" + str(seven))
print("eight:\t" + str(eight))
print("nine:\t" + str(nine))
print("ten:\t" + str(ten))

