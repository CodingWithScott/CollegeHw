"""
RULES:
1. 	Strip any whitespace and non-legal chars:
		" * + , / : ; < = > ? \ [ ] | .
2.	Truncate string before 8 char mark to 6 chars and append ~1.
3.	Convert to all uppercase.
4.	If a user with that name already exists, increment num being 
	appened to ~2, etc.	If a user with ~9 already exists, truncate 
	string to 5 chars and append ~10, etc. Continue to ~999. Beyond 999,
	may God have mercy on your soul.
"""


# TODO: Make the entire thing work
# TODO: Clean it up and compartmentalize definitions to make for easier
#		code reuse.

all_users = dict()	# global hash table for all users

""" #### HELPER FUCKTION #### """
# Take a DOSname and increment to next appropriate name, if DOSname
# is already taken.
def incr_name(oldname):
	if (oldname[7].isdigit()) and not (oldname[6].isdigit()):
		if oldname[7] == "9":
			newname = oldname[:5] + "~" + str(int(oldname[7])+1)
		elif oldname[7] != "9":
			newname = oldname[:6] + "~" + str(int(oldname[7])+1)
	elif (oldname[7].isdigit()) and (oldname[6].isdigit()) and not (oldname[5].isdigit()):
		if oldname[6:7] == "99":
			newname = oldname[:3] + "~" + str(int(oldname[6:7])+1)
		elif oldname[6:7] != "99":
			newname = oldname[:4] + "~" + str(int(oldname[6:7])+1)
	elif (oldname[7].isdigit()) and (oldname[6].isdigit()) and (oldname[5].isdigit()):
		newname = oldname[:3] + "~" + str(int(name[5:7])+1)
	else:
		newname = ("You had >999 users with the same name, or " + 
		"something else is fucked up. Sorry man")
		
	return newname
		
# Add a DOSname to table or use recursion to increment name counter
# until can add successfully.
def try_add(input_name):
	DOSname = namefilter(input_name)

	# base case: DOSname is not in the table of users, add them
	if DOSname not in all_users:
		all_users[DOSname] = 1
		print("DOSname:  " + DOSname)
	# recurse case: DOSname is currently in table of users, increment
	# and try the new name.
	else:
		DOSname = incr_name(DOSname)
		try_add(DOSname)

	
# Perform filtering steps 1-3
def namefilter(input_name):
	# Step 1: strip illegal chars	
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
	
	# Step 2: Capitalize
	DOSname = DOSname.upper()
	# Step 3: Truncate, if necessary
	if len(DOSname) > 8:
		DOSname = (DOSname[:6] + "~1")

	return DOSname

	
""" #### MAIN PROGRAM #### """

name = "ScottyPoopsALot/:;<=>?\[]|  "
name2 = "  ScottyPoopsALot/:;<=>?\[]|  "
name3 = "  ScottyPoopsALot/:;<=>?\[]|  "
name4 = "  ScottyPoopsALot/:;<=>?\[]|  "
name5 = "  ScottyPoopsALot/:;<=>?\[]|  "
name6 = "  ScottyPoopsALot/:;<=>?\[]|  "
name7 = "  ScottyPoopsALot/:;<=>?\[]|  "
name8 = "  ScottyPoopsALot/:;<=>?\[]|  "
name9 = "  ScottyPoopsALot/:;<=>?\[]|  "
name10 = "  ScottyPoopsALot/:;<=>?\[]|  "
#name = "Scotty Anthony Felch"
# refresher on tables:  http://tinyurl.com/n6ksqqb
				
print("name:   " + name)
print("name2:  " + name2)
print("name3:  " + name3)
print("name4:  " + name4)
print("name5:  " + name5)
print("name6:  " + name6)
print("name7:  " + name7)
print("name8:  " + name8)
print("name9:  " + name9)
print("name10:  " + name10)

# Perform conversion
#DOSname = namefilter(name)	
#DOSname2 = namefilter(name2)
#DOSname3 = namefilter(name3)
#DOSname4 = namefilter(name4)

#namefilter(DOSname)

#print("DOSname:   " + DOSname)
#print("DOSname2:   " + DOSname2)
#print("DOSname3:   " + DOSname3)
#print("DOSname4:   " + DOSname4)
	
# Step 4: (increment if necessary) then DOSname to all_uers
#try_add(DOSname)
try_add(name)
try_add(name2)
try_add(name3)
try_add(name4)
try_add(name5)
try_add(name6)
try_add(name7)
try_add(name8)
try_add(name9)
try_add(name10)





