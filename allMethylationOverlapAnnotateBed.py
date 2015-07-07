#! /usr/bin/python
import sys, re

files = list()
for line in sys.stdin:
	files.append(line.strip())

bigList = list()
for f in files:
	print 'Input file:', f
	with open(f, 'r') as fx:
		bigList.append(set(fx.read().split(' ')))
		
with open(sys.argv[1], 'r') as input:
	with open(sys.argv[1] + '.overlapSummary', 'w') as output:
		# iterate through wig.bed file
		lcount = 0
		for line in input:
			lcount += 1
			if lcount % 1000000 == 0:
				print lcount
			ls = line.split('\t')
			pos = ls[0] + ':' + ls[1] + '-' + ls[2]
			hits = list()
			# iterate through list of query files
			for b in range(len(bigList)):
				#print files[b]
				# keep any matches to current position
				if pos in bigList[b]:
					this_hit = files[b].split('-')[1].replace('_uniq_ids', '')
					hits.append(this_hit)
			if len(hits) == 0:
				output.write( line.strip() + '\tnone\n' )
			else:
				output.write( line.strip() + '\t' + ','.join(hits) + '\n')