import random

class Client:														   		   #
	def __init__(self):														   #
		self.myfullname			= ""
		self.troops				= 1000 # troops remaining, def=1000

Scott = Client()
Scott.myfullname = "SCOTT"
Grace = Client()
Grace.myfullname = "GRACE"




def battle_death_kill(player1, player2, p1dice, p2dice):
	p1_end_point = player1.troops / 2
	p2_end_point = player2.troops / 2

	while (player1.troops > p1_end_point) and (player2.troops > p2_end_point) \
		and (player1.troops > 0) and (player2.troops > 0):
		if p1dice == 2: 
			p1_results = [random.randint(1,10),
						  random.randint(1,10)]
		elif p1dice == 3:
			p1_results = [random.randint(1,10),
						  random.randint(1,10),
						  random.randint(1,10)]
		if p2dice == 2: 
			p2_results = [random.randint(1,10),
						  random.randint(1,10)]
		elif p2dice == 3:
			p2_results = [random.randint(1,10),
						  random.randint(1,10),
						  random.randint(1,10)]

		print(p1_results)
		p1_results.sort()
		print(p1_results)

		print("\n")
		print(p2_results)
		p2_results.sort()
		print(p2_results)

		if p1_results[0] > p2_results[0]:
			player2.troops -= 1
		elif p1_results[0] < p2_results[0]:
			player1.troops -= 1
		if p1_results[1] > p2_results[1]:
			player2.troops -= 1
		elif p1_results[1] < p2_results[1]:
			player1.troops -= 1

	print("After:\t")
	print(player1.myfullname + "\t" + str(player1.troops))
	print(player2.myfullname + "\t" + str(player2.troops))


print("Before:\t")
print("GRACE" + "\t" + str(Grace.troops))
print("SCOTT" + "\t" + str(Scott.troops))

battle_death_kill(Grace, Scott, 2, 3)