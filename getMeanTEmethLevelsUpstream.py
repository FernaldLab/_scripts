#! /usr/bin/python
import sys
# sys.argv[1] should be TE hit file, eg 3157.wig.bed-TEs.hit
# sys.argv[2] should be Abur_final_TE.bed.closestCDSstranded.upstream_uniq

# read hit file into list
with open(sys.argv[1], 'r') as f_hit:
	l = list(f_hit)

# read upstream ids into set
upstream_ids = set()
with open(sys.argv[2], 'r') as f_up:
	for line in f_up:
		ls = line.strip('\n').split('\t')
		upstream_ids.add('\t'.join(ls[:3]))

# initialize variables to hold methylation levels and ids (to avoid duplicates)
lvl = 0
lvlCount = 0
lvl_up = 0
lvl_upCount = 0
lvl_incl_dupes = 0
m_ids = set()

# iterate through lines in hit file list
for line in l:

	# split line to get id and methylation level
	ls = line.split('\t')
	this_m_id = '\t'.join(ls[:3])
	this_id = '\t'.join(ls[5:8])
	this_lvl = float(ls[4])
	
	# check if m_id has already been added
	if this_m_id not in m_ids:
		
		# check whether id is in upstream ids
		if this_id in upstream_ids:
			
			lvl_up += this_lvl
			lvl_upCount += 1
		else:
			lvl += this_lvl
			lvlCount += 1
	
	m_ids.add(this_m_id)
	lvl_incl_dupes += this_lvl
	
print lvl_incl_dupes / len(l), lvl / lvlCount, lvl_up / lvl_upCount
#print 'no upstream:', lvl / lvlCount
#print 'upstream:', lvl_up / lvl_upCount