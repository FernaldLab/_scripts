#! /usr/bin/python

def readFiles(generic_file_with_gene_ids, gene_names_file):
	with open(generic_file_with_gene_ids, 'r') as f1:
		idlist = list(f1)
	with open(gene_names_file, 'r') as f2:
		genelist = list(f2)
	genedict = dict()
	for l in genelist:
		genedict[l.split('\t')[0]] = l.split('\t')[1:]
	return idlist, genedict
	
def getIDs(idlist, genedict, outfilename, id_field, field_sep='\t'):
	#print genedict.values()
	with open(outfilename, 'w') as out:
		for idl in idlist:
			idlspl = idl.split(field_sep)
			this_id = idlspl[id_field-1].split(';')[0].split(' ')[1].replace('"', '')
			if this_id in genedict.keys():
				this_gene = genedict[this_id]
				#print this_gene
			else:
				this_gene = list(['NO ANNOTATION', 'NO ANNOTATION', 'NO ANNOTATION\n'])
			toWrite = idl.strip('\n') + '\t' + '\t'.join(this_gene)
			out.write(toWrite)

def main():
	idlist, genedict = readFiles('3157_vs_3165.filtered.50percent.significant.gtfintersect.bed', '../geneNamesTree_AB_noNONE')
	getIDs(idlist, genedict, '3157_vs_3165.filtered.50percent.significant.gtfintersect_with_genes.bed', id_field=20, field_sep='\t')

if __name__ == '__main__':
	main()