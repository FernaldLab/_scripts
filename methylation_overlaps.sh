#!/bin/bash

#### methylation pipeline ####

## start with "3157_vs_3165.filtered.50percent.significant.bed"
cd ~/Documents/_Fernald_lab/_methylation

### get overlap with different features ###
## exons ##
echo GTF-exons
bedtools intersect \
-a 3157_vs_3165.filtered.50percent.significant.bed \
-b ../Astatotilapia_burtoni.BROADAB2fix.gtf \
-wao \
> 3157_vs_3165.filtered.50percent.significant.bed-GTF

## introns ##
echo GTF-introns
bedtools intersect \
-a 3157_vs_3165.filtered.50percent.significant.bed \
-b ../Astatotilapia_burtoni.BROADAB2fix.intron.gtf \
-wo > 3157_vs_3165overlaps/overlap_GTF-intron

## UTRs ##
echo GFF-UTRs
bedtools intersect \
-a 3157_vs_3165.filtered.50percent.significant.bed \
-b ../Astatotilapia_burtoni.BROADAB1.UTRs.gff3 \
-wao \
> 3157_vs_3165.filtered.50percent.significant.bed-UTRs

## splice junctions ##
echo splice junctions
bedtools intersect \
-a 3157_vs_3165.filtered.50percent.significant.bed \
-b /Users/ath/Documents/_Fernald_lab/_LYNLEY_RNAseq/tophatOUT/GTF/orig/ATCACG/junctions.bed \
-wao \
> 3157_vs_3165.filtered.50percent.significant.bed-3157junctions

bedtools intersect \
-a 3157_vs_3165.filtered.50percent.significant.bed \
-b /Users/ath/Documents/_Fernald_lab/_LYNLEY_RNAseq/tophatOUT/GTF/orig/CGATGT/junctions.bed \
-wao \
> 3157_vs_3165.filtered.50percent.significant.bed-3165junctions

## lncRNAs ##
echo lncs
bedtools intersect \
-a 3157_vs_3165.filtered.50percent.significant.bed \
-b ../_broadftp/Annotation/lncRNA/abur.lnc.final.gtf \
-wao \
> 3157_vs_3165.filtered.50percent.significant.bed-LNC

## transposons ##
echo TEs
bedtools intersect \
-a 3157_vs_3165.filtered.50percent.significant.bed \
-b ../_broadftp/Annotation/TE/Abur_final_TE.bed \
-wao \
> 3157_vs_3165.filtered.50percent.significant.bed-TE

## miRNAs ##
echo miRNAs
bedtools intersect \
-a 3157_vs_3165.filtered.50percent.significant.bed \
-b ../abur_miRNAs-130326.bed \
-wao \
> 3157_vs_3165.filtered.50percent.significant.bed-miRNAs

## cuffdiff output in bed file format ##
echo DE genes
# bedtools intersect \
# -a 3157_vs_3165.filtered.50percent.significant.bed \
# -b /Volumes/FishStudies/_LYNLEY_RNAseq/cuffdiff/cuffdiffOUT/gene_exp.diff.significant.common.bed \
# -wao \
# > 3157_vs_3165.filtered.50percent.significant.bed-DE
# 
# bedtools intersect \
# -a 3157_vs_3165.filtered.50percent.significant.bed \
# -b /Volumes/FishStudies/_LYNLEY_RNAseq/cuffdiff/cuffdiffOUT_markedDuplicates/gene_exp.diff.significant.bed \
# -wao \
# > 3157_vs_3165.filtered.50percent.significant.bed-DE_mDup
# 
# bedtools intersect \
# -a 3157_vs_3165.filtered.50percent.significant.bed \
# -b /Volumes/FishStudies/_LYNLEY_RNAseq/cuffdiff/cuffdiffOUT/gene_exp.diff.significant.bed \
# -wao \
# > 3157_vs_3165.filtered.50percent.significant.bed-DE_allDup

bedtools intersect \
-a 3157_vs_3165.filtered.50percent.significant.bed \
-b ../_gatkbp_backup/cuffdiff_postRealign_bqsr_fa/gene_exp.diff.sig.bed \
-wo > 3157_vs_3165overlaps/overlap_DE-postRealign_bqsr_fa

## CNV ##
echo CNV
bedtools intersect \
-a 3157_vs_3165.filtered.50percent.significant.bed \
-b ../_broadftp/cnv/Burtoni/Burtoni_cnv_final.out.bed \
-wao \
> 3157_vs_3165.filtered.50percent.significant.bed-CNV

## SNPs ##
# echo SNPs
# bedtools intersect \
# -a 3157_vs_3165.filtered.50percent.significant.bed \
# -b ../_LYNLEY_RNAseq/snps/ATCACG_Rsubread.sam.bam.sorted.bam.snps.raw.vcf \
# -wao \
# > 3157_vs_3165.filtered.50percent.significant.bed-SNP-3157
# 
# bedtools intersect \
# -a 3157_vs_3165.filtered.50percent.significant.bed \
# -b ../_LYNLEY_RNAseq/snps/CGATGT_Rsubread.sam.bam.sorted.bam.snps.raw.vcf \
# -wao \
# > 3157_vs_3165.filtered.50percent.significant.bed-SNP-3165

# redo individual SNPs overlap
echo individual_SNPs
echo 3157
bedtools intersect \
-a 3157_vs_3165.filtered.50percent.significant.bed \
-b ../_gatkbp_backup/tophat/ATCACG/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf \
-wo > 3157_vs_3165overlaps/overlap_SNP-3157

echo 3165
bedtools intersect \
-a 3157_vs_3165.filtered.50percent.significant.bed \
-b ../_gatkbp_backup/tophat/CGATGT/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf \
-wo > 3157_vs_3165overlaps/overlap_SNP-3165

## Assembly SNPs ##
bedtools intersect \
-a 3157_vs_3165.filtered.50percent.significant.bed \
-b Assembly_SNPs.noHeader.gff3 \
-wao \
> 3157_vs_3165.filtered.50percent.significant.bed-SNP-Assembly

## microsatellites ##
bedtools intersect \
-a 3157_vs_3165.filtered.50percent.significant.bed \
-b microsatellites.noHeader.gff3 \
-wao \
> 3157_vs_3165.filtered.50percent.significant.bed-microsatellites


### get sites that are DM in more than one comparison (3157v3165, 3157v3581, 3165v3677, 3581v3677)
# see R code methylation_overlap.R for generation of starting file dm_multiple
awk '{split($1, a, ":"); s=a[2]-1; print ""a[1]"\t"s"\t"a[2]""}' dm_multiple > dm_multiple.bed

bedtools intersect \
-a dm_multiple.bed \
-b ../_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf \
-wao \
> dm_multiple.bed.GTFoverlap

awk 'BEGIN{FS="\t"} $13>0' dm_multiple.bed.GTFoverlap > dm_multiple.bed.GTFoverlap.hit


### SNPs after BQSR
ls ~/Documents/gatkbp/tophat/ | awk '{print "echo "$1";bedtools intersect -a 3157_vs_3165.filtered.50percent.significant.bed -b ~/Documents/gatkbp/tophat/"$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf -wao > 3157_vs_3165.filtered.50percent.significant.bed-SNP_"$1"_bqsr"}'
ls ~/Documents/gatkbp/tophat/ | awk '{print "echo "$1";bedtools intersect -a dm_multiple.bed -b ~/Documents/gatkbp/tophat/"$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf -wao > dm_multiple.bed-SNP_"$1"_bqsr"}'

ls | grep bqsr$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $12>1'\'' "$1" > "$1"Filt"}'
ls | grep bqsrFilt$ | awk '{print "echo "$1"; awk '\''END{print NR}'\'' "$1"; head "$1""}' | bash