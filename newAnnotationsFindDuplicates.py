#! /usr/bin/python

#Usage: python <fileWithDuplicatesFromTheSameScaffold> <gtf = $preface> <name of newGeneNumbers file>

import sys, re

def main():
	possibleDuplicates = open(sys.argv[1], 'r')
	descriptions = {}
	for line in possibleDuplicates:
		if not line.split('\t')[1] in descriptions: descriptions[line.split('\t')[1]] = []
		descriptions[line.split('\t')[1]].append(line.split('\t')[0])
		
	gtfFile = open(sys.argv[2], 'r')
	gtfLines = {}
	scaffolds = {}
	for line in gtfFile:
		if not line.split('"')[1] in gtfLines: gtfLines[line.split('"')[1]] = []
		gtfLines[line.split('"')[1]].append(line)
		
		if not line.split('\t')[0] in scaffolds: scaffolds[line.split('\t')[0]] = {}
		if not line.split('"')[1] in scaffolds[line.split('\t')[0]]: scaffolds[line.split('\t')[0]][line.split('"')[1]] = int(line.split('\t')[3])
		if int(line.split('\t')[3]) < scaffolds[line.split('\t')[0]][line.split('"')[1]]: scaffolds[line.split('\t')[0]][line.split('"')[1]] = int(line.split('\t')[3])
	
	outfile = open(sys.argv[1] + '.gtf', 'w')
	for description in descriptions:
		outfile.write(description)
		geneIDs = descriptions[description]
		for iD in geneIDs:
			for line in gtfLines["CUFF." + iD.split('.')[2]]:
				outfile.write(line)
	outfile.close()
	
	print "Genes on same scaffold but opposite strands:"
	for description in descriptions:
		geneIDs = descriptions[description]
		dir = ''
		for iD in geneIDs:
			for line in gtfLines["CUFF." + iD.split('.')[2]]:
				if dir == '': dir = line.split('\t')[6]
				if line.split('\t')[6] != dir: print description,
	
	outfile = open(sys.argv[3], 'w')
	for scaffold in scaffolds:
		genes = scaffolds[scaffold].keys()
		
		# bubble sort (I know, I know, this is super embarassing)
		swapped = 1
		while swapped:
			swapped = 0
			for i in range(0, len(genes) - 1):
				if scaffolds[scaffold][genes[i]] > scaffolds[scaffold][genes[i + 1]]:
					swapped = 1
					temp = genes[i]
					genes[i] = genes[i+1]
					genes[i+1] = temp
		
		for i in range(0, len(genes)):
			outfile.write(genes[i] + "\t" + str(i + 1) + "\n")
	outfile.close()

main()