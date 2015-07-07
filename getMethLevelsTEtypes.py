#! /usr/bin/python
import sys

id_field = 3
level_field = 4

#print 'reading file:', sys.argv[1]
with open(sys.argv[1], 'r') as f:
	l = list(f)
	
ids = set()
level_sum = 0
for line in l:
	#print line
	this_id = line.split('\t')[id_field]
	if this_id in ids:
		continue
	else:
		level_sum += float(line.split('\t')[level_field])
		ids.add(this_id)

level_mean = level_sum / len(ids)
output = str(level_sum) + '\t' + str(len(ids)) + '\t' + str(level_mean)

print sys.argv[1] + '\t' + output 