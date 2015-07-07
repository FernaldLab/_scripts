#! /usr/bin/python

## This script takes a .bed file with one entry for each exon and collapses those entries to create
## a new .bed file with one entry per gene.

## The input file should have extension ".bed" for the output naming to make sense.
## All exons of a single gene must be sequential - the order does not matter, but if there is an
## exon from gene B in between exons from gene A, this program will create two entries for gene A.
## (ie. the input must be sorted by gene)

import sys, re

def main():
	exonBed = open(sys.argv[1], 'r')
	geneBed = open(sys.argv[1][:-4] + ".genes" + sys.argv[1][-4:], 'w')
	
	currentGene = exonBed.readline().split('\t') #[scaffold, start, end, geneID, '.']
	for line in exonBed:
		exon = line.split('\t')
		if exon[3] == currentGene[3]:
			if int(exon[1]) < int(currentGene[1]): currentGene[1] = exon[1]
			if int(exon[2]) > int(currentGene[2]): currentGene[2] = exon[2]
		else:
			geneBed.write('\t'.join(currentGene))
			currentGene = exon
	geneBed.write('\t'.join(currentGene))
	exonBed.close()
	geneBed.close()


main()