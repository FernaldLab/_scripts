#!/bin/bash
cd /Users/burtonigenomics/Documents/_Burtoni_annotations

# remove lines that aren't genomic intervals
awk '/^NW/' ref_AstBur1.0_scaffolds.gff3 \
> ref_AstBur1.0_scaffolds.clean.gff3

# make file of "regions" to compare to scaffolds
awk '$3=="region"' ref_AstBur1.0_scaffolds.clean.gff3 \
> NW.scaffolds

# use scaffold lengths to match scaffold number to region name
awk 'FNR==NR{a[$5]=$1;next}$2 in a{print a[$2]"\t"$1}' \
NW.scaffolds ../_Burtoni_genome_files/H_burtoni_v1.assembly.fa.fai \
> NW.scaffolds.translate

# make translated file
awk 'FNR==NR{a[$1]=$2;next}$1 in a{print a[$1]"\t"$0}' \
NW.scaffolds.translate ref_AstBur1.0_scaffolds.clean.gff3 | \
cut -f1,3- \
> ref_AstBur1.0_scaffolds.clean.translate.gff3

# get rid of lines with "region" in 3rd field
awk '$3!="region"' ref_AstBur1.0_scaffolds.clean.translate.gff3 \
> ref_AstBur1.0_scaffolds.clean.translate.final.gff3

### investigate rest of features to potentially filter out more lines
wc -l ref_AstBur1.0_scaffolds.clean.translate.final.gff3
# 1098351

cut -f2 ref_AstBur1.0_scaffolds.clean.translate.final.gff3 | sort | uniq -c
# 1095862 Gnomon
#  	  855 RefSeq
#    1634 tRNAscan-SE

cut -f3 ref_AstBur1.0_scaffolds.clean.translate.final.gff3 | sort | uniq -c
# 491100 CDS
#     31 C_gene_segment
#    170 V_gene_segment
#    732 cDNA_match
# 534642 exon
#  26458 gene
#  41482 mRNA
#    123 match
#    561 tRNA
#   3052 transcript

awk '{print $2":"$3}' ref_AstBur1.0_scaffolds.clean.translate.final.gff3 | sort | uniq -c
# 491100 Gnomon:CDS
#     31 Gnomon:C_gene_segment
#    170 Gnomon:V_gene_segment
# 534081 Gnomon:exon
#  25946 Gnomon:gene
#  41482 Gnomon:mRNA
#   3052 Gnomon:transcript
#    732 RefSeq:cDNA_match
#    123 RefSeq:match
#    561 tRNAscan-SE:exon
#    512 tRNAscan-SE:gene
#    561 tRNAscan-SE:tRNA

# get exon intervals
awk '$3=="exon"{print $1":"$4"-"$5}' ref_AstBur1.0_scaffolds.clean.translate.final.gff3 | sort | uniq \
> ref_AstBur1.0_scaffolds.clean.translate.final.gff3.intervals

awk '{split($0,a,"-"); print a[1]}' ref_AstBur1.0_scaffolds.clean.translate.final.gff3.intervals | sort | uniq  \
> ref_AstBur1.0_scaffolds.clean.translate.final.gff3.intervalsStart

awk '$3=="exon"{print $1"\t"$4"\t"$5}' ref_AstBur1.0_scaffolds.clean.translate.final.gff3 | sort | uniq \
> ref_AstBur1.0_scaffolds.clean.translate.final.gff3.intervals.bed

# get intervals from Broad gtf file of coding sequences
awk '{print $1":"$4"-"$5}' Astatotilapia_burtoni.BROADAB2.gtf | sort | uniq \
> Astatotilapia_burtoni.BROADAB2.gtf.intervals

awk '{split($0,a,"-"); print a[1]}' Astatotilapia_burtoni.BROADAB2.gtf.intervals | sort | uniq  \
> Astatotilapia_burtoni.BROADAB2.gtf.intervalsStart

awk '{print $1"\t"$4"\t"$5}' Astatotilapia_burtoni.BROADAB2.gtf | sort | uniq \
> Astatotilapia_burtoni.BROADAB2.gtf.intervals.bed

wc -l ref_AstBur1.0_scaffolds.clean.translate.final.gff3.intervals
# 279806

wc -l Astatotilapia_burtoni.BROADAB2.gtf.intervals 
# 242938

bedtools intersect \
-a ref_AstBur1.0_scaffolds.clean.translate.final.gff3.intervals.bed \
-b Astatotilapia_burtoni.BROADAB2.gtf.intervals.bed \
-wao \
> exon_interval_intersects


bedtools intersect \
-a ref_AstBur1.0_scaffolds.clean.translate.final.gff3.intervals.bed \
-b Astatotilapia_burtoni.BROADAB2.gtf.intervals.bed \
-f 0.5 -wao \
> exon_interval_intersects-f.5

#################################

# edit existing TE and lncRNA annotation files to merge with new gff for realignment and counting with htseq
cut -f1-8 Abur_final_TE.gtf | awk 'BEGIN{FS="\t"}{print $0"\tgene="$3"_"$1":"$4"-"$5}' \
> Abur_final_TE_forHTSeq.gtf

awk 'BEGIN{FS="\t"}{gsub(/gene_id \"/,"gene=");gsub(/\"; tr/,"; tr");print}' abur.lnc.final.gtf \
> abur.lnc.final_forHTSeq.gtf

cp ref_AstBur1.0_scaffolds.clean.translate.final.gff3 ref_AstBur1.0_scaffolds.clean.translate.final.combo.gff3
cat Abur_final_TE_forHTSeq.gtf >> ref_AstBur1.0_scaffolds.clean.translate.final.combo.gff3
cat abur.lnc.final_forHTSeq.gtf >> ref_AstBur1.0_scaffolds.clean.translate.final.combo.gff3


##################################
# get gene %GC and length for cqn
bedtools nuc \
-s \
-fi ../_Burtoni_genome_files/H_burtoni_v1.assembly.fa \
-bed ../_Burtoni_annotations/ref_AstBur1.0_scaffolds.clean.translate.final.combo.gff3 \
> ../_Burtoni_annotations/ref_AstBur1.0_scaffolds.clean.translate.final.combo.gff3_bedtools_nuc

awk 'BEGIN{FS="\t"}$3=="gene" && /LOC/{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$11"\t"$18}' \
../_Burtoni_annotations/ref_AstBur1.0_scaffolds.clean.translate.final.combo.gff3_bedtools_nuc \
> ../_Burtoni_annotations/ref_AstBur1.0_scaffolds.clean.translate.final.combo.gff3_bedtools_nucLOC

##################################