#! /usr/bin/python
import sys, re

def get_counts(input):
	usage = {}
	for l in input:
		if re.search('>', l):
			print l.strip('\n')
			continue
		else:
			for c in l.strip('\n'):
				if c not in usage:
					usage.update({c:1})
				else:
					usage[c] += 1
	print usage


if len(sys.argv) == 1:
	get_counts(sys.stdin)
else:
	with open(sys.argv[1], 'r') as f:
		get_counts(f)