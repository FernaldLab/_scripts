#! /usr/bin/python
import sys, re

blist = list()
id = ''
with open(sys.argv[1], 'r') as f:
	for line in f:
		this_id = line.split('\t')[3]
		if this_id == id:
			print 'MATCHED'
			blist.append(line)
		else:
			#for el in blist:
			#	if re.search('\n', el):
			#		print re.search('\n', el).group(0)
			print 'DID NOT MATCH\nNEWID: ', this_id
			id = this_id
			blist = list()
			blist.append(line)
		print len(blist)
		print len(set(blist))