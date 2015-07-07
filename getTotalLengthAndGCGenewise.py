#! /usr/bin/python


import sys, re

def longestIsoformString(isoforms):
	longestIsoform = isoforms[0]
	for isoform in isoforms:
		if isoform[1] > longestIsoform[1]: longestIsoform = isoform
	
	exons = longestIsoform[2:]
	numGC = 0
	length = 0
	for exon in exons:
		numGC += int(round(float(exon[0]) * int(exon[1])))
		length += int(exon[1])
	if length != longestIsoform[1]: print 'ERROR: Length computed incorrectly'
	gcPercentage = float(numGC)/length
	return longestIsoform[0] + '\t' + str(gcPercentage) + '\t' + str(length)

def main():
	exonBed = open(sys.argv[1], 'r')
	geneBed = open(sys.argv[1] + '.genes', 'w')
	
	# isoformID = line.split('"')[3]
	# geneID = line.split('"')[1]
	
	exonBed.readline()
	firstLine = exonBed.readline()
	currentGeneID = firstLine.split('"')[1]
	isoforms = [[firstLine.split('"')[3], 0]]
	exonBed.seek(0)
	exonBed.readline()
	for line in exonBed:
		entry = line.split('\t')
		if line.split('"')[1] != currentGeneID:			
			geneBed.write(currentGeneID + '\t' + longestIsoformString(isoforms) + '\n') # geneID, longest isoform ID, GC % of longest isoform, longest isoform length
			currentGeneID = line.split('"')[1]
			isoforms = [[line.split('"')[3], 0]]
		if line.split('"')[3] != isoforms[-1][0]:
			isoforms.append([line.split('"')[3], 0])
		isoforms[-1].append((entry[2], entry[3]))
		isoforms[-1][1] = int(isoforms[-1][1]) + int(entry[3])
		# add to length
		# add tuple

	geneBed.write(currentGeneID + '\t' + longestIsoformString(isoforms) + '\n')
	exonBed.close()
	geneBed.close()


main()