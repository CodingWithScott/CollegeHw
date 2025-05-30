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
-Phase 1
-Parse incoming SERVER chat messages 
-Change default flag values back to required things before submitting

	Medium priority
-Phase 2
-Phase 3

	Low priority
-Only display server stats if they've changed since last display
-Debug mode. 
	Mode 1: record into a text file all text received
	Mode 2: record into a text file all text sent
	Mode 3: record into a text file all text sent and received
-Timeout

"""
os.system('cls' if os.name == 'nt' else 'clear')	# clear terminal
print("-------------------------CRANK DAT SERVER~!----------------------------")
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
		self.last_strike_reason	= ""		# used by kick function				
		self.my_fullname 		= ""		# filename + "." + ext		   	   #
		self.state 				= "start"	# current FSM state			   	   #
		self.strikes 			= 0			# total strikes accrued			   #			
		self.their_name			= ""		# cchat recipients as 			   #
											# being assembled  	   			   #
		
		# game-related data   	   			
		# 1. Used to differentiate between offers being depleted or just 
		#    never had any.
		# 2. Offers for alliances received from other users, stored as a list 
		#    of strings. Format: ["R#,ALLY,ATTACKEE"]
		# 3. Outgoing offer deconstructed into pieces
		#    Format: "R#,PASS" or "R#,ALLY,ATTACKEE"
		# 4. Flag for making an outgoing offer in Phase 1
		#	 Format: "APPROACH" or "PASS"
		# 5. Flag for outgoing offer getting accepted in Phase 2
		#    Format: "ACCEPT" or "DECLINE"
		# 6. Flag for action in Phase 3
		#	 Format: "ATTACK" or "PASS"
		self.had_offers 		= False		# 1
		self.incoming_offers	= []		# 2
		self.in_game 			= False		# False = in lobby, True = in game #
		self.offer_parts		= []		# 3
		self.offer_p1_action	= ""		# 4
		self.offer_p2_action	= ""		# 5
		self.offer_p3_action	= ""		# 6
		self.offer_ally			= ""		# Person you accepted an offer from
		# Socket of person making offer
		self.ally_socket	= socket.socket(socket.AF_INET, socket.SOCK_STREAM)
				
		self.offer_victim 		= ""		# Who your alliance will attack
		self.outgoing_offer		= ""		# Plan for Phase 1
		self.phase1_responded	= False
		self.phase2_responded	= False
		self.phase3_responded	= False	
		self.troops				= troops_default # troops remaining, def=1000
		
################################################################################

################################################################################
# STRIKE/KICK: Issue a strike to users, send message + reason, and 	   		   #
# kick if user accumulates 3 strikes.								   		   #
################################################################################
def strike(me, reason):												   		   #
	clients[me].strikes += 1 										   		   #
	clients[me].last_strike_reason = reason 							   		   #
	if reason == "(malformed)":										   		   #
		clients[me].state = "resync1" 								   		   #
	#clients[me].last_cmd_time = calendar.timegm(time.gmtime())		   		   #
	output_msg = "Striking client:\t" + clients[me].my_fullname		   		   #
	output_msg += "\treason:\t" + reason							   		   #	
	output_msg += "\tstrikes:\t" + str(clients[me].strikes)			   		   #
	print(output_msg)												   		   #
	server_response = "(strike("								   	   		   #
	server_response += str(clients[me].strikes) + ")"			   	   		   #
	server_response += reason + ")"
	schat(s, server_response, "strike()")
def kick_user(me):													   		   #
	server_response = "(kick" + clients[me].last_strike_reason + ")"	   		   #
	schat(s, server_response, "kick_user()")
	output_msg = "Kicking client:\t\t" + clients[me].my_fullname		   		   #
	output_msg += "\treason:\t" + clients[me].last_strike_reason		   		   #
	del clients[me]													   		   #
	input.remove(s)												   	   		   #
	print(output_msg)												   		   #
	s.close()														   		   #
	sstat()															   		   #
################################################################################

################################################################################
# LOBBY TIMEOUT: Check if (curr_time - last_interact_time) > lobby timeout     #
# 				 period. Violation results in kick.							   #
# 					******* UNFINISHED, DONE IN PHASE 2 ********	   		   #
# GAME TIMEOUT:	 Check if user has responded to last server query within	   #
#				 specified time limit. Violation results in strike and passing #
#				 current round. 											   #
################################################################################
def lobby_timeout_check():
	# print("lobby_timeout_check")
	current_time = time.time()

	for each in clients:
		#print(current_time - clients[each].last_cmd_time)
		if (current_time - clients[each].last_cmd_time) > lobbytime:
			clients[each].last_cmd_time = current_time
			#strike(each, "(timeout)")
			#strike(each, "(lobbytimeout)")
			if (clients[each].strikes >= 3):
				kick_user(each)
			# break to make sure don't try to loop through when client is
			break
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
			ppl_list = clients[me].their_name.spli              
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
			
			#debug  = "player:\t" + clients[me].my_fullname + "\t"
			# debug += "clients[me].msg_parts[1]:\t" + clients[me].msg_parts[1] +"\t"
			# debug += "curr_round:\t" + str(curr_round)
			#print(debug)

			# if client is out of sync then strike and give default values
			if int(clients[me].msg_parts[1]) != curr_round:
				print(clients[me].my_fullname + " has wrong round")
				strike(me, "(malformed)")
				# not sure if anything else goes here?
				clients[me].outgoing_offer = "PASS"
				#clients[me].offer_p2_action = "DECLINE"	# do I use this??
		
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
						print("cchat " + clients[me].my_fullname + " msg_parts:")
						print(clients[me].msg_parts)
						# msg_parts[0] == PLAN
						# msg_parts[1] == ROUND #
						# msg_parts[2] == APPROACH
						ally = clients[me].msg_parts[3].upper()
						# Link the sockets for the two players
						for them in clients:
							if clients[them].my_fullname == ally:
								clients[me].ally_socket = them
								clients[them].ally_socket = me



								""" READ THIS SHIT RIGHT HERE IT IS EXTREMELY IMPORTANT!!!!!!! """




								clients[me].ally_socket.send("Message from " + clients[me].my_fullname + " to " + clients[clients[me].ally_socket].my_fullname)



								print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")

								clients[me].ally_socket.send("poop balls")
								print("ally by socket:\t" + clients[clients[me].ally_socket].my_fullname)
								print("victim:\t" + clients[me].offer_victim)

						clients[me].offer_ally = ally
						attackee = clients[me].msg_parts[4].upper()
						clients[me].offer_victim = attackee

						print("ally:\t" + clients[me].offer_ally)


						

						

						# after assembling the plan store it in client's
						# "outgoing_offer" field, will send it in phase1().
						clients[me].outgoing_offer = clients[me].msg_parts
						debug  = clients[me].my_fullname + " approached " + ally
						debug += " to attack " + attackee

						print(clients[me].my_fullname + " outgoing_offer:")
						print(clients[me].outgoing_offer)
					elif "PASS" in clients[me].msg_parts[2].upper():
						clients[me].outgoing_offer = "PASS"

					#p1_summary.append(debug)
			####################################################################

			######################### PHASE 2 COMMANDS #########################
			#	NOTE: 	guy accepting offer is S, guy proposing is EACH
			elif clients[me].msg_parts[0] == "ACCEPT":
				# msg_parts[0] == "ACCEPT" or "DECLINE"
				# msg_parts[1] == R#
				# msg_parts[2] == ALLY_NAME
				print(clients[me].my_fullname + " message parts: ")
				print(clients[me].msg_parts)
				# valid is used to check for accepting imaginary treaties
				valid = False	
				# msg_parts[1] == R#
				# ally = guy whose proposed alliance got accepted, find him and
				# send accept acknowledgement
				clients[me].offer_ally = clients[me].msg_parts[2]
				clients[me].phase2_responded = True
				
				# shoudl do this in phase 1, no reason to save til here

				# for them in clients:
				# 	# Set my name to be their ally, save their socket
				# 	# in my client for easy access.
				# 	if clients[them].my_fullname == clients[me].offer_ally:
				# 		print("attempting to assign ally_socket")
				# 		print("them:\t")
				# 		print(them)
				# 		clients[me].ally_socket = them
				# 		clients[them].offer_p2_action = "ACCEPT"
				# 		clients[them].offer_ally = clients[me].my_fullname
				# 		valid = True
				# 		break
				


				if not valid:
					print(clients[me].my_fullname + " accepted imaginary treaty")
					strike(me, "(malformed)")
				# Finish this shit when I get to Phase 2
				print("Registered ACCEPT from " + clients[me].my_fullname)
			elif clients[me].msg_parts[0] == "DECLINE":				

				valid = False	
				# Still need to record ally for purpose of logging
				clients[me].offer_ally = clients[me].msg_parts[2]
				clients[me].phase2_responded = True
				for them in clients:
					# Set my name to be their ally, save their socket
					# in my client for easy access.
					if clients[them].my_fullname == clients[me].offer_ally:
						clients[me].ally_socket = them
						clients[me].offer_p2_action = "DECLINE"
						clients[them].offer_ally = clients[me].my_fullname
						valid = True
						break
				if not valid:
					print(clients[me].my_fullname + "declined imaginary treaty")
					strike(me, "(malformed)")
				# Finish this shit when I get to Phase 2
				print("Registered DECLINE from " + clients[me].my_fullname)

			# receiving phase 3 commands from clients
			elif clients[me].msg_parts[0] == "ACTION":
				if clients[me].msg_parts[2] == "ATTACK":
					clients[me].phase3_responded = True
					# do something here
					# clients[me].action = "ATTACK"
					print("Registered ATTACK from " + clients[me].my_fullname)
				elif clients[me].msg_parts[2] == "PASS":
					clients[me].phase3_responded = True

					clients[me].action = "PASS"
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
# Helper for CJOIN: Take a DOSname and increment to next appropriate   		   #
# name, if DOSname is already taken.								   		   #
################################################################################
def incr_name(me):
	newfilename = ""
	old = clients[me].filename	

	try:
		# name = "SCOTTY" --> "SCOTTY~1"	
		if not (old[len(old)-1].isdigit()) and not (old[len(old)-2] == "~"):
			newfilename = old[:len(old)-2] + "~1"
		# name = "SCOTT~1" --> "SCOTT~9"
		elif (old[len(old)-1].isdigit()) and (old[len(old)-2] == '~'):
			if int(old[len(old)-1]) < 9:
				newfilename  = old[:len(old)-1] 
				newfilename += str(int(old[len(old)-1])+1)
			elif int(old[len(old)-1]) == 9:
				newfilename  = old[:len(old)-2]+'~' 
				newfilename += str(int(old[len(old)-1]) + 1)
		# name = "SCOT~10" --> "SCOT~99"
		elif (old[len(old)-1].isdigit()) and (old[len(old)-2].isdigit()):
			if (old[len(old)-3] == '~'):
				if int(old[len(old)-2:]) < 99:
					newfilename  = old[:len(old)-2] 
					newfilename += str(int(old[len(old)-2:]) + 1)
				elif int(old[len(old)-2:]) == 99:
					newfilename  = old[:len(old)-4] 
					newfilename += '~' + str(int(old[len(old)-2:]) + 1)
		# name = "SCO~100" --> "SCO~999"
		elif (old[len(old)-1].isdigit()) and (old[len(old)-2].isdigit()):
			if (old[len(old)-3].isdigit()) and (old[len(old)-4] == '~'):
					if int(old[len(old)-3:]) < 999:
						newfilename =  old[:len(old)-3] 
						newfilename += str(int(old[len(old)-3:]   ) + 1)
					elif int(old[len(old)-3:]) == 999:
						print("You can't have 1000 of same name, sorry")
		else:
			print("Something fucked up, you should never see this")
	except:
		print("oops")

	clients[me].filename = newfilename

	# if no file extension then set fullname to just filename
	if clients[me].ext == "":
		clients[me].my_fullname = clients[me].filename
	# otherwise add the extension
	else:
		clients[me].my_fullname = clients[me].filename + "." + clients[me].ext			
################################################################################

################################################################################
# CJOIN: Method for a client joining chat session. Handles name filtering 	   #
#        and collisions. 										   			   #
################################################################################
def cjoin(me):
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
			
			#print("clients[me].my_fullname:\t" + 	clients[me].my_fullname)
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
			print("Total clients:\t\t\t\t\t\t\t     " + str(len(clients)))
			
	# User may have been kicked above, check if entry still exists in hash 
	# table before trying to reset this			
	if clients.get(me, 0) != 0:
		clients[me].my_name_bldr = ""
################################################################################

################################################################################
# Misc helpers for CSTAT, STAT, and CJOIN									   #
################################################################################
# Print a pretty title to announce beginning of next phase
def announce_phase(which_phase):
	message1  = "*******************************************"
	message1 += "****************************"
	message2  = "***************************** Begin Phase " + str(which_phase)
	message2 += " ***************************"
	print(message1)
	print(message2)
	print(message1)
# Send congratulations to last user in-game, reset all server variables		   #
def declare_winner():
	for each in clients:
		if clients[each].in_game == True:
				outgoing_msg = "(schat(SERVER)(A winner is you!))"
				schat(each, outgoing_msg, "declare_winner()")													     #
# Find the name of attackee your ally is proposing
def find_victim(ally):
	print("find_victim, looking for the victim of:\t" + ally)
	for them in clients:
		if clients[them].my_fullname == ally:
			print("find_victim found:\t" + clients[them].offer_victim)
			return clients[them].offer_victim
# Check for last man standing, used to check whether to go Phase 3 --> Phase 1 #
def game_over():
	active_users = 0
	for each in clients:
		if clients[each].in_game:
			active_users += 1
	if active_users > 1:
		return False
	elif active_users <= 1:
		return  															 #
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
def list_all_user_stats():
	results = ""
	for each in clients:
		if results == "":
			results   = clients[each].my_fullname + ","
			results  += str(clients[each].strikes) + ","
			results  += str(clients[each].troops)
		elif results != "":
			results  += "," + clients[each].my_fullname + ","
			results  += str(clients[each].strikes) + ","
			results  += str(clients[each].troops)
	return results															   													 #													 #													 # 													 #
# Check if the requested name exists already on the server 					   #
def name_exists(me, looking_for): 											   #
	for them in clients: 													   #
		if (clients[them].my_fullname == looking_for):
			# Make sure not to return a True when you find yourself
		 	if them != me:		   #
				return True 												   #
	return False													   		   #
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
# CSTAT: Send a message to a specific user who requested server info   		   #
# SSTAT: Broadcast every player's stats 							   		   #
################################################################################
def cstat(me):																   #
	all_user_stats = list_all_user_stats()								   	   #											   #
	server_response = "(sstat(" + all_user_stats + "))"				   		   #
	schat(me, server_response, "cstat()")								   	   #
def sstat():								
	all_user_stats = list_all_user_stats()								 	   #
	server_response = "(sstat(" + all_user_stats + "))"				   		   #
	for each in clients:													   #
		schat(each, server_response, "sstat()")								   #
################################################################################

################################################################################
# PHASE FUNCTIONS: Performs end-of-phase behavior, after all players respond   #
# PHASE 1: Ask players for proposed plans.				   #
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
	global phase_start_time
	global phase_end_time

	# Might use this to keep track of when to display updated stats, not sure
	# exactly how to implement it. Low priority.
	# current_status  = curr_phase + curr_round 
	# current_status += str(len(clients)) + str(minplayers)

	#print("entered main_game_loop")
	print("\ncurr_phase:\t" + str(curr_phase))
	print("curr_round:\t" + str(curr_round))
	print("len(clients):\t" + str(len(clients)))
	print("minplayers:\t" + str(minplayers) + "\n")

	if curr_phase == 0:
		if int(len(clients)) >= int(minplayers):
			phase_start_time = time.time()
			phase_start_time = int(phase_start_time)
			phase_end_time = int(phase_end_time)
			phase_end_time = phase_start_time + timeout
			# everyone currently in lobby gets initialized when game goes live
			for each in clients:
				clients[each].in_game = True

			broadcast("(schat(SERVER)(PLAN," + str(curr_round) + "))")
			curr_phase = 1
	elif curr_phase == 1:
		if time.time() > phase_end_time:
			announce_phase(1)
			phase1()
			phase_start_time = time.time()
			phase_end_time = phase_start_time + timeout								   #
			announce_phase(2)
			curr_phase = 2
	elif curr_phase == 2:
		if time.time() > phase_end_time:
			
			phase2()								
			phase_start_time = time.time()
			phase_end_time = phase_start_time + timeout								   #
			announce_phase(3)
			curr_phase = 3
	elif curr_phase == 3:
		if time.time() > phase_end_time:
			phase3()	
			phase_start_time = time.time()
			phase_end_time = phase_start_time + timeout																	   #
		if not game_over():
			curr_round += 1
			announce_phase(1)
			curr_phase = 1
		else:
			declare_winner()
################################################################################

################################################################################
# PHASE 1: 																	   #
# 	Server sent out request for plans in Phase 0. Players responded to server  #
# 	with alliances they'd like to form with others before Phase 1 started. 	   #
#	Here I transfer the plans from user's outgoing_offers box and into the 	   #
# 	other party's incoming_offers box and send schats to notify them. 		   #
################################################################################
def phase1():
	# Helper function to assign an offer from sender's outbox to recipient's 
	# incoming offers inbox.
	# me = my own socket
	# ally = dude I want to form an alliance with
	# attackee = homie that we're going to try to attack together
	def assign_offer(me, round_num, ally, attackee):
		# Find ally and append the offer to his incoming_offers
		# Going to append in form:	 "R#,ALLY,ATTACKEE"

		print("assign offer contents:")
		print("sendername:\t" + sender)
		print("round_num:\t" + round_num)
		print("ally:\t" + ally)
		print("attackee:\t" + attackee)


		for them in clients:
			if clients[them].my_fullname == ally:
				# will have either OFFER or OFFERL prepended when schat() sends
				offer = ""
				offer = round_num + "," + sender + "," + attackee

				clients[me].ally_socket = them

				clients[them].incoming_offers.append(offer)
				print("appended offer from:\t" + clients[me].my_fullname)
				print("appended offer to:\t" + clients[them].my_fullname)
				print("offer:\t")
				print(clients[them].incoming_offers)
				break

	# Find socket by player name
	def find_socket(name):
		for each in clients:
			if clients[each].my_fullname == name:
				return each

	global curr_round
	global p1_summary

	# Plan format = "PLAYERNAME,R#,PASS", or 
	# "PLAYERNAME,R#,APPROACH,ALLY,ATTACKEE"

	""" Transfer values from outgoing offers to players' offer inboxes """
	# Make sure all players sent in a plan, strike anyone without and assign
	# default value.
	for me in clients:
		#print("Phase 1 loop looking at:\t" + clients[me].my_fullname)
		if clients[me].in_game: 
			if clients[me].phase1_responded:
				print("Part 1, Looking at " + clients[me].my_fullname)
		#		print(clients[me].my_fullname + " is ingame and responded")
				#log  = "clients[me].outgoing_offer:\t"
				#log += clients[me].outgoing_offer + "\n"
				#print(clients[me].my_fullname + "outgoing_offer:\t")
				#print(clients[me].outgoing_offer)
				if "PASS" in clients[me].outgoing_offer:
					log  = clients[me].my_fullname + " will PASS this turn."
					p1_summary.append(log)

					print("\nphase1 " + clients[me].my_fullname + " outgoing_offer contents:")
					print("action:\tPASS")
				elif "APPROACH" in clients[me].outgoing_offer:
					# outgoing_offer[0] == PLAN
					round_num = clients[me].outgoing_offer[1] 					
					# offer_parts[2] == APPROACH
					ally = clients[me].outgoing_offer[3].upper()
					attackee = clients[me].outgoing_offer[4].upper() 
					clients[me].offer_victim = attackee

					sender = clients[me].my_fullname

					print("\nphase1 part1")
					print(clients[me].my_fullname + " outgoing_offer contents:")
					print("sender:\t" + sender)
					print("round_num:\t" + round_num)
					print("ally:\t" + ally)
					print("attackee:\t" + clients[me].offer_victim + "\n")

					
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
			print("Part 2, Looking at " + clients[each].my_fullname)

			# print("\nphase1 part2")
			# print(clients[each].my_fullname + " outgoing_offer contents:")
			# print("sender:\t" + sender)
			# print("round_num:\t" + round_num)
			# print("ally:\t" + ally)
			# print("attackee:\t" + clients[each].offer_victim + "\n")


			# If player has more than 1 incoming_offer need to tag as OFFERL
			# only for last entry.
			if len(clients[each].incoming_offers) >= 2:
				# iterate through client's offers they received
				# Keep track of offers already seen so not sending duplicate
				# schats.
				log = []
				#print("line 817")
				# Send message to player for each of his stored incoming offers
				for x in range(1, len(clients[each].incoming_offers)-1):
					# If it's the last offer in list then do OFFERL
					# print("line 821")
					if x == len(clients[each].incoming_offers)-1:
						outgoing_msg  = "(schat(SERVER)(OFFERL,"
						outgoing_msg += clients[each].incoming_offers[x] + "))"
						# print("line 825")
						if outgoing_msg not in log:
							log.append(outgoing_msg)
							schat(each, outgoing_msg, "phase1() more than 1 offer")
					else:
						outgoing_msg  = "(schat(SERVER)(OFFER,"
						outgoing_msg += clients[each].incoming_offers[x] + "))"
						if outgoing_msg not in log:
							log.append(outgoing_msg)
							schat(each, outgoing_msg, "phase1() more than 1 offer")
					# I don't think I need these here.... we'll see
					# if log not in p2_summary:
					# 	p2_summary.append(log)

			# If player only got a single offer just send it
			elif len(clients[each].incoming_offers) == 1:
				# print("line 841")
				print(clients[each].my_fullname + " got ONE incoming offer!")
				print("incoming_offers:\t")
				print(clients[each].incoming_offers)
				print("curr_offer (joined version):")
				curr_offer = ''.join(clients[each].incoming_offers)
				print(curr_offer)




				# How do I look up the original player making offer to send 
				# back confirmation?
				ally_socket = clients[each].ally_socket
				outgoing_msg = "(schat(SERVER)(OFFERL," + curr_offer + "))"
				schat(ally_socket, outgoing_msg, "phase1() last offer")
				# if log not in p2_summary:
				# 	p2_summary.append(log)

			# If player got no offers at all then send a placeholder message
			elif len(clients[each].incoming_offers) == 0:
				# print("line 851")
				print(clients[each].my_fullname + " got NO incoming offers!")
				outgoing_msg  = "(schat(SERVER)(OFFERL," 
				outgoing_msg += str(curr_round) + "))"
				schat(each, outgoing_msg, "phase1() no incoming offers")

			# reset client values for next round
			# NEED THIS STILL, BUT THIS ISN'T THE RIGHT PLACE
			clients[each].phase1_responded 	= False
			# clients[each].outgoing_offer 	= ""
			# clients[each].offer_parts		= []	# NEVER EVEN USED
			# clients[each].offer_p2_action	= ""
			# clients[each].offer_ally		= ""
			# clients[each].offer_victim 		= ""

	print("\nPhase 1 offer proposals summary:")

	# print to console what happened this phase
	for each_action in p1_summary:
		print(each_action)
	p1_summary = []
	print("\n")
################################################################################

################################################################################
# PHASE 2:	Inform players of the offers they were given in Phase 1, ask for   #
# 			confirmation of ACCEPT/DENY alliance, and then send the response   #
# 			back to original player offering the alliance. 					   #
################################################################################
def phase2():
	global curr_phase
	global p2_summary

	# Process clients' ACCEPT or DENIAL of the offers they were sent
	for each in clients:
		if not "PASS" in clients[each].outgoing_offer:
			if clients[each].offer_p2_action == "ACCEPT":


				""" SOMETHING IN HERE BROKEN """

				print(clients[each].my_fullname + " message parts: ")
				print(clients[each].msg_parts)
				# print("line 843")
				# print(clients[each].msg_parts)
				
				outgoing_msg  = "(schat(SERVER)(ACCEPT," 
				outgoing_msg += str(curr_round) 
				outgoing_msg += "," + clients[each].offer_ally + "))"
				ally = clients[each].offer_ally   #What is this doing?
				attackee = find_victim(clients[each].offer_ally)
				sender = clients[each].my_fullname


				schat(clients[each].ally_socket, outgoing_msg, "phase2 ACCEPT")
				# Sender first, ally second... i think?
				# log  = sender + " accepted " + ally + "'s offer"
				# log += " to attack " + attackee
				log  = attackee + " accepted " + ally + "'s offer"
				log += " to attack " + sender
				# print("line 860 log:\t" + log)
				p2_summary.append(log)
				# print("line 883 outgoing_msg:\t" + outgoing_msg)
			elif clients[each].offer_p2_action == "DECLINE":
				# print("line 863")
				# print(clients[each].msg_parts)
				ally = clients[each].offer_ally
				#attackee = find_victim(clients[each].offer_ally)
				sender = clients[each].my_fullname

				# print("clients[each].msg:\t" + clients[each].msg)

				outgoing_msg  = "(schat(SERVER)(DECLINE," + str(curr_round) 
				outgoing_msg += "," + ally + "))"
				schat(each, outgoing_msg, "phase2 DECLINE")
				log  = ally + " declined " 
				log += sender + "'s offer to attack "
				# Maybe later I'll fix this so you can see who the attackee
				# was but holy fuck I'm tired
				#log += attackee
				# print("line 874 log:\t" + log)
				p2_summary.append(log)
				# print("line 900 outgoing_msg:\t" + outgoing_msg)

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
	broadcast("Pretend phase 3 just happened")
	global curr_phase
	global curr_round 
	#curr_round += 1  			# Redundant? can be done in main_game_loop()
	

	# reset all clients' data before continuing
	for each in clients:
		clients[each].phase1_responded = False
		clients[each].phase2_responded = False
		clients[each].phase3_responded = False
		clients[each].action = ""
		clients[each].incoming_offers = []

	curr_phase = 1


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
clients 	= {}	# hash table w/ socket = key, and Client object = value
					# for reading in data for each user
curr_round	= 1		# current round, start at 0, gets incremented immediately
curr_phase 	= 0 	# phase in current round, defaults to 0 (lobby). 
p1_summary	= []	# offers sent in for phase 1, in plain English
p2_summary	= []	# offers accepted/denied for phase 2, in plain English
p3_summary 	= []	# list of battles, will be used for NOTIFY broadcast

# Might do this... not sure exactly how to implement it
latest_stats= ""	# If server stats haven't changed since last display in
					# main_game_loop then don't display them. Store last stats
					# here.

phase_start_time = int(time.time())
phase_end_time = phase_start_time + timeout

""" NOTE: All time-related variables are ints or cast to ints """

################################################################################
while running:
	# serves no purpose except to make next call fit w/in 80 columns
	to = timeout 

	# don't necessarily need this to be set to timeout, can hard code
	inputready,outputready,exceptready = select.select(input,[],[], float(to))

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
			print("---TURN DAT SHIT OFF!!---")
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
				print("received:\t" + data)
				fsm(s, data)
			# If user disconnects hits this block. (Blank input does 
			# NOT reach this block.) """
			else:
				# Remove client from hashtable and send a new sstat
				if clients.get(s, 0) != 0:
					del clients[s]
					sstat()
				s.close()
				input.remove(s)
				print "Connection terminated"
				break
				
print("Peace out gurl scout!!")
server.close()
################################################################################