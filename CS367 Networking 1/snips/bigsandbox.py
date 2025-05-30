""" 
This strips leading and trailing whitespace, spaces are still intact
instide the username. If this isn't acceptable (i don't think it is)
it can be stripped out later with a regex or soemthing like that.
"""

"""
test = "This, is, uhhhhh, a     string  with,   uh   , some  spaces."
splitted = test.split(",")
stripped = map(str.strip, splitted)
"""

"""
print ("test:  " + test + "\n")
print ("splitted:  ") 
print(splitted)
print ("stripped:  ")
print (stripped)
"""

# Find first occurrence of right paran, this indicates index of ending 
# point of user names.
"""
test = "(cchat(MOE,LARRY,CURLY)(hahaha dickbutts))"
r_paran_loc = test.find(")")
print (test + "\n")
print ("Found right paran at:  " + str(r_paran_loc) + "\n")
print (test[r_paran_loc])
print (test[:r_paran_loc])
"""

import sys

# line = "(cchat(MOE,LARRY,CURLY)(hahaha dick)butts))"
#line = "(cchat(MOE,LARRY,CURLY)(hahaha dickbutts hahaha dickbutts hahaha dickbutts hahaha dickbutts hahaha dickbutts hahaha dickbutts hahaha dickbutts ))"

def findnth(haystack, needle, n):
    parts= haystack.split(needle, n+1)
    if len(parts)<=n+1:
        return -1		#returns -1 by default, I'm going to change to 79
#		return 79
    return len(haystack)-len(parts[-1])-len(needle)

# check for a few violations of username validity rules, most will be
# done server-side though    
def validate(username, valid):
	print("Unfiltered username:  " + username)
	# strip last 2 trailing parans, if necessary

	username = username[:len(username)-1]
	if username[len(username)-1] == ")":
		username = username[:len(username)-1]
		if username[len(username)-1] == ")":
			username = username[:len(username)-1]	

	# check for >2 parans or incorrectly placed paran
	if ")" in username:
		validated = False
		print("You've got a paran which doesn't belong in there")
	
	# check for illegal chars
	elif ("\"" in username or	"*" in username or "+" in username or
		"," in username or "/" in username or ":" in username or
		";" in username or "<" in username or "=" in username or
		">" in username or "?" in username or "\\" in username or
		"[" in username or "]" in username or "|" in username):
		validated = False
	
	# check for reserved words			
	elif (username == "all" or username == "any"):
		validated = False
	else:
		validated = True
	
	return(username, validated)

""" ### begin main program ### """
sys.stdout.write('%')
line = sys.stdin.readline()
line = line[:79]
loc_of_sec_right_paran = findnth(line, ")", 1) # used for validation

# Going to do a shitload of error checking before sending any data
# Check if user is trying to exit
if line == '\n':
    print("Exiting program")
elif line[:2] != "(c":
	print "Invalid input: must start with '(c'"
	
# user is now joining chat session
elif line[:6] == "(cjoin":
	end_name_loc = line.find(")")	
	username = line[7:]
	
	# Send username and a bool flag, return filtered username
	# and whether or not valid
	valid = False
	username, valid = validate(username, valid)

	if valid:
		print("Filtered username:  " + username)
		print("That's a good name!")
	else:
		print("Invalid username:  " + username)
	
# user is sending a chat message, check who recipient(s) is/are
elif line[:6] == "(cchat":
	end_name_loc = line.find(")")
	usernames = line[7:end_name_loc]
	usernames = usernames.split(",")
	print("You're sending a chat message to users: ")
	print(usernames)
	
	# read in message contents
	msg_begin_loc = end_name_loc + 2
	
	# truncate trailing parans from message	
	message = line[msg_begin_loc : loc_of_sec_right_paran]
	print("Your message is:  " + message)
	
	# 1st ) occurs at end of section indicating users, now check for 
	# 2nd ). If any ) occur after beginning of message, it should be 
	# last 1-2 chars, indicating message ending. However truncation may 
	# result in last 2 chars being something other than ), which is 
	# fine, just need to be sure nothing occurring after any ).
	print("the location of the 2nd right paran is:  " + str(loc_of_sec_right_paran))
	if (loc_of_sec_right_paran < len(line)-3) and (loc_of_sec_right_paran != -1):
		print("Chat fucked up, you can't put a right paran there")


	
else:
	print(line + "\n")
	print("...I seriously don't even know what you're trying to do")

