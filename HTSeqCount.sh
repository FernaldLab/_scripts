#!/bin/bash

homeFolder="/Users/burtonigenomics/Desktop/Katrina"


SUBJECTS="CGATGT TGACCA TTAGGC"

# This script takes 2-4 hours to run.

# for s in $SUBJECTS
# 	do
# 		cd $homeFolder"/tophat/_filteredRuns/"$s
# 		echo -e "\n\n\n\n\n\n\n\n############ "$s" ############ \n\n\n\n\n\n\n\n"
# 		date
# 		samtools view -h $homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits.namesorted.bam" |
# 		htseq-count -m union -s reverse - ../ATCACG/accepted_hits.bam.cufflinksStranded.v4.sorted.gtf > \
# 		$s"_ATCACGnewannotations_v3_HTSeq_counts.txt"
# 	done
# 
# date
# 
# # v2 - ../ATCACG/accepted_hits.bam.cufflinksStranded.v4
# 
# SUBJECTS="ATCACG"
# 
# # This script takes 2-4 hours to run.
# 
# for s in $SUBJECTS
# 	do
# 		cd $homeFolder"/tophat/_filteredRuns/"$s
# 		echo -e "\n\n\n\n\n\n\n\n############ "$s" ############ \n\n\n\n\n\n\n\n"
# 		date
# 		samtools view -h $homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits.namesorted.bam.bam" |
# 		htseq-count -m union -s reverse - ../ATCACG/accepted_hits.bam.cufflinksStranded.v4.sorted.gtf > \
# 		$s"_ATCACGnewannotations_v3_HTSeq_counts.txt"
# 	done
# 
# date





SUBJECTS="CGATGT TGACCA TTAGGC"

# This script takes 2-4 hours to run.

for s in $SUBJECTS
	do
		cd $homeFolder"/tophat/_filteredRuns/"$s
		echo -e "\n\n\n\n\n\n\n\n############ "$s" ############ \n\n\n\n\n\n\n\n"
		date
		samtools view -h $homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits.namesorted.bam" |
		htseq-count -m union -s reverse - ../CGATGT/accepted_hits.bam.cufflinksStranded.v4.notATCACG.gtf > \
		$s"_CGATGTnewannotations_v2_HTSeq_counts.txt"
	done

date



SUBJECTS="ATCACG"

# This script takes 2-4 hours to run.

for s in $SUBJECTS
	do
		cd $homeFolder"/tophat/_filteredRuns/"$s
		echo -e "\n\n\n\n\n\n\n\n############ "$s" ############ \n\n\n\n\n\n\n\n"
		date
		samtools view -h $homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits.namesorted.bam.bam" |
		htseq-count -m union -s reverse - ../CGATGT/accepted_hits.bam.cufflinksStranded.v4.notATCACG.gtf > \
		$s"_CGATGTnewannotations_v2_HTSeq_counts.txt"
	done

date
#try changing strandedness - cufflinks annotations might be backwards



# SUBJECTS="ATCACG"
# 
# # This script takes 2-4 hours to run.
# 
# for s in $SUBJECTS
# 	do
# 		echo -e "\n\n\n\n\n\n\n\n############ "$s" ############ \n\n\n\n\n\n\n\n"
# 		date
# 		samtools view -h $homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits.namesorted.bam.bam" |
# 		htseq-count -m union -s reverse -o $homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits.namesorted.bam.bam_HTSeqCountAssignments" \
# 		- \
# 		$homeFolder"/Astatotilapia_burtoni.BROADAB2fix.gtf" > $homeFolder"/tophat/_filteredRuns/"$s"/"$s"_HTSeq_counts.txt"
# 	done
# 
# date
# 
# 
# 
# 
# SUBJECTS="CGATGT TGACCA TTAGGC"
# 
# # This script takes 2-4 hours to run.
# 
# for s in $SUBJECTS
# 	do
# 		echo -e "\n\n\n\n\n\n\n\n############ "$s" ############ \n\n\n\n\n\n\n\n"
# 		date
# # 		samtools sort -n $homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits.bam" $homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits.namesorted"
# 		samtools view -h $homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits.namesorted.bam" |
# 		htseq-count -m union -s reverse -o $homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits.namesorted.bam_HTSeqCountAssignments" \
# 		- \
# 		$homeFolder"/Astatotilapia_burtoni.BROADAB2fix.gtf" > $homeFolder"/tophat/_filteredRuns/"$s"/"$s"_HTSeq_counts.txt"
# 	done
# 
# date
