#!/usr/bin/env python
import argparse		# command line arguments
import calendar		# used for timeout
import os			# used for clearing terminal
import random		# used for "any" chat command
import re 			# regular expressions
import select
import socket
import sys
import time 		# used for timeout

parser = argparse.ArgumentParser(description='Basic chat server')
parser.add_argument('-l','--lobbytime',  
	help='Enter lobby wait time in seconds', default=15, required=False)
parser.add_argument('-m','--minplayers', 
	help='Enter minimum number of players',  default=4,  required=False)
parser.add_argument('-t','--timeout', 
	help='Enter a timeout length in seconds', default=2, required=False)

args = parser.parse_args()

# putting this in so I can avoid typing "args.blahblah" later
lobbytime 	= args.lobbytime
min_players = args.minplayers
timeout 	= args.timeout

start_timeout = time.time()

host 		= ''
port 		= 36735
backlog 	= 5		# of messages to store prior to processing
msg_size 	= 480	# character limit for messages received from clients
running 	= 1

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server.bind((host,port))
server.listen(backlog)
input 		= [server,sys.stdin]

clients 	= {}	# hash table w/ socket = key, and Client object = value
					# for reading in data for each user

"""		TO DO:
	High priority
-(none)

	Medium priority
-Automatic chat mode

	Low priority
-Debug mode. 
	Mode 1: record into a text file all text received
	Mode 2: record into a text file all text sent
	Mode 3: record into a text file all text sent and received
-Timeout (never mind, save for phase 2)

"""
os.system('cls' if os.name == 'nt' else 'clear')	# clear terminal
print("-------------------------CRANK DAT SERVER~!----------------------------")
print("Lobby time:\t\t\t"	 + str(lobbytime))
print("Min players:\t\t\t" + str(min_players))
print("Timeout:\t\t\t" 	 + str(timeout))
print("-----------------------------------------------------------------------")

################################################################################
# CLIENT: Holds raw buffer, index, message/name strings, FSM 		   		   #
# 		  state and number of strikes.								   		   #
################################################################################
class Client:														   		   #
	buffstr 			= ""		# raw buffer received from TCP stream  	   #
	index 				= -1		# where I'm at processing buffer	   	   #
	msg 				= ""		# cchat message being assembled 	   	   #
																	   		   #
	# intermediate steps											   		   #
	my_name_bldr 		= ""		# cjoin name as it's being assembled   	   #
	filename			= ""		# first part of filename, before .	   	   #
	ext		 			= ""		# file extension, after .			   	   #
																	   		   #
	# final product of name (and optional extension)				   		   #
	my_fullname 		= ""		# filename + "." + ext				   	   #
	their_name			= ""		# cchat recipients as being assembled  	   #
	state 				= "start"	# current FSM state					   	   #
	strikes 			= 0			# total strikes accrued				   	   #
	last_strike_reason	= ""		# used by kick function				   	   #
																	   		   #
####last_cmd_time	= 0			# time since Unix epoch in # of secs   		   #
################################################################################

################################################################################
# STRIKE/KICK: Issue a strike to users, send message + reason, and 	   		   #
# kick if user accumulates 3 strikes.								   		   #
################################################################################
def strike(s, reason):												   		   #
	clients[s].strikes += 1 										   		   #
	clients[s].last_strike_reason = reason 							   		   #
	if reason == "(malformed)":										   		   #
		clients[s].state = "resync1" 								   		   #
	#clients[s].last_cmd_time = calendar.timegm(time.gmtime())		   		   #
	output_msg = "Striking client:\t" + clients[s].my_fullname		   		   #
	output_msg += "\treason:\t" + reason							   		   #	
	output_msg += "\tstrikes:\t" + str(clients[s].strikes)			   		   #
	print(output_msg)												   		   #
	server_response = "(strike("								   	   		   #
	server_response += str(clients[s].strikes) + ")"			   	   		   #
	server_response += reason + ")"								   	   		   #
	s.send(server_response)										   	   		   #
																	   		   #
def kick_user(s):													   		   #
	server_response = "(kick" + clients[s].last_strike_reason + ")"	   		   #
	s.send(server_response)											   		   #
	output_msg = "Kicking client:\t\t" + clients[s].my_fullname		   		   #
	output_msg += "\treason:\t" + clients[s].last_strike_reason		   		   #
	del clients[s]													   		   #
	input.remove(s)												   	   		   #
	print(output_msg)												   		   #
	s.close()														   		   #
	sstat()															   		   #
################################################################################

################################################################################
# TIMEOUT_CHECK: Check if (curr_time - last_interact_time) > timeout   		   #
# 				 period.											   		   #
# 					******* UNFINISHED, DONE IN PHASE 2 ********	   		   #
################################################################################
def timeout_check():
	current_time = calendar.timegm(time.gmtime())
	#current_time = time.time()

	#if (current_time - start_timeout) > timeout:

	for each in clients:
		#print(current_time - clients[each].last_cmd_time)
		if (current_time - clients[each].last_cmd_time) > timeout:
			clients[each].last_cmd_time = current_time
			strike(each, "(timeout)")
			if (clients[each].strikes >= 3):
				kick_user(each)
			# break to make sure don't try to loop through when client is
			break
################################################################################

################################################################################
# CCHAT: Send a message to all users, a random user, a single user,	   		   #
#		 or a list of specific users. Strikes given for invalid users. 		   #
################################################################################
def cchat(s):
	# will use these just for server console output, not sent to users
	sending_to 		= clients[s].their_name
	sending_from 	= clients[s].my_fullname
	sending_type	= "" 
	msg 			= clients[s].msg

	# Check if this socket has a username already , don't continue
	if clients[s].my_fullname == "":
		print("User attempting to send without joining")
		strike(s, "(malformed)")
	else:
		# split recipients into a list if there's >1 person
		if "," in clients[s].their_name:
			ppl_list = clients[s].their_name.split(",")
			# capitalize all usernames in ppl_list
			ppl_list = [x.upper() for x in ppl_list]
		else:
			ppl_list = clients[s].their_name
			ppl_list = ppl_list.upper()
		
		outgoing_msg = "(schat(" + clients[s].my_fullname 
		outgoing_msg += ")(" + clients[s].msg + "))"

		# check if sending a broadcast message or random message
		if ppl_list == "ALL":
			sending_type = "BROADCAST"
			# iterate through entire hashtable of names and send
			for each in clients:
				if each != s:
					each.send(outgoing_msg)
		elif ppl_list == "ANY":
			sending_type = "RANDOM"
			# need to randomly choose an entry from hash table
			random_guy = random.choice(clients.keys())
		
			# if random value turns out to be the sender, then try again
			while random_guy == s:
				random_guy = random.choice(clients.keys())

			sending_to = clients[random_guy].my_fullname
			random_guy.send(outgoing_msg)

		# send to specific user
		elif (type(ppl_list) == str):
			sending_type = "SINGLE USER"
			all_valid_users = list_all_users()
			# check if it's a valid user to send to
			if ppl_list not in all_valid_users:
				strike(s, "(malformed)")
				console_output  = "Issuing strike to " + sending_from 
				console_output += " for invalid recipient:\t"
				console_output += ppl_list
				print(console_output)
			else:
				for each in clients:
					# send msg when curr_sock name matches homie in ppl_list
					if clients[each].my_fullname in ppl_list:
						each.send(outgoing_msg)
						break
		# send to multiple users
		else:
			sending_type = "MULTI USER"
			all_valid_users = list_all_users().split(",")

			# strike for any reserved words in the recipient list
			if "ALL" in ppl_list:
				ppl_list.remove("ALL")
				strike(s, "(malformed)")
				console_output  = "Issuing strike to " + sending_from 
				console_output += " for invalid recipient:\tALL"
				print(console_output)
			if "ANY" in ppl_list:
				ppl_list.remove("ANY")
				strike(s, "(malformed)")
				console_output  = "Issuing strike to " + sending_from 
				console_output += " for invalid recipient:\tANY"
				print(console_output)

			# strike for any invalid users in the recipient list
			for curr_name in ppl_list:
				if curr_name not in all_valid_users:
					strike(s, "(malformed)")
					console_output  = "Issuing strike to " + sending_from 
					console_output += " for invalid recipient:\t"
					console_output += curr_name
					print(console_output)
				
			# send message to all connected users in the recipient list
			for each in clients:
				# send msg when the curr_sock name is in ppl_list
				if clients[each].my_fullname in ppl_list:
					each.send(outgoing_msg)
				

	console_output =  sending_from + " sent a " 
	console_output += sending_type + " message to "
	console_output += sending_to + ":\n\t" + msg
	print(console_output)

	clients[s].their_name = ""
	clients[s].msg = ""
################################################################################

################################################################################
# Helper for CJOIN: Take a DOSname and increment to next appropriate   		   #
# name, if DOSname is already taken.								   		   #
################################################################################
def incr_name(s):
	newfilename = ""
	old = clients[s].filename	

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
	
	clients[s].filename = newfilename

	# if no file extension then set fullname to just filename
	if clients[s].ext == "":
		clients[s].my_fullname = clients[s].filename
	# otherwise add the extension
	else:
		clients[s].my_fullname = clients[s].filename + "." + clients[s].ext			
################################################################################


################################################################################
# CJOIN: Method for a client joining chat session. Handles name filtering 	   #
#        and collisions. 										   			   #
################################################################################
def cjoin(s):
	# If socket is requested a username and they already have one, then strike	
	if clients[s].my_fullname != "":
		strike(s, "(malformed)")
		console_output  = "Issuing strike to " + clients[s].my_fullname 
		console_output += " for requesting a second CJOIN"
		print(console_output)
	else:
		# mnb is just my_name_bldr, just doing this to control width of code
		
		mnb = clients[s].my_name_bldr

		stripName(s)

		# strike for empty name
		if mnb == "":	
			strike(s, "(malformed)")
		# strike for reserved name
		elif mnb.upper() == "ALL" or mnb.upper() == "ANY":	
			strike(s, "(malformed)")		
		# strike if there's >1 dot remaining
		elif any(mnb.count(x) > 2 for x in mnb if x == "."):
			strike(s, "(malformed)")
		else:
			# split the username into filename and extension, if necessary
			name_chunks = re.split('[.]', clients[s].my_name_bldr)
			clients[s].filename = name_chunks[0]

			if len(name_chunks) == 1:
				if len(name_chunks[0]) > 8:
					clients[s].filename[0] = name_chunks[0][:6] + "~1"
				clients[s].my_fullname = clients[s].filename
			
			elif len(name_chunks) == 2:
				clients[s].ext = name_chunks[1]
				if len(clients[s].ext) > 3:
					clients[s].ext = clients[s].ext[:3]
				clients[s].my_fullname  = clients[s].filename 
				clients[s].my_fullname += "." + clients[s].ext
			
			#print("clients[s].my_fullname:\t" + 	clients[s].my_fullname)
			# increment name if filename+ext is already taken 
			if name_exists(clients[s].my_fullname):
				print("Duplicate name detected:\t" + clients[s].my_fullname)
				while name_exists(clients[s].my_fullname):
					incr_name(s)
			
			# after appropriate incrementation is done then clients[s] 
			# will have a unique name
			if len(name_chunks) == 1:
				clients[s].my_fullname = clients[s].filename
			elif len(name_chunks) == 2:
				clients[s].my_fullname  = clients[s].filename 
				clients[s].my_fullname += "." + clients[s].ext
			
			clients[s].my_fullname = clients[s].my_fullname.upper()

			# confirm join and send response
			server_response = "(sjoin("
			server_response += clients[s].my_fullname + ")("
			server_response += list_all_users() + ")("
			server_response += str(min_players) + ","
			server_response += str(lobbytime) + ","
			server_response += str(timeout) + "))"
			s.send(server_response)
			sstat()
			print("Added:\t\t\t\t" + clients[s].my_fullname)
			
	# User may have been kicked above, check if entry still exists in hash 
	# table before trying to reset this			
	if clients.get(s, 0) != 0:
		clients[s].my_name_bldr = ""
################################################################################

################################################################################
# Misc helpers for CSTAT, STAT, and CJOIN									   #
################################################################################
# Returns a string listing all players in format: USER~1,USER~2,BLAH~1 		   #
def list_all_users():												  		   #
	all_names = ""													   		   #
	for each in clients:											   		   #
		if all_names == "":											   		   #
			all_names = clients[each].my_fullname					   		   #
		elif all_names != "":										   		   #
			all_names = all_names + "," + clients[each].my_fullname	   		   #
	return all_names												   		   #
																			   #
# Check if the requested name exists already on the server 					   #
def name_exists(looking_for): 												   #
	for each in clients: 													   #
		if (clients[each].my_fullname == looking_for): 						   #
			if (each != s): 												   #
				return True 												   #
	return False													   		   #
																			   #
# Strip out non-printable ASCII chars, as well as parans. 					   #
def stripMsg(oldmsg):														   #
	newmsg = ""																   #
	for x in range(0, len(oldmsg)):											   #
		iv = ord(oldmsg[x]) 	# iv => integer value 						   #
		# allow integer values for letters and digits (respectively)		   #
		if (iv >= 42 and iv <= 126) or (iv >= 32 and iv <= 39): 			   #
			newmsg += oldmsg[x]												   #
	return newmsg															   #		
																			   #
# Strip out all characters except alphanumeric (A-Z, 0-9) and a single 		   #	
# period somewhere in the middle of the name.								   #
def stripName(s):															   #
	clients[s].my_name_bldr = clients[s].my_name_bldr.upper()				   #
	newname = ""															   #
	for x in range(0, len(clients[s].my_name_bldr)):						   #
		iv = ord(clients[s].my_name_bldr[x])	# iv => integer value 		   #
		# allow letters, digits, and a period (respectively) 				   #
		if (iv >= 48 and iv <= 57) or (iv >= 65 and iv <= 90) or (iv == 46):   #
			newname += clients[s].my_name_bldr[x]							   #
	clients[s].my_name_bldr = newname  										   #
################################################################################

################################################################################
# CSTAT: Send a message to a specific user who requested server info   		   #
# SSTAT: Broadcast a server status message to everyone				   		   #
################################################################################
def cstat(s):														   		   #
	all_names = list_all_users()									   		   #
	server_response = "(sstat(" + all_names + "))"					   		   #
	s.send(server_response)											   		   #
																	   		   #
def sstat():														   		   #
	all_names = ""													   		   #
	all_names = list_all_users()									   		   #
	server_response = "(sstat(" + all_names + "))"					   		   #
	for each in clients:											   		   #
		each.send(server_response)									   		   #
################################################################################

################################################################################
# FSM: Parses user input and directs data to appropriate functions     		   #
################################################################################
def fsm(s, data):
## FSM decided upon by class:
# http://i.imgur.com/1v6NUAI.png 

## More verbose version, essentially equivalent: 
# http://i.imgur.com/or5rSbU.jpg

	
	index = clients[s].index
	clients[s].buffstr += data
	
	while index < len(clients[s].buffstr)-1:
		index += 1

		# Leave for debug purposes
		# line_info = "x: " + str(index) 
		# line_info += "\tdata[" + str(index) 
		# line_info += "]:  " + clients[s].buffstr[index]
		# line_info += "\tstate:\t" + clients[s].state
		# line_info += "\t\tbuffer:\t" + clients[s].buffstr
		# print(line_info)

		# reach end of current buffer, done reading current message
		if clients[s].buffstr[index] == "":			
			break
		elif clients[s].state == "start":
			if clients[s].buffstr[index] == "(":				
				clients[s].state = "start2"
			else: 
				strike(s, "(malformed)")			
				print("reject start")
		elif clients[s].state == "start2":
			if clients[s].buffstr[index] == "c":
				clients[s].state = "start3"
			else: 
				clients[s].state = "resync2"
				strike(s, "(malformed)")
				print("reject start2")
		elif clients[s].state == "start3":
			if clients[s].buffstr[index] == "c":		
				clients[s].state = "chat1"
			elif clients[s].buffstr[index] == "j":		
				clients[s].state = "join1"
			elif clients[s].buffstr[index] == "s":		
				clients[s].state = "stat1"
			else: 
				# not spelling cchat, cjoin, or cstat
				strike(s, "(malformed)")		
				print("reject start3")
		
		############################## CHAT ################################		
		elif clients[s].state == "chat1":
			if clients[s].buffstr[index] == "h":
				clients[s].state = "chat2"
			else: 
				strike(s, "(malformed)")
				print("reject chat1")
		elif clients[s].state == "chat2":
			if clients[s].buffstr[index] == "a":
				clients[s].state = "chat3"
			else: 
				strike(s, "(malformed)")
				print("reject chat2")
		elif clients[s].state == "chat3":
			if clients[s].buffstr[index] == "t":
				clients[s].state = "chat4"
			else: 
				strike(s, "(malformed)")
				print("reject chat3")
		elif clients[s].state == "chat4":
			if clients[s].buffstr[index] == "(":
				clients[s].state = "chat5"
			else: 
				strike(s, "(malformed)")	# incorrectly placed paran
				print("reject chat4")
		elif clients[s].state == "chat5":
			# reading in list of names one char at a time until close paran
			if clients[s].buffstr[index] != ")":
				clients[s].their_name += clients[s].buffstr[index]
				if len(clients[s].their_name) == 419:
					#    30 names * 13 char name limit + 
					# +  29 commas 
					# =  419 char their_name limit
					strike(s, "(malformed)")
			else:
				clients[s].their_name = stripMsg(clients[s].their_name)
				clients[s].state = "chat6"
		elif clients[s].state == "chat6":
			# looking for a paran before beginning of message
			if clients[s].buffstr[index] == "(":
				clients[s].state = "chat7"
			else: 
				strike(s, "(malformed)")
				print("reject chat6")
		elif clients[s].state == "chat7":
			# reading in message one char at a time until 1st closing paran
			if clients[s].buffstr[index] != ")":
				clients[s].msg += clients[s].buffstr[index]
				
				
				
				# THIS SHIT IS BROKE
				
				# if msg is >80 chars then just truncate and skip to accept
				if len(clients[s].msg) == 80:	
					clients[s].msg = stripMsg(clients[s].msg)
#					clients[s].msg = clients[s].msg[:len(clients[s].msg)-2] + "))"
					clients[s].buffstr = clients[s].buffstr[:index]
#					print("clients[s].buffstr:\t" + clients[s].buffstr)
					cchat(s)
					clients[s].state = "resync1"
					clients[s].buffstr = clients[s].buffstr[index+1:]
					index = -1
			else: 
				# Strip out any illegal chars in message before next state
				clients[s].msg = stripMsg(clients[s].msg)
				clients[s].state = "chat8"
		elif clients[s].state == "chat8":
			# looking for 2nd closing paran
			if clients[s].buffstr[index] == ")":
				cchat(s)
				clients[s].buffstr = clients[s].buffstr[index+1:]
				index = -1
				clients[s].state = "start"

		############################## JOIN ################################
		elif clients[s].state == "join1":
			if clients[s].buffstr[index] == "o":
				clients[s].state = "join2"
			else: 
				strike(s, "(malformed)")	# misspelled cjoin
				print("reject join1")
		elif clients[s].state == "join2":
			if clients[s].buffstr[index] == "i":
				clients[s].state = "join3"
			else: 
				strike(s, "(malformed)")
				print("reject join2")
		elif clients[s].state == "join3":
			if clients[s].buffstr[index] == "n":
				clients[s].state = "join4"
			else: 
				strike(client, "(malformed)")
				print("reject join3")
		elif clients[s].state == "join4":
			if clients[s].buffstr[index] == "(":
				# verify room on server before proceeding
				if len(clients) == 30:		
					kick_user(s, "(snovac)")
				else:
					clients[s].state = "join5"
			else:
				strike(s, "(malformed)")
				print("reject join4")
		elif clients[s].state == "join5":
			# CJOIN: reading in name one char at a time until close paran
			if clients[s].buffstr[index] != ")":
				clients[s].my_name_bldr += clients[s].buffstr[index]
			else:
				# user finished entering name, begin add process
				clients[s].state = "join6"
		elif clients[s].state == "join6":
			# CJOIN: looking for closing parans
			if clients[s].buffstr[index] == ")":
				clients[s].state = "start"
				cjoin(s)
				clients[s].buffstr = clients[s].buffstr[index+1:]
				index = -1
			else: 
				strike(s, "(malformed)")	# misplaced paran
				print("reject join6")

		############################## STAT ################################		
		elif clients[s].state == "stat1":
			if clients[s].buffstr[index] == "t":
				clients[s].state = "stat2"
			else: 
				strike(s, "(malformed)")
				print("reject stat2")
		elif clients[s].state == "stat2":
			if clients[s].buffstr[index] == "a":
				clients[s].state = "stat3"
			else: 
				strike(s, "(malformed)")
				print("reject stat3")
		elif clients[s].state == "stat3":
			if clients[s].buffstr[index] == "t":
				clients[s].state = "stat4"
			else: 
				strike(s, "(malformed)")
				print("reject stat4")
		elif clients[s].state == "stat4":
			if clients[s].buffstr[index] == ")":
				clients[s].state = "stat_accept"
				clients[s].state = "start"
				cstat(s)
				clients[s].buffstr = clients[s].buffstr[index+1:]
				index = -1
			else: 
				strike(s, "(malformed)")
				print("reject stat4")

		############################# RESYNC ###############################
		elif clients[s].state == "resync1":
			if clients[s].buffstr[index] == "(":
				clients[s].state = "resync2"
		elif clients[s].state == "resync2":
			if clients[s].buffstr[index] == "c":
				clients[s].buffstr = clients[s].buffstr[index-1:]
				index = -1
				clients[s].state = "start"
			else:
				clients[s].state = "resync1"

		# If message is too long issue strike, reset buffer and index
		if (index == msg_size-1):
			strikes(s, "(toolong)")
			index = -1
			clients[s].buffstr = ""
		# Perform kick check at end if client accrued 3 strikes total
		if clients[s].strikes >= 3:
			kick_user(s)
			break
		else:
			clients[s].index = index			
################################################################################

################################################################################
# MAIN:		Server select loop cycles through sockets waiting for input 	   #
################################################################################
while running:
	# don't necessarily need this to be set to timeout, can hard code
	inputready,outputready,exceptready = select.select(input,[],[], float(timeout))

	# timeout checking is done even if no data is received
	# TODO: will put in phase 2
#	if not (inputready or outputready or exceptready):
#		timeout_check()		
	
	for s in inputready:
		# timeout checkp performed if data has been received
#		timeout_check()		################
		if s == server:
			# handle the server socket
			client, address = server.accept()
			input.append(client)
			print "Connection established"
			if len(clients) >= 30:
				s.send("(snovac)")
				s.close()
				input.remove(s)
			
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
