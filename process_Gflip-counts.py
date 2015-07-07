#! /usr/bin/python
import sys, re

d = {}
for l in sys.stdin:
	if re.search('Gflip$', l):
		s = l.split('.')[0]
		d[s] = {}
	else:
		l = l.split(' ')
		d[s][l[-1].strip()] = l[-2]

# for k in d.keys():
# 	print k
# 	for kk in d[k].keys():
# 		print kk, d[k][kk]