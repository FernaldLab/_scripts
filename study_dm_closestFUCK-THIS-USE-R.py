#! /usr/bin/python
import os, re

if os.path.exists('no_overlap-3157_vs_3165.filtered.50percent.significant.bed_closest'):
	os.remove('no_overlap-3157_vs_3165.filtered.50percent.significant.bed_closest')

files = list()
for f in os.listdir('.'):
	if re.search('closest$', f):
		files.append(f)

d = {}
for file in files:
	print file
	with open(file , 'r') as f:
		for line in f:
			l = line.split('\t')
			pos = '\t'.join(l[:11])
			closest = '\t'.join(l[11:])
			if pos in d.keys():
				d[pos] = ';;'.join([d[pos], closest])
			else:
				d[pos] = closest
#print d				
with open('no_overlap-3157_vs_3165.filtered.50percent.significant.bed_closest', 'w') as f:
	for h in d.keys():
		hs = d[h].split(';;')
		tmp = list()
		for c in hs:
			if c[0] == '.':
				continue
			else:
				tmp.append(str(c))
		f.write(h + '\t' + str(tmp) + '\n')
		
#with open('no_overlap-3157_vs_3165.filtered.50percent.significant.bed_closest', 'r') as f:
#	l = list(f)
#for line in l:
#	h = line.split('\t')[11]
#	print h.split(', ')