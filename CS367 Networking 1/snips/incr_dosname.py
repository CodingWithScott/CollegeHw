name = "SCOT~999"

print("old:  " + name)
newname = ""

# name = "SCOTT~1" --> "SCOTT~9"
if (name[len(name)-1].isdigit()) and (name[len(name)-2] == '~'):
	if int(name[len(name)-1]) < 9:
		newname = name[:len(name)-1] + str(int(name[len(name)-1])+1)
	elif int(name[len(name)-1]) == 9:
		newname = name[:len(name)-2] + '~' + str(int(name[len(name)-1]) + 1)
# name = "SCOT~10" --> "SCOT~99"
elif (name[len(name)-1].isdigit()) and (name[len(name)-2].isdigit()) and (name[len(name)-3] == '~'):
	if int(name[len(name)-2:]) < 99:
		newname = name[:len(name)-2] + str(int(name[len(name)-2:]) + 1)
	elif int(name[len(name)-2:]) == 99:
		newname = name[:len(name)-4] + '~' + str(int(name[len(name)-2:]) + 1)
# name = "SCO~100" --> "SCO~999"
elif (name[len(name)-1].isdigit()) and (name[len(name)-2].isdigit()) and (name[len(name)-3].isdigit()) and (name[len(name)-4] == '~'):
	if int(name[len(name)-3:]) < 999:
		newname = name[:len(name)-3] + str(int(name[len(name)-3:]   ) + 1)
	elif int(name[len(name)-3:]) == 999:
		print("You can't have 1000 of same user, sorry")
else:
	print("Something fucked up, you should never see this")
	
print("new:  " + newname)	



# Broken hard coded version
if (oldname[7].isdigit()) and not (oldname[6].isdigit()):
		if oldname[7] == "9":
			newname = oldname[:5] + "~" + str(int(oldname[7])+1)
		elif oldname[7] != "9":
			newname = oldname[:6] + "~" + str(int(oldname[7])+1)
	elif (oldname[7].isdigit()) and (oldname[6].isdigit()) and not (oldname[5].isdigit()):
		if oldname[6:7] == "99":
			newname = oldname[:3] + "~" + str(int(oldname[6:7])+1)
		elif oldname[6:7] != "99":
			newname = oldname[:4] + "~" + str(int(oldname[6:7])+1)
	elif (oldname[7].isdigit()) and (oldname[6].isdigit()) and (oldname[5].isdigit()):
		newname = oldname[:3] + "~" + str(int(name[5:7])+1)
	else:
		newname = ("You had >999 users with the same name, or " + 
		"something else is fucked up. Sorry man")
