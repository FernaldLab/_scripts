#! /usr/bin/python
import sys

def get_complement_nuc(nuc):
	if nuc == 'A': return 'T'
	if nuc == 'C': return 'G'
	if nuc == 'G': return 'C'
	if nuc == 'T': return 'A'
	if nuc == 'N': return 'N'
	

with open(sys.argv[1], 'r') as IN:
	with open(sys.argv[1]+'_Gflip', 'w') as OUT:
		for l in IN:
			l = l.split('\t')
			strand = '+'
			nucs = l[5].strip()			
			if len(nucs) != 5:
				print 'Skipping', '\t'.join(l).strip()
				continue
			if nucs[2] == 'G':
				strand = '-'
				nucs_rc = ''
				for b in nucs:
					nucs_rc = nucs_rc + get_complement_nuc(b)
				nucs_rc = nucs_rc[::-1]
				nucsPrint = '\t'.join([nucs, strand, nucs_rc])
			else:
				nucsPrint = '\t'.join([nucs, strand, '.'])
			OUT.write('\t'.join(l[:5]) + '\t' + nucsPrint + '\n')