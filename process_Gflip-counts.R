.buildTab = function(counts_matrix) {
	s_names = c();
	for (row in 1:nrow(counts_matrix)) {
		if (grepl('Gflip', counts_matrix[row, 1])) {
			s_names = c(s_names, counts_matrix[row, 1])
		}
	}
	nucs = unique(counts[,2])[unique(counts[,2])!=''];
	mat = matrix(ncol=length(s_names), 
				 nrow=length(nucs),
				 dimnames=list(nucs, s_names)
				 );
	for (row in 1:nrow(counts_matrix)) {
		if (grepl('Gflip', counts_matrix[row, 1])) {
			s = counts_matrix[row, 1];
			next;
		} else {
			mat[match(counts_matrix[row,2], rownames(mat)), match(s, colnames(mat))] = as.numeric(counts_matrix[row, 1]);
		}
	}
	return(mat);
}

.mergeFwdRev = function(vec,s=3,e=4) {
	vec = vec[order(names(vec))];
	v = c();
	for (n in 1:(length(vec)/2)) {
		nuc = substr(names(vec)[n],s,e);
		v = c(v, sum(vec[substr(names(vec),s,e)==nuc]));
		names(v)[n] = substr(names(vec)[n],s,e)
	}
	return(v)
}

setwd('/Volumes/fishstudies/_methylation')
counts=read.table('_wig.bed.nucs_Gflip-counts',header=F,fill=T);
tmp = read.table('../_Burtoni_genome_files/1mer_counts.jf.dump',row.names=1);
mers1 = tmp[,1]; names(mers1) = rownames(tmp); rm(tmp);
tmp = read.table('../_Burtoni_genome_files/2mer_counts.jf.dump',row.names=1);
mers2 = tmp[,1]; names(mers2) = rownames(tmp); rm(tmp);
tmp = read.table('../_Burtoni_genome_files/3mer_counts.jf.dump',row.names=1);
mers3 = tmp[,1]; names(mers3) = rownames(tmp); rm(tmp);

x = as.data.frame(.buildTab(counts));
names(x) = gsub('.wig.bed.nucs_Gflip','',names(x))
x = x[!grepl('N',rownames(x)), ]
x2 = x[nchar(rownames(x))==4,]
x3 = x[nchar(rownames(x))==5,]

x3m = x3[grepl('^m',rownames(x3)),] + x3[grepl('^p',rownames(x3)),];
rownames(x3m) = gsub('m:','',rownames(x3m));

x3mCG = x3m[grep('CG[ACGT]',rownames(x3m)),];
x3mCHG = x3m[grep('C[ACT]G',rownames(x3m)),];
x3mCHH = x3m[grep('C[ACT][ACT]',rownames(x3m)),];

total_hits = apply(x3m,2,sum);
totalCG = apply(x3mCG,2,sum);
totalCHG = apply(x3mCHG,2,sum);
totalCHH = apply(x3mCHH,2,sum);
percentCG = totalCG / total_hits;
percentCHG = totalCHG / total_hits;
percentCHH = totalCHH / total_hits;




countsDM=read.table('3157_vs_3165.filtered.50percent.significant.bed_Gflip-counts',header=F,fill=T);
xDM = countsDM[,1];
names(xDM) = countsDM[,2];
xDM = xDM[!grepl('N',names(xDM)) & !grepl('00',names(xDM))];
xDM2 = xDM[nchar(names(xDM))==4];
xDM3 = xDM[nchar(names(xDM))==5];

par(mfrow=c(2,2));
pie(sort(.mergeFwdRev(xDM2,3,4)),main=paste('DM dinucleotide distribution:\nn=',sum(xDM2),sep=''));

pie(sort(.mergeFwdRev(apply(x2,1,mean),3,4)),main=paste('methylated dinucleotide distribution:\nn=',floor(sum(apply(x2,1,mean))),sep=''));

pie(sort(.mergeFwdRev(xDM3,3,5)),main=paste('DM trinucleotide distribution:\nn=',sum(xDM3),sep=''));

pie(sort(.mergeFwdRev(apply(x3,1,mean),3,5)),main=paste('methylated trinucleotide distribution:\nn=',floor(sum(apply(x3,1,mean))),sep=''));


############
# rownames of mat must be formatted as 'p:NNN' and 'm:NNN'
library(WGCNA);
.verboseBoxplotStrands = function(mat, mfrow=c(3,6)) {
	par(mfrow=mfrow);
	trp = names(table(substr(rownames(mat),3,6)));
	for (tt in trp) {
		verboseBoxplot(unlist(c(mat[trp==tt, ][1,], mat[trp==tt, ][2,])), as.factor(c(rep(rownames(mat[trp==tt, ])[1],4), rep(rownames(mat[trp==tt, ])[2],4))),col='grey',xlab='',ylab='counts')
	}
}

.verboseBoxplotFromMatrix = function(mat,...) {
	g = c();
	for (name in colnames(mat)) {
		g = c(g, rep(name, 4));
	}
	verboseBoxplot(as.vector(mat),as.factor(g),col='grey',xlab='',ylab='meth.hits',...);
}

# x3CG = x3[grep('[mp]:CG[ACGT]',rownames(x3)),];
# x3CHG = x3[grep('[mp]:C[ACT]G',rownames(x3)),];
# x3CHH = x3[grep('[mp]:C[ACT][ACT]',rownames(x3)),];

# x3CGmerge = x3CG[grepl('^m',rownames(x3CG)),] + x3CG[grepl('^p',rownames(x3CG)),];
# rownames(x3CGmerge) = gsub('m:','',rownames(x3CGmerge));
# x3CHGmerge = x3CHG[grepl('^m',rownames(x3CHG)),] + x3CHG[grepl('^p',rownames(x3CHG)),];
# rownames(x3CHGmerge) = gsub('m:','',rownames(x3CHGmerge));
# x3CHHmerge = x3CHH[grepl('^m',rownames(x3CHH)),] + x3CHH[grepl('^p',rownames(x3CHH)),];
# rownames(x3CHHmerge) = gsub('m:','',rownames(x3CHHmerge));