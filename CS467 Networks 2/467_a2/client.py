import xmlrpclib

s = xmlrpclib.ServerProxy('http://localhost:8000')
print "2^3 = " + str(s.pow(2,3))  # Returns 2**3 = 8
print "2+3 = " + str(s.add(2,3))  # Returns 5
print "5/2 = " + str(s.div(5,2))  # Returns 5//2 = 2

# Print list of available methods
print s.system.listMethods()