def incr_name(s):
	newfilename = ""
	old = clients[s].filename	

	# name = "SCOTTY" --> "SCOTTY~1"	
	if not (clients[s].filename[len(clients[s].filename)-1].isdigit()) and not (clients[s].filename[len(clients[s].filename)-2] == "~"):
		newfilename = clients[s].filename[:len(clients[s].filename)-2] + "~1"
	# name = "SCOTT~1" --> "SCOTT~9"
	elif (clients[s].filename[len(clients[s].filename)-1].isdigit()) and (clients[s].filename[len(clients[s].filename)-2] == '~'):
		if int(clients[s].filename[len(clients[s].filename)-1]) < 9:
			newfilename  = clients[s].filename[:len(clients[s].filename)-1] 
			newfilename += str(int(clients[s].filename[len(clients[s].filename)-1])+1)
		elif int(clients[s].filename[len(clients[s].filename)-1]) == 9:
			newfilename  = clients[s].filename[:len(clients[s].filename)-2]+'~' 
			newfilename += str(int(clients[s].filename[len(clients[s].filename)-1]) + 1)
	# name = "SCOT~10" --> "SCOT~99"
	elif (clients[s].filename[len(clients[s].filename)-1].isdigit()) and (clients[s].filename[len(clients[s].filename)-2].isdigit()) and (clients[s].filename[len(clients[s].filename)-3] == '~'):
		if int(clients[s].filename[len(clients[s].filename)-2:]) < 99:
			newfilename  = clients[s].filename[:len(clients[s].filename)-2] 
			newfilename += str(int(clients[s].filename[len(clients[s].filename)-2:]) + 1)
		elif int(clients[s].filename[len(clients[s].filename)-2:]) == 99:
			newfilename  = clients[s].filename[:len(clients[s].filename)-4] 
			newfilename += '~' + str(int(clients[s].filename[len(clients[s].filename)-2:]) + 1)
	# name = "SCO~100" --> "SCO~999"
	elif (clients[s].filename[len(clients[s].filename)-1].isdigit()) and (clients[s].filename[len(clients[s].filename)-2].isdigit()) and (clients[s].filename[len(clients[s].filename)-3].isdigit()) and (clients[s].filename[len(clients[s].filename)-4] == '~'):
		if int(clients[s].filename[len(clients[s].filename)-3:]) < 999:
			newfilename =  clients[s].filename[:len(clients[s].filename)-3] 
			newfilename += str(int(clients[s].filename[len(clients[s].filename)-3:]   ) + 1)
		elif int(clients[s].filename[len(clients[s].filename)-3:]) == 999:
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