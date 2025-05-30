def cjoin(data):

	

	give_strike = False
	r_paran_loc = data.find(")")
	
	# truncate trailing 2 parans
	username = data[7: len(data)-2]
	
	# check for ) contained in message					 
	if (data[r_paran_loc + 1] != ")"):
		give_strike = True
		print("You've got a paran in there which doesn't belong")
	elif (username == "all" or username == "any"):
		give_strike = True
		print("Can't use reserved word as a name")
	
	if not give_strike:
		print("Attempting to add:  " + username) 
		try_add(username)
	else:
		print("Invalid username:  " + username)
		
		
		

