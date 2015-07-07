#! /usr/bin/python
import sys, re

# parses gtf/gff file (sys.argv[1]) to create lookup table for features defined below

#########################################################
geneStr = 'gene='
rnaIDStr = 'ID='
mRNAIDStr = 'transcript_id='
cdsParentStr = 'Parent='
cdsIDStr = 'protein_id='
infoField = 9
splitOn = ';'
#########################################################

featureFile = open(sys.argv[1], 'r')
outfile = open(sys.argv[1]+'.lookup', 'w')

print 'Getting information from '+sys.argv[1]+'...'
geneDict = dict()
for line in featureFile:
	l = line.split('\t')
	if l[2] not in ['gene', 'mRNA', 'transcript', 'CDS']:
		continue
		
	info = l[infoField-1].split(splitOn)
	
	if l[2] == 'gene':
		for i in info:
			if re.match(geneStr, i):
				geneID = i.replace(geneStr, '').strip()
				if geneID not in geneDict.keys():
					geneDict[geneID] = set()

	if l[2] in ['mRNA', 'transcript']:
		for i in info:
			if re.match(geneStr, i):
				geneID = i.replace(geneStr, '').strip()
			if re.match(rnaIDStr, i):
				rnaID = i.replace(rnaIDStr, '').strip()
			if re.match(mRNAIDStr, i):
				mRNAID = i.replace(mRNAIDStr, '').strip()
		geneDict[geneID].add(rnaID+':'+mRNAID)
		
	if l[2] == 'CDS':
		for i in info:
			if re.match(geneStr, i):
				geneID = i.replace(geneStr, '').strip()
			if re.match(cdsParentStr, i):
				cdsParent = i.replace(cdsParentStr, '').strip()
			if re.match(cdsIDStr, i):
				cdsID = i.replace(cdsIDStr, '').strip()
		geneDict[geneID].add(cdsParent+':'+cdsID)

outfile.write('gene\trna_num\trna\tprotein\n')

print 'Writing to '+sys.argv[1]+'.lookup...'
for gene in geneDict.items():	
	features = sorted(list(gene[1]))
	ids = set()
	for f in features:
		ids.add(f.split(':')[0])
	for i in ids:
		tmp = []
		for f in features:
			if f.split(':')[0] == i:
				tmp.append(f)
		if len(tmp) == 1:
			stmp = tmp[0].split(':')
			if stmp[1].split('_')[0] == 'XR':
				outfile.write(gene[0]+'\t'+stmp[0]+'\t'+stmp[1]+'\n')
			else:
				print 'Warning, check '+gene[0]
		if len(tmp) == 2:
			stmp = tmp[0].split(':')
			stmp1 = tmp[1].split(':')
			outfile.write(gene[0]+'\t'+stmp[0]+'\t'+stmp[1]+'\t'+stmp1[1]+'\n')
featureFile.close()
outfile.close()