import re

########################################################################
# CLIENT: Holds raw buffer, index, message/name strings, FSM 		   #
# 		  state and number of strikes.								   #
########################################################################
class Client:
	# intermediate steps
	filename		= ""		# first part of filename, before .
	ext		 		= ""		# file extension, after .
	
	# final product of name (and optional extension)
	my_fullname 	= ""		# filename + "." + ext
########################################################################

clients = {}
s = "pretend socket"
clients[s] = Client()
clients[s] = clients[s]

########################################################################
# Helper for cjoin: Take a DOSname and increment to next appropriate 
# name, if DOSname is already taken.
def incr_name():
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
	
	
#	print("line 54")
#	print(clients[s].filename)
########################################################################


clients[s].my_fullname = "SCOTTY.TXT"
print("clients[s].my_fullname:\t" + clients[s].my_fullname)
clients[s].my_fullname = clients[s].my_fullname.strip(',.-')


name_chunks = re.split('[.]', clients[s].my_fullname)
clients[s].filename = name_chunks[0]
clients[s].ext = name_chunks[1]


## E

print("num of name chunks: " + str(len(name_chunks)))


print("name_chunks[0]:\t" + name_chunks[0])

if len(name_chunks) == 2:
	print("name_chunks[1]:\t" + name_chunks[1])
	if len(name_chunks[1]) > 3:
		print("file extension too long")

if len(name_chunks[0]) > 8:
	name_chunks[0] = (name_chunks[0][:6] + "~1")






for count in range (1, 15):
	if len(name_chunks) == 1:
		clients[s].my_fullname = clients[s].filename	 
	elif len(name_chunks) == 2:
		clients[s].my_fullname = clients[s].filename + "." + clients[s].ext

	print(clients[s].my_fullname)
	incr_name()
#	if len(name_chunks) == 1:
#		clients[s].my_fullname = clients[s].filename
#	elif len(name_chunks) == 2:
#		clients[s].my_fullname = clients[s].filename + "." + clients[s].ext
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
