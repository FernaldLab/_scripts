#! /usr/bin/python
import sys

def generateTEbedInfo(IN):
	types = {}
	for l in IN:
		ls = l.split('\t')
		
		
if len(sys.argv) == 1:
	generateTEbedInfo(sys.stdin)
else:
	with open(sys.argv[1], 'r') as f:
		generateTEbedInfo(f)