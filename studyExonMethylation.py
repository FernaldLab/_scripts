#! /usr/bin/python
import sys

# sys.argv[1] should be e.g. 3157.wig.bed-GTF.hitCDSfor_groupBy_grouped

def studyExonMethylation(for_groupBy_groupedFile, outfile_name):
	outfile = open(outfile_name, 'w')
	for l in for_groupBy_groupedFile:
		ls = l.split('\t')
		fstrands = ls[5].split(',')			# don't collapse because frames may differ
		frames = ls[6].split(',')
		if fstrands[0] == '+':
			start = int(ls[1])
			end = int(ls[2])
		elif fstrands[0] == '-':
			start = int(ls[2])
			end = int(ls[1])
		else:
			print 'INVALID STRAND INFO', l
		hit_count = float(ls[3])
		hits = ls[4].split(',')

		new_hits = list()
		lvl = 0
		for hit in range(len(hits)-1):
			h = hits[hit].split(':')
			lvl += float(h[4])
			pos = int(h[2])
			frame = int(frames[hit])
			fstrand = fstrands[hit]
			mstrand = h[6]
			if fstrand == '-':
				frame = -1 * frame
			fstart = start + frame
			dist_start = pos - fstart
			if fstrand == '-':
				dist_start = -1 * dist_start
			if mstrand == fstrand:
				sense = 's'
			elif mstrand != fstrand:
				sense = 'as'				
			else:
				print 'INVALID STRAND INFO', l
			h.append(str(dist_start))
			h.append(str(sense))
			new_hits.append(':'.join(h))
		
		avg_lvl = lvl / hit_count
		pc_bp = hit_count / abs(end - start)
		toPrint = '\t'.join(['\t'.join(ls[:4]), str(pc_bp), str(avg_lvl)])
		toPrint = '\t'.join([toPrint, ','.join(new_hits), ls[5], ls[6], ls[7]])
 		outfile.write(toPrint)
 	outfile.close()

if len(sys.argv) == 1:
	studyExonMethylation(sys.stdin, sys.stdin+'V2') # broken when used in pipe
else:
	with open(sys.argv[1], 'r') as f:
		studyExonMethylation(f, sys.argv[1]+'V2')