#!/usr/bin/env python
import argparse		# command line arguments
import calendar		# used for timeout
import os			# used for clearing terminal
import random		# used for "any" chat command
import re 			# regular expressions
import select
import socket
import string
import sys
import time 		# used for timeout

parser = argparse.ArgumentParser(description='Basic chat server')
parser.add_argument('-l','--lobbytime',  help='Enter lobby wait time in seconds',  default=15, required=False)
parser.add_argument('-m','--minplayers', help='Enter minimum number of players',   default=4,  required=False)
parser.add_argument('-t','--timeout',    help='Enter a timeout length in seconds', default=2, required=False)

args = parser.parse_args()

# putting this in so I can avoid typing "args.blahblah" later
lobbytime 	= args.lobbytime
min_players = args.minplayers
timeout 	= args.timeout


#### start_timeout = time.time()




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
-Timeout
-Resync

	Medium priority
-Automatic chat mode

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
class Client:														   #
	buffstr 		= ""		# raw buffer received from TCP stream  #
	index 			= -1		# where I'm at processing buffer	   #
	msg 			= ""		# cchat message being assembled 	   #
																	   #
	# intermediate steps											   #
	my_name_bldr 	= ""		# cjoin name as it's being assembled   #
	filename		= ""		# first part of filename, before .	   #
	ext		 		= ""		# file extension, after .			   #
																	   #
	# final product of name (and optional extension)				   #
	my_fullname 	= ""		# filename + "." + ext				   #
	their_name 		= ""		# cchat recipients as being assembled  #
	state 			= "start"	# current FSM state					   #
	strikes 		= 0			# total strikes accrued				   #
	last_strike_reason = ""											   #
																	   #
####last_cmd_time	= 0			# time since Unix epoch in # of secs   #
########################################################################


########################################################################
# STRIKE/KICK: Issue a strike to users, send message + reason, and 	   #
# kick if user accumulates 3 strikes.								   #
########################################################################
def strike(s, reason):												   #
	clients[s].strikes += 1 										   #
	clients[s].last_strike_reason = reason 							   #
	if reason == "(malformed)":										   #
		clients[s].state = "resync1" 								   #
	#clients[s].last_cmd_time = calendar.timegm(time.gmtime())		   #
	output_msg = "Striking client:\t" + clients[s].my_fullname		   #
	output_msg += "\treason:\t" + reason							   #	
	output_msg += "\tstrikes:\t" + str(clients[s].strikes)			   #
	print(output_msg)												   #
	#if clients[s].strikes >= 3:									   #
	#	kickflag = True												   #
	#	kick(client, reason)										   #
	#else:															   #
	kickflag = False											 	   #
	server_response = "(strike("								   	   #
	server_response += str(clients[s].strikes) + ")"			   	   #
	server_response += reason + ")"								   	   #
	s.send(server_response)										   	   #
	#return kickflag												   #
																	   #
def kick_user(s):													   #
	server_response = "(kick" + clients[s].last_strike_reason + ")"	   #
	s.send(server_response)											   #
	output_msg = "Kicking client:\t\t" + clients[s].my_fullname		   #
	output_msg += "\treason:\t" + clients[s].last_strike_reason		   #
	del clients[s]													   #
	input.remove(s)												   	   #
	print(output_msg)												   #
	s.close()														   #
	sstat()															   #
########################################################################

########################################################################
# TIMEOUT_CHECK: Check if (curr_time - last_interact_time) > timeout   #
# 				 period.											   #
########################################################################
def timeout_check():
	current_time = calendar.timegm(time.gmtime())
	#current_time = time.time()

	if (current_time - start_timeout) > timeout:
		strike(each, "(timeout)")

	for each in clients:
		#print(clients[each].last_cmd_time - current_time)
		#if (current_time - clients[each].last_cmd_time) > timeout:

			# break to make sure don't try to loop through when client is
			break
########################################################################

########################################################################
# CCHAT: Send a message to all users, a random user, a single user,	   #
#		 or a list of specific users. Strikes given for invalid users. #
########################################################################
def cchat(s):
	print("clients[s].their_name:  " + clients[s].their_name)
	print("clients[s].msg:  " + clients[s].msg)

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
			all_valid_users = list_all_users()
			# check if it's a valid user to send to
			if ppl_list not in all_valid_users:
				print("unable to send to:\t" + ppl_list)
				strike(s, "(malformed)")
			else:
				for each in clients:
					# send msg when curr_sock name matches homie in ppl_list
					if clients[each].my_fullname in ppl_list:
						each.send(outgoing_msg)
						break
		# send to multiple users
		else:
			all_valid_users = list_all_users().split(",")
			print("all_valid_users:\t" + str(all_valid_users))


			print("type(ppl_list):\t" + str(type(ppl_list)))
			""" ## Isn't it assumed that ppl_list is a list at this point?? """

			# strike for any reserved words in the recipient list
			if "ALL" in ppl_list:
				# don't actually use the kick flag here, but I 
				# think I need to have a receiving variable. 
				# Idk I'll try in a sec
				print("can't put ALL in the send list")
				ppl_list.remove("ALL")
				strike(s, "(malformed)")
			if "ANY" in ppl_list:
				print("can't put ANY in the send list")
				ppl_list.remove("ANY")
				strike(s, "(malformed)")


			# strike for any invalid users in the recipient list
			for curr_name in ppl_list:
				print("curr_name:  " + curr_name)
				print("all_valid_users:  ") 
				print(all_valid_users)
				if curr_name not in all_valid_users:
					strike(s, "(malformed)")
					print("should be strike")
				
			# send message to all connected users in the recipient list
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
	
	clients[s].filename = newfilename

	# if no file extension then set fullname to just filename
	if clients[s].ext == "":
		clients[s].my_fullname = clients[s].filename
	# otherwise add the extension
	else:
		clients[s].my_fullname = clients[s].filename + "." + clients[s].ext			
########################################################################


########################################################################
# CJOIN: Method for a client joining chat session. Handles name 	   #
# 		 name filtering and colission. 								   #
########################################################################
def cjoin(s):
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
		strike(s, "(malformed)")
	else:
		# strike for empty name
		if clients[s].my_name_bldr == "":	
			strike(s, "(malformed)")
		# strike for reserved name
		elif clients[s].my_name_bldr.upper() == "ALL" or clients[s].my_name_bldr.upper() == "ANY":	
			strike(s, "(malformed)")		
		# strike if there's >1 dot remaining
		elif any(clients[s].my_name_bldr.count(x) > 2 for x in clients[s].my_name_bldr if x == "."):
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
				clients[s].my_fullname = clients[s].filename + "." + clients[s].ext					
			
			#print("clients[s].my_fullname:\t" + 	clients[s].my_fullname)
			# check if filename+ext is already taken, if it is then increment name
			if name_exists(clients[s].my_fullname):
				print("that name is already there")
				while name_exists(clients[s].my_fullname):
					incr_name(s)
			
			# after appropriate incrementation is done then clients[s] will have a unique name
			if len(name_chunks) == 1:
				clients[s].my_fullname = clients[s].filename
			elif len(name_chunks) == 2:
				clients[s].my_fullname = clients[s].filename + "." + clients[s].ext
			
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
			print("Added:\t\t\t" + clients[s].my_fullname)
			
#			user_table()
	
	# User may have been kicked above, check if entry still exists in hash table before trying to reset this			
	if clients.get(s, 0) != 0:
		clients[s].my_name_bldr = ""
########################################################################





				
			
########################################################################
# Helper for CSTAT, STAT, and CJOIN									   #
# Returns a string listing all players in format: USER~1,USER~2,BLAH~1 #
########################################################################
def list_all_users():												   #
	all_names = ""													   #
	for each in clients:											   #
		if all_names == "":											   #
			all_names = clients[each].my_fullname					   #
		elif all_names != "":										   #
			all_names = all_names + "," + clients[each].my_fullname	   #
	return all_names												   #
########################################################################	

########################################################################	
# CSTAT: Send a message to a specific user who requested server info   #
# SSTAT: Broadcast a server status message to everyone				   #
########################################################################
def cstat(s):														   #
	all_names = list_all_users()									   #
	server_response = "(sstat(" + all_names + "))"					   #
	s.send(server_response)											   #
																	   #
def sstat():														   #
	all_names = ""													   #
	all_names = list_all_users()									   #
	server_response = "(sstat(" + all_names + "))"					   #
	for each in clients:											   #
		each.send(server_response)									   #
########################################################################


########################################################################
# OKAY SERIOUSLY FUCK THIS WHOLE THING, FUCK IT IN THE TESTICLE HOLE
########################################################################
def fsm(s, data):
## FSM decided upon by class:
# http://i.imgur.com/1v6NUAI.png 

## More verbose version, essentially equivalent: 
# http://i.imgur.com/or5rSbU.jpg
	# Strip out non-printable ASCII chars, as well as parans.
	def stripMsg(oldmsg):
		newmsg = ""
		for i in range(0, len(oldmsg)):
			int_val = ord(oldmsg[i])
			# allow integer values for letters and digits (respectively)
			if (int_val >= 42 and int_val <= 126) or (int_val >= 32 and int_val <= 39): 
				newmsg += oldmsg[i]
		return newmsg
	
	index = clients[s].index
	clients[s].buffstr += data
	
	while index < len(clients[s].buffstr)-1:
			index += 1

			line_info = "x: " + str(index) 
			line_info += "\tdata[" + str(index) 
			line_info += "]:  " + clients[s].buffstr[index]
			line_info += "\tstate:\t" + clients[s].state
			line_info += "\t\tbuffer:\t" + clients[s].buffstr
			print(line_info)

			if clients[s].buffstr[index] == "":			# reach end of current buffer, done reading current message
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
					state = "resync2"
					strike(s, "(malformed)")
					print("reject start2")
			elif clients[s].state == "start3":
				if clients[s].buffstr[index] == "c":		# begin (cchat, clients[s].state = 19.*
					clients[s].state = "chat1"
				elif clients[s].buffstr[index] == "j":		# begin (cjoin, clients[s].state = 20.*
					clients[s].state = "join1"
				elif clients[s].buffstr[index] == "s":		# begin (cstat), clients[s].state = 1.*
					clients[s].state = "stat1"
				else: 
					strike(s, "(malformed)")		# not spelling cchat, cjoin, or cstat
					print("reject start3")



					
					
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
					command = "chat"
					clients[s].state = "chat5"
				else: 
					strike(s, "(malformed)")	# incorrectly placed paran
					print("reject chat4")
			elif clients[s].state == "chat5":
				print("line 519")
				# CCHAT: reading in list of names one char at a time until close paran
				if clients[s].buffstr[index] != ")":
					clients[s].their_name += clients[s].buffstr[index]
					if len(clients[s].their_name) == 419:
						# (30 names * 13 char name limit) + 29 commas = 419 char their_name limit
						strike(s, "(malformed)")
				else:
					clients[s].their_name = stripMsg(clients[s].their_name)
					clients[s].state = "chat6"
			elif clients[s].state == "chat6":
				print("line 530 clients[s].their_name:\t" + clients[s].their_name)

				# CCHAT: looking for a paran before beginning of message
				if clients[s].buffstr[index] == "(":
					clients[s].state = "chat7"
				else: 
					strike(s, "(malformed)")
					print("reject chat6")
			elif clients[s].state == "chat7":
				print("line 531")
				# CCHAT: reading in message one char at a time until 1st closing paran
				if clients[s].buffstr[index] != ")":
					clients[s].msg += clients[s].buffstr[index]
					if len(clients[s].msg) == 80:	# if msg is >80 chars then just truncate and skip to accept
						clients[s].msg = stripMsg(clients[s].msg)
						clients[s].buffstr = clients[s].buffstr[:index]
						print("chat_accept, message truncated")
						print("ppl:\t" + clients[s].their_name)
						print("msg:\t" + clients[s].msg)
						cchat(s)
						clients[s].buffstr = clients[s].buffstr[index+1:]
						index = -1
						command = ""
						print("new buffer:  " + clients[s].buffstr)
						print("accept chat")
						print("msg:\t" + clients[s].msg)
				else: 
					# Strip out any illegal chars in message before passing to next state
					print("line 610 clients[s].msg:\t" + clients[s].msg)
					clients[s].msg = stripMsg(clients[s].msg)
					print("line 612 clients[s].msg:\t" + clients[s].msg)
					clients[s].state = "chat8"
			elif clients[s].state == "chat8":
				print("line 556")
				# CCHAT: looking for 2nd closing paran
				if clients[s].buffstr[index] == ")":
					print("line 559 chat_accept")
					print("ppl:\t" + clients[s].their_name)
					print("msg:\t" + clients[s].msg)
					cchat(s)
					clients[s].buffstr = clients[s].buffstr[index+1:]
					index = -1
					print("new buffer:  " + clients[s].buffstr)
					clients[s].state = "start"




					
					
					
					
			elif clients[s].state == "join1":
				# clients[s].states 20.*: reading in CJOIN command one char at a time
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
					command = "join"
					if len(clients) == 30:		# verify room on server before proceeding
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
	#				clients[s].state = "join_accept"
	#				print("name:\t" + clients[s].my_name_bldr)
	#				print("join_accept")
	#				print("buffer:  " + clients[s].buffstr[:index+1])
					clients[s].state = "start"
					cjoin(s)
					clients[s].buffstr = clients[s].buffstr[index+1:]
					index = -1
					print("buffer:  " + clients[s].buffstr[:index+1])
					
	#				print("new buffer:  " + clients[s].buffstr)
				else: 
					print("rejected on char:  " + str(index) + ":  " + clients[s].buffstr[index])
					print("length so far:  " + str(index))
					
					strike(s, "(malformed)")	# misplaced paran
					print("reject join6")





					
					
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
					command = "cstat"
					clients[s].state = "stat_accept"
					print("accept stat")
					print("Valid command:\t\t" + clients[s].buffstr[:index+1])
					clients[s].state = "start"
					cstat(s)
					clients[s].buffstr = clients[s].buffstr[index+1:]
					index = -1
					command = ""
					print("new buffer:  " + clients[s].buffstr)
				else: 
					strike(s, "(malformed)")
					print("reject stat4")









			elif clients[s].state == "resync1":
				if clients[s].buffstr[index] == "(":
					clients[s].state = "resync2"
				print("curr buffer:\t" + clients[s].buffstr)
			elif clients[s].state == "resync2":
				if clients[s].buffstr[index] == "c":
					clients[s].buffstr = clients[s].buffstr[index-1:]
					index = -1
					clients[s].state = "start"
				else:
					clients[s].state = "resync1"
				print("curr buffer:\t" + clients[s].buffstr)	
			else:
				print("state:  " + str(clients[s].state) + "   something broke, this should never happen")

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
	
	
		
########################################################################

while running:
	inputready,outputready,exceptready = select.select(input,[],[], .5)

	# timeout checking is done even if no data is received
	# TODO: will put in phase 2
####if not (inputready or outputready or exceptready):
####	timeout_check()		
	
	for s in inputready:
		# timeout checkp performed if data has been received
####	timeout_check()		
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
####		clients[s].last_cmd_time = calendar.timegm(time.gmtime()) 

			""" check how much space is available in that socket's
				buffer before  telling how much data to receive """
			data = s.recv(msg_size - clients[s].index + 1)

			if data:
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
				break
				
print("Peace out gurl scout!!")
server.close()
