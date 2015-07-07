#! /usr/bin/python

##IN DEVELOPMENT
# Goal: make a GTF file with transcriptome indexing.
# Note: such a program may already exist.


## python nameOfThisFile GTF BED

# this might be a useful thing to do with whole-gene ribosome alignments, which include both exons and
# introns. Or maybe even with only exons. But incomplete right now.

import sys, re


def main():
	genesBed = open(sys.argv[2], 'r')
	oldGtf = open(sys.argv[1], 'r')
	newIndexing = open(sys.argv[2] + '.gtf')
	
	currentGene = genesBed.readline().split('\t') #[scaffold, start, end, geneID, '.']
	for line in oldGtf:
		exon = line.split('\t')
		
		if re.search(currentGene[3], exon[8]):
			newIndexing.write(line WithRangesSubtractedFromStart)
		else:
			getTheNextLineOfBedFile
			if isSameScaffoldAsPreviousGene:
				subtractValue = start - numBasesInPrevGene
			else
				subtractValue = start (-1?)
			#indexed from 1, I think
			resetVariables


main()