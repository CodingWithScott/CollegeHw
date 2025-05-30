#!/usr/bin/env python
import argparse		# command line arguments
import os			# used for clearing terminal
import random		# used for "any" chat command
import re 			# regular expressions
import select
import socket
import string
import sys

parser = argparse.ArgumentParser(description='Basic chat server')
parser.add_argument('-l','--lobbytime', help='Enter lobby wait time in seconds', default=15, required=False)
parser.add_argument('-m','--minplayers', help='Enter minimum number of players', default=4, required=False)
parser.add_argument('-t','--timeout', help='Enter a timeout length in seconds', default=15, required=False)

args = parser.parse_args()

# putting this in so I can avoid typing "args.blahblah" later
lobbytime = args.lobbytime
min_players = args.minplayers
timeout = args.timeout

host = ''
port = 36735
backlog = 5
msg_size = 480			# character limit for messages received from clients
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server.bind((host,port))
server.listen(backlog)
input = [server,sys.stdin]
running = 1

clients = {}	# hash table w/ socket = key, and Client object = value
				# for reading in data for each user

"""		TO DO:

	High priority
-Thoroughly test FSM
-Test name collision

	Medium priority
-Automatic chat mode
-Implement DOS file extension naming mechanism 

	Low priority
-Debug mode. 
	Mode 1: record into a text file all text received
	Mode 2: record into a text file all text sent
	Mode 3: record into a text file all text sent and received

"""
os.system('cls' if os.name == 'nt' else 'clear')	# clear terminal
print("------CRANK DAT SERVER~!------")
print("lobbytime:\t\t" + str(lobbytime))
print("minplayers:\t\t" + str(min_players))
print("timeout:\t\t" + str(timeout))
print("------------------------------")

########################################################################
# CLIENT: Holds raw buffer, index, message/name strings, FSM 		   #
# 		  state and number of strikes.								   #
########################################################################
class Client:
	buffstr 		= ""		# raw buffer as received from TCP stream
	index 			= 0			# where I'm at processing buffer
	msg 			= ""		# cchat message as it's being assembled 

	# intermediate steps
	my_name_bldr 	= ""		# cjoin name as it's being assembled
	filename		= ""		# first part of filename, before .
	ext		 		= ""		# file extension, after .
	
	# final product of name (and optional extension)
	my_fullname 	= ""		# filename + "." + ext
	their_name 		= ""		# cchat recipients as being assembled
	state 			= "start"	# current FSM state
	strikes = 0					# total strikes accrued
########################################################################


########################################################################
# STRIKE/KICK: Issue a strike to users, send message + reason, and 	   #
# kick if user accumulates 3 strikes.								   #
########################################################################
def strike(s, reason):
	clients[s].strikes += 1
	print("Issued strike: " + reason)
	print("Current total strikes: " + str(clients[s].strikes))
	if clients[s].strikes >= 3:
		kickflag = True
		kick(client, reason)
	else:
		kickflag = False
		server_response = "(strike("
		server_response += str(clients[s].strikes) + ")"
		server_response += reason + ")"
		s.send(server_response)
	return kickflag
def kick(s, reason):
	del clients[s]
	input.remove(s)
	server_response = "(kick" + reason + ")"
	s.send(server_response)
	print("Kicking client: " + reason)
	s.close()
	sstat()
########################################################################

########################################################################
# CCHAT: Send a message to all users, a random user, a single user,	   #
#		 or a list of specific users. Strikes given for invalid users. #
########################################################################
def cchat(s):
	print("line 274")
	print("clients[s].their_name:  " + clients[s].their_name)
	print("clients[s].msg:  " + clients[s].msg)

	# Check if this socket has a username already , don't continue
	if clients[s].my_fullname == "":
		print("User attempting to send without joining")
		kick = strike(s, "(malformed)")
	else:
		# split recipients into a list if there's >1 person
		if "," in clients[s].their_name:
			ppl_list = clients[s].their_name.split(",")
			# capitalize all usernames in ppl_list
			ppl_list = [x.upper() for x in ppl_list]
		else:
			ppl_list = clients[s].their_name
			ppl_list = ppl_list.upper()
		
		
		
		outgoing_msg = "(schat(" + clients[s].my_fullname + ")(" + clients[s].msg + "))"

		# check if sending a broadcast message or random message
		if ppl_list == "ALL":
			# iterate through entire hashtable of names and send
			for each in clients:
				if each != s:
					each.send(outgoing_msg)
		elif ppl_list == "ANY":
			# need to randomly choose an entry from hash table
			random_guy = random.choice(clients.keys())
		
			# if random value turns out to be the sender, then try again
			while random_guy == s:
				random_guy = random.choice(clients.keys())
			random_guy.send(outgoing_msg)

			print("Random message sent:  " + clients[s].msg)
			print("to user:  " + clients[random_guy].my_fullname)
			
		# send to specific user(s)
		elif (type(ppl_list) == str):
			for each in clients:
				# send msg when curr_sock name matches the guy in ppl_list
				if clients[each].my_fullname in ppl_list:
					each.send(outgoing_msg)
					break
		# send to multiple users
		else:
	
			all_valid_users = list_all_users().split(",")
#			print("all valid users:")
#			print(all_valid_users)		
			
#			print("line 218\nppl_list:  ") 
#			print(ppl_list)	

			if type(ppl_list) == list:	# sending to more than one person
				# strike for any reserved words in the recipient list
				if "ALL" in ppl_list:
					# don't actually use the kick flag here, but I think I need to have a receiving variable. 
					# Idk I'll try in a sec
					ppl_list.remove("ALL")
					kick = strike(s, "(malformed)")
				if "ANY" in ppl_list:
					ppl_list.remove("ANY")
					kick = strike(s, "(malformed)")
				# strike for any invalid users in the recipient list
	
				print("line 232\nppl_list:  ") 
				print(ppl_list)	
			

#				print("line 236\nppl_list items one at a time:")
				for item in ppl_list:
					print(item)
					curr_name = item
					print("curr_name:  ")
					print("all_valid_users:  ") 
					print(all_valid_users)
					if curr_name not in all_valid_users:
						kick = strike(s, "(malformed)")
						print("should be strike")
				
			# Send messages to all connected users in the recipient list.
			for each in clients:
				# send msg when the curr_sock name is in ppl_list
				if clients[each].my_fullname in ppl_list:
					each.send(outgoing_msg)
				
	clients[s].their_name = ""
	clients[s].msg = ""
########################################################################








########################################################################
# Helper for CJOIN: Take a DOSname and increment to next appropriate   #
# name, if DOSname is already taken.								   #
########################################################################
def incr_name(s):
	newfilename = ""

	# name = "SCOTTY" --> "SCOTTY~1"	
#	if not (clients[s].filename[len(clients[s].filename)-1].isdigit()) and (clients[s].filename[len(clients[s].filename)-2] == "~"):
#	if not (clients[s].filename[len(clients[s].filename)-1].isdigit()):
	if not (clients[s].filename[len(clients[s].filename)-1].isdigit()) and not (clients[s].filename[len(clients[s].filename)-2] == "~"):
		newfilename = clients[s].filename[:len(clients[s].filename)-2] + "~1"
	# name = "SCOTT~1" --> "SCOTT~9"
	elif (clients[s].filename[len(clients[s].filename)-1].isdigit()) and (clients[s].filename[len(clients[s].filename)-2] == '~'):
		if int(clients[s].filename[len(clients[s].filename)-1]) < 9:
			newfilename = clients[s].filename[:len(clients[s].filename)-1] + str(int(clients[s].filename[len(clients[s].filename)-1])+1)
		elif int(clients[s].filename[len(clients[s].filename)-1]) == 9:
			newfilename = clients[s].filename[:len(clients[s].filename)-2] + '~' + str(int(clients[s].filename[len(clients[s].filename)-1]) + 1)
	# name = "SCOT~10" --> "SCOT~99"
	elif (clients[s].filename[len(clients[s].filename)-1].isdigit()) and (clients[s].filename[len(clients[s].filename)-2].isdigit()) and (clients[s].filename[len(clients[s].filename)-3] == '~'):
		if int(clients[s].filename[len(clients[s].filename)-2:]) < 99:
			newfilename = clients[s].filename[:len(clients[s].filename)-2] + str(int(clients[s].filename[len(clients[s].filename)-2:]) + 1)
		elif int(clients[s].filename[len(clients[s].filename)-2:]) == 99:
			newfilename = clients[s].filename[:len(clients[s].filename)-4] + '~' + str(int(clients[s].filename[len(clients[s].filename)-2:]) + 1)
	# name = "SCO~100" --> "SCO~999"
	elif (clients[s].filename[len(clients[s].filename)-1].isdigit()) and (clients[s].filename[len(clients[s].filename)-2].isdigit()) and (clients[s].filename[len(clients[s].filename)-3].isdigit()) and (clients[s].filename[len(clients[s].filename)-4] == '~'):
		if int(clients[s].filename[len(clients[s].filename)-3:]) < 999:
			newfilename = clients[s].filename[:len(clients[s].filename)-3] + str(int(clients[s].filename[len(clients[s].filename)-3:]   ) + 1)
		elif int(clients[s].filename[len(clients[s].filename)-3:]) == 999:
			print("You can't have 1000 of same clients[s], sorry")
	else:
		print("Something fucked up, you should never see this")
	
#	return newfilename
	clients[s].filename = newfilename
########################################################################


########################################################################
# CJOIN: Method for a client joining chat session. Handles name 
# 		 name filtering and colission. 
########################################################################
def cjoin(s):
#	print("Attempting to add:  " + clients[s].my_name_bldr) 
#	print("all clients:  ") 
#	print_all_players()
	
	# Strip out all characters except alphanumeric (A-Z, 0-9) and a single 
	# period somewhere in the middle of the name.
	def stripName():
		clients[s].my_name_bldr = clients[s].my_name_bldr.upper()
		newname = ""
		for i in range(0, len(clients[s].my_name_bldr)):
			int_val = ord(clients[s].my_name_bldr[i])
			# allow letters, digits, and a period (respectively)
			if (int_val >= 48 and int_val <= 57) or (int_val >= 65 and int_val <= 90) or (int_val == 46):
				newname += clients[s].my_name_bldr[i]
		print("oldname: " + clients[s].my_name_bldr)
		print("newname: " + newname)
		clients[s].my_name_bldr = newname
		
		
	# Check if the requested name exists already on the server
	def name_exists(looking_for):
		for each in clients:
#			print("each: " + clients[each].my_fullname)
#			print("s: " + clients[s].my_fullname)
			if (clients[each].my_fullname == looking_for):
				if (each != s):
					return True
		return False
		
	# Helper function to print out table of all players. COmpletely unnecessary, probably won't use
	def user_table():
		print([ip for ip in socket.gethostbyname_ex(socket.gethostname())[2] if not ip.startswith("127.")][:1])

		

	# If socket is requested a username and they already have one, then strike	
	if clients[s].my_fullname != "":
		print("You already have a name. Go home, you're drunk.")
		kick = strike(s, "(malformed)")
	else:
#		clients[s].my_name_bldr = stripName()	# strip illegal chars
		name_chunks = re.split('[.]', clients[s].my_name_bldr)
		
#		print("name_chunks[0]:\t" + name_chunks[0])
#		if len(name_chunks) == 2:
#			print("name_chunks[1]:\t" + name_chunks[1])
#			if len(name_chunks[1]) > 3:
#				name_chunks[1] = name_chunks[1][:3]
				

	
#		print("clients[s].my_name_bldr:  " + clients[s].my_name_bldr)
	
		# strike for empty name
		if clients[s].my_name_bldr == "":	
			kick = strike(s, "(malformed)")
		# strike for reserved name
		elif clients[s].my_name_bldr.upper() == "ALL" or clients[s].my_name_bldr.upper() == "ANY":	
			kick = strike(s, "(malformed)")		
		# strike if there's >1 dot remaining
		elif any(clients[s].my_name_bldr.count(x) > 2 for x in clients[s].my_name_bldr if x == "."):
			kick = strike(s, "(malformed)")
		else:
			# split the username into filename and extension, if necessary
			name_chunks = re.split('[.]', clients[s].my_name_bldr)
			print("line 327")
			print("name_chunks[0]:\t" + name_chunks[0])
			if len(name_chunks) == 2:
				print("name_chunks[1]:\t" + name_chunks[1])
			clients[s].filename = name_chunks[0]

			if len(name_chunks) == 1:
				if len(name_chunks[0]) > 8:
					clients[s].filename[0] = name_chunks[0][:6] + "~1"
				clients[s].my_fullname = clients[s].filename
			
			elif len(name_chunks) == 2:
				clients[s].ext = name_chunks[1]
				if len(clients[s].ext) > 3:
					clients[s].ext = clients[s].ext[:3]
				clients[s].my_fullname = clients[s].filename + "." + clients[s].ext					
	

			
			print("line 340")
			print("clients[s].my_fullname:\t" + 	clients[s].my_fullname)
			# check if filename+ext is already taken, if it is then increment name
			if name_exists(clients[s].my_fullname):
				print("that name is already there")
				incr_name(s)
			
			# after appropriate incrementation is done then clients[s] will have a unique name
			if len(name_chunks) == 1:
				clients[s].my_fullname = clients[s].filename
			elif len(name_chunks) == 2:
				clients[s].my_fullname = clients[s].filename + "." + clients[s].ext
			
			
	#		print("assigned final name:\t" + clients[s].my_fullname)

	#		print("all clients:  ") 
	#		print_all_players()
	
			print("name_chunks[0]:\t" + name_chunks[0])
			if len(name_chunks) == 2:
				print("name_chunks[1]:\t" + name_chunks[1])
				if len(name_chunks[1]) > 3:
					name_chunks[1] = name_chunks[1][:3]
		
			num_players = len(clients)

			# confirm join and send response
			server_response = "(sjoin("
			server_response += clients[s].my_fullname + ")("
			server_response += list_all_users() + ")("
			server_response += str(min_players) + ","
			server_response += str(lobbytime) + ","
			server_response += str(timeout) + "))"
			s.send(server_response)
			sstat()
			
#			user_table()
	
	# User may have been kicked above, check if entry still exists in hash table before trying to reset this			
	if clients.get(s, 0) != 0:
		clients[s].my_name_bldr = ""
########################################################################





				
			
########################################################################
# Helper for CSTAT, STAT, and CJOIN
# Returns a string listing all players in format: USER~1,USER~2,BLAH~1
def list_all_users():
	all_names = ""
	for each in clients:
		if all_names == "":
			all_names = clients[each].my_fullname
		elif all_names != "":
			all_names = all_names + "," + clients[each].my_fullname
	return all_names
########################################################################	

########################################################################	
# CSTAT: Send a message to a specific user who has requested server info
# SSTAT: Broadcast a server status message to everyone
def cstat(s):
	all_names = list_all_users()
	server_response = "(sstat(" + all_names + "))"
	s.send(server_response)
def sstat():
	all_names = ""		
	all_names = list_all_users()
	server_response = "(sstat(" + all_names + "))"
	for each in clients:
		each.send(server_response)
########################################################################


########################################################################
def fsm(s, data):
## FSM decided upon by class:
# http://i.imgur.com/1v6NUAI.png 

## More verbose version, essentially equivalent: 
# http://i.imgur.com/or5rSbU.jpg
	
	# Enable Resync = issue strike + reject to exit out of current loop 
	def enableResync(client, curr_strikes):
		curr_strikes, kickflag, reject, resync = strike(client, "(toolong)", curr_strikes)
		clients[s].index = 0
		reject = True
		resync = True
		return curr_strikes, kickflag, reject, resync

	# Strip out non-printable ASCII chars, as well as parans.
	def stripMsg(oldmsg):
		newmsg = ""
		for i in range(0, len(oldmsg)):
			int_val = ord(oldmsg[i])
			# allow integer values for letters and digits (respectively)
			if (int_val >= 42 and int_val <= 126) or (int_val >= 32 and int_val <= 39): 
				newmsg += oldmsg[i]
		return newmsg
	


	accept = False		# flag to indicate end-of-loop behavior, current route through machine ends in Accept
	almostkick = False	# set to true if user is getting kicked, then clear data, then kick
	kick   = False		# if user incurred 3 strikes then after kicking (closing socket) break while loop
	reject = False		# flag to indicate end-of-loop behavior, current route through machine ends in Reject
	resync = False		# causes additional strikes to be ignored for up to 480 chars

	accepts = 0			# total # of successful accepts in buffer entry
	curr_strikes = 0	# total # of strikes in buffer entry
	
	command = ""
	
	clients[s].buffstr += data
	
	while kick == False and clients.get(s, 0) != 0 and clients[s].index < len(clients[s].buffstr):
		line_info = "x: " + str(clients[s].index) 
		line_info += "\t\tdata[" + str(clients[s].index) 
		line_info += "]:  " + clients[s].buffstr[clients[s].index]
		print(line_info)
		if clients[s].buffstr[clients[s].index] == "":			# reach end of current buffer, done reading current message
			break
			
		# If message is too long and not resyncing, set to true and issue strike
		if clients[s].index == 480 and accept == False and resync == False:
			# set reject and resync to true, kick will be true if strikes now == 3
			kick = strike(client, "(toolong)")
			clients[s].index = 0
			reject = True
		elif clients[s].index == 480 and accept == False and resync == True:
			print("Resync:  " + str(resync))
			kick = strike(client, "(toolong)")

	
		if almostkick == True:	# if user has been kicked reset data 
								# exit loop and don't resume
			clients[s].buffstr = ""
			data = ""
			kick = True		
		
		elif clients[s].state == "start":
			if clients[s].buffstr[clients[s].index] == "(":				
				clients[s].state = "start2"
			else: 
				if resync == False:
					# enable resync, give strike
					strike(s, "(toolong)")			
					# I don't know hwo to handle kick making server not crash yet
#					if kick:	
#						break
					print("reject start")
				elif resync == True:				# dont' give strike if still waiting to find valid input
					pass
					# do nothing but increment counter and keep looking
		elif clients[s].state == "start2":
			if clients[s].buffstr[clients[s].index] == "c":
				clients[s].state = "start3"
				if resync == True:		# Now found some good input, set resync to false and try again
					resync = False
			else: 
				if resync == False:			
					kick = strike(s, "(malformed)")
					print("reject start2")
#					curr_strikes, reject, resync = enableResync(client, curr_strikes)
										
				elif resync == True:
					# do nothing but increment counter and keep looking
					pass
		elif clients[s].state == "start3":
			if clients[s].buffstr[clients[s].index] == "c":		# begin (cchat, clients[s].state = 19.*
				clients[s].state = "chat1"
			elif clients[s].buffstr[clients[s].index] == "j":		# begin (cjoin, clients[s].state = 20.*
				clients[s].state = "join1"
			elif clients[s].buffstr[clients[s].index] == "s":		# begin (cstat), clients[s].state = 1.*
				clients[s].state = "stat1"
			else: 
				kick = strike(s, "(malformed)")		# not spelling cchat, cjoin, or cstat
				
				print("reject start3")
				reject = True
				resync = True
				
				
				
				
				

				
				
				
				
				
		elif clients[s].state == "chat1":
			if clients[s].buffstr[clients[s].index] == "h":
				clients[s].state = "chat2"
			else: 
				kick = strike(s, "(malformed)")
				print("reject chat1")
				reject = True
				resync = True
		elif clients[s].state == "chat2":
			if clients[s].buffstr[clients[s].index] == "a":
				clients[s].state = "chat3"
			else: 
				kick = strike(s, "(malformed)")
				print("reject chat2")
				reject = True
				resync = True
		elif clients[s].state == "chat3":
			if clients[s].buffstr[clients[s].index] == "t":
				clients[s].state = "chat4"
			else: 
				kick = strike(s, "(malformed)")
				print("reject chat3")
				reject = True
		elif clients[s].state == "chat4":
			if clients[s].buffstr[clients[s].index] == "(":
				command = "chat"
				clients[s].state = "chat5"
			else: 
				kick = strike(s, "(malformed)")	# incorrectly placed paran
				print("reject chat4")
				reject = True
		elif clients[s].state == "chat5":
			# CCHAT: reading in list of names one char at a time until close paran
			if clients[s].buffstr[clients[s].index] != ")":
				clients[s].their_name += clients[s].buffstr[clients[s].index]
				if len(clients[s].their_name) == 419:
					# (30 names * 13 char name limit) + 29 commas = 419 char their_name limit
					kick = strike(s, "(malformed)")
					reject = True
					resync = True
			else:
				print("clients[s].their_name:\t" + clients[s].their_name)
				clients[s].their_name = stripMsg(clients[s].their_name)
				clients[s].state = "chat6"
				
		elif clients[s].state == "chat6":
			# CCHAT: looking for a paran before beginning of message
			if clients[s].buffstr[clients[s].index] == "(":
				clients[s].state = "chat7"
			else: 
				kick = strike(s, "(malformed)")
				print("reject chat6")
				reject = True
				resync = True
		elif clients[s].state == "chat7":
			# CCHAT: reading in message one char at a time until 1st closing paran
			if clients[s].buffstr[clients[s].index] != ")":
				clients[s].msg += clients[s].buffstr[clients[s].index]
				if len(clients[s].msg) == 80:	# if msg is >80 chars then just truncate and skip to accept
					clients[s].msg = stripMsg(clients[s].msg)
					clients[s].buffstr = clients[s].buffstr[:clients[s].index]
					accepts += 1
					print("accept chat, message truncated")
					accept = True
			else: 
				# Strip out any illegal chars in message before passing to next state
				clients[s].msg = stripMsg(clients[s].msg)
				clients[s].state = "chat8"
		elif clients[s].state == "chat8":
			# CCHAT: looking for 2nd closing paran
			if clients[s].buffstr[clients[s].index] == ")":
				clients[s].state = "chat_accept"
				accepts += 1
				print("accept chat")
				print("msg:\t" + clients[s].msg)
				accept = True	# accept CCHAT




				
				
				
				
		elif clients[s].state == "join1":
			# clients[s].states 20.*: reading in CJOIN command one char at a time
			if clients[s].buffstr[clients[s].index] == "o":
				clients[s].state = "join2"
			else: 
				kick = strike(s, "(malformed)")	# misspelled cjoin
				print("reject join1")
				reject = True
				resync = True
		elif clients[s].state == "join2":
			if clients[s].buffstr[clients[s].index] == "i":
				clients[s].state = "join3"
			else: 
				kick = strike(s, "(malformed)")
				print("reject join2")
				reject = True
				resync = True
		elif clients[s].state == "join3":
			if clients[s].buffstr[clients[s].index] == "n":
				clients[s].state = "join4"
			else: 
				strike(client, "(malformed)")
				print("reject join3")
				reject = True
				resync = True
		elif clients[s].state == "join4":
			if clients[s].buffstr[clients[s].index] == "(":
				command = "join"
				if len(clients) == 30:		# verify room on server before proceeding
					kick(client, "(snovac)")

#				elif socket already has a name associated with it then give strike
					
				else:
					clients[s].state = "join5"
			else:
				kick = strike(s, "(malformed)")
				print("reject join4")
				reject = True
				resync = True
		elif clients[s].state == "join5":
			# CJOIN: reading in name one char at a time until close paran
			if clients[s].buffstr[clients[s].index] != ")":
				clients[s].my_name_bldr += clients[s].buffstr[clients[s].index]
			else:
				# user finished entering name, begin add process
				clients[s].state = "join6"
		elif clients[s].state == "join6":
			# CJOIN: looking for closing parans
			if clients[s].buffstr[clients[s].index] == ")":
				clients[s].state = 41
				accepts += 1
				command = "join"		# Will call (cjoin) at end
				accept = True			# accept CJOIN
			else: 
				print("rejected on char:  " + str(clients[s].index) + ":  " + clients[s].buffstr[clients[s].index])
				print("length so far:  " + str(clients[s].index))
				kick = strike(s, "(malformed)")	# misplaced paran
				print("reject join6")
				reject = True
				resync = True







				
				
		elif clients[s].state == "stat1":
			if clients[s].buffstr[clients[s].index] == "t":
				clients[s].state = "stat2"
			else: 
				kick = strike(s, "(malformed)")
				print("reject stat2")
				reject = True
				resync = True
		elif clients[s].state == "stat2":
			if clients[s].buffstr[clients[s].index] == "a":
				clients[s].state = "stat3"
			else: 
				kick = strike(s, "(malformed)")
				print("reject stat3")
				reject = True
				resync = True
		elif clients[s].state == "stat3":
			if clients[s].buffstr[clients[s].index] == "t":
				clients[s].state = "stat4"
			else: 
				kick = strike(s, "(malformed)")
				print("reject stat4")
				reject = True
				resync = True
		elif clients[s].state == "stat4":
			if clients[s].buffstr[clients[s].index] == ")":
				command = "cstat"
				cstat(s)
				clients[s].state = "stat_accept"
				print("accept stat")
				accepts += 1
				accept = True			# accept (cstat)
			else: 
				kick = strike(s, "(malformed)")
				print("reject stat4")
				reject = True
				resync = True
				
				
				
				
				
				
		elif clients[s].state == 999:
				print("should have broken already")
		else:
				print("state:  " + str(clients[s].state) + "   something broke")

		if reject:
			print("Invalid command\t\t" + clients[s].buffstr[:clients[s].index+1] + "\n\n")
#			print("resyncing to eliminate bad input")
			clients[s].buffstr = clients[s].buffstr[clients[s].index+1:]		# resync, cut out bad input
																	# I changed index+1 --> index+2, maybe this is wrong??
			print("new buffer:  " + clients[s].buffstr)
			reject = False
			clients[s].index = 0
			clients[s].state = "start"
		elif accept:
#			print("Valid command:\t\t" + clients[s].buffstr[:clients[s].index+1])
			clients[s].buffstr = clients[s].buffstr[clients[s].index+1:]		# resync, accept 
			print("new buffer:  " + clients[s].buffstr)
			accept = False
			clients[s].index = -1		# why the fuck is this -1? I guess it's getting incremented somewhere, fuck if i know
			clients[s].state = "start"
			if command == "chat":
				print("line 701")
				print("ppl:\t" + clients[s].their_name)
				print("msg:\t" + clients[s].msg)
				cchat(s)
			elif command == "join":
				cjoin(s)
			elif command == "stat":
				cstat()
			command = ""
			
			
		# verify client wasn't kicked before attempting to increment index	
		if clients.get(s, 0) != 0:			
			clients[s].index += 1
########################################################################

while running:
	inputready,outputready,exceptready = select.select(input,[],[])
	
	for s in inputready:
		if s == server:
			# handle the server socket
			client, address = server.accept()
			input.append(client)
#			strikes[s] = 0	# create new entry in strikes for this 
							# socket, set to 0 strikes
			#print "Connection established"
			if len(clients) >= 30:
				s.send("(snovac)")
				s.close()
				input.remove(s)
			
		elif s == sys.stdin:
			# handle standard input
			junk = sys.stdin.readline()
			print("---TURN DAT SHIT OFF!!---")
			running = 0 
		else:
			# handle all other sockets
			if clients.get(s, 0) == 0:			# If no Client for this socket, then
				clients[s] = Client()			# create new Client object with this socket
#				clients[s].socket = s

			## check how much space is available in that socket's buffer before 
			# telling how much data to receive
			data = s.recv(msg_size - clients[s].index + 1)

			if data:
				fsm(s, data)

			# If user disconnects hits this block. Blank input does 
			# NOT reach this block.
			else:
				# Remove client from hashtable and send a new sstat
				if clients.get(s, 0) != 0:
					del clients[s]
					sstat()
			
				s.close()
				input.remove(s)
				break
				
print("This line never happens. Why? Who knows. It should! But it doesn't. Quite a mystery.")
server.close()
