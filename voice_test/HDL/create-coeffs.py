boundaries = [0,3,6,10,14,18,24,30,36,44,52,62,72,85,98,114,131,150,173,197,225,256]
ascending = [0]*257
descending = [0]*257

for i in xrange(len(boundaries)-1):
   left = boundaries[i]
   right = boundaries[i+1]
   for j in xrange(left, right):
      
      ascending[j] = int(round(1023.0*(j-left)/(right-left)))
      descending[j] = 1023 - int(round(1023.0*(j-left)/(right-left)))
      

for b in boundaries:
   ascending[b] = 1023

# Generate verilog code for assignments

'''
for i in xrange(257):
   print "assign ascending[" + str(i) + "] = " + str(ascending[i]) + ";" 
for i in xrange(257):
   print "assign descending[" + str(i) + "] = " + str(descending[i]) + ";" 
'''

for i in xrange(256):
   print "  8'd" + str(i) + ": ascending <= " + str(ascending[i]) + ";" 
for i in xrange(256):
   print "  8'd" + str(i) + ": descending <= " + str(descending[i]) + ";" 
