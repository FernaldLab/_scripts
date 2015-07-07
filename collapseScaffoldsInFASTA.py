#! /usr/bin/python

## After taking a .gtf file and making a fasta file with sequences for only those genes, this script
## collapses the sequences by scaffold, rather than having a separate pseudo-scaffold for each gene
## or exon.

## The input file should have extension ".fa" for the output naming to make sense.
## Also, all "pseudo-scaffolds" from the same real scaffold should be together. That is, all sequences
## from scaffold 0 should be together, with no sequences from other scaffolds in between them.

import sys, re


def main():
	inputFasta = open(sys.argv[1], 'r')
	outputFasta = open(sys.argv[1][:-3] + ".collapsed" + sys.argv[1][-3:], 'w')
	
	lastScaffoldName = re.search(r'^>scaffold_\w+', inputFasta.readline()).group()
	charsLeftInLine = 80
	outputFasta.write(lastScaffoldName + '\n')
	for line in inputFasta:
		isScaffoldName = re.search(r'^>scaffold_\w+', line)
		if isScaffoldName:
			scaffoldName = isScaffoldName.group()
			if scaffoldName != lastScaffoldName:
				lastScaffoldName = scaffoldName
				charsLeftInLine = 80
				outputFasta.write('\n' + lastScaffoldName + '\n')
		else:
			line = line[:-1]
			while len(line) > charsLeftInLine:
				outputFasta.write(line[:charsLeftInLine] + '\n')
				line = line[charsLeftInLine:]
				charsLeftInLine = 80
			outputFasta.write(line)
			charsLeftInLine -= len(line)
	outputFasta.write("\n")
	inputFasta.close()


main()