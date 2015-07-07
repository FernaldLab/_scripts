#!/bin/bash

cd /Users/burtonigenomics/Documents/_methylation

FILES=" /Users/burtonigenomics/Documents/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix_CDS.gtf \
		/Users/burtonigenomics/Documents/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.intron.gtf \
		/Users/burtonigenomics/Documents/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 \
		/Users/burtonigenomics/Documents/_Burtoni_annotations/abur.lnc.final.gtf \
		/Users/burtonigenomics/Documents/_Burtoni_annotations/Abur_final_TE.bed \
		/Users/burtonigenomics/Documents/_Burtoni_annotations/abur_miRNAs-130326.fix.bed \
		/Users/burtonigenomics/Documents/_Burtoni_annotations/Burtoni_cnv_final.out.bed \
		/Users/burtonigenomics/Documents/_Burtoni_annotations/Assembly_SNPs.noHeader.gff3 \
		/Users/burtonigenomics/Documents/_Burtoni_annotations/microsatellites.noHeader.gff3"

SUBJECTS="/Users/burtonigenomics/Desktop/Katrina/_IndelOverrep/IndelOutput.txt.bed_annotatedCGATGT_unique.txt \
          /Users/burtonigenomics/Desktop/Katrina/_IndelOverrep/IndelOutput.txt.bed_annotatedTGACCA_unique.txt \
          /Users/burtonigenomics/Desktop/Katrina/_IndelOverrep/IndelOutput.txt.bed_annotatedTTAGGC_unique.txt"	  

for s in $SUBJECTS
do
	echo "Working on "$s"..."
	for f in $FILES
	do 
		echo "    "$f
		bedtools intersect -a $s -b $f -wo >> $s"_overlap"
	done
done