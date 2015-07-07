#! /usr/bin/python
import sys

scaffold = ''	
with open(sys.argv[1], 'r') as IN:
	with open(sys.argv[1]+'.wig', 'w') as OUT:
		OUT.write('track type=wiggle_0\n')
		for l in IN:
			l = l.split('\t')
			positionAndValue = l[1] + '\t' + l[4] + '\n'
			if scaffold == '':
				OUT.write('variableStep chrom=' + l[0] + '\n')
				OUT.write(positionAndValue)
				scaffold = l[0]
				continue
			if l[0] != scaffold:
				OUT.write('variableStep chrom=' + l[0] + '\n')
				OUT.write(positionAndValue)
				scaffold = l[0]
			else:
				OUT.write(positionAndValue)