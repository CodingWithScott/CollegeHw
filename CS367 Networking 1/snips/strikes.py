clients = {}

class Client:
	"""A Client class"""
	"""A Client class"""
	buffstr 		= ""		# buffer being read in by TCP stream prior to processing
	index 			= 0		
	msg_bldr 		= ""		# part of buffer containing cchat message as it's read in



	
	# intermediate steps
	my_name_bldr 	= ""		# part of buffer containing cjoin name as it's read in
	filename		= ""		# first part of filename, before .
	ext		 		= ""		# file extension, after .
	
	# final product of name (and optional extension)
	my_fullname 	= ""		# filename + "." + ext
	their_name 		= ""		# part of buffer continaing cchat names to send to 
	state 			= "start"	# current FSM state
	total_strikes = 0


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
	
	
testdude = Client()

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) = socket.socket(


for count in range(1,5):
	clients[s] = testdude()



