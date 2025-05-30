## TODO: figure out a way to represent a client in the server's dictionary of all clients
## Need to keep track of socket, DOSname, and num_strikes

dos_names = {}	# hash table w/ socket = key, and name = value
strikes = {}	# hash table w/ socket = key, and num of strikes = value


dos_names["socket1"] = "SCOTT~1"
dos_names["socket2"] = "BUTTLICK"
dos_names["socket3"] = "KATSAJRK"

print("number of entries in dos_name:  " + str(len(dos_names)))



# return list of all players in format: USER~1,USER~2,BLAH~1,POOPBUTT
def get_all_players():
	all_names = ""
	for name in dos_names.values():
		print("all_names:  " + all_names)
		print("name:  " + name)
		if all_names == "":
			all_names = name
		elif all_names != "":
			all_names = all_names + "," + name
			
	return all_names
	
all_names = "" 
all_names = get_all_players()
	
print("dos_names:  " + all_names)


## TO DO: 	Figure out why name conversion is truncating unnecessarily sometimes


data1 = "(cjoin(ScottyMcTits)!!!)"
data2 = "(cjoin(ScottyMcTits))"
data2 = "(cjoin(ScottButt))"
data3 = "(cjoin(ScottButt))"
data6 = "(cjoin(ButtLicker))"
data7 = "(cjoin(Sex))"
data8 = "(cjoin(Dog))"
data4 = "(cjoin(ScottButt))"
data5 = "(cjoin(ScottButt))"
data6 = "(cjoin(ScottButt))"
data7 = "(cjoin(ScottButt))"
data8 = "(cjoin(ScottButt))"
data9 = "(cjoin(ScottButt))"
data10 = "(cjoin(ScottButt))"
data11 = "(cjoin(ScottButt))"
data12 = "(cjoin(ScottButt))"
data13 = "(cjoin(ScottButt))"
data14 = "(cjoin(ScottButt))"
data15 = "(cjoin(ScottButt))"

clients = {}

def givestrike(s):
	strikes[s] = strikes[s] + 1


data = [data1, data2, data3, data4, data5, data6, data7, data8, data9, 
		data10, data11, data12, data13, data14, data15]


	
print("\n\n")
print(clients)



