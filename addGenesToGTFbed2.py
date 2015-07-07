#! /usr/bin/python

def readFilesIntoLists(gtf_bed_file, gene_names_file):
	with open(gtf_bed_file, 'r') as gtf_bed:
		gtf_bedlist = list(gtf_bed)
	with open(gene_names_file, 'r') as gene_names:
		genelist = list(gene_names)
	return gtf_bedlist, genelist
	
def getGene(gtf_bedlist, genelist, id_col=4):
	for l1 in gtf_bedlist:
		l1s = l1.split('\t')
		id = l1s[id_col-1]
		for l2 in genelist:
			l2s = l2.split('\t')
			if id==l2s[0]:
				new = l1s[9].strip('\n') + ' gene_sym "' + l2s[2] + '"; gene_name "' + l2s[3].strip('\n') + '"'
				print '\t'.join(l1s[:9]) + '\t' + new
				
def getGene2(gtf_bedlist, genelist, id_col=4):
	for l1 in gtf_bedlist:
		l1s = l1.split('\t')
		id = l1s[id_col-1]
		for l2 in genelist:
			l2s = l2.split('\t')
			if id==l2s[0]:
				print '\t'.join(l1s[:3]) + '\t' + l2s[2] + '\t' + '\t'.join(l1s[4:]).strip('\n')

def main():
	(gtf_bedlist, genelist) = readFilesIntoLists("Astatotilapia_burtoni.BROADAB2.gtf.bed", "geneNamesTree_AB_noNONE")
	#getGene(gtf_bedlist, genelist)
	getGene2(gtf_bedlist, genelist)
	
if __name__ == '__main__':
	main()