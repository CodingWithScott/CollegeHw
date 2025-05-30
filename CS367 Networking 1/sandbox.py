battles = [[0 for x in xrange(30)] for x in xrange(30)] 


for x in range (0, 30):
	row = ""
	for y in range(0, 30):
		row += str(battles[x][y]) + " "
	print(row)
