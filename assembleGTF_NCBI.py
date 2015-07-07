#! /usr/bin/python

# What this program does
# Usage: python /Volumes/fishstudies/_scripts/parseNCBIAnnotations.py <listOfRealGenes> <cufflinksOutput> <geneRenumbers> <prefix>

import sys, re

def main():
	geneRenumberFile = open(sys.argv[3], 'r')
	newNumbers = {}
	for line in geneRenumberFile:
		newNumbers[line.split('\t')[0]] = line.split('\t')[1][:-1]
	genesToKeepFile = open(sys.argv[1], 'r')
	cufflinksGTF = open(sys.argv[2], 'r')
	outfile = open(sys.argv[2] + '.gtf', 'w')
	
	genesToKeep = {}
	for line in genesToKeepFile:
		genesToKeep[line.split('\t')[0]] = 1
	
	for line in cufflinksGTF:
		fields = line.split('\t') #[0 = scaffold, 3 = start, 4 = stop, 6 = strand, 8 = info]
		geneInfo = fields[8].split('"') #[1 = geneID, 3 = transcriptID, 5 = exonNumber]
		
		geneID = "cuff.s" + fields[0][9:] + "." + geneInfo[1][5:]
		if (geneID in genesToKeep):
			outFields = fields[0:8]
			if not geneInfo[1] in newNumbers:
				newNumbers[geneInfo[1]] = '1'
				print geneInfo[1]
			str = 'gene_id "cuff.gene.s' + fields[0][9:] + '.' + sys.argv[4] + '.' + newNumbers[geneInfo[1]] + '"; old_gene_ID "' + geneID + '"; transcript_id "' + geneInfo[3] + '"; '
			str += 'exon_number "' + geneInfo[5] + '";'
			outFields.append(str)
			outfile.write('\t'.join(outFields) + '\n')


main()
