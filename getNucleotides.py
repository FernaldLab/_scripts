#! /usr/bin/python
import re
# needs fasta file where nucs for each scaffold are only on 1 line
def readFiles(fafile, wigfile):
	with open(fafile, 'r') as fa:
		lf = list(fa)
	i = iter(lf)
	df = dict(zip(i, i))
	with open(wigfile, 'r') as wig:
		lw = list(wig)
	return df, lw
	
def getNucs(df, lw, outfilename, interval=(2,2)):
	with open(outfilename, 'w') as out:
		for line in lw:
			if re.search('scaffold', line):
				scaffold = line.replace('variableStep chrom=', '')
				#print scaffold
				#print df.keys()
				letters = df['>'+scaffold].strip('\n')
				#print letters[:20]
			if re.search('^[0-9]', line):
				pos = int(line.split('\t')[0])
				pos0 = pos-1
				if pos0-interval[0] < 0:
					BOS, tag = True, 'start_of_scaffold'
					begin, end = 0, pos0+interval[1]
				elif pos0+interval[1] > len(letters)-1:
					EOS, tag = True, 'end_of_scaffold'
					begin, end = pos0-interval[0], len(letters)-1
				else:
					BOS, EOS, tag = False, False, 'NA'
					begin, end = pos0-interval[0], pos0+interval[1]
				val = line.split('\t')[1].strip('\n')
				toPrint = scaffold.strip('\n') + '\t' + str(pos) + '\t' + val + '\t' + letters[begin:end+1] + '\t' + tag + '\n'
				#print toPrint
				out.write(toPrint)

def main():
	(df, lw) = readFiles('/Volumes/fishstudies/_Burtoni_genome_files/H_burtoni_v1.assembly.fa.1line.fa', '/Volumes/fishstudies/_methylation/3157.wig')
	getNucs(df, lw, '/Users/burtonigenomics/Documents/_LYNLEY_RNAseq/3157.wig.nucs')
	
	(df, lw) = readFiles('/Volumes/fishstudies/_Burtoni_genome_files/H_burtoni_v1.assembly.fa.1line.fa', '/Volumes/fishstudies/_methylation/3165.wig')
	getNucs(df, lw, '/Users/burtonigenomics/Documents/_LYNLEY_RNAseq/3165.wig.nucs')
	
	(df, lw) = readFiles('/Volumes/fishstudies/_Burtoni_genome_files/H_burtoni_v1.assembly.fa.1line.fa', '/Volumes/fishstudies/_methylation/3581.wig')
	getNucs(df, lw, '/Users/burtonigenomics/Documents/_LYNLEY_RNAseq/3581.wig.nucs')
	
	(df, lw) = readFiles('/Volumes/fishstudies/_Burtoni_genome_files/H_burtoni_v1.assembly.fa.1line.fa', '/Volumes/fishstudies/_methylation/3677.wig')
	getNucs(df, lw, '/Users/burtonigenomics/Documents/_LYNLEY_RNAseq/3677.wig.nucs')

if __name__ == '__main__':
	main()