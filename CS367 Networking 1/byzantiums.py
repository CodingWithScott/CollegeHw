""" Byzantium Generals Server """

#!/usr/bin/env python
import argparse		# command line arguments
import os			# used for clearing terminal
import random		# used for "any" chat command
import re 			# regular expressions
import select
import socket
import sys
import time 		# used for timeout

parser = argparse.ArgumentParser(description='Basic chat server')
parser.add_argument('-f','--forcesize',
	help='Enter force size (default number of troops)',
	default=1000, 
	required=False,
	type=int)
parser.add_argument('-l','--lobbytime',  
	help='Enter lobby wait time in seconds', 
	default=15, 
	required=False,
	type=int)
parser.add_argument('-m','--minplayers', 
	help='Enter minimum number of players',  
	default=3,  
	required=False,
	type=int)
parser.add_argument('-t','--timeout', 
	help='Enter a timeout length in seconds', 
	default=2, 
	required=False,
	type=int)

args = parser.parse_args()

# putting this in so I can avoid typing "args.blahblah" later
troops_default	= args.forcesize
lobbytime 		= args.lobbytime
minplayers 		= args.minplayers
timeout 		= args.timeout

start_timeout = time.time()

host 		= ''
port 		= 36735
backlog 	= 5		# of messages to store prior to processing
msg_size 	= 608	# character limit for messages received from clients
running 	= 1

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server.bind((host,port))
server.listen(backlog)
input 		= [server,sys.stdin]

"""		TO DO:
	High priority
-Change default flag values back to required things before submitting

	Medium priority
-Phase 3

	Low priority
-Only display server stats if they've changed since last display
-Debug mode. 
	Mode 1: record into a text file all text received
	Mode 2: record into a text file all text sent
	Mode 3: record into a text file all text sent and received
"""
os.system('cls' if os.name == 'nt' else 'clear')	# clear terminal
line1 = "Welcome to..."
line2 = "Today's a good day to die."
print(line1.center(72))

print("\t________   ________  ___   _   _ _____ _____ _   _  _____ ")
print("\t| ___ \ \ / /___  / / _ \ | \ | |_   _|_   _| \ | ||  ___|")
print("\t| |_/ /\ V /   / / / /_\ \|  \| | | |   | | |  \| || |__  ")
print("\t| ___ \ \ /   / /  |  _  || . ` | | |   | | | . ` ||  __| ")
print("\t| |_/ / | | ./ /___| | | || |\  | | |  _| |_| |\  || |___ ")
print("\t\____/  \_/ \_____/\_| |_/\_| \_/ \_/  \___/\_| \_/\____/ ")
print("\t    _____  _____ _   _  ___________  ___   _      _____      ")
print("\t   |  __ \|  ___| \ | ||  ___| ___ \/ _ \ | |    /  ___|     ")
print("\t   | |  \/| |__ |  \| || |__ | |_/ / /_\ \| |    \ `--.      ")
print("\t   | | __ |  __|| . ` ||  __||    /|  _  || |     `--. \     ")
print("\t   | |_\ \| |___| |\  || |___| |\ \| | | || |____/\__/ /     ")
print("\t    \____/\____/\_| \_/\____/\_| \_\_| |_/\_____/\____/      ")
print("\n")
print(line2.center(72))
print("\n")
print("-----------------------------------------------------------------------")
print("Lobby time:\t\t\t\t\t\t\t     "	+ str(lobbytime))
print("Min players:\t\t\t\t\t\t\t     "	+ str(minplayers))
print("Timeout:\t\t\t\t\t\t\t     "		+ str(timeout))
print("-----------------------------------------------------------------------")

################################################################################
# CLIENT: Holds buffer components, message/name strings, FSM state, and 	   #
#		  game-related values. 												   #
################################################################################
class Client:														   		   #
	def __init__(self):														   #
		# buffer components													   #
		self.buffstr 			= ""	# raw buffer received from TCP stream  #
		self.index 				= -1	# where I'm at processing buffer	   #
		self.msg 				= ""	# cchat message being assembled 	   #
		self.msg_parts			= []	# "" disassembled for analysis  	   #
																		       #
		# intermediate steps										   		   #
		self.my_name_bldr 		= ""	# cjoin name as it's being assembled   #
		self.filename			= ""	# first part of filename, before dot   #
		self.ext		 		= ""	# file extension, after dot		   	   #
																	   		   #
		# final product of name (and optional extension)			   		   #
		self.last_strike_reason	= ""		# used by kick function			   #
		self.my_fullname 		= ""		# filename + "." + ext		   	   #
		self.state 				= "start"	# current FSM state			   	   #
		self.strikes 			= 0			# total strikes accrued			   #			
		self.their_name			= ""		# cchat recipients as 			   #
											# being assembled  	   			   #
																			   #
		# game-related data   	   											   #
		# 1. Used to differentiate between offers being depleted or just  	   #
		#    never had any. 												   #
		# 2. Offers for alliances received from other users, stored as a list  #
		#    of strings. Format: ["R#,ALLY,ATTACKEE"] 						   #
		# 3. Flag for making an outgoing offer in Phase 1 					   #
		#	 Format: "APPROACH" or "PASS" 									   #
		# 4. Flag for outgoing offer getting accepted in Phase 2 			   #
		#    Format: "ACCEPT" or "DECLINE" 									   #
		# 5. Flag for action in Phase 3 									   #
		#	 Format: "ATTACK" or "PASS" 									   #
		self.had_offers 		= False		# 1 							   #
		self.incoming_offers	= []		# 2 							   #
		self.in_game 			= False		# False = in lobby, True = in game #
		self.offer_p1_action	= ""		# 3 							   #
		self.offer_p2_action	= ""		# 4 							   #
		self.offer_p3_action	= ""		# 5 							   #
		self.offer_ally			= ""		# Person you accepted an offer from#
		self.offer_victim 		= ""		# Who your alliance will attack    #
		self.outgoing_offer		= ""		# Plan for Phase 1 				   #
		self.phase1_responded	= False 									   #
		self.phase2_responded	= False 									   #
		self.phase3_responded	= False										   #
		self.player_num			= 0 		# assigned upon cjoin 			   #
		self.troops				= troops_default 							   #
################################################################################

################################################################################
# STRIKE/KICK: Issue a strike to users, send message + reason, and 	   		   #
# kick if user accumulates 3 strikes.								   		   #
################################################################################
def strike(me, reason):												   		   #
	clients[me].strikes += 1 										   		   #
	clients[me].last_strike_reason = reason 						   		   #
	if reason == "(malformed)":										   		   #
		clients[me].state = "resync1" 								   		   #
	#clients[me].last_cmd_time = calendar.timegm(time.gmtime())		   		   #
	output_msg = "Striking client:\t" + clients[me].my_fullname		   		   #
	output_msg += "\treason:\t" + reason							   		   #	
	output_msg += "\tstrikes:\t" + str(clients[me].strikes)			   		   #
	print(output_msg)												   		   #
	server_response = "(strike("								   	   		   #
	server_response += str(clients[me].strikes) + ")"			   	   		   #
	server_response += reason + ")" 										   #
	schat(s, server_response, "strike()") 									   #
def kick_user(me):													   		   #
	global all_pnums

	server_response = "(kick" + clients[me].last_strike_reason + ")"	   	   #
	schat(me, server_response, "kick_user()") 								   #
	output_msg = "Kicking client:\t\t" + clients[me].my_fullname		   	   #
	output_msg += "\treason:\t" + clients[me].last_strike_reason		   	   #
	
	# I sure hope these two lines work
	pnum_to_remove = clients[me].player_num
	all_pnums[pnum_to_remove] = ""
	
	del clients[me]													   		   #
	input.remove(me)												   	   		   #
	print(output_msg)												   		   #
	me.close()														   		   #
	sstat()															   		   #
################################################################################

################################################################################
# BROADCAST: Broadcast server messages to all clients. 						   #
# SCHAT:	 Send a message from server to specific user. 					   #
# CCHAT: 	 Process incoming user data to send a message from a user to all   #
#			 users, a random user, single user, a list of specific users, or   #
#			 sending server commands. Strikes given for invalid commands or    # 
# 			 users.	   									   					   #
################################################################################
def broadcast(outgoing_msg): 
	for each in clients: 												
		if each != s:
			# s == current socket, from main select loop
			schat(each, outgoing_msg, "broadcast()")
def schat(me, outgoing_msg, sending_function):
	try:
		me.send(outgoing_msg)
	except socket.error:
		print("Socket error:\t" + sending_function)
def cchat(me):
	global curr_round 	# why the fuck do I have to do this??
	# will use these just for server console output, not sent to users
	sending_to 		= clients[me].their_name
	sending_from 	= clients[me].my_fullname
	sending_type	= "" 
	msg 			= clients[me].msg

	# Check if this socket has a username already , don't continue
	if clients[me].my_fullname == "":
		print("User attempting to send without joining")
		strike(me, "(malformed)")
	else:
		# split recipients into a list if there's >1 person
		if "," in clients[me].their_name:
			ppl_list = clients[me].their_name.split(",")
			ppl_list = [x.upper() for x in ppl_list]
		else:
			ppl_list = clients[me].their_name
			ppl_list = ppl_list.upper()
		
		outgoing_msg = "(schat(" + clients[me].my_fullname 
		outgoing_msg += ")(" + clients[me].msg + "))"

		# send broadcast message 
		if ppl_list == "ALL":
			sending_type = "BROADCAST"
			# iterate through entire hashtable of names and send
			for them in clients:
				if them != me:
					schat(them, outgoing_msg, "cchat ALL")

		# send random message
		elif ppl_list == "ANY":
			sending_type = "RANDOM"
			# need to randomly choose an entry from hash table
			random_guy = random.choice(clients.keys())
		
			# if random value turns out to be the sender, then try again
			while random_guy == me:
				random_guy = random.choice(clients.keys())

			sending_to = clients[random_guy].my_fullname
			schat(random_guy, outgoing_msg, "cchat ANY")

		# send to specific user
		elif (type(ppl_list) == str) and (ppl_list != "SERVER"):
			sending_type = "SINGLE USER"
			all_valid_users = list_all_users()
			# check if it's a valid user to send to
			if ppl_list not in all_valid_users:
				strike(me, "(malformed)")
				console_output  = "Issuing strike to " + sending_from 
				console_output += " for invalid recipient:\t"
				console_output += ppl_list
				print(console_output)
			else:
				for them in clients:
					# send msg when curr_sock name matches homie in ppl_list
					if clients[them].my_fullname in ppl_list:
						schat(them, outgoing_msg, "cchat SINGLE-USER")
						break

		# send to multiple users
		elif (type(ppl_list) == list):
			sending_type = "MULTI USER"
			all_valid_users = list_all_users().split(",")

			# strike for any reserved words in the recipient list
			# any number of invalid names = 1 strike, so use elif blocks
			if "ALL" in ppl_list:
				ppl_list.remove("ALL")
				strike(me, "(malformed)")
				console_output  = "Issuing strike to " + sending_from 
				console_output += " for invalid recipient:\tALL"
				print(console_output)
			elif "ANY" in ppl_list:
				ppl_list.remove("ANY")
				print(clients[me].my_fullname + "used reversed name ANY")
				strike(me, "(malformed)")
				console_output  = "Issuing strike to " + sending_from 
				console_output += " for invalid recipient:\tANY"
				print(console_output)
			elif "SERVER" in ppl_list:
				ppl_list.remove("SERVER")
				strike(me, "(malformed)")
				console_output  = "Issuing strike to " + sending_from 
				console_output += " for invalid recipient:\tSERVER"
				print(console_output)

			# strike for any invalid users in the recipient list
			for curr_name in ppl_list:
				if curr_name not in all_valid_users:
					strike(me, "(malformed)")
					console_output  = "Issuing strike to " + sending_from 
					console_output += " for invalid recipient:\t"
					console_output += curr_name
					print(console_output)
				
			# send message to all connected users in the recipient list
			for them in clients:
				# send msg when the curr_sock name is in ppl_list
				if clients[them].my_fullname in ppl_list:
					schat(them, outgoing_msg, "cchat MULTI-USER")

		# perform game commands
		elif ppl_list == "SERVER":
			sending_type = "GAME"
			clients[me].msg_parts = msg.split(",")
			
			# if client is out of sync then strike and give default values
			if int(clients[me].msg_parts[1]) != curr_round:
				print(clients[me].my_fullname + " has wrong round")
				strike(me, "(malformed)")
				clients[me].outgoing_offer = "PASS"
		
			######################### PHASE 1 COMMANDS #########################
			#	Propose a plan to an ally and link their name to you,
			#   or pass your turn.
			elif clients[me].msg_parts[0].upper() == "PLAN":
				# strike player if attemping more than 1 offer per round
				if clients[me].phase1_responded:
					print(clients[me].my_fullname + " already sent a plan")
					strike(me, "(malformed)")
				else:
					clients[me].phase1_responded = True

					if "APPROACH" in clients[me].msg_parts[2].upper():
						# msg_parts[0] == PLAN
						# msg_parts[1] == ROUND #
						# msg_parts[2] == APPROACH
						ally = clients[me].msg_parts[3].upper()
						attackee = clients[me].msg_parts[4].upper()

						clients[me].offer_p1_action = "APPROACH"
						# NOTE: Don't want to set THEM to have a victim or ally
						# yet because they haven't accepted the offer.
						clients[me].offer_ally = ally
						clients[me].offer_victim = attackee

						# after assembling the plan store it in client's
						# "outgoing_offer" field, will send it in phase1().
						clients[me].outgoing_offer = clients[me].msg_parts
						debug  = clients[me].my_fullname + " approached " + ally
						debug += " to attack " + attackee

					elif "PASS" in clients[me].msg_parts[2].upper():
						clients[me].offer_p1_action = "PASS"
						clients[me].outgoing_offer = "PASS"
			####################################################################

			######################### PHASE 2 COMMANDS #########################
			#	Accept or decline incoming offers, to notify sending party
			elif clients[me].msg_parts[0] == "ACCEPT":
				# valid is used to check for accepting imaginary treaties
				valid = False	
				# msg_parts[0] == "ACCEPT" or "DECLINE"
				# msg_parts[1] == R#
				# msg_parts[2] == ALLY_NAME
				potential_ally = clients[me].msg_parts[2]

				# valid will be set to True if the user specified (THEM) 
				# actually did propose alliance to current guy (ME)
				them = find_socket(potential_ally)
				if clients[them].offer_ally == clients[me].my_fullname:
					valid = True
					clients[me].offer_ally = potential_ally
					clients[me].phase2_responded = True
					clients[me].offer_p2_action = "ACCEPT"
					clients[me].offer_victim = clients[them].offer_victim

				if not valid:
					temp = clients[me].my_fullname  
					print(temp + " accepted imaginary treaty")
					strike(me, "(malformed)")
				print("Registered ACCEPT from " + clients[me].my_fullname)

			elif clients[me].msg_parts[0] == "DECLINE":				
				valid = False	
				# msg_parts[0] == "ACCEPT" or "DECLINE"
				# msg_parts[1] == R#
				# msg_parts[2] == ALLY_NAME
				potential_ally = clients[me].msg_parts[2]

				# valid will be set to True if the user specified (THEM) 
				# actually did propose alliance to current guy (ME)
				them = find_socket(potential_ally)
				if clients[them].offer_ally == clients[me].my_fullname:
					valid = True
					# still store ally name even though declined, need it 
					# for printing messages
					clients[me].offer_ally = clients[them].my_fullname
					clients[me].phase2_responded = True
					clients[me].offer_p2_action = "DECLINE"
					clients[me].offer_victim = clients[them].offer_victim
				if not valid:
					temp = clients[me].my_fullname
					print(temp + " declined imaginary treaty")
					strike(me, "(malformed)")
				print("Registered DECLINE from " + clients[me].my_fullname)
			####################################################################

			######################### PHASE 3 COMMANDS #########################
			elif clients[me].msg_parts[0] == "ACTION":
				# clients[me].msg_parts[1] == R#
				if clients[me].msg_parts[2] == "ATTACK":
					# shit is about to get REAL, player is actually going 
					# to do it!!
					clients[me].offer_p3_action = "ATTACK"
					clients[me].offer_victim = clients[me].msg_parts[3]
					attacker_num = clients[me].player_num
					victim_num = find_pnum(clients[me].offer_victim)

					try:
						battles[attacker_num][victim_num] = 1
					except:
						print("That's not a valid attack or victim")

					clients[me].phase3_responded = True
					print("Registered ATTACK from " + clients[me].my_fullname)
				elif clients[me].msg_parts[2] == "PASS":
					clients[me].phase3_responded = True
					clients[me].offer_p3_action = "PASS"
					print("Registered PASS from " + clients[me].my_fullname)
			####################################################################
				
	console_output =  sending_from + " sent a " 
	console_output += sending_type + " message to "

	console_output += sending_to + ":\n\t" + msg + "\n"
	print(console_output)

	clients[me].their_name = ""
	clients[me].msg = ""
################################################################################

################################################################################
# CJOIN: Method for a client joining chat session. Handles name filtering 	   #
#        and collisions. 										   			   #
################################################################################
def cjoin(me):
	global all_pnums

	# If socket is requested a username and they already have one, then strike	
	if clients[me].my_fullname != "":
		strike(me, "(malformed) cjoin")
		console_output  = "Issuing strike to " + clients[me].my_fullname 
		console_output += " for requesting a second CJOIN"
		print(console_output)
	else:
		# mnb is just my_name_bldr, just doing this to control width of code
		
		mnb = clients[me].my_name_bldr
		stripName(me)

		# strike for empty name
		if mnb == "":	
			strike(me, "(malformed) empty name")
		# strike for reserved names
		elif mnb.upper() == "ALL":
			strike(me, "(malformed) reserved word ALL")
		elif mnb.upper() == "ANY":
			strike(me, "(malformed) reserved word ANY")
		elif mnb.upper() == "SERVER":
			strike(me, "(malformed) reserved word SERVER")
		# strike if there's >1 dot remaining
		elif any(mnb.count(x) > 2 for x in mnb if x == "."):
			strike(me, "(malformed) more than 1 dot")
		else:
			# split the username into filename and extension, if necessary
			name_chunks = re.split('[.]', clients[me].my_name_bldr)
			clients[me].filename = name_chunks[0]

			if len(name_chunks) == 1:
				if len(name_chunks[0]) > 8:
					clients[me].filename[0] = name_chunks[0][:6] + "~1"
				clients[me].my_fullname = clients[me].filename
			
			elif len(name_chunks) == 2:
				clients[me].ext = name_chunks[1]
				if len(clients[me].ext) > 3:
					clients[me].ext = clients[me].ext[:3]
				clients[me].my_fullname  = clients[me].filename 
				clients[me].my_fullname += "." + clients[me].ext
			
			# increment name if filename+ext is already taken 
			if name_exists(me, clients[me].my_fullname):
				print("Duplicate name detected:\t" + clients[me].my_fullname)
				while name_exists(clients[me].my_fullname):
					incr_name(me)
			
			# after appropriate incrementation is done then clients[me] 
			# will have a unique name
			if len(name_chunks) == 1:
				clients[me].my_fullname = clients[me].filename
			elif len(name_chunks) == 2:
				clients[me].my_fullname  = clients[me].filename 
				clients[me].my_fullname += "." + clients[me].ext
			
			clients[me].my_fullname = clients[me].my_fullname.upper()

			# find 1st available player number and assign it in player object
			# and global directory of player numbers
			for x in range (1, 30):
				if all_pnums[x] == "":
					clients[me].player_num = x
					print("Assigned player number " + str(x) + " to " + clients[me].my_fullname)
					all_pnums[x] = clients[me].my_fullname
					break

			# confirm join and send response
			server_response = "(sjoin("
			server_response += clients[me].my_fullname + ")("
			server_response += list_all_users() + ")("
			server_response += str(minplayers) + ","
			server_response += str(lobbytime) + ","
			server_response += str(timeout) + "))"
			schat(me, server_response, "cjoin")
			sstat()

			print("Added:\t\t\t\t\t\t\t\t" + clients[me].my_fullname)
			print("Player number:\t\t\t\t\t\t\t" + str(clients[me].player_num))
			print("Total clients:\t\t\t\t\t\t\t     " + str(len(clients)))
			
	# User may have been kicked above, check if entry still exists in hash 
	# table before trying to reset this			
	if clients.get(me, 0) != 0:
		clients[me].my_name_bldr = ""
################################################################################

################################################################################
# Misc helpers for CSTAT, STAT, CJOIN, and PHASE#()							   #
################################################################################
# Checks if all players have submitted their resposnes for next round 		   #
def all_ready(which_phase): 												   #
	# Assume players are all ready, return False if found one who isn't 	   #
	if which_phase == 1: 													   #
		for each in clients: 												   #
			if clients[each].in_game and not clients[each].phase1_responded:   #
				return False 												   #
		return True 														   #
	elif which_phase == 2: 													   #
		for each in clients: 												   #
			if clients[each].in_game and not clients[each].phase2_responded:   #
				return False 												   #
		return True 														   #
	elif which_phase == 3: 													   #
		for each in clients: 												   #
			if clients[each].in_game and not clients[each].phase3_responded:   #
				return False 												   #
		return True 														   # 
# Print a pretty title to announce beginning of next phase 					   #
def announce_phase(which_phase): 											   #
	message1  = "*******************************************" 				   #
	message1 += "****************************" 								   #
	message2  = " Begin Phase " + str(which_phase)							   #
	print(message1) 														   #
	print(message2.center(71, "*")) 										   #
	print(message1) 														   #
# Assign an offer from sender's outbox to recipient's incoming offers inbox.   #
def assign_offer(me, round_num, ally, attackee): 							   #
	# Find ally and append the offer to his incoming_offers 				   #
	# Going to append in form:	 "R#,SENDER,ATTACKEE" 						   #
	sender = clients[me].my_fullname 										   #
	for them in clients: 													   #
		if clients[them].my_fullname == ally:	 							   #
			# will have either OFFER or OFFERL prepended when schat() sends    #
			offer = "" 														   #
			offer = round_num + "," + sender + "," + attackee 				   #
			clients[them].incoming_offers.append(offer) 					   #
			break 															   #
# Pit two generals against each other in battle, num dice inidicates who is    #
# attacking and who is defending. Player1/player2 = sockets					   #
def battle_death_kill(player1, player2, p1dice, p2dice): 					   #
	p1_end_point = clients[player1].troops / 2 								   #
	p2_end_point = clients[player2].troops / 2 								   #
																			   #
	while (clients[player1].troops > p1_end_point) and  \
		  (clients[player2].troops > p2_end_point) and  \
		  (clients[player1].troops > 0) and \
		  (clients[player2].troops > 0): 					  				   #
		if p1dice == 2:  													   #
			p1_results = [random.randint(1,10),								   #
						  random.randint(1,10)] 							   #
		elif p1dice == 3: 													   #
			p1_results = [random.randint(1,10), 							   #
						  random.randint(1,10), 							   #
						  random.randint(1,10)] 							   #
		if p2dice == 2:  													   #
			p2_results = [random.randint(1,10), 							   #
						  random.randint(1,10)] 							   #
		elif p2dice == 3: 													   #
			p2_results = [random.randint(1,10), 							   #
						  random.randint(1,10), 							   #
						  random.randint(1,10)] 							   #
						  													   #
		p1_results = sorted(p1_results, reverse=True)				  		   #
		p2_results = sorted(p2_results, reverse=True)				  		   #
		if p1_results[0] > p2_results[0]: 									   #
			clients[player2].troops -= 1 									   #
		elif p1_results[0] < p2_results[0]: 								   #
			clients[player1].troops -= 1 									   #
		if p1_results[1] > p2_results[1]: 									   #
			clients[player2].troops -= 1 									   #
		elif p1_results[1] < p2_results[1]: 								   #
			clients[player1].troops -= 1 									   #


	if p1_end_point == clients[player1].troops:
		print("Victor:\t" + clients[player2].my_fullname)
		print("Loser:\t" + clients[player1].my_fullname)
	elif p2_end_point == clients[player2].troops:
		print(clients[player2].my_fullname + " has lost!")
# Send a message to a specific user who requested server info   		   	   #
def cstat(me):																   #
	all_user_stats = list_all_user_stats()								   	   #											   #
	server_response = "(sstat(" + all_user_stats + "))"				   		   #
	schat(me, server_response, "cstat()")								   	   #
# Send congratulations to last user in-game, reset all server variables		   #
def declare_winner(): 														   #
	for each in clients: 													   #
		if clients[each].in_game == True: 									   #
				outgoing_msg = "(schat(SERVER)(A winner is you!))" 			   #
				schat(each, outgoing_msg, "declare_winner()")				   #
# Accept user name and return their player number 							   #
def find_pnum(name): 														   #
	global all_pnums 														   #
	for x in range(1, 30): 													   #
		if all_pnums[x] == name: 											   #
			return x 														   #
# Accept user name and return their socket 									   #
def find_socket(name):														   #
	for them in clients:													   #
		if clients[them].my_fullname == name: 								   #
			return them 													   #
	return "Sorry to crash your program here, but user doesn't exist man." 	   #
# Check for last man standing, used to check whether to go Phase 3 --> Phase 1 #
def game_over(): 															   #
	active_users = 0 														   #
	for each in clients: 													   #
		if clients[each].in_game: 											   #
			active_users += 1 												   #
	if active_users > 1: 													   #
		return False 														   #
	elif active_users <= 1: 												   #
		return True 														   #
# Increment DOSname to next appropriate name, if name is already taken.		   #					   		   #
def incr_name(me): 															   #
	newfilename = "" 														   #
	old = clients[me].filename												   #
																			   #
	# this worked flawlessly for 1-1000 users until one day I changed variable #
	# names elsewhere in the program and now it's fucked. Maybe fix someday,   #
	# try block for now. 													   #
	try: 																	   #
		# name = "SCOTTY" --> "SCOTTY~1"	 								   #
		if not (old[len(old)-1].isdigit()) and not (old[len(old)-2] == "~"):   #
			newfilename = old[:len(old)-2] + "~1" 							   #
		# name = "SCOTT~1" --> "SCOTT~9" 									   #
		elif (old[len(old)-1].isdigit()) and (old[len(old)-2] == '~'): 		   #
			if int(old[len(old)-1]) < 9: 									   #
				newfilename  = old[:len(old)-1]  						   	   #
				newfilename += str(int(old[len(old)-1])+1) 					   #
			elif int(old[len(old)-1]) == 9: 								   #
				newfilename  = old[:len(old)-2]+'~'  						   #
				newfilename += str(int(old[len(old)-1]) + 1) 				   #
		# name = "SCOT~10" --> "SCOT~99" 									   #
		elif (old[len(old)-1].isdigit()) and (old[len(old)-2].isdigit()): 	   #
			if (old[len(old)-3] == '~'): 									   #
				if int(old[len(old)-2:]) < 99: 								   #
					newfilename  = old[:len(old)-2]  						   #
					newfilename += str(int(old[len(old)-2:]) + 1) 			   #
				elif int(old[len(old)-2:]) == 99: 							   #
					newfilename  = old[:len(old)-4]  						   #
					newfilename += '~' + str(int(old[len(old)-2:]) + 1) 	   #
		# name = "SCO~100" --> "SCO~999" 									   #
		elif (old[len(old)-1].isdigit()) and (old[len(old)-2].isdigit()): 	   #
			if (old[len(old)-3].isdigit()) and (old[len(old)-4] == '~'): 	   #
					if int(old[len(old)-3:]) < 999: 						   #
						newfilename =  old[:len(old)-3]  					   #
						newfilename += str(int(old[len(old)-3:]   ) + 1) 	   #
					elif int(old[len(old)-3:]) == 999: 						   #
						print("You can't have 1000 of same name, sorry") 	   #
		else: 																   #
			print("Something fucked up, you should never see this") 		   #
	except: 																   #
		print("oops") 														   #
																			   #
	clients[me].filename = newfilename 										   #
																			   #
	# if no file extension then set fullname to just filename 				   #
	if clients[me].ext == "": 												   #
		clients[me].my_fullname = clients[me].filename 						   #
	# otherwise add the extension 											   #
	else: 																	   #
		clients[me].my_fullname = clients[me].filename + "." + clients[me].ext #			
# Initialize battles table with all 0s 										   #
def init_battles(): 														   #
	for x in range (0, 30): 												   #
		row = "" 															   #
		for y in range(0, 30): 												   #
			row += str(battles[x][y]) + " " 								   #
# Returns a string listing all players in format: USER~1,USER~2,BLAH~1 		   #
def list_all_users():												  		   #
	all_names = ""													   		   #
	for each in clients:											   		   #
		if all_names   == "":											   	   #
			all_names   = clients[each].my_fullname					   		   #
		elif all_names != "":										   		   #
			all_names   = all_names + "," + clients[each].my_fullname	   	   #
	return all_names												   		   
# Returns a string listing all players, their strikes, and troops remaining	   #
def list_all_user_stats(): 													   #
	results = ""  															   #
	for each in clients: 													   #
		if results == "": 													   #
			results   = clients[each].my_fullname + "," 					   #
			results  += str(clients[each].strikes) + "," 					   #
			results  += str(clients[each].troops) 							   #
		elif results != "": 												   #
			results  += "," + clients[each].my_fullname + "," 				   #
			results  += str(clients[each].strikes) + "," 					   #
			results  += str(clients[each].troops) 							   #
	return results		   													   #
# Check if (curr_time - last_interact_time) > lobby timeout period. 		   #
def lobby_timeout_check():													   #
	# Not going to lie, I still have no fucking idea what this function is     #
	# SUPPOSED to do gameplay-wise. Right now it just sits here and does       #
	# nothing. 																   #
	# print("lobby_timeout_check")											   #
	current_time = time.time() 												   #
																			   #
	for each in clients: 													   #
		if (current_time - clients[each].last_cmd_time) > lobbytime: 		   #
			clients[each].last_cmd_time = current_time 						   #
			#strike(each, "(timeout)") 										   #
			#strike(each, "(lobbytimeout)") 								   #
			if (clients[each].strikes >= 3): 								   #
				kick_user(each) 											   #
			# Break makes sure not to error out on this for loop if multiple   #
			# people kicked at once, but also limits to 1 kick per loop...     #
			break 															   #
# Check if the requested name exists already on the server 					   #
def name_exists(me, looking_for): 											   #
	for them in clients: 													   #
		if (clients[them].my_fullname == looking_for):
			# Make sure not to return a True when you find yourself
		 	if them != me:		   #
				return True 												   #
	return False													   		   #
# Return number of connected clients currently in-game 						   #
def num_players_ingame():	  												   #
	num_players = 0 														   #
	for each in clients: 													   #
		if clients[each].in_game: 											   #
			num_players += 1 												   #
	return num_players 														   #
# Broadcast every player's stats 							   		   		   #
def sstat():																   #
	all_user_stats = list_all_user_stats()								 	   #
	server_response = "(sstat(" + all_user_stats + "))"				   		   #
	for each in clients:													   #
		schat(each, server_response, "sstat()")								   #	
# Strip out non-printable ASCII chars, as well as parans. 					   #
def stripMsg(oldmsg):														   #
	newmsg = ""																   #
	for x in range(0, len(oldmsg)):											   #
		iv = ord(oldmsg[x]) 	# iv => integer value 						   #
		# allow integer values for letters and digits (respectively)		   #
		if (iv >= 42 and iv <= 126) or (iv >= 32 and iv <= 39): 			   #
			newmsg += oldmsg[x]												   #
	return newmsg															   #		
# Strip out all characters except alphanumeric (A-Z, 0-9) and a single 		   #	
# period somewhere in the middle of the name.								   #
def stripName(me):															   #
	clients[me].my_name_bldr = clients[me].my_name_bldr.upper()				   #
	newname = ""															   #
	for x in range(0, len(clients[me].my_name_bldr)):						   #
		iv = ord(clients[me].my_name_bldr[x])	# iv => integer value 		   #
		# allow letters, digits, and a period (respectively) 				   #
		if (iv >= 48 and iv <= 57) or (iv >= 65 and iv <= 90) or (iv == 46):   #
			newname += clients[me].my_name_bldr[x]							   #
	clients[me].my_name_bldr = newname  										   #
################################################################################

################################################################################
# PHASE FUNCTIONS: Performs end-of-phase behavior, after all players respond   #
# PHASE 1: Ask players for proposed plans.									   #
# PHASE 2: Collect all plan proposal responses from users 					   #
# PHASE 3: Ask users if they wish to attack or pass, then compute battles	   #
#		   and send results. Loop to Phase 1 until all users but 1 have died.  #
################################################################################
def main_game_loop():														   #
	# Loop through for set period of time checking for client responses.
	# Call phaseX() function to implement end-of-phase behavior once responses
	# have all been received.
	global clients
	global curr_phase
	global curr_round
	global minplayers
	global need_update
	global phase_start_time
	global phase_end_time


	display_phase = "Current phase:\t" + str(curr_phase)
	display_round = "Current round:\t" + str(curr_round)
	display_clients = "Number of clients connected:\t" + str(len(clients))

	if need_update:
		print(display_phase.center(72))
		print(display_round.center(72))
		print(display_clients.center(72))

		print("Players in-game:")
		for x in range (1, 30):
			if all_pnums[x] != "":
				log  = "Player #" + str(x) + ":\t\t" 
				log += all_pnums[x]
				print(log)

		need_update = False

	if num_players_ingame <= 1:
		curr_phase = 0

	if curr_phase == 0:
		# if time expires OR all players have responded, move on
		if int(len(clients)) >= int(minplayers):
			phase_start_time = time.time()
			#phase_start_time = int(phase_start_time)
			#phase_end_time = int(phase_end_time)
			phase_end_time = phase_start_time + timeout
			# everyone currently in lobby gets initialized when game goes live
			for each in clients:
				clients[each].in_game = True

			broadcast("(schat(SERVER)(PLAN," + str(curr_round) + "))")
			announce_phase(1)
			need_update = True
			curr_phase = 1
	elif curr_phase == 1:
		if all_ready(1):
			print("All players responded, entering Phase 1")
			need_update = True
			phase1()
			phase_start_time = time.time()
			phase_end_time = phase_start_time + timeout						   #
			announce_phase(2)
			curr_phase = 2
		elif time.time() > phase_end_time:
			print("Time expired, entering Phase 1")
			need_update = True
			phase1()
			phase_start_time = time.time()
			phase_end_time = phase_start_time + timeout						   #
			announce_phase(2)
			curr_phase = 2
	elif curr_phase == 2:
		if all_ready(2):
			print("All players responded, entering Phase 2")
			need_update = True
			phase2()								
			phase_start_time = time.time()
			phase_end_time = phase_start_time + timeout						   #
			announce_phase(3)
			broadcast("(schat(SERVER)(ACTION," + str(curr_round) + "))")
			curr_phase = 3
		elif time.time() > phase_end_time:
			print("Time expired, entering Phase 2")
			need_update = True
			phase2()								
			phase_start_time = time.time()
			phase_end_time = phase_start_time + timeout						   #
			announce_phase(3)
			broadcast("(schat(SERVER)(ACTION," + str(curr_round) + "))")
			curr_phase = 3
	elif curr_phase == 3:
		if all_ready(3):
			print("All players responded, entering Phase 3")
			need_update = True
			phase3()	
			phase_start_time = time.time()
			phase_end_time = phase_start_time + timeout						   #
		elif time.time() > phase_end_time:
		 	print("Time expired, entering Phase 3")
		 	need_update = True
			phase3()	
			phase_start_time = time.time()
			phase_end_time = phase_start_time + timeout						   #
		if not game_over():
			curr_round += 1
			need_update = True
			announce_phase(1)
			curr_phase = 1
		else:
			need_update = True
			declare_winner()
			curr_phase = 1
################################################################################

################################################################################
# PHASE 1: 																	   #
# 	Server sent out request for plans in Phase 0. Players responded to server  #
# 	with alliances they'd like to form with others before Phase 1 started. 	   #
#	Here I transfer the plans from user's outgoing_offers box and into the 	   #
# 	other party's incoming_offers box and send schats to notify them. 		   #
################################################################################
def phase1():
	global curr_round
	global p1_summary

	# Plan format = "PLAYERNAME,R#,PASS", or 
	# "PLAYERNAME,R#,APPROACH,ALLY,ATTACKEE"

	""" Transfer values from outgoing offers to players' offer inboxes """
	# Make sure all players sent in a plan, strike anyone without and assign
	# default value.
	for me in clients:
		if clients[me].in_game: 
			if clients[me].phase1_responded:
				if "PASS" in clients[me].outgoing_offer:
					log  = clients[me].my_fullname + " will PASS this turn."
					p1_summary.append(log)
				elif "APPROACH" in clients[me].outgoing_offer:
					# outgoing_offer[0] == PLAN
					round_num = clients[me].outgoing_offer[1] 					
					# outgoing_offer[2] == APPROACH
					ally = clients[me].outgoing_offer[3].upper()
					attackee = clients[me].outgoing_offer[4].upper() 
					clients[me].offer_victim = attackee

					sender = clients[me].my_fullname

					offer  = sender + "," + round_num + "," + ally + "," 
					offer += attackee

					# put the offer in the recipient's incoming offers
					# Send them my socket (me), my name, number,
					# name of ally I'm looking for and dude to attack.
					assign_offer(me, round_num, ally, attackee)

					log  = sender + " approached " + ally 
					log += " to attack " + clients[me].offer_victim

					if log not in p1_summary:
						p1_summary.append(log)

			elif not clients[me].phase1_responded:
				strike(me, "(gametimeout)")
				clients[me].plan = "PASS"
				log  = clients[me].my_fullname + " didn't respond and " 
				log += "will PASS this turn."
				if log not in p1_summary:
						p1_summary.append(log)

	""" Convert offers from players inboxes to outgoing schats """
	# All offers are now copied from outgoing_offer and stored in respective
	# incoming_offers inboxes. Schat all incoming_offers to players.
	for each in clients:
		if clients[each].in_game:
			num_offers = len(clients[each].incoming_offers)
			print(clients[each].my_fullname + " got " + str(num_offers) + " incoming offers!!")

			# If player has more than 1 incoming_offer need to tag as OFFERL
			# only for last entry.
			if num_offers >= 2:
				# iterate through client's offers they received
				# Keep track of offers already seen so not sending duplicate
				# schats.
				log = []

				# Send message to player for each of his stored incoming offers
				for x in range(0, num_offers):
					# If it's the last offer in list then do OFFERL
					if x == len(clients[each].incoming_offers)-1:
						outgoing_msg  = "(schat(SERVER)(OFFERL,"
						outgoing_msg += clients[each].incoming_offers[x] + "))"
						if outgoing_msg not in log:
							log.append(outgoing_msg)
							schat(each, outgoing_msg, "phase1() more than 1 offer")
					else:
						outgoing_msg  = "(schat(SERVER)(OFFER,"
						outgoing_msg += clients[each].incoming_offers[x] + "))"
						if outgoing_msg not in log:
							log.append(outgoing_msg)
							schat(each, outgoing_msg, "phase1() more than 1 offer")

			# If player only got a single offer just send it
			elif num_offers == 1:
				curr_offer = ''.join(clients[each].incoming_offers)
				outgoing_msg = "(schat(SERVER)(OFFERL," + curr_offer + "))"
				schat(each, outgoing_msg, "phase1() last offer")

			# If player got no offers at all then send a placeholder message
			elif num_offers == 0:
				# print("line 851")
				# print(clients[each].my_fullname + " got NO incoming offers!")
				outgoing_msg  = "(schat(SERVER)(OFFERL," 
				outgoing_msg += str(curr_round) + "))"
				schat(each, outgoing_msg, "phase1() no incoming offers")

	# print to console what happened this phase
	print("\nPhase 1 offer proposals summary:")
	for each_action in p1_summary:
		print(each_action)
	p1_summary = []
	print("\n")

################################################################################
# PHASE 2:	Inform players of the offers they were given in Phase 1, ask for   #
# 			confirmation of ACCEPT/DENY alliance, and then send the response   #
# 			back to original player offering the alliance. 					   #
################################################################################
def phase2():
	global curr_phase
	global p2_summary

	# Process clients' ACCEPT or DENIAL of the offers they were sent
	for me in clients:
		if not "PASS" in clients[me].outgoing_offer:
			if clients[me].offer_p2_action == "ACCEPT":
				them = find_socket(clients[me].offer_ally)

				outgoing_msg  = "(schat(SERVER)(ACCEPT," 
				outgoing_msg += str(curr_round) 
				outgoing_msg += "," + clients[me].my_fullname + "))"

				schat(them, outgoing_msg, "phase2 ACCEPT")

				log  = clients[me].my_fullname + " accepted " 
				log += clients[me].offer_ally + "'s offer to attack "
				log += clients[me].offer_victim
				p2_summary.append(log)
			elif clients[me].offer_p2_action == "DECLINE":
				them = find_socket(clients[me].offer_ally)
				
				outgoing_msg  = "(schat(SERVER)(DECLINE,"
				outgoing_msg += str(curr_round)
				outgoing_msg += "," + clients[me].my_fullname + "))"
				
				schat(them, outgoing_msg, "phase2 DECLINE")

				log  = clients[me].my_fullname + " declined " 
				log += clients[me].offer_ally + "'s offer to attack "
				log += clients[them].offer_victim

				p2_summary.append(log)

	print("\nPhase 2 summary:")
	for each in p2_summary:
		print(each)
	p2_summary = []

################################################################################
# PHASE 3:	Ask players wehther they will ATTACK or PASS in this round.  	   #
# 			Once all responses are received a broadcast is sent out to all 	   #
#			players in the form (schat(SERVER)(NOTIFY,R#,ATTACKER,ATTACKEE)).  #
# 			Battles are computed and players troops are modified. If people    #
#			still alive then loop back to Phase 1.
################################################################################
def phase3():
	print("Let the battles begin!")
	global battles
	global curr_phase
	global curr_round 
	
	for attacker in range(1, 30):
		for victim in range(1, 30):
			# found a battle... 
			if battles[attacker][victim] != 0:

				# get player socket from player number
				attacker_socket = find_socket(all_pnums[attacker])
				victim_socket = find_socket(all_pnums[victim])

				# if victim is fighting back then num of dice is equal
				if battles[victim][attacker] != 0:
					log  = clients[attacker_socket].my_fullname + " attacks " 
					log += clients[victim_socket].my_fullname + ", " 
					log += " fights back!"
					battle_death_kill(attacker_socket,victim_socket,3,3)
				# otherwise attacker gets an extra die
				elif battles[victim][attacker] == 0:
					log  = clients[attacker_socket].my_fullname 
					log += " attacks " 
					log += clients[victim_socket].my_fullname 
					log += ", is unprepared!"
					print(log)
					battle_death_kill(attacker_socket,victim_socket,3,2)
				# record who attacks who
				p3_summary.append(log)

				# record any defeats that occur and kick the loser
				if clients[attacker_socket].troops <= 0:
					log  = clients[attacker_socket].my_fullname
					log += " has been DEFEATED in round #:\t" + str(curr_round)
					p3_summary.append(log)
					clients[attacker_socket].last_strike_reason = "You lose!"
					kick_user(attacker_socket)
				elif clients[victim_socket].troops <= 0:
					log  = clients[victim_socket].my_fullname
					log += " has been DEFEATED in round #:\t" + str(curr_round)
					p3_summary.append(log)
					clients[victim_socket].last_strike_reason = "You lose!"
					kick_user(victim_socket)

				# clear battle data from matrix
				battles[attacker][victim] = 0
				battles[victim][attacker] = 0

	# reset all clients' data before continuing 							   #
	for each in clients:													   #
		clients[each].had_offers 	   	= False 							   #
		clients[each].incoming_offers 	= [] 								   #
		clients[each].offer_p1_action	= ""								   #
		clients[each].offer_p2_action	= ""	 							   #
		clients[each].offer_p3_action	= ""	 							   #
		clients[each].offer_ally		= ""								   #
		clients[each].outgoing_offer	= ""								   #
		clients[each].offer_victim 		= ""								   #
		clients[each].phase1_responded 	= False 							   #
		clients[each].phase2_responded 	= False 							   #
		clients[each].phase3_responded 	= False 							   #

	# send new scores out to clients
	sstat()

################################################################################
# FSM: Parses user input and directs data to appropriate functions     		   #
################################################################################
def fsm(me, data):
	## FSM decided upon by class:
	# http://i.imgur.com/1v6NUAI.png 

	## More verbose version, essentially equivalent: 
	# http://i.imgur.com/or5rSbU.jpg

	
	index = clients[me].index
	clients[me].buffstr += data
	
	while index < len(clients[me].buffstr)-1:
		index += 1

		# Leave for debug purposes
		# line_info = "x: " + str(index) 
		# line_info += "\tdata[" + str(index) 
		# line_info += "]:  " + clients[me].buffstr[index]
		# line_info += "\tstate:\t" + clients[me].state
		# line_info += "\t\tbuffer:\t" + clients[me].buffstr
		# print(line_info)

		# reach end of current buffer, done reading current message
		if clients[me].buffstr[index] == "":			
			break
		elif clients[me].state == "start":
			if clients[me].buffstr[index] == "(":				
				clients[me].state = "start2"
			else: 
				strike(me, "(malformed)")			
				print("reject start")
		elif clients[me].state == "start2":
			if clients[me].buffstr[index] == "c":
				clients[me].state = "start3"
			else: 
				clients[me].state = "resync2"
				strike(me, "(malformed)")
				print("reject start2")
		elif clients[me].state == "start3":
			if clients[me].buffstr[index] == "c":		
				clients[me].state = "chat1"
			elif clients[me].buffstr[index] == "j":		
				clients[me].state = "join1"
			elif clients[me].buffstr[index] == "s":		
				clients[me].state = "stat1"
			else: 
				# not spelling cchat, cjoin, or cstat
				strike(me, "(malformed)")		
				print("reject start3")
		
		############################## CHAT ################################		
		elif clients[me].state == "chat1":
			if clients[me].buffstr[index] == "h":
				clients[me].state = "chat2"
			else: 
				strike(me, "(malformed)")
				print("reject chat1")
		elif clients[me].state == "chat2":
			if clients[me].buffstr[index] == "a":
				clients[me].state = "chat3"
			else: 
				strike(me, "(malformed)")
				print("reject chat2")
		elif clients[me].state == "chat3":
			if clients[me].buffstr[index] == "t":
				clients[me].state = "chat4"
			else: 
				strike(me, "(malformed)")
				print("reject chat3")
		elif clients[me].state == "chat4":
			if clients[me].buffstr[index] == "(":
				clients[me].state = "chat5"
			else: 
				strike(me, "(malformed)")	# incorrectly placed paran
				print("reject chat4")
		elif clients[me].state == "chat5":
			# reading in list of names one char at a time until close paran
			if clients[me].buffstr[index] != ")":
				clients[me].their_name += clients[me].buffstr[index]
				if len(clients[me].their_name) == 419:
					#    30 names * 13 char name limit + 
					# +  29 commas 
					# =  419 char their_name limit
					strike(me, "(malformed)")
			else:
				clients[me].their_name = stripMsg(clients[me].their_name)
				clients[me].state = "chat6"
		elif clients[me].state == "chat6":
			# looking for a paran before beginning of message
			if clients[me].buffstr[index] == "(":
				clients[me].state = "chat7"
			else: 
				strike(me, "(malformed)")
				print("reject chat6")
		elif clients[me].state == "chat7":
			# reading in message one char at a time until 1st closing paran
			if clients[me].buffstr[index] != ")":
				clients[me].msg += clients[me].buffstr[index]
				
				# THIS SHIT IS BROKE
				
				# if msg is >80 chars then just truncate and skip to accept
				if len(clients[me].msg) == 80:	
					clients[me].msg = stripMsg(clients[me].msg)
					#clients[me].msg = clients[me].msg[:len(clients[me].msg)-2] + "))"
					clients[me].buffstr = clients[me].buffstr[:index]
					cchat(me)
					clients[me].state = "resync1"
					clients[me].buffstr = clients[me].buffstr[index+1:]
					index = -1
			else: 
				# Strip out any illegal chars in message before next state
				clients[me].msg = stripMsg(clients[me].msg)
				clients[me].state = "chat8"
		elif clients[me].state == "chat8":
			# looking for 2nd closing paran
			if clients[me].buffstr[index] == ")":
				cchat(me)
				clients[me].buffstr = clients[me].buffstr[index+1:]
				index = -1
				clients[me].state = "start"

		############################## JOIN ################################
		elif clients[me].state == "join1":
			if clients[me].buffstr[index] == "o":
				clients[me].state = "join2"
			else: 
				strike(me, "(malformed)")	# misspelled cjoin
				print("reject join1")
		elif clients[me].state == "join2":
			if clients[me].buffstr[index] == "i":
				clients[me].state = "join3"
			else: 
				strike(me, "(malformed)")
				print("reject join2")
		elif clients[me].state == "join3":
			if clients[me].buffstr[index] == "n":
				clients[me].state = "join4"
			else: 
				strike(client, "(malformed)")
				print("reject join3")
		elif clients[me].state == "join4":
			if clients[me].buffstr[index] == "(":
				# verify room on server before proceeding
				if len(clients) == 30:		
					kick_user(s, "(snovac)")
				else:
					clients[me].state = "join5"
			else:
				strike(me, "(malformed)")
				print("reject join4")
		elif clients[me].state == "join5":
			# CJOIN: reading in name one char at a time until close paran
			if clients[me].buffstr[index] != ")":
				clients[me].my_name_bldr += clients[me].buffstr[index]
			else:
				# user finished entering name, begin add process
				clients[me].state = "join6"
		elif clients[me].state == "join6":
			# CJOIN: looking for closing parans
			if clients[me].buffstr[index] == ")":
				clients[me].state = "start"
				cjoin(me)
				clients[me].buffstr = clients[me].buffstr[index+1:]
				index = -1
			else: 
				strike(me, "(malformed)")	# misplaced paran
				print("reject join6")

		############################## STAT ################################		
		elif clients[me].state == "stat1":
			if clients[me].buffstr[index] == "t":
				clients[me].state = "stat2"
			else: 
				strike(me, "(malformed)")
				print("reject stat2")
		elif clients[me].state == "stat2":
			if clients[me].buffstr[index] == "a":
				clients[me].state = "stat3"
			else: 
				strike(me, "(malformed)")
				print("reject stat3")
		elif clients[me].state == "stat3":
			if clients[me].buffstr[index] == "t":
				clients[me].state = "stat4"
			else: 
				strike(me, "(malformed)")
				print("reject stat4")
		elif clients[me].state == "stat4":
			if clients[me].buffstr[index] == ")":
				clients[me].state = "stat_accept"
				clients[me].state = "start"
				cstat(me)
				clients[me].buffstr = clients[me].buffstr[index+1:]
				index = -1
			else: 
				strike(me, "(malformed)")
				print("reject stat4")

		############################# RESYNC ###############################
		elif clients[me].state == "resync1":
			if clients[me].buffstr[index] == "(":
				clients[me].state = "resync2"
		elif clients[me].state == "resync2":
			if clients[me].buffstr[index] == "c":
				clients[me].buffstr = clients[me].buffstr[index-1:]
				index = -1
				clients[me].state = "start"
			else:
				clients[me].state = "resync1"

		# If message is too long issue strike, reset buffer and index
		if (index == msg_size-1):
			strike(me, "(toolong)")
			index = -1
			clients[me].buffstr = ""
		# Perform kick check at end if client accrued 3 strikes total
		if clients[me].strikes >= 3:
			kick_user(me)
			break
		else:
			clients[me].index = index			
################################################################################

################################################################################
# MAIN:		Server select loop cycles through sockets waiting for input 	   #
################################################################################
# array of all player numbers, index = player num and value = player name
all_pnums 	= ["" for x in xrange(30)]
# 2D array of all battles in game by player number, x=attacker, y=victim
battles = [[0 for x in xrange(30)] for x in xrange(30)] 
init_battles()
clients 	= {}	# hash table w/ socket = key, and Client object = value
					# for reading in data for each user
curr_round	= 1		# current round, start at 0, gets incremented immediately
curr_phase 	= 0 	# phase in current round, defaults to 0 (lobby). 
p1_summary	= []	# offers sent in for phase 1, in plain English
p2_summary	= []	# offers accepted/denied for phase 2, in plain English
p3_summary 	= []	# list of battles, will be used for NOTIFY broadcast

need_update = True  # If server stats have changed since last display in
					# main_game_loop then display them

phase_start_time = int(time.time())
phase_end_time = phase_start_time + timeout

################################################################################
while running:
	# Last digit is how often to check main_game_loop
	inputready,outputready,exceptready = select.select(input,[],[], 1)

	# timeout checking is done even if no data is received
	# TODO: will put in phase 2
	if not (inputready or outputready or exceptready):
		lobby_timeout_check()		
		main_game_loop()
	
	for s in inputready:
		# timeout check performed if data has been received
		if len(clients) >= minplayers:
			main_game_loop()
		lobby_timeout_check()		################
		if s == server:
			# handle the server socket
			client, address = server.accept()
			input.append(client)
			print "Connection established"
			if len(clients) >= 30:
				schat(s, "(snovac)", "(snovac) ")
				s.close()
				input.remove(s)
			elif len(clients) >= minplayers:
				# if min players joined then begin game
				main_game_loop()
		elif s == sys.stdin:
			# handle standard input
			junk = sys.stdin.readline()
			running = 0 
		else:	# handle all other sockets
			""" If no Client for this socket, then create new 
				Client object with this socket """
			if clients.get(s, 0) == 0:
				clients[s] = Client()

			# mark time of last recorded command with current time
			clients[s].last_cmd_time = time.time()  ################

			""" check how much space is available in that socket's
				buffer before telling how much data to receive """
			data = s.recv(msg_size - clients[s].index + 1)

			if data:
				# Turn on to enable raw printing of all input
				# print("received:\t" + data)
				fsm(s, data)
			# If user disconnects hits this block. (Blank input does 
			# NOT reach this block.) """
			else:
				# Remove client from hashtable and send a new sstat
				if clients.get(s, 0) != 0:
					pnum_to_remove = clients[s].player_num
					all_pnums[pnum_to_remove] = ""
					del clients[s]
					sstat()
				s.close()
				input.remove(s)
				print "Connection terminated"
				break
				
print("\t _____ _____  ___________________   _______      ")
print("\t|  __ \  _  ||  _  |  _  \ ___ \ \ / /  ___|     ")
print("\t| |  \/ | | || | | | | | | |_/ /\ V /| |__       ")
print("\t| | __| | | || | | | | | | ___ \ \ / |  __|      ")
print("\t| |_\ \ \_/ /\ \_/ / |/ /| |_/ / | | | |____ _ _ ")
print("\t \____/\___/  \___/|___/ \____/  \_/ \____(_|_|_)")
server.close()
################################################################################