#!/bin/bash

knownSNPs="/Users/burtonigenomics/Documents/_Burtoni_annotations/Assembly_SNPs.noHeader.gff3"
significantGeneIDs="/Users/burtonigenomics/Desktop/Katrina/allSignificantGenes_IDs"
gtf="/Users/burtonigenomics/Desktop/Katrina/Astatotilapia_burtoni.BROADAB2fix.noexons.gtf"
subjPath="/Users/burtonigenomics/Desktop/Katrina/tophat/_filteredRuns"

# awk 'BEGIN{FS="\""}NR==FNR{sigGenes[$1]; next}$2 in sigGenes' $significantGeneIDs $gtf > $significantGeneIDs".gtf"
# bedtools intersect -a $significantGeneIDs".gtf" -b $knownSNPs -wo > $significantGeneIDs".gtf_SNPoverlap"
# bedtools closest -a $significantGeneIDs".gtf" -b $knownSNPs -d -io > $significantGeneIDs".gtf_closestNonoverlappingSNP"

SUBJECTS="ATCACG CGATGT TGACCA TTAGGC"

for s in $SUBJECTS
	do
		snps=$subjPath"/"$s"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf"
		bedtools intersect -a $significantGeneIDs".gtf" -b $snps -wo > $significantGeneIDs".gtf_overlappingSNPsOnly_"$s
		bedtools closest -a $significantGeneIDs".gtf" -b $snps -d > $significantGeneIDs".gtf_closestSNP_"$s
	done