#!/usr/bin/env python

"""
An echo client that allows the user to send multiple lines to the 
server. Entering a blank line will exit the client.
"""
import argparse
import select
import socket
import sys

host = 'localhost'
port = 36735
size = 1024
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host,port))

parser = argparse.ArgumentParser(description='Basic chat client')
parser.add_argument('-d','--debug', help='Enter a debug code', default=0, required=False)
parser.add_argument('-m','--manual', help='Select manual mode', default=True, required=False)
parser.add_argument('-n','--name', help='Select your username', default="Turdbucket", required=True)
parser.add_argument('-p','--port', help='Select port #', default=36735, required=False)
parser.add_argument('-s','--server', help='Select server address', default="localhost", required=True)

# Create a hash table named "args" which contains arguments
# if args['foo'] == 'Hello':
    # code here
args = parser.parse_args()

print("Name:\t" + args.name)
print("Server:\t" + args.server)
print("Port:\t" + str(args.port))
print("Manual:\t" + str(args.manual))
print("Debug:\t" + str(args.debug))

# Chat-join filtering appears to be competely done afaik, woohoo!!
# TO-DO: Clean up message-send filtering using logic from chat filter

# TO-DO: Everything network related




running = 1
sys.stdout.write('%')

""" #### MAIN PROGRAM #### """
while running:
	line = sys.stdin.readline()

	# Check if user is trying to exit
	if line == '\n':
		break

	s.send(line)
	data = s.recv(size)
	sys.stdout.write(data)
	sys.stdout.write('%')

s.send("Connection terminated")
s.close()
