#! /usr/bin/python
import sys, re

field = 8

# sys.argv[1] should be TE.hit file, e.g. 3157.wig.bed-TEs.hit
print 'reading file...'
with open(sys.argv[1], 'r') as f:
	l = list(f)

print 'collecting TE types...'	
s = set()
for line in l:
	s.add(line.split('\t')[field])
print 'TE types:', s

outlist = list()
for type in s:
	outlist.append(sys.argv[1] + '.' + type)

# this is slow but works
for file in outlist:
	print 'working on ' + file
	with open(file, 'w') as out:
		for line in l:
			#print line.split('\t')[field]
			#print file.split('.')[2]
			if line.split('\t')[field] == file.split('.')[4]:
				out.write(line)