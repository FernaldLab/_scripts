#! /usr/bin/python

# sys.argv[1] is output from blast run...
#
#	blastx -query H_burtoni_rna.fa \
#		   -db ./db/Drer_Olat_Onil_Trub_ENS_pep \
#		   -out H_burtoni_rna_blastx_FISH_ENS_top1 \
#		   -outfmt '7 std' \
#		   -max_target_seqs 1
#
# -outfmt and -max_target_seqs must be set to '7 std' and '1', respectively

import sys, re
geneNamePattern = 'LOC[0-9]{9}'
print 'Gene name regex:\n  '+geneNamePattern

blastResults = open(sys.argv[1], 'r')
outfile = open(sys.argv[1]+'.transcriptsAndHitsByGenes', 'w')
#outfileMulti = open(sys.argv[1]+'.transcriptsAndHitsByGenes_multi', 'w')

geneDict = dict()
print 'Parsing input file:\n  '+sys.argv[1]
for line in blastResults:
	if re.match('^#', line):
		sLine = line.split(' ')
		if sLine[1] == 'Query:':
			queryID = sLine[2]
			queryLongName = ' '.join(sLine[3:]).strip()
			for i in sLine:
				queryParentGene = re.findall(geneNamePattern, i)
				if len(queryParentGene) == 1:
					queryParentGene = queryParentGene[0]
					break		
	else:
		sLine = line.split('\t')
		hit = sLine[1:]
		if queryParentGene in geneDict.keys():
			geneDict[queryParentGene].append((queryID, hit[0], queryLongName))
		else:
			geneDict[queryParentGene] = [(queryID, hit[0], queryLongName)]

print 'Writing output file:\n  '+sys.argv[1]+'.transcriptsAndHitsByGenes'
for gene in geneDict.items():
	#print gene[0]
	for namePair in gene[1]:
		toWrite = gene[0]+'\t'+namePair[0]+'\t'+namePair[1]+'\t'+namePair[2]+'\n'
		#print namePair[0].split('|')[3]
		#print toWrite.strip()
		outfile.write(toWrite)
	#print '\n'
		
blastResults.close()
outfile.close()
#outfileMulti.close()
				