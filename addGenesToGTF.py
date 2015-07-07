#! /usr/bin/python
import re

def readFilesIntoLists(gtf_file, gene_names_file):
	with open(gtf_file, 'r') as gtf:
		gtflist = list(gtf)
	with open(gene_names_file, 'r') as gene_names:
		genelist = list(gene_names)
	return gtflist, genelist
	
def getGene(gtflist, genelist, id_col=9):
	for l1 in gtflist:
		l1s = l1.split('\t')
		field = l1s[id_col-1].split(';')
		#print field
		if re.search('gene_id', field[0]):
			id = field[0].split(' ')[1].replace('"', '')
			for l2 in genelist:
				l2s = l2.split('\t')
				if l2s[0]==id:
					attr = field
					transcript_id = attr[1].split(' ')[1].replace('"', '')
					new_attr = attr[0] + ';' + attr[1].rstrip('"') + '_' + l2s[2] + '";' + attr[2] + ';' + attr[3]
					print '\t'.join(l1s[:8]) + '\t' + new_attr
		else:
			print l1.strip('\n')

def main():
	(gtflist, genelist) = readFilesIntoLists("/Users/burtonigenomics/Documents/_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.igvsort.gtf", \
											 "/Users/burtonigenomics/Documents/_Burtoni_annotations/geneNamesTree_AB_noNONE.txt")
	getGene(gtflist, genelist)
	
if __name__ == '__main__':
	main()