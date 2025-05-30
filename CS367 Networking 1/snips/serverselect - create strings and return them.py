#!/usr/bin/env python

"""
An echo server that uses select to handle multiple clients at a time.
Entering any line of input at the terminal will exit the server.
"""

"""		TO DO:

	High priority
Kick a person when they get 3 strikes	
Send a chat message to users

	Low priority
Automatic chat mode
Implement DOS file extension naming mechanism (low priority)










Finish join:

"""



import argparse
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
print("lobbytime:      " + str(lobbytime))
print("minplayers:     " + str(min_players))
print("timeout:        " + str(timeout))

host = ''
port = 36735
backlog = 5
size = 1024
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server.bind((host,port))
server.listen(backlog)
input = [server,sys.stdin]
running = 1

names = {}			# hash table w/ socket = key, and DOSname = value
strikes = {}		# hash table w/ socket = key, and num of strikes = value
all_sockets = {}	# hash table w/ socket = key, and True as value
					# to keep track of all sockets connected at any time



""" ######## HELPER FUCKTION ######## """

"""			 DOS NAME RULES:
1.  Strip any whitespace and non-legal chars:
		" * + , / : ; < = > ? \ [ ] | .
2.  Truncate string before 8 char mark to 6 chars and append ~1.
3.  Convert to all uppercase.
4.  If a user with that name already exists, increment num being 
	appened to ~2, etc. If a user with ~9 already exists, truncate 
	string to 5 chars and append ~10, etc. Continue to ~999. Beyond 999,
	may God have mercy on your soul.
"""

	## TODO: use Telnet to send commands to server instead of client,
	# eliminates possibility of client problems when troubleshooting 
	# server

print("---CRANK DAT SERVER~!---")




########################################################################
# Most important function: giving strikes to kick users
def givestrike(s, reason):
	if strikes[s] == 2:
		server_response = kick_user(s, reason)
	else:		
		strikes[s] = strikes[s] + 1
		server_response = "(strike(" + str(strikes[s]) + ")" + reason + "))"
	return server_response
########################################################################


########################################################################	
# Also most important function: disconnecting user with too many strikes
def kick_user(s, reason):
	strikes.pop(s, None)
	names.pop(s, None)
	s.send("You are being kicked because " + reason)
	s.close()
	input.remove(s)
########################################################################	

########################################################################
# Method and sub-methods for a client joining chat session
# Accepts the input message from client, and socket they're connected on
def cjoin(s, data):
	# Check if this socket has already connected
	if (s in names):
		server_response = givestrike(s, "You already joined!")
		return server_response
		
	# Take a DOSname and increment to next appropriate name, if DOSname
	# is already taken.
	def incr_name(name):
		newname = ""
	
		# name = "SCOTT~1" --> "SCOTT~9"
		if (name[len(name)-1].isdigit()) and (name[len(name)-2] == '~'):
			if int(name[len(name)-1]) < 9:
				newname = name[:len(name)-1] + str(int(name[len(name)-1])+1)
			elif int(name[len(name)-1]) == 9:
				newname = name[:len(name)-2] + '~' + str(int(name[len(name)-1]) + 1)
		# name = "SCOT~10" --> "SCOT~99"
		elif (name[len(name)-1].isdigit()) and (name[len(name)-2].isdigit()) and (name[len(name)-3] == '~'):
			if int(name[len(name)-2:]) < 99:
				newname = name[:len(name)-2] + str(int(name[len(name)-2:]) + 1)
			elif int(name[len(name)-2:]) == 99:
				newname = name[:len(name)-4] + '~' + str(int(name[len(name)-2:]) + 1)
		# name = "SCO~100" --> "SCO~999"
		elif (name[len(name)-1].isdigit()) and (name[len(name)-2].isdigit()) and (name[len(name)-3].isdigit()) and (name[len(name)-4] == '~'):
			if int(name[len(name)-3:]) < 999:
				newname = name[:len(name)-3] + str(int(name[len(name)-3:]   ) + 1)
			elif int(name[len(name)-3:]) == 999:
				print("You can't have 1000 of same user, sorry")
		else:
			print("Something fucked up, you should never see this")
		
		return newname

	# Add a DOSname to table or use recursion to increment name counter
	# until can add successfully.
	def try_add(input_name):
		# Step 1: strip illegal chars and control chars
		DOSname = input_name.replace(" ", "")
		DOSname = DOSname.replace(".", "")
		DOSname = DOSname.replace("*", "")
		DOSname = DOSname.replace("+", "")
		DOSname = DOSname.replace(",", "")
		DOSname = DOSname.replace("/", "")
		DOSname = DOSname.replace(":", "")
		DOSname = DOSname.replace(";", "")
		DOSname = DOSname.replace("<", "")
		DOSname = DOSname.replace("=", "")
		DOSname = DOSname.replace(">", "")
		DOSname = DOSname.replace("?", "")
		DOSname = DOSname.replace("[", "")
		DOSname = DOSname.replace("]", "")
		DOSname = DOSname.replace("|", "")
		DOSname = DOSname.replace("\"", "")
		DOSname = DOSname.replace("\\", "")
		DOSname = filter(string.printable.__contains__, DOSname)
	
		# Step 2: Capitalize
		DOSname = DOSname.upper()
		# Step 3: Truncate, if necessary
		if len(DOSname) > 8:
			DOSname = (DOSname[:6] + "~1")
	
		# base case: DOSname is not in the table of users, add them
		if DOSname not in names:
			# tie socket to username in the names table, set 0 strikes
			names[s] = DOSname
			strikes[s] = 0
			return DOSname
		# recurse case: DOSname is currently in table of users, increment
		# and try the new name.
		else:
			DOSname = incr_name(DOSname)
			try_add(DOSname)

	r_paran_loc = data.find(")")
	
	# truncate trailing 2 parans
	username = data[7: len(data)-3]
	
	# check for ) contained in message					 
	if (data[r_paran_loc + 1] != ")"):
		reason = "You've got a paran in there which doesn't belong"
		server_response = givestrike(s, reason)
	elif (username == "all" or username == "any"):
		reason = "Can't use reserved word as a name"
		server_response = givestrike(s, reason)
	else:
		print("Attempting to add:  " + username) 
		DOSname = try_add(username)
		
		num_players = len(names)
		
		print(names)
		print(strikes)

		# Idk if this is ever actually going to be an issue but I put 
		# this in just for funsies. 
		# ACTUALLY: there can be sockets gathering strikes that haven't 
		# gotten a name yet, so this is fine.
		if len(names) != len(strikes):
			print("There's not the same number of usernames as strike entries, an unnamed connection is fucking up")
		
		
		server_response = "(sjoin(" + DOSname + ")(" + str(num_players) + "," + str(min_players) + "," + str(timeout) + "))"
		print("line 170")
		print(server_response)

	return server_response
########################################################################

########################################################################	
def cstat(s, data):
	# make a string listing all players in format: USER~1,USER~2,BLAH~1,POOPBUTT
	# should it be its own function?
	def get_all_players():
		all_names = ""
		for name in names.values():
			print("all_names:  " + all_names)
			print("name:  " + name)
			if all_names == "":
				all_names = name
			elif all_names != "":
				all_names = all_names + "," + name
			
		return all_names
		
	all_names = get_all_players()

	server_response = "(sstat(" + all_names + "))"
	return server_response

while running:
	inputready,outputready,exceptready = select.select(input,[],[])
	
	print(strikes)

	for s in inputready:

		if s == server:
			# handle the server socket
			client, address = server.accept()
			input.append(client)
#			strikes[s] = 0	# create new entry in strikes for this 
							# socket, set to 0 strikes
			print "Connection established"
			all
			
			
		elif s == sys.stdin:
			# handle standard input
			junk = sys.stdin.readline()
			print("---TURN DAT SHIT OFF!!---")
			running = 0 
		else:
			# handle all other sockets
			# print whatever text user sends
			data = s.recv(size)
			
			if data:
				print("data:  ") 
				print data
				
				if len(data) < 7:
					givestrike(s, "Invalid input:  " + data)

				# user is now joining chat session
				elif data[:7] == "(cjoin(":
					server_response = cjoin(s, data)
					s.send(server_response)
					
					
					
					
					
					
					# Switch all the sending to being done in teh procedures, so I don't
					# end up closing a socket due to strikes and then tring to send a message to 
					# a 
					
					
					
					
					
					
				# user is sending a chat message
				elif data[:7] == "(cchat(":
					cchat(s, data)
					
				# user is requesting server stats
				elif data[:7] == "(cstat)":
					server_response = cstat(s, data)
					s.send(server_response)
					
				# user sent some other bullshit
				else:
					givestrike(s, ("Invalid input:  " + data))

			# If user disconnects hits this block. Blank input does 
			# NOT reach this block.
			else:
				s.close()
				input.remove(s)
				
print("This line never happens")
server.close()
