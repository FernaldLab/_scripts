# intersect SNPs with GTF file

cd /Users/ath/Documents/_Fernald_lab/_LYNLEY_RNAseq/snps
# ls
# ATCACG_Rsubread.sam.bam.sorted.bam.snps.raw.vcf		CGATGT_Rsubread.sam.bam.sorted.bam.snps.raw.vcf.idx	TTAGGC_Rsubread.sam.bam.sorted.bam.snps.raw.vcf
# ATCACG_Rsubread.sam.bam.sorted.bam.snps.raw.vcf.idx	TGACCA_Rsubread.sam.bam.sorted.bam.snps.raw.vcf		TTAGGC_Rsubread.sam.bam.sorted.bam.snps.raw.vcf.idx
# CGATGT_Rsubread.sam.bam.sorted.bam.snps.raw.vcf		TGACCA_Rsubread.sam.bam.sorted.bam.snps.raw.vcf.idx

ls | grep vcf$ | \
awk ' 
{
	print "bedtools intersect -a "$0" -b ../../Astatotilapia_burtoni.BROADAB2fix.gtf -wa -wb > "$0"gtfintersect.vcf"
} ' | bash