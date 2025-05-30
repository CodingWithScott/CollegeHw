for them in clients:
	if clients[them].my_fullname == ally:
		# Point my socket to them, and their socket to me
		clients[me].ally_socket = them
		clients[them].ally_socket = me



		""" READ THIS SHIT RIGHT HERE IT IS EXTREMELY IMPORTANT!!!!!!! """



		print("My name is " + clients[me].my_fullname)
		print("My ally's name is " + clients[clients[me].ally_socket].my_fullname)
		print("My ally's name is " + clients[them].my_fullname)
		print(" and I'm sending her the word 'dickbutts' right now...")
		clients[me].ally_socket.send("Dickbutts here, line 370\n")
		them.send("more dickbutts now, line 371\n")

		print("Now I'll have " + clients[them].my_fullname + " send me 'poopballs'")


		# This should send message to SCOTT's termianl, getting nothing
		me.send(clients[me].my_fullname + " this is " + clients[them].my_fullname + " poopballs line377\n")
		clients[them].ally_socket.send(clients[me].my_fullname + " this is " + clients[them].my_fullname + " poopballs line378\n")
		
		them.send(clients[me].my_fullname + " this is " + clients[them].my_fullname + "line380\n")



		print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")

		print("ally by socket:\t" + clients[clients[me].ally_socket].my_fullname + "\n")
		print("victim:\t" + clients[me].offer_victim + "\n")