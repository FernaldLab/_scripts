#!/bin/bash

# This script takes 5-7 hours to run.

cd ~/Desktop/Katrina

homeFolder="/Users/burtonigenomics/Desktop/Katrina"
readsFolder=$homeFolder"/FilteredReads_v8_NoAdapters"
genomePath=$homeFolder"/H_burtoni_v1.assembly"

SUBJECTS="CGATGT TGACCA TTAGGC"

# rsem-prepare-reference --no-polyA --bowtie2 \
# --gtf $homeFolder/Astatotilapia_burtoni.BROADAB2fix.gtf \
# $genomePath".fa" $genomePath

for s in $SUBJECTS
	do
		echo -e "\n\n\n\n\n\n\n\n############ "$s" ############ \n\n\n\n\n\n\n\n"
		date
		rsem-calculate-expression -p 4 --output-genome-bam --time \
		--bowtie2 --fragment-length-max 5000 --forward-prob 0 \
		--paired-end $readsFolder"/"$s"Reads_Filtered_1.fastq" $readsFolder"/"$s"Reads_Filtered_2.fastq" \
		$genomePath $s"_rsem"
	done