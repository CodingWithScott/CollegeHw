def cjoin(s):
	# If socket is requested a username and they already have one, then strike	
	if clients[s].my_fullname != "":
		strike(s, "(malformed)")
		console_output  = "Issuing strike to " + clients[s].my_fullname 
		console_output += " for requesting a second CJOIN"
		print(console_output)
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