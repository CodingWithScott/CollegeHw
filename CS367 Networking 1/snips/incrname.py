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



########################################################################
# Helper for cjoin: Take a DOSname and increment to next appropriate 
# name, if DOSname is already taken.
def incr_name():
	newfilename = ""

	# name = "SCOTTY" --> "SCOTTY~1"	
#	if not (user.filename[len(user.filename)-1].isdigit()) and (user.filename[len(user.filename)-2] == "~"):
#	if not (user.filename[len(user.filename)-1].isdigit()):
	if not (user.filename[len(user.filename)-1].isdigit()) and not (user.filename[len(user.filename)-2] == "~"):
		newfilename = user.filename[:len(user.filename)-2] + "~1"
	# name = "SCOTT~1" --> "SCOTT~9"
	elif (user.filename[len(user.filename)-1].isdigit()) and (user.filename[len(user.filename)-2] == '~'):
		if int(user.filename[len(user.filename)-1]) < 9:
			newfilename = user.filename[:len(user.filename)-1] + str(int(user.filename[len(user.filename)-1])+1)
		elif int(user.filename[len(user.filename)-1]) == 9:
			newfilename = user.filename[:len(user.filename)-2] + '~' + str(int(user.filename[len(user.filename)-1]) + 1)
	# name = "SCOT~10" --> "SCOT~99"
	elif (user.filename[len(user.filename)-1].isdigit()) and (user.filename[len(user.filename)-2].isdigit()) and (user.filename[len(user.filename)-3] == '~'):
		if int(user.filename[len(user.filename)-2:]) < 99:
			newfilename = user.filename[:len(user.filename)-2] + str(int(user.filename[len(user.filename)-2:]) + 1)
		elif int(user.filename[len(user.filename)-2:]) == 99:
			newfilename = user.filename[:len(user.filename)-4] + '~' + str(int(user.filename[len(user.filename)-2:]) + 1)
	# name = "SCO~100" --> "SCO~999"
	elif (user.filename[len(user.filename)-1].isdigit()) and (user.filename[len(user.filename)-2].isdigit()) and (user.filename[len(user.filename)-3].isdigit()) and (user.filename[len(user.filename)-4] == '~'):
		if int(user.filename[len(user.filename)-3:]) < 999:
			newfilename = user.filename[:len(user.filename)-3] + str(int(user.filename[len(user.filename)-3:]   ) + 1)
		elif int(user.filename[len(user.filename)-3:]) == 999:
			print("You can't have 1000 of same user, sorry")
	else:
		print("Something fucked up, you should never see this")
	
#	return newfilename
	user.filename = newfilename
########################################################################

user = Client()
user.my_fullname = "SCOTTY.TXT"
print("user.my_fullname:\t" + user.my_fullname)
user.my_fullname = user.my_fullname.strip(',.-')


name_chunks = re.split('[.]', user.my_fullname)
user.filename = name_chunks[0]
user.ext = name_chunks[1]


## E

print("num of name chunks: " + str(len(name_chunks)))


print("name_chunks[0]:\t" + name_chunks[0])

if len(name_chunks) == 2:
	print("name_chunks[1]:\t" + name_chunks[1])
	if len(name_chunks[1]) > 3:
		print("file extension too long")

if len(name_chunks[0]) > 8:
	name_chunks[0] = (name_chunks[0][:6] + "~1")


if len(name_chunks) == 1:
	user.my_fullname = name_chunks[0]	 
elif len(name_chunks) == 2:
	user.my_fullname = name_chunks[0] + "." + name_chunks[1]



for count in range (1, 15):
	print(user.my_fullname)
	incr_name()
	if len(name_chunks) == 1:
		user.my_fullname = user.filename
	elif len(name_chunks) == 2:
		user.my_fullname = user.filename + "." + user.ext
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
