#!/usr/bin/env python

"""
An echo client that allows the user to send multiple lines to the 
server. Entering a blank line will exit the client.
"""
import argparse
import os
import select
import socket
import sys


""" 	TO DO:  
	High priority:


	Low priority:
 Keep track of own name
 Keep track of own strikes
"""

# Create a hash table named "args" which contains arguments
# if args['foo'] == 'Hello':
    # code here
parser = argparse.ArgumentParser(description='Basic chat client')

parser.add_argument('-d','--debug', help='Enter a debug code', default=0, required=False)
parser.add_argument('-m','--manual', help='Select manual mode', default=True, required=False)
parser.add_argument('-n','--name', help='Select your username', default="Defaultname", required=True)
parser.add_argument('-p','--port', help='Select port #', default=36735, required=False)
parser.add_argument('-s','--server', help='Select server address', default="localhost", required=False)

args = parser.parse_args()

host = args.server
port = args.port
size = 1024
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#input = [s,sys.stdin]
s.connect((host,port))

os.system('cls' if os.name == 'nt' else 'clear')	# clear terminal
print("Name:\t" + args.name)
print("Server:\t" + args.server)
print("Port:\t" + str(args.port))
print("Manual:\t" + str(args.manual))
print("Debug:\t" + str(args.debug))

cjoin = "(cjoin(" + args.name + "))"
s.send(cjoin)
running = 1

def prompt():
	sys.stdout.write("% ")
	sys.stdout.flush()


""" #### MAIN PROGRAM #### """
while running:

	try:
		prompt()
		
#		socketlist = [s, sys.stdin]
#		inputready,outputready,exceptready = select.select(socketlist,[],[])
		inputready, outputready,exceptrdy = select.select([0, s], [],[])

		# took format for client-select logic from http://tinyurl.com/6jnpzqj
		for i in inputready:
			# if user is typing into keyboard then read it
			if i == 0:
				#self.sock = s
				data = sys.stdin.readline().strip()
				if data: s.send(data)
			# if receiving data from server then print it
			elif i == s:
				data = s.recv(size)
				if not data:
					print("Connection lost.")	
					running = 0
#					s.close()		don't use this?
					break
				else:
					sys.stdout.write(data + "\n")
					sys.stdout.flush()
			else:
				line = sys.stdin.readline()	
				# Exit if user enters empty line
				if line == '\n':
					break
				else:
					s.send(line)

					
	except KeyboardInterrupt:
		print("Connection terminated by client.")
		s.close()
		break
