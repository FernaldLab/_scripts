#! /usr/bin/python
import sys, re

with open(sys.argv[1], 'r') as input:
	with open(sys.argv[1] + '.clean', 'w') as output:
		l = list(input)
		for ind in range(len(l)):
			if re.search('^RAW', l[ind]):
				start = ind + 4
			if re.search('^FULL', l[ind]):
				end = ind - 2			# only -2 since otherwise +1 in range(start,end) anyway
		seq = list()
		for ind in range(start, end):
			#print l[ind], len(l[ind]), l[ind].split().pop()
			if len(l[ind]) > 20:
				seq.append(l[ind].split().pop())
		output.write(' '.join(seq) + '\n')