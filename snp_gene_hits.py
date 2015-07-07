#! /usr/bin/python

#################################################
# cd /Volumes/fishstudies/_gatkbp_backup/tophat
# # get gene hits
# ls | while read stdin; \
# do echo $stdin; \
# bedtools intersect \
# -a $stdin/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf \
# -b ../../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.geneNames.gtf \
# -wo \
# > $stdin/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf.geneNames.gtf.hits; \
# done
##################################################

import sys, re

ND = ['ATCACG', 'TGACCA']
D = ['CGATGT', 'TTAGGC']

# read in hit files and assign groups
biglist = list()
grp_assign = list()
for f in sys.argv[1:]:
	print 'reading', f, '...'
	with open(f, 'r') as ff:
		biglist.append(list(ff))
		if f.split('/')[0] in ND:
			print '    assigned to ND'
			grp_assign.append('ND')
		elif f.split('/')[0] in D:
			print '    assigned to D'
			grp_assign.append('D')
		else:
			print 'UNKNOWN GROUP:', f
			sys.exit()
			
# get indices of group assignments
iND = [i for i in range(len(grp_assign)) if grp_assign[i] == 'ND']
iD = [i for i in range(len(grp_assign)) if grp_assign[i] == 'D']

# get genes for each file
geneslist = list()
for l in range(len(biglist)):
	s = set()
	for line in biglist[l]:
		s.add(re.findall('gene_id "(ab.gene.s[0-9]+.[0-9]+)"', line)[0])
	geneslist.append(s)
	print grp_assign[l] + ':', len(s), 'genes'

# get ND common genes
print '\ngetting genes common to ND samples ...'
NDgenes = geneslist[iND[0]]
print '    start with', len(NDgenes)
for i in iND[1:]:
	NDgenes = NDgenes & geneslist[i]
	print '    filter to', len(NDgenes) 

# remove ND genes that are in either D sample
print 'removing ND genes that are in either D sample ...'
for i in iD:
	NDgenes = NDgenes - geneslist[i]
	print '    filtered to', len(NDgenes)
#print 'ND genes left:\n', NDgenes

# filter ND input files based on NDgenes
print 'writing filtered input files ...'
for i in iND:
	print '   ', sys.argv[i+1] + 'NDonly'
	with open(sys.argv[i+1] + 'NDonly', 'w') as out:
		for line in biglist[i]:
			this_gene = re.findall('gene_id "(ab.gene.s[0-9]+.[0-9]+)"', line)[0]
			if this_gene in NDgenes:
				out.write(line)

# get D common genes
print '\ngetting genes common to D samples ...'
Dgenes = geneslist[iD[0]]
print '    start with', len(Dgenes)
for i in iD[1:]:
	Dgenes = Dgenes & geneslist[i]
	print '    filtered to', len(Dgenes) 

# remove D genes that are in either ND sample
print 'removing D genes that are in either ND sample ...'
for i in iND:
	Dgenes = Dgenes - geneslist[i]
	print '    filter to', len(Dgenes)
#print 'D genes left:\n', Dgenes

# filter D input files based on Dgenes
print 'writing filtered input files ...'
for i in iD:
	print '   ', sys.argv[i+1] + 'Donly'
	with open(sys.argv[i+1] + 'Donly', 'w') as out:
		for line in biglist[i]:
			this_gene = re.findall('gene_id "(ab.gene.s[0-9]+.[0-9]+)"', line)[0]
			if this_gene in Dgenes:
				out.write(line)
				
#########################################################


## add back vcf headers
# ls | grep '^AT\|^TG' | \
# while read stdin; \
# do \
# 	echo $stdin; \
# 	awk '/^#/' $stdin/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf > $stdin/vcfHEADER; \
# 	cut -f1-10 $stdin/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf.geneNames.gtf.hitsNDonly | \
# 		cat $stdin/vcfHEADER - \
# 		> $stdin/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf.geneNames.gtf.hitsNDonlyHeader.vcf; \
# done
# 
# 
# ls | grep '^TT\|^CG' | \
# while read stdin; \
# do \
# 	echo $stdin; \
# 	awk '/^#/' $stdin/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf > $stdin/vcfHEADER; \
# 	cut -f1-10 $stdin/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf.geneNames.gtf.hitsDonly | \
# 		cat $stdin/vcfHEADER - \
# 		> $stdin/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf.geneNames.gtf.hitsDonlyHeader.vcf; \
# done

### in R
setwd('/Volumes/fishstudies/_gatkbp_backup/tophat/');
x = list();
files = c('ATCACG/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf.geneNames.gtf.hitsNDonly',
		  'TGACCA/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf.geneNames.gtf.hitsNDonly',
		  'CGATGT/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf.geneNames.gtf.hitsDonly',
		  'TTAGGC/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf.geneNames.gtf.hitsDonly'
		  );
for (f in 1:length(files)) {
	x[[f]] = read.table(files[f], header=F, sep='\t');
	x[[f]] = x[[f]][x[[f]]$V13=='CDS', ];
	names(x)[f] = substring(files[f], 1, 6);
}; rm(f);

NDsnps = intersect(paste(x$ATCACG$V1, x$ATCACG$V2),paste(x$TGACCA$V1, x$TGACCA$V2));
x$ATCACG = x$ATCACG[paste(x$ATCACG$V1, x$ATCACG$V2) %in% NDsnps, ];
x$TGACCA = x$TGACCA[paste(x$TGACCA$V1, x$TGACCA$V2) %in% NDsnps, ];

Dsnps = intersect(paste(x$CGATGT$V1, x$CGATGT$V2),paste(x$TTAGGC$V1, x$TTAGGC$V2));
x$CGATGT = x$CGATGT[paste(x$CGATGT$V1, x$CGATGT$V2) %in% Dsnps, ];
x$TTAGGC = x$TTAGGC[paste(x$TTAGGC$V1, x$TTAGGC$V2) %in% Dsnps, ];

x2 = lapply(x, function(f) f[, -c(8,20)]);

nd = cbind(x2$ATCACG, x2$TGACCA);
colnames(nd) = paste('V', 1:ncol(nd), sep='');
if (sum(paste(nd[,1],nd[,2]) == paste(nd[,19],nd[,20])) == nrow(nd)) {
	nd2 = cbind(nd[,1:6], nd[,24], (nd$V6+nd$V24)/2, nd[,8:9], nd[,27], nd[,10:18]);
}
nd2 = nd2[order(nd2[,8],decreasing=T), ];


d = cbind(x2$CGATGT, x2$TTAGGC);
colnames(d) = paste('V', 1:ncol(d), sep='');
if (sum(paste(d[,1],d[,2]) == paste(d[,19],d[,20])) == nrow(d)) {
	d2 = cbind(d[,1:6], d[,24], (d$V6+d$V24)/2, d[,8:9], d[,27], d[,10:18]);
}
d2 = d2[order(d2[,8],decreasing=T), ];



# asnps = read.table('../../_Burtoni_annotations/Assembly_SNPs.noHeader.gff3');
# asnps = asnps[, -c(2:4,6:8)];
# 
# nd2 = cbind(nd2, paste(nd2$V1,nd2$V2) %in% paste(asnps$V1,asnps$V5));
# colnames(nd2) = paste('V', 1:ncol(nd2), sep='');
# d2 = cbind(d2, paste(d2$V1,d2$V2) %in% paste(asnps$V1,asnps$V5));
# colnames(d2) = paste('V', 1:ncol(d2), sep='');

# write.table(nd2[order(nd2$V1,nd2$V2,-nd2$V8),], file='NDsharedSNPs.csv', col.names=F, row.names=F, quote=F, sep='\t');
# write.table(d2[order(d2$V1,d2$V2,-d2$V8),], file='DsharedSNPs.csv', col.names=F, row.names=F, quote=F, sep='\t');