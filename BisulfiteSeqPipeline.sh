#!/bin/bash

cd /Users/burtonigenomics/Documents/BSseeker2-master


homeFolder="/Users/burtonigenomics/Desktop/Katrina"
readsFolder=$homeFolder"/BisulfiteData"

#SUBJECTS="TGACCA TTAGGC" # "ATCACG CGATGT"
# filteromePath=$homeFolder"/pileupRegionIGV_manual_v8.bed.collapsed"
# filteredReadsFolder=$homeFolder"/FilteredReads_v8_NoAdapters"
# genomePath=$homeFolder"/H_burtoni_v1.assembly"
# remoteStorage="/Volumes/fishstudies/Katrina/storage/Filter_v8_NoAdapters"
# # uncompressedReadsFolder="/Volumes/fishstudies/_LYNLEY_RNAseq/data" It used to be this.
# uncompressedReadsFolder=$homeFolder"/fastq"


# python bs_seeker2-build.py \
# --aligner=bowtie2 -d $homeFolder \
# -f $homeFolder"/H_burtoni_v1.assembly.fa" \

# python FilterReads.py -i $readsFolder"/130917_TENNISON_0250_AD2H9VACXX_L4_1_pf.fastq.gz",$readsFolder"/130917_TENNISON_0250_AD2H9VACXX_L4_2_pf.fastq.gz" \
# -o $readsFolder"/130917_TENNISON_0250_AD2H9VACXX_L4_1_pf.Filtered.fastq.gz",$readsFolder"/130917_TENNISON_0250_AD2H9VACXX_L4_2_pf.Filtered.fastq.gz"


##Filter reads?????

python bs_seeker2-align.py \
--bt2-p 4 --bt2--end-to-end --bt2-X 500 \
--aligner=bowtie2 -d $homeFolder -a /Users/burtonigenomics/Desktop/Katrina/BSAdapterSeqs.txt \
-1 $readsFolder"/130917_TENNISON_0250_AD2H9VACXX_L4_1_pf.fastq.gz" \
-2 $readsFolder"/130917_TENNISON_0250_AD2H9VACXX_L4_2_pf.fastq.gz" \
-g $homeFolder"/H_burtoni_v1.assembly.fa"
# there is an option to change the outfile (-o) or format (-f) if this is inconvenient

# used 220 GB before crash


# 
# python bs_seeker2-align.py -o $readsFolder"/TENNISON_BSseeker2_Filtered" \
# --aligner=bowtie2 -d $homeFolder --bt2-p 4 -a $homefolder"/BSAdapterSeqs.txt" \
# -1 $readsFolder"/130917_TENNISON_0250_AD2H9VACXX_L4_1_pf.Filtered.fastq.gz" \
# -2 $readsFolder"/130917_TENNISON_0250_AD2H9VACXX_L4_2_pf.Filtered.fastq.gz" \
# -g $homeFolder"/H_burtoni_v1.assembly.fa"