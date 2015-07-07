#! /usr/bin/python

# What this program does

import sys, re

def main():
	infile = open(sys.argv[1], 'r')
	outputCounts = open(sys.argv[1] + '.genecounts', 'w')
	
	for line in infile:
		fields = line.split('\t')
		geneID = fields[18].split('"')[1]
		counts = fields[9].split(':')[1].split(',')
		count = int(counts[0]) + int(counts[1])
		outputCounts.write(geneID + '\t' + str(count) + '\n')
	infile.close()
	outputCounts.close()

main()