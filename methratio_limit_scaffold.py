#! /usr/bin/python
import sys, re

upto = int(sys.argv[2])
with open(sys.argv[1], 'r') as IN:
	with open(sys.argv[1]+'.upto'+str(upto), 'w') as OUT:
		for line in IN:
			scaffold = line.split('\t')[0]
			num = int(scaffold.split('_')[1])
			if num <= upto:
				OUT.write(line)