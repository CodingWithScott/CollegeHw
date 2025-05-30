import string, sys, re, parser
from optparse import OptionParser
import random

#    print opts.get_option(port)

d = {}
d[1] = "cat"
d[2] = "dog"
d[3] = "string"
d[4] = "bird"

#s = "dog"

#if s in d.values():
#    print s
#else:
#    print "not here"

rnd = d.values()

print(d)
print(random.choice(d.values()))
print(random.choice(d.values()))
print(random.choice(d.values()))
print(random.choice(d.values()))

#print(rnd)

#print rnd[0]

random.shuffle(rnd)

print(rnd)
#print rnd[0]



"""
s = "IsaacPoWEll.tXt"

s = s.upper()

print s
"""
