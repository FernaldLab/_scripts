#! /usr/bin/python

# Takes the output of a fastQC run and looks through the overrepresented sequences to determine
# which sequences are actually the same, but with different starting points.
# Sequences that do match are merged and their other data (# reads and % of total reads) are added
#   together, then the shorter list of merged sequences is saved to a new file.
# NB: The matching algorithm is not very thorough - if 10 base pairs match, it assumes the sequences
#	match everywhere without checking. Take these results with a grain of salt.

import sys, re

def combineIfMatch(sequences, refIndex, checkIndex, searchSequence):
	startIndexCheck = sequences[checkIndex][0].find(searchSequence)
	if startIndexCheck == -1: return 0
	startIndexRef = sequences[refIndex][0].find(searchSequence)
	endIndexCheck = startIndexCheck + len(searchSequence)
	endIndexRef = startIndexRef + len(searchSequence)
	
	while endIndexRef < len(sequences[refIndex][0]) and endIndexCheck < len(sequences[checkIndex][0]):
		if sequences[refIndex][0][endIndexRef] != sequences[checkIndex][0][endIndexCheck]:
			if sequences[refIndex][0][endIndexRef] == 'N':
				sequences[refIndex][0] = sequences[refIndex][0][:endIndexRef] + sequences[checkIndex][0][endIndexCheck] + sequences[refIndex][0][endIndexRef + 1:]
			elif sequences[checkIndex][0][endIndexCheck] != 'N':
				return 0
		endIndexRef += 1
		endIndexCheck += 1
	while startIndexRef >= 0 and startIndexCheck >= 0:
		if (sequences[refIndex][0][startIndexRef] != sequences[checkIndex][0][startIndexCheck]): return 0
		startIndexRef -= 1
		startIndexCheck -= 1
	
	addLength = len(sequences[checkIndex][0]) - (endIndexCheck - startIndexCheck)
	if addLength >= 10: return 0
	
	if startIndexCheck > startIndexRef:
		sequences[refIndex][0] = sequences[checkIndex][0][:startIndexCheck] + sequences[refIndex][0][startIndexRef:]
	elif len(sequences[checkIndex][0]) - startIndexCheck > len(sequences[refIndex][0]) - startIndexRef:
		sequences[refIndex][0] = sequences[refIndex][0][:startIndexRef] + sequences[checkIndex][0][startIndexCheck:]
	sequences[refIndex][1] = str(int(sequences[refIndex][1]) + int(sequences[checkIndex][1]))
	sequences[refIndex][2] = str(float(sequences[refIndex][2]) + float(sequences[checkIndex][2]))
	return 1
    
def main():
    inputReport = open(sys.argv[1], 'r')
    sequences = []
    for line in inputReport:
        sequences.append(line.split('\t'))
    inputReport.close()
    
    firstUnmatchedIndex = 1
    print str(len(sequences)) + " sequences have been loaded into memory."
    #STRUCT TYPE: [sequence string, count, percentage, source]
    while firstUnmatchedIndex < len(sequences):
        searchSequence = ''
        while searchSequence != sequences[firstUnmatchedIndex][0][5:20]:
            searchSequence = sequences[firstUnmatchedIndex][0][5:20]
            for i in range(len(sequences) - 1, firstUnmatchedIndex, -1):
                if combineIfMatch(sequences, firstUnmatchedIndex, i, searchSequence): sequences.pop(i)
            for i in range(len(sequences) - 1, firstUnmatchedIndex, -1):
                if combineIfMatch(sequences, firstUnmatchedIndex, i, searchSequence): sequences.pop(i)
        while searchSequence != sequences[firstUnmatchedIndex][0][-20:-5]:
            searchSequence = sequences[firstUnmatchedIndex][0][-20:-5]
            for i in range(len(sequences) - 1, firstUnmatchedIndex, -1):
                if combineIfMatch(sequences, firstUnmatchedIndex, i, searchSequence): sequences.pop(i)
            for i in range(len(sequences) - 1, firstUnmatchedIndex, -1):
                if combineIfMatch(sequences, firstUnmatchedIndex, i, searchSequence): sequences.pop(i)
        if not firstUnmatchedIndex % 5:
        	print str(firstUnmatchedIndex) + " consensus sequences condensed (" + str(len(sequences)) + " still in memory)"
        firstUnmatchedIndex += 1
    outfile = open(sys.argv[1] + '.overrepresentedsequences.txt', 'w')
    for line in sequences: outfile.write('\t'.join(line))
    outfile.close()

main()

# sequence	1	1	readID