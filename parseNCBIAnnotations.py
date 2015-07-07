#! /usr/bin/python

# What this program does
# Usage: python /Volumes/fishstudies/_scripts/parseNCBIAnnotations.py <CUFFLINKS_GTF_FILE> <ANNOTATED_BLAST_RESULTS>

import sys, re

def getScaffoldStruct(cufflinksFile):
	for line in cufflinksFile:
		fields = line.split('\t') #[0 = scaffold, 3 = start, 4 = stop, 6 = strand, 8 = info]
		geneInfo = fields[8].split('"') #[1 = geneID, 3 = transcriptID, 5 = exonNumber]
		
		if not(fields[0] in scaffolds):
			scaffolds[fields[0]] = {}
		genesOnScaffold = scaffolds[fields[0]]
		
		geneID = "cuff.s" + fields[0][9:] + "." + geneInfo[1][5:]
		if not(geneID in genesOnScaffold):
			genesOnScaffold[geneID] = {}
		transcripts = genesOnScaffold[geneID]
		
		transcriptID = "cuff.s" + fields[0][9:] + "." + geneInfo[3][5:]
		if not(transcriptID in transcripts):
			transcripts[transcriptID] = []
		exons = transcripts[transcriptID]
		exons.append((fields[3], fields[4]))
	return scaffolds;
# scaffolds is a dict keys=[scaffold_0, scaffold_1, etc]
# scaffold 0 is dict of genes keys=[cuff.s0.1, cuff.s0.2, etc]
# cuff.s0.1 is a dict of transcripts keys=[cuff.s0.1.1, cuff.s0.1.2, etc]
# cuff.s0.1.1 is a list of exons represented as tuples [(exon1start, exon1end), (exon2start, exon2end), etc]

def isGoodHit(hit):
	#hit = [0region, 1burtoni name, 2pident, 3length, 4mismatch, 5gapopen, ,,,, 10=evalue]
	match = re.search(r'scaffold_\d+:(\d+)-(\d+)', hit[0])
	start = int(match.group(1))
	end = int(match.group(2))
	length = int(hit[3])
	return float(length) / (end - start) > .9 and float(hit[2]) >= 98

def main():
	cufflinksFile = open(sys.argv[1], 'r')
	blastResults = open(sys.argv[2], 'r')
	outfile = open(sys.argv[2] + '.genecounts', 'w')
	
	hitsDict = {}
	blastResults.readline()
	for line in blastResults:
		hit = line.split(',')
		if isGoodHit(hit) and (not(hit[0] in hitsDict) or float(hit[2]) > hitsDict[hit[0]][1]):
				match = re.search(r'PREDICTED: Haplochromis burtoni ([^(]+) \(LOC', hit[1])
				if match: hitsDict[hit[0]] = (match.group(1), float(hit[2]))
				else: hitsDict[hit[0]] = (hit[1], float(hit[2]))
	
	scaffolds = {}
	for line in cufflinksFile:
		fields = line.split('\t') #[0 = scaffold, 3 = start, 4 = stop, 6 = strand, 8 = info]
		geneInfo = fields[8].split('"') #[1 = geneID, 3 = transcriptID, 5 = exonNumber]
		if not(fields[0] in scaffolds):
			scaffolds[fields[0]] = {}
		genesOnScaffold = scaffolds[fields[0]]
		geneID = "cuff.s" + fields[0][9:] + "." + geneInfo[1][5:]
 		if not(geneID in genesOnScaffold):
			genesOnScaffold[geneID] = {}
		geneDescriptions = genesOnScaffold[geneID]
		transcriptID = "cuff.s" + fields[0][9:] + "." + geneInfo[3][5:]
		key = fields[0] + ":" + str(int(fields[3])-1) + "-" + fields[4]
		if key in hitsDict:
			description = hitsDict[key][0]
		else:
			description = "NO_HIT"
		if not(description in geneDescriptions):
			geneDescriptions[description] = []
		exonsWithDescription = geneDescriptions[description]
		exonsWithDescription.append(transcriptID + "." + geneInfo[5])
	for scaffold in scaffolds.values():
		for geneID in scaffold:
			descriptionsOfGeneID = scaffold[geneID]
			for description in descriptionsOfGeneID:
				outfile.write(geneID + "\t" + description + "\t(" + ', '.join(descriptionsOfGeneID[description]) + ")\n")
				
		
		

# 		
#		transcriptID = "cuff.s" + fields[0][9:] + "." + geneInfo[3][5:]
# 		if not(transcriptID in transcripts):
# 			transcripts[transcriptID] = []
# 		exons = transcripts[transcriptID]
		
# 		key = fields[0] + ":" + str(int(fields[3])-1) + "-" + fields[4]
# 		if key in hitsDict:
# 			exons.append((fields[3], fields[4], hitsDict[key]))
# 			print transcriptID + "." + geneInfo[5], (fields[3], fields[4], hitsDict[key])
# 		else:
# 			exons.append((fields[3], fields[4], "NO_HIT"))
# 			print transcriptID + "." + geneInfo[5], (fields[3], fields[4], "NO_HIT") #maybe add "NO_HIT" to dict??



# 		geneID = fields[18].split('"')[1]
# 		counts = fields[9].split(':')[1].split(',')
# 		count = int(counts[0]) + int(counts[1])
# 		outputCounts.write(geneID + '\t' + str(count) + '\n')
# 	infile.close()
# 	outputCounts.close()

# get cuff.s##.##.##.## (exon ID)
# for (gene)
# print description w/ list of exons that hit it, including NO_HIT.

main()