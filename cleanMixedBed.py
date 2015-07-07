#! /usr/bin/python

# Changes the fourth column of a "messy" bed file to be a plain geneID (s##.##) when the gene ID is in most other formats.
# (used once when interleafing UTRs and exons)

import sys, re

def main():
	messyBed = open(sys.argv[1], 'r')
	neatBed = open(sys.argv[1][:-4] + ".clean4" + sys.argv[1][-4:], 'w')
	
	for line in messyBed:
		entry = line.split('\t')
		entry[3] = re.search(r's\w+\.\w+', entry[3]).group()
		neatBed.write('\t'.join(entry))
	neatBed.close()
	messyBed.close()


main()