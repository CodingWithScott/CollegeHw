#!/usr/bin/env python

"""
A simple echo client
"""

import socket

host = '127.0.0.1'
#host = '140.160.138.149'
port = 50000
size = 1024
message = ""
keep_going = True

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host,port))

print ("Type a message to send, or \"STOP\":")
while keep_going:
	message = input()
	if message == "STOP":
		keep_going = False
	s.send(message)
	data = s.recv(size)
# end loop

s.close()
print 'Received:', data
