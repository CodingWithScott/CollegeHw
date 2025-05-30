#!/usr/bin/env python

"""
An echo server that uses select to handle multiple clients at a time.
Entering any line of input at the terminal will exit the server.
"""

import select
import socket
import sys

host = ''
port = 50000
backlog = 5
size = 1024
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((host,port))
server.listen(5)
input = [server,sys.stdin]
running = 1

clients = {}

while running:
    inputready,outputready,exceptready = select.select(input,[],[])

    for s in inputready:

        if s == server:
            # handle the server socket
            client, address = server.accept()
            input.append(client)
            print "Connection established"
        elif s == sys.stdin:
            # handle standard input
            junk = sys.stdin.readline()
            running = 0 
            print "Server shutting down"
        else:
            # handle all other sockets
            # print whatever text user sends
            data = s.recv(size)

			# create a hash table entry using the socket as key and 
			# message as value. Will eventually use this to store client
			# names
            clients[s] = data
            print "s = "
            print s
            print (client[s])
            print data
            if data:
                s.send(data)
            else:
                s.close()
                input.remove(s)
server.close()
