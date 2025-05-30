
## Example nested case statements:
## http://stackoverflow.com/questions/20701834/implementing-a-finite-state-machine-with-a-single-coroutine

## FSM decided upon by class:
## http://i.imgur.com/1v6NUAI.png 

import os			# used for clearing terminal
import sys			# used for getting keyboard text

def fsm(data):

	# probably not going to use this, will throw strikes outside of this FSM
	legal_chars = ['A','B','C','D','E','F','G','H','I','J','K','L','M',
	'N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c',
	'd','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s',
	't','u','v','w','x','y','z']

	state = 0
	accept = False
	reject = False 

	command = ""
	name_bldr = ""
	msg_bldr = ""
	x = 0
	
	print("data:\t" + data)
	print("length:\t" + str(len(data))) 

	while not accept and not reject and x<len(data):
			if state == 0:
				if data[x] + data[x+1] == "(c":
#					print(data[x] + data[x+1])
					print("state=1")
					x += 2
					state = 1
				else:
					state = "99"
			elif state == 1:
#				print("command:  " + data[x:x+5])
#				print("x:  " + str(x))
				if data[x:x+5] == "chat(":
					command = "chat"
					print("state=20\n")
					state = 20
					x+=5	# skip over 5 chars at a time
				elif data[x:x+5] == "join(":
					command = "join"
					print("state=21")
					state = 21
					x+=5
				elif data[x:x+5] == "stat)":
					command = "stat"
					print("state=22")
					state = 22
					x+=5
					accept = True
				else:
					print("reject = True, line 52")
					x+=1
					reject = True
			elif state == 20:
				# CCHAT: reading in list of names one char at a time until close paran
				if data[x] != ")":
					print("name_bldr:  " + name_bldr)
					name_bldr += data[x]
					x+=1
				else:
					print("name_bldr:  " + name_bldr)
					print("\nstate=30")
					x+=1
					state = 30
			elif state == 21:
				# CJOIN: reading in name one char at a time until close paran
				if data[x] != ")":
					print("name_bldr:  " + name_bldr)
					name_bldr += data[x]
					x+=1
				else:
					print("name_bldr:  " + name_bldr)
					print("\nstate=31")
					state = 31
			elif state == 31:
				# CJOIN: looking for closing parans
				print("x:  " + str(x) + "   data[" + str(x) + "]:  " + data[x])				
				if data[x:x+2]  != "))":
					print("expected )), found " + data[x:x+2])
					print("reject = True, line 86")
					reject = True
				else:
#					print("state = 50")
					accept = True
			elif state == 30:
				# CCHAT: looking for a paran before beginning of message
				if data[x] == "(":
#					print("x:  " + str(x) + "   data[" + str(x) + "]:  " + data[x])
					x+=1
					print("state=40")
					state = 40
				else:
					print("expected ), found " + data[x])
					print("reject = True, line 99")
					reject = True
			elif state == 40:
				# CCHAT: reading in message one char at a time
				if data[x] != ")":
#					print("x:  " + str(x) + "   data[" + str(x) + "]:  " + data[x])
					msg_bldr += data[x]
#					print("x:  " + str(x) + "   msg_bldr:  " + msg_bldr)
					x+=1
				else:
#					print("x:  " + str(x) + "   data[" + str(x) + "]:  " + data[x])
#					print("state = 50")
					print("state=50")
					state = 50
			elif state == 50:
				# CCHAT: looking for closing parans
#				print("x:  " + str(x) + "   data[" + str(x) + "]:  " + data[x])
				if data[x:x+2]  != "))":
#					print("expected )), found " + data[x:x+2])
					print("reject = True, line 116")
					reject = True
				else:
#					print("state = 50")
					accept = True
			
					
					
	print("data:\t\t" + data)					
	if reject:
		print("\nInvalid command.")
	if accept:
		print("\nValid command.")
		if command == "chat":
			 print("command:\tchat") 
			 print("names:\t\t" + name_bldr)
			 print("message:\t" + msg_bldr) 
		elif command == "join":
		 	print("command:\tjoin")
		 	print("name:\t\t" + name_bldr)
		elif command == "stat":
			print("command:\tstat")
				
	print("Final state:\t" + str(state))
	
	
		
os.system('cls' if os.name == 'nt' else 'clear')	# clear terminal	
data = "(cstat)"
fsm(data)
data = "(cchat(SCOTTY)(buttholes))"
fsm(data)
data = "(cjoin(allthesex))"
fsm(data)
data = "(cchat(SCOTTY,KAT,BUTTHOLE)(;lkjasdfkjasdlfjslkdfjlksdjflksdjflkjsdflkjsdflkjsdflkjsdflkjsdflkjsdlfjksdlfjksdlfjkslkdjflksdjflksjflksjdflksjdflkjsdflkjsdlfkjsdlkfjslkdjflksdfjlksdjflksjdflkjsdflkjsdlfkjsdlkfjsdlkfjsldkfjsdlkfjlskdjflksdjflksdjflksdjflkjsdflkjsdflkjsdflkjsdlfjk))"
fsm(data)
#data = "(cchat(SCOTTY,KAT,BUTTHOLElkjsdlfkjsdlkfjslkjlkjsdflkjsdflkjsdflkjsdflkjsdlfkjsdlfkjsdlfjksdlfkjsdlfkjsdlkfjksdljflksdjflksdjflksjdflkjsdfljsdflkjsdflkjsdflkjsdlfkjsdlkfjslkdjflskdjflkjsdfljsdflkjsdlfjksdlkfjsdlfjlksdjflsjdfljksdlfjsdlfjksdlkfjsdlkfjsdlkfjsldkfjsldfjksldkfjsldkjflksjdflkjsflkjsdflkjsdflkjsdflksjfdlkjsdflksdjflkjfsdlkjsdlskjflkjsdlksdjflsdkjfsdlkjfslksdjsdlkjfsldkfjsdlkfjslkfjsdlkfjslkjdflksdfjsldkjflksdjflksdjfksdljf;ksjdgklhklfjhsiouwencoiuweonuounwocunweouncweonrcweoncrwoenruowenurcownurconweucowniucrownirucownierucowenirucowieowenwienoiweoiwenrucoiwenruoweinruonweu)(i like farts))"
#fsm(data)
#data = "(cchat)()()()()()()()((SCOTTY,KAT,BUTTHOLE)(i like farts))"
#fsm(data)
#data = "(cchat(SCOTTY,KAT,BUTTHOLE)(UI)&*HKNND    UII_I_I (c (c (c (c kjsdlkfjlksjf)))))))))))))))))))))))))))(i like farts))"
#fsm(data)


#sys.stdout.write("% ")
#data = sys.stdin.readline().strip()

#while data.strip() != "":
#	sys.stdout.write("%  ")
#	data = sys.stdin.readline().strip()
#	fsm(data)



