#! /usr/bin/python
import sys, re

gtf_file = sys.argv[1]
gene_names_file = sys.argv[2]
id_col = int(sys.argv[3])

with open(gtf_file, 'r') as gtf:
	gtflist = list(gtf)
with open(gene_names_file, 'r') as gene_names:
	genelist = list(gene_names)
genedict = {}
for l in genelist:
	ls = l.split('\t')
	if ls[1].strip() == 'NONE':
		genedict[ls[0]] = ls[1].strip()
	else:
		genedict[ls[0]] = ls[2] + '_' + ls[1]

with open(gtf_file.replace('.gtf', '') + '.geneNames.gtf', 'w') as outfile:
	count = 0
	for l1 in gtflist:
		count += 1
		if count % 100000 == 0:
			print count
		l1s = l1.split('\t')
		field = l1s[id_col-1].split(';')
		id = field[0].split(' ')[1].replace('"', '')
		if id in genedict.keys():
			new_attr = field[0] + ';' + field[1].rstrip('"') + '_' + genedict[id] + '";' + field[2] + ';' + field[3] + '\n'
			#outfile.write('\t'.join(l1s[:8]) + '\t' + new_attr)
			outfile.write('\t'.join(l1s[:8]) + '\t' + l1s[15] + '\t' + new_attr)
		else:
			outfile.write(l1)