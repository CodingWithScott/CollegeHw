""" Byzantium Generals Client """
#!/usr/bin/env python
import argparse
import os			# used to clear screen
import random		# used for ANY command in autosend
import re 			# for parsing regular expressions when receiving sstat
import select
import socket
import sys
import time 		# used for timeout

# how long to wait after starting server to send first automated cchat msg
next_time_to_send = time.time() + random.randint(1, 2)




""" 	TO DO:  
	High priority:

	Low priority:
 Keep track of own name
 Keep track of own strikes
 
 	Extremely low priority:
Parse SSTAT messages to send to real users instead of just ALL and ANY
 
 
 
"""

# Create a hash table named "args" which contains arguments
# if args['foo'] == 'Hello':
	# code here
parser = argparse.ArgumentParser(description='Basic chat client')

parser.add_argument('-d','--debug', 
	help='Enter a debug code', 
	default=0, 
	required=False)
parser.add_argument('-m','--manual', 
	action="store_true",
	help='Select manual mode', 
	default=False)
parser.add_argument('-n','--name', 
	help='Select your username', 
	default="Defaultname", 
	required=True)
parser.add_argument('-p','--port', 
	type=int,
	help='Select port #', 
	default=36735, 
	required=False)
parser.add_argument('-s','--server', 
	type=str,
	help='Select server address', 
	default="localhost", 
	required=False)

args = parser.parse_args()

host = socket.gethostbyname(args.server)
manual = args.manual
name = args.name

print("host:\t" + host)

port = args.port
size = 480
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host,port))

os.system('cls' if os.name == 'nt' else 'clear')	# clear terminal
print("Name:\t" + args.name)
print("Server:\t" + args.server)
print("Port:\t" + str(args.port))
print("Manual:\t" + str(args.manual))
print("Debug:\t" + str(args.debug))

cjoin = "(cjoin(" + args.name + "))"
s.send(cjoin)
"""
if name == "GRACE":
	offer = "(cchat(SERVER)(PLAN,1,PASS))"
elif name == "KAT":
	offer = "(cchat(SERVER)(PLAN,1,APPROACH,SCOTT,GRACE))"
elif name == "SCOTT":
	offer = "(cchat(SERVER)(PLAN,1,APPROACH,GRACE,KAT))"
s.send(offer)
if name == "GRACE":
	confirm = "(cchat(SERVER)(ACCEPT,1,SCOTT))"
	s.send(confirm)
elif name == "SCOTT":
	confirm = "(cchat(SERVER)(DECLINE,1,KAT))"
	s.send(confirm)
"""

running = 1

messages = ["That's C, baby.",
            "It's fuckin C, man.",
            "Hahaha, okay, okay!!",
            "I code in Comic Sans.",
            "Do you even code, bro?",
            "Pfftt. PFFFFFFTTTT!!!!",
            "Have you tried doing better?",
            "Those idiots over in Redmond...",
            "Why don't you transfer to Devry?",
            "I didn't know I couldn't do that.",
            "City morgue, you stab 'em, we slab 'em.",
            "I drank 90 energy drinks in 12 days. #cs",
            "Let's flip on this little idiot light here.",
            "Pop this sucker in here and let's run it...",
            "I like girls. I like butts. I like girl butts.",
            "Meehan's dog Casey has the same birthday as him.",
            "You see, the thing is, you just have to do better.",
            "You want 35938 bytes? That's cool as shit, here's 5.",
            "It's real simple, guys. Even a Java programmer can do this.",
            "We do a socket call after we get all the good poop in there.",
            "What's the worst part of watching Doctor Who? Doctor Who fans.",
            "I love it when you're coding so long they turn the lights off.",
            "Just don't go to the final, they can't fail you if you don't go.",
            "BO to my left, farter to my right. Yep, it's another 8am CS class.",
            "WWU Comic Book Club: get yo superhero on!! Thursdays @ 5pm, Miller 105",
            "The %eax register slams up over here into the %rax register, then POW!",
            "How many questions will be on the midterm? I don't know.... maybe a lot.",
            "It might send you off to some place you don't want to go... like Puyallup.",
            "The secret to programming is you just have to understand what you're doing.",
            "I KNOW it's 3am on Dead Week... what do you mean you won't play Magic with me?",
            "Oh HELL YEAH, you better believe IBM will still sell you a Big Endian mainframe.",
            "Physics is fake. It's not even real. It's a scam invented by textbook publishers.",
            "Do you really think somebody would do that, just go on the internet and tell lies?",
            "It's like programming on the highway with a box of live hand grenades on your desk.",
            "My girlfriend has a master's degree so I KIND OF know what I'm talking about, okay?",
            "I hate cats beyond belief, and yet my girlfriend is named Kat. It's a real problem.",
            "Why would you teach this class at 8am? ARE YOU TRYING TO KEEP THIS SHIT A SECRET?!?",
            "How does this email server know we're the guy we calimed to be? ....because we told him.",
            "Every woman I've ever lived with has shed more hair than every dog I've ever had put together.",
            "Visual Studio needs to update? More like \"you need to take a break from work for 15 minutes\"!",
            "I don't wear my seatbelt driving to school because I want to die before I can make it to this class."
            "That awkward moment when you're writing code for a boss who thinks Visual Studio is a programming language.",
            "Batman is a sociopathic billionaire who has made it his life mission to torment a mentally ill homeless man.",
            "The message is too big to get through in a single datagram. Then what do we do? Ask nicely? Stomp real hard?",
            "Believe if or not, you can live a long and happy life without ever learning about internal routing algorithms.",
            "I have taken CSCI 141 3 times at 3 different universities in 3 different languages. (Ada, C++, Python) Shit is cray.",
            "It's hard to remember when you're up to your asshole in alligators that your original intent was to drain the swamp.",
            "Professor says \"fuck\" in lecture, nobody cares. Put \"fuck\" in your source code and EVERYONE LOSES THEIR MINDS!!!",
            "Did you hear the prime minister of New Zealand's house caught on fire? It almost burned the whole trailer park down!!",
            "Can you try to cheat the system, like unlocking IBM machines? You could, but you'd rather screw with the IRS than IBM.",
            "Hanging out with your friends doesn't count unless you make a fb status stating what you're doing and tagging everyone you're with.",
            "I have a lizard named Lola and she's pretty cute. I think she likes me. At least as far as an emotionless creature can like someone.",
            "That awesome feeling when you get home from a good first date and you get to let out that fart you've been holding in for 4 hours. Yep.",
            "SMTP stands for Simle Mail Transfer Protocol, but it SHOULD stand for Stupid Mail Transfer Protocol because it is the genesis of all spam.",
            "The amount of coughing, hacking, weezing, sniffling and snorting going on in my 8am class is like being in a class of pugs. Except not very cute.",
            "\"When he had turned in the scantron, Jesus said, 'It is finished.' With that, he bowed his head and gave up the school year. Spring break is here!!\" -John 19:30",
            "Q: What's the difference between a Vim user and a Mormon missionary? A: Mormon missionaries are required to shower, shave and brush their teeth before going in public.",
            "When I was a teenager I was always trying to find adults to buy me alcohol. Now I'm in my 20s and all the 40+ year olds in my classes keep asking me to buy weed for them. I don't know what to do with this information.",
            "Asynchronous transfer mode was popular in the 80s and early 90s, until it just got its head stomped on. So if you ever run into it in the real world, just take it and throw it in a river. There is no good reason to EVER use that.",
                ]

""" Useful globals to keep track of """
clients 	= {}
my_name		= ""
curr_round	= 0		# current curr_round client thinks it is. why is this blue?
strikes		= 0		# do I need this?


def timeout_check():
	current_time = time.time()
	if (current_time - start_time) > timeout:
		print("poop happens")


def do_random():
	p = re.compile(r'(\(sstat\()(.*)[)][)]')
	sstat = "(sstat(BOB,JOE,SCOTTY))"
	poop = p.match(sstat)

	ppl_list = poop.group(2).split(",")

	for each in ppl_list:
		#print("each:\t" + each)
		clients[each] = 1

	# fix this shit later, need to parse sstat messages into a local dictionary
	# for user specific sending to work
	# possible_types = ["ALL", "ANY", "single", "multi"]		
	possible_types = ["ALL", "ANY"]
	send_type = random.choice(possible_types)
	random_msg = random.choice(messages)
	#print("send_type:\t" + send_type)

	if send_type == "single":
		send_to = random.choice(clients.keys())
	elif send_type == "multi":
		# select a random num people to send a message to,
		# between 1 and total num of users
		num_ppl = random.randint(1, len(clients)-1)
		#print("num_ppl:\t" + str(num_ppl))
		send_to = ""

		for count in range (0, num_ppl):
			might_send_to = random.choice(clients.keys())
			#print("might_send_to:\t" + might_send_to)
			# make sure not sending a duplicate message
			while might_send_to in send_to:
				might_send_to = random.choice(clients.keys())
			send_to += might_send_to + ","
		# trim trailing paran
		send_to = send_to[:len(send_to)-1] 
	elif send_type == "ANY":
		send_to = random.choice(clients.keys())
	elif send_type == "ALL":
		send_to = "ALL"

	#output = "(cchat(" + send_to + ")(" + random_msg + "))"
	output = "(cchat(ALL)(" + random_msg + "))"
#	print("output:\t" + output)
	return output

def prompt():
	sys.stdout.write("% ")
	sys.stdout.flush()

def parse_sstat(s):
	p = re.compile(r'(\(sstat\()(.*)[)][)]')
	sstat = "(sstat(BOB,JOE,SCOTTY))"
	poop = p.match(sstat)

	ppl_list = poop.group(2).split(",")

	for each in ppl_list:
		#print("each:\t" + each)
		clients[each] = 1

	print("clients{}:\t")
	print(clients)

prompt()

# Extremely advanced AI that passes every round
def do_nothing():
	global curr_phase 

	if curr_phase == 1:
		return "(cchat(SERVER)(PLAN," + curr_round + "PASS))"
	elif curr_phase == 3:
		return "(cchat(SERVER)(ACTION," + curr_round + "PASS))"

curr_round = 0

""" #### MAIN PROGRAM #### """
while running:
	try:
		# ttw = time to wait
		ttw = random.randint(2, 15)
		# wait 1-3 seconds of inactivity to send a new message
		inputready, outputready,exceptrdy = select.select([0, s], [],[], ttw)
		
		if not (inputready or outputready or exceptrdy) and not manual:
			if time.time() > next_time_to_send:
				s.send(do_random())
				next_time_to_send = time.time() + random.randint(1, 3)

		# took format for client-select logic from http://tinyurl.com/6jnpzqj
		for i in inputready:
			# if user is typing into keyboard then read it
			if i == 0:
				#self.sock = s
				if manual:
					#data = sys.stdin.readline().strip()
					data = raw_input().strip()
				elif not manual:
					#data = do_random()

					data = do_nothing()



				if data: s.send(data)
			# if receiving data from server then print it
			elif i == s:
				data = s.recv(size)
				if "(schat(SERVER)(PLAN," in data:
					curr_round = data[20:len(data)-2]
					curr_phase = 1
				elif "(schat(SERVER)(ACTION," in data:
					curr_round = data[22:len(data)-2]
					curr_phase = 3
				if not data:
					print("Connection lost.")	
					running = 0
					break
				else:
					sys.stdout.write(data + "\n")
			else:
				line = sys.stdin.readline()	
				# Exit if user enters empty line
				if line == '\n':
					break
				else:
					s.send(line)
			if manual:
				prompt()

	except KeyboardInterrupt:
		print("Connection terminated by client.")
		s.close()
		break

