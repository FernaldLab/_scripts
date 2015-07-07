#! /usr/bin/python

#Reads should be 101 base pairs long

import sys, re

def main():
	infile = open(sys.argv[1], 'r')
	outfile1 = open(sys.argv[1] + "_firstHalfTrimmed", 'w')
	outfile2 = open(sys.argv[1] + "_secondHalfTrimmed", 'w')
	
	while True:
		geneID = infile.readline()
		if geneID == '': break
		outfile1.write(geneID)
		outfile2.write(geneID)
		bases = infile.readline()
		outfile1.write(bases[:51] + '\n')
		outfile2.write(bases[51:])
		dir = infile.readline()
		outfile1.write(dir)
		outfile2.write(dir)
		phred = infile.readline()
		outfile1.write(phred[:51] + '\n')
		outfile2.write(phred[51:])
		
	infile.close()
	outfile1.close()
	outfile2.close()


main()