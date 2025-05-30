## Example nested case client.statements:
## http://stackoverflow.com/questions/20701834/implementing-a-finite-client.state-machine-with-a-single-coroutine

## FSM decided upon by class:
## http://i.imgur.com/1v6NUAI.png 

import os			# used for clearing terminal
import sys			# used for getting keyboard text



## So far it seems to be working correctly, but it doesn't know there's illegal
## chars in the name, ie:
#  scotty(msg	  is a legal name

# I think that TOOLONG checking is working but I'm not positive it's bulletproof.








""" 
			TODO: 
		High priority
	-resync s.t. only 1 strike given per 480 chars, not 1 strike every single char
	
		if x == 480 and Accept == False, then Reject = True, issueStrike(toolong)
	
		Low priority

"""





########################################################################
class Client:
	"""A Client class"""
	buffstr = ""
#	self.buff_size = buff_size		# maybe don't need
	index = 0
	state = 0		# What client.state the FSM is in 
	name_bldr = ""
	msg_bldr = ""
	total_strikes = 0
	
########################################################################

def cchat(client):
	print("Sent message:\t\t\t" + client.msg_bldr)
	print("Sent to:\t\t\t" + client.name_bldr)
	
def cjoin(client):
	# check if server is full first
	if len(clients) == 30:
		kick(client, "(snovac)")
	else:
		print("Joined server: " + client.name_bldr)
	
def cstat():
	print("(sstat(look-at-all-these-users-woah!!))")
	
	
# Malformed, toolong, and badint strikes trigger resync, be sure to set
# to True and return
def strike(client, reason, curr_strikes):
	client.total_strikes += 1
	print("Issued strike: " + reason)
	print("Current total strikes: " + str(client.total_strikes))
	
	if client.total_strikes == 3:
		kickflag = True
		kick(client, reason)
	else:
		kickflag = False
	
	# TODO: implement this when it's called, not when passed into Strike. I think taht's a good idea....
	if reason == "(badint)" or reason == "(malformed)" or reason == "(toolong)":
		resync = True
	else:
		resync = False
	
	# If a strike is being given reject will always be true
	reject = True
	
	return (curr_strikes + 1), kickflag, reject, resync
	
def kick(client, reason):
	client.buffer = ""
	client.name_bldr = ""
	client.msg_bldr = ""
	
	print("Kicking client: " + reason)
	
	

	



########################################################################
## WARNING: This is some next level shit, I hope you're ready for 	   #
## close to 350+ lines of logic. (It's actually not THAT complex 	   #
## though, see diagram here: http://tinyurl.com/scottysfsm  )		   #
########################################################################
def fsm(client, data):
	
	# Enable Resync = issue strike + reject to exit out of current loop
	def enableResync(client, curr_strikes):
		curr_strikes, kickflag, reject, resync = strike(client, "(toolong)", curr_strikes)
		client.index = 0
		reject = True
		resync = True
		return curr_strikes, kickflag, reject, resync

	# Strip out non-printable ASCII chars, as well as parans.
	def stripMsg(oldmsg):
		newmsg = ""
		for i in range(0, len(oldmsg)):
			int_val = ord(oldmsg[i])
			if (int_val >= 32 and int_val <= 39) or (int_val >= 42 and int_val <= 126): 
				newmsg += oldmsg[i]
		return newmsg
	
	# Strip out all characters except alphanumeric (A-Z, 0-9) and a single 
	# period somewhere in the middle of the name.
	def stripName(oldname):
		oldname = oldname.upper()
		newname = ""
		for i in range(0, len(oldname)):
			int_val = ord(oldname[i])
			if (int_val >= 48 and int_val <= 57) or (int_val >= 65 and int_val <= 90):		# If numeric, add it
				newname += oldname[i]
		return newname

	accept = False		# flag to indicate end-of-loop behavior, current route through machine ends in Accept
	almostkick = False	# set to true if user is getting kicked, then clear data, then kick
	kick   = False		# if user incurred 3 strikes then after kicking (closing socket) break while loop
	reject = False		# flag to indicate end-of-loop behavior, current route through machine ends in Reject
	resync = False		# causes additional strikes to be ignored for up to 480 chars

	accepts = 0			# total # of successful accepts in buffer entry
	curr_strikes = 0	# total # of strikes in buffer entry
	
	command = ""
	
	client.buffstr += data
	
	while kick == False and client.index < len(client.buffstr):
#		print("x: " + str(client.index) + "\t\tdata[" + str(client.index) + "]:  " + client.buffstr[client.index])
		if client.buffstr[client.index] == "":			# reach end of current buffer, done reading current message
			break
			
		# If message is too long and not resyncing, set to true and issue strike
		if client.index == 480 and accept == False and resync == False:
			# set reject and resync to true, kick will be true if strikes now == 3
			curr_strikes, almostkick, reject, resync = strike(client, "(toolong)", curr_strikes)
			print("total_strikes:  " + str(client.total_strikes))
			print("kick:  " + str(kick))
#			if kick:
#				buffer = ""
#				data = ""
			client.index = 0
			reject = True
		elif client.index == 480 and accept == False and resync == True:
			print("Resync:  " + str(resync))
			curr_strikes, almostkick, reject, resync = strike(client, "(toolong)", curr_strikes)

	
		if almostkick == True:						# if user has been kicked exit loop and don't resume
			client.buffstr = ""
			data = ""
			kick = True		
		
		
		elif client.state == 0:
			if client.buffstr[client.index] == "(":				
		 		client.state = 0.5
			else: 
				if resync == False:
					# enable resync, give strike
					curr_strikes, kick, reject, resync = enableResync(client, curr_strikes)			
					if kick:
						break
					print("reject 0")
				elif resync == True:				# dont' give strike if still waiting to find valid input
					pass
					# do nothing but increment counter and keep looking
		elif client.state == 0.5:
			if client.buffstr[client.index] == "c":
				client.state = 1
				if resync == True:		# Now found some good input, set resync to false and try again
					resync = False
			else: 
				if resync == False:			
					curr_strikes, almostkick, reject, resync = strike(client, "(malformed)", curr_strikes)
					print("reject 0.5")
					curr_strikes, reject, resync = enableResync(client, curr_strikes)
				elif resync == True:
					# do nothing but increment counter and keep looking
					pass
		elif client.state == 1:					# Looking for command type
			if client.buffstr[client.index] == "c":		# begin (cchat, client.state = 19.*
				client.state = 19.1
			elif client.buffstr[client.index] == "j":		# begin (cjoin, client.state = 20.*
				client.state = 20.1					
			elif client.buffstr[client.index] == "s":		# begin (cstat), client.state = 1.*
				client.state = 1.1
			else: 
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)		# not spelling cchat, cjoin, or cstat
				
				print("reject 1")
				reject = True
		elif client.state == 1.1:				# 1.* = cstat
			if client.buffstr[client.index] == "t":
				client.state = 1.2
			else: 
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)
				print("reject 1.1")
				reject = True
		elif client.state == 1.2:
			if client.buffstr[client.index] == "a":
				client.state = 1.3
			else: 
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)
				print("reject 1.2")
				reject = True
		elif client.state == 1.3:
			if client.buffstr[client.index] == "t":
				client.state = 1.4
			else: 
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)
				print("reject 1.3")
				reject = True
		elif client.state == 1.4:
			if client.buffstr[client.index] == ")":
				command = "cstat"
				cstat(client)
				client.state = 22
				print("accept 1.4")
				accepts += 1
				accept = True			# accept (cstat)
			else: 
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)
				print("reject 1.4")
				reject = True
		elif client.state == 19.1:				# 19.* = cchat
			if client.buffstr[client.index] == "h":
				client.state = 19.2
			else: 
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)
				print("reject 19.1")
				reject = True
		elif client.state == 19.2:
			if client.buffstr[client.index] == "a":
				client.state = 19.3
			else: 
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)
				print("reject 19.2")
				reject = True
		elif client.state == 19.3:
			if client.buffstr[client.index] == "t":
				client.state = 19.4
			else: 
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)
				print("reject 19.3")
				reject = True
		elif client.state == 19.4:
			if client.buffstr[client.index] == "(":
				command = "chat"
				client.state = 20
			else: 
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)	# incorrectly placed paran
				print("reject 19.4")
				reject = True
		elif client.state == 20:
			# CCHAT: reading in list of names one char at a time until close paran
			if client.buffstr[client.index] != ")":
				client.name_bldr += client.buffstr[client.index]
				if len(client.name_bldr) == 419:
					# (30 names * 13 char name limit) + 29 commas = 419 char name_bldr limit
					curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)
					reject = True
			else:
				client.name_bldr = stripMsg(client.name_bldr)
				client.state = 30
		elif client.state == 20.1:
			# client.states 20.*: reading in CJOIN command one char at a time
			if client.buffstr[client.index] == "o":
				client.state = 20.2
			else: 
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)	# misspelled cjoin
				print("reject 20.1")
				reject = True
		elif client.state == 20.2:
			if client.buffstr[client.index] == "i":
				client.state = 20.3
			else: 
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)
				print("reject 20.2")
				reject = True
		elif client.state == 20.3:
			if client.buffstr[client.index] == "n":
				client.state = 20.4
			else: 
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)
				print("reject 20.3")
				reject = True
		elif client.state == 20.4:
			if client.buffstr[client.index] == "(":
				command = "join"
				client.state = 21
			else:
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)
				print("reject 20.4")
				reject = True
		elif client.state == 21:
			# CJOIN: reading in name one char at a time until close paran
			if client.buffstr[client.index] != ")":
				client.name_bldr += client.buffstr[client.index]
			else: 
				client.name_bldr = stripName(client.name_bldr)
				if client.name_bldr == "":
					curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)
				elif client.name_bldr.upper() == "ALL" or client.name_bldr.upper() == "ANY":
					curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)					
				client.state = 31
		elif client.state == 31:
			# CJOIN: looking for closing parans
			if client.buffstr[client.index] == ")":
				client.state = 41
				accepts += 1
				print("accept 31")
				command = "join"
				accept = True	# accept CJOIN
			else: 
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)	# misplaced paran
				print("reject 31")
				reject = True
		elif client.state == 30:
			# CCHAT: looking for a paran before beginning of message
			if client.buffstr[client.index] == "(":
				client.state = 40
			else: 
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)
				print("reject 30")
				reject = True
		elif client.state == 40:
			# CCHAT: reading in message one char at a time until 1st closing paran
			if client.buffstr[client.index] != ")":
				client.msg_bldr += client.buffstr[client.index]
				if len(client.msg_bldr) == 80:	# if msg is >80 chars then just truncate and skip to accept
					client.msg_bldr = stripMsg(client.msg_bldr)
					client.buffstr = client.buffstr[:client.index]
					accepts += 1
					print("accept 356")
					accept = True
# THIS IS WRONG!! Need to just truncate, not strike message
#					curr_strikes, kick, reject, resync = strike(client, "(toolong)")
#					reject = True
			else: 
				# Strip out any illegal chars in message before passing to next state
				client.msg_bldr = stripMsg(client.msg_bldr)
				client.state = 50
		elif client.state == 50:
			# CCHAT: looking for 2nd closing paran
			if client.buffstr[client.index] == ")":
				client.state = 60
				accepts += 1
				print("accept 50")
#				cchat(client)
				accept = True	# accept CCHAT
			else: 
				print("rejected on char:  " + str(client.index) + ":  " + client.buffstr[client.index])
				print("length so far:  " + str(client.index))
				curr_strikes, kick, reject, resync = strike(client, "(malformed)", curr_strikes)
				print("reject 50")
				reject = True
		elif client.state == 999:
				print("should have broken already")
		else:
				print("state:  " + str(client.state) + "   something broke")

		if reject:
			print("Invalid command\t\t" + client.buffstr[:client.index+1] + "\n\n")
#			print("resyncing to eliminate bad input")
			client.buffstr = client.buffstr[client.index+1:]		# resync, cut out bad input
			print("new buffer:  " + client.buffstr)
			reject = False
			client.index = 0
			client.state = 0
		if accept:
#			print("Valid command:\t\t" + client.buffstr[:client.index+1])
			client.buffstr = client.buffstr[client.index+1:]		# resync, accept 
			accept = False
			client.index = 0
			client.state = 0
			if command == "chat":
				cchat(client)
			elif command == "join":
				cjoin(client)
			elif command == "stat":
				cstat(client)
			command = ""
			
		client.index += 1
		
			
#		return True		# if reach either end client.state then return that you're done				
	
	print("data:\t\t\t\t" + data + "\n")
	print("buffer:\t\t\t" + client.buffstr)
	print("strikes for this entry:\t\t" + str(curr_strikes))
	print("accepts:\t\t\t" + str(accepts))
	print("resync:\t\t\t\t" + str(resync))
#	print("data length:\t\t" + str(len(data))) 
#	print("buffer length:\t\t" + str(len(client.buffstr))) 

				
#	print("Final client.state:\t" + str(client.state))
	
	
		
os.system('cls' if os.name == 'nt' else 'clear')	# clear terminal	
#data = "(cstat)"
#fsm(data)
#data = "(cchat(SCOTTY)(buttholes))"
#fsm(data)
#data = "(cjoin(allthesex))"
#fsm(data)
#data= "(cchat(\nany)(fadsafa))"

client = Client()
clients = {}
clients[client] = "there's a guy here"


#sys.stdout.write("% ")
#data = sys.stdin.readline().strip()

#while data.strip() != "":
#	fsm(client, data)
#	sys.stdout.write("%  ")
#	data = sys.stdin.readline().strip()
#	print("Total number of client strikes after typing in toolong message:  " + str(client.total_strikes))




test = "(cchat(scotty)(hello))"

#print("testing fsm with hardcoded string:  " + test)

#print("test:  " + test)
#test = stripMsg(test)
#print("test:  " + test)


fsm(client, test)






