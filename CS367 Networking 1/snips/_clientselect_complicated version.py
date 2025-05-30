#!/usr/bin/env python

"""
An echo client that allows the user to send multiple lines to the 
server. Entering a blank line will exit the client.
"""

import socket
import sys

# Chat-join filtering appears to be competely done afaik, woohoo!!
# TO-DO: Clean up message-send filtering using logic from chat filter

# TO-DO: Everything network related

users = []
running = 1

""" #### HELPER FUCKTIONS #### """
# This helper function will find occurrences of right parans
# stole it from Stack Overflow: http://tinyurl.com/ldbgwfw
def findnth(haystack, needle, n):
	parts= haystack.split(needle, n+1)
	if len(parts)<=n+1:
		return -1
	return len(haystack)-len(parts[-1])-len(needle)
	
# check for a few violations of username validity rules, most will be
# done server-side though
def validate_name(input_name, valid):
	print("Unfiltered username:  " + username)
	# strip last 2 trailing parans, if necessary
	username = input_name[:len(input_name)-1]

	if username[len(username)-1] == ")":
		username = username[:len(username)-1]
		if username[len(username)-1] == ")":
			username = username[:len(username)-1]

	# check for >2 parans or incorrectly placed paran
	if ")" in username:
		validated = False
		print("You've got a paran in there which doesn't belong")
	
	# check for illegal chars
	elif ("\"" in username or "*" in username or "+" in username or
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


""" #### MAIN PROGRAM #### """
while running:
	line = sys.stdin.readline()
	# Going to do a shitload of error checking before sending any data
	
	print("line[:5] = " + line[:5])

	# Check if user is trying to exit
	if line == '\n':
		break
	elif line[:2] != "(c":
		print ("Invalid input: must start with '(c'")
		
	# user is now joining chat session
	elif line[:5] == "(cjoin":
		end_name_loc = line.find(")")
		username = line[7:]
	
		# Send username and a bool flag, return filtered username
		# and whether or not valid
		valid = False
		username, valid = validate_name(username, valid)

		if valid:
			print("Filtered username:  " + username)
			print("That's a good name!")
		else:
			print("Invalid username:  " + username)
		
	# user is sending a chat message, check who recipient(s) is/are
	elif line [:7] == "(cchat":
		line = line[:79] # Truncate to 80 chars
		send_data = "((chat"


		end_name_loc = line.find(")")
		usernames = line[7:end_name_loc]
		usernames = usernames.split(",")

		# print input before and after truncation
		print("line:  " + line)
		# delete trailing parans, if necessary (won't happen if truncated)
		if line[len(line)-1] == ")":
			line = line[:len(line)-1]
			if line[len(line)-1] == ")":
				line = line[:len(line)-1]
		print("line:  " + line)

		print("You're sending a chat message to users: ")
		print(usernames)
		
		# read in message contents
		msg_begin_loc = end_name_loc + 2
		#message = line[msg_begin_loc : len(line) - 2]
		message = line[msg_begin_loc:]

		print("Your message is:  " + message)
		
		# 1st ) occurs at end of section indicating users, now check for 
		# 2nd ). If any ) occur after beginning of message, it should be 
		# last 1-2 chars, indicating message ending. However truncation may 
		# result in last 2 chars being something other than ), which is 
		# fine, just need to be sure nothing occurring after any ).

		loc_of_sec_right_paran = findnth(line, ")", 1)
		if (loc_of_sec_right_paran < len(line)-3):
			print("You done fucked up, you can't put a right paran there")


	else:
		print(line + "	 don't work \nYour shit is broke, son")

	s.send(line)
	data = s.recv(size)
	sys.stdout.write(data)
	sys.stdout.write('%')

s.send("Connection terminated")
s.close()
