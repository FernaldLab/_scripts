#! /usr/bin/python
import sys

# sys.argv[1] must be output from studyExonMethylation-parseForR.py, 
#    e.g. 3157.wig.bed-GTF.hitCDSfor_groupBy_groupedV2_forR
# sys.argv[2] must be base filename for up/downstream, overlap, no_hit files,
#    e.g. ../../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix_CDS_exon1uniq_closestTE.gtf

with open(sys.argv[1], 'r') as f:
	m = list(f)
refs = list()
for file in ['upstream', 'downstream', 'overlap', 'no_hit']:
	with open(sys.argv[2] + '.' + file, 'r') as f:
		d = {}
		for line in f:
			l = line.split('\t')
			d[':'.join([l[0], l[3], l[4]])] = line 
		refs.append(d)
#for r in refs