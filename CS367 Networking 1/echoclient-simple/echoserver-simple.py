#!/usr/bin/env python
"""
Server
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
server.listen(backlog)
input = [server,sys.stdin]
running = 1   """sys.argv[1]"""

while running:
    inputready,outputready,exceptready = select.select(input,[],[])

    for s in inputready:

        if s == server:
            # handle the server socket
            client, address = server.accept()
            input.append(client)
            print "Hello world"

        elif s == sys.stdin:
            # handle standard input
            junk = sys.stdin.readline()
            running = 0
            print "Server shutting down"

        else:
            # handle all other sockets
            data = s.recv(size)
            if data:
            	print data
                s.send(data)
            else:
                s.close()
                input.remove(s)
server.close()
