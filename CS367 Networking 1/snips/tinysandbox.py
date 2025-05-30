import re
import string
import sys

line = "abcdefg" + chr(3) + chr(6) + chr(10) + "hijklmn"
line = chr(0) + chr(1) +chr(2) + chr(3) +  chr(4) +  chr(5) +  chr(6) +  chr(7) +  chr(8) +  chr(9) + "hi!" + chr(15)

test = "(cchat(" + chr(5) + chr(7) + chr(11) + "namehere)(buttholes are neato))"

#legal_chars = (chr(x) for x in range(32,126))

#print("legal_chars:\t" + legal_chars)




#for x in range(0, 3):
#	if line[x] not in legal_chars or line[x] == "(" or line[x] == ")":
#		line = line[:x] + line[x+1:]

def clean_line(line):
	cleanline = ""
	for i in range(0, len(line)):
	#	print(i, c)
	#	print("i:\t" + str(i) + "c:\t" + c)
	#	print("line[i]:\t" + line[i])

		int_val = ord(line[i])
		if (int_val >= 32 and int_val <= 39) or (int_val >= 42 and int_val <= 126): 
	#		print("happening!")
			cleanline += line[i]
			
	return cleanline
	
print("test: " + test)
test = clean_line(test)
print("cleantest: " + test)


