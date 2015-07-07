#!/bin/bash

# This part of the pipeline takes raw fastq files, trims adapters, filters them against a "filterome",
# then aligns the cleaned-up reads using Tophat2. The "filterome" should be given as a fasta file
# containing sequences to be removed (contamination, highly-expressed genes, rRNA, etc.)

# Suggested workflow for creating the filter:
#   1. Run FastQC and condenseOverrepSequences.py on both of the paired-end fastq files
		# ~/Documents/FastQC/fastqc reads_1.fastq
		# python /Volumes/fishstudies/_scripts/condenseOverrepSeq.py reads_1_fastqc/fastqc_data.txt
#   2. BLAST these sequences against the burtoni genome to find their coordinates.
#   3. If unannotated, BLAST the sequnces against other organisms using NCBI's website to try to identify them.
#   4. Use IGV along with existing annotations for burtoni and other animals to determine the boundaries
#      of each sequence. Create a .bed file with the coordinates of each sequence.
#   5. Run bedtools getfasta to create the filterome.
		# bedtools getfasta -fi H_burtoni_v1.assembly.fa -bed filterome.bed -fo filterome.bed.fa
#   6. If any sequence had multiple exons, you'll also need to collapse the fasta file by scaffold
		# python /Volumes/fishstudies/_scripts/collapseScaffoldsInFASTA.py filterome.bed.fa
		
		

# This script need <=50 GB of free space for each animal.
# This script takes about 8 hours per animal to run if you comment out the mv lines.

# Before running this: filteromePath.fa + index files should be in home folder CHECK
#                      homefolder/bowtie2/(subj)Filter_v8_NoAdapters/ must exist for each animal. CHECK
#					   Lynley reads (_1_ and _2_) must be in homefolder/fastq/ for each animal. CHECK
#					   filteredReadsFolder must exist CHECK
#                      genomePath.fa + index files should be in home folder. CHECK
#                      homeFolder/Astatotilapia_burtoni.BROADAB2fix.noexons.gtf exists CHECK
#                      homeFolder/tophat/_filteredRuns/(subj) exists for each animal 
#                      remoteStorage/(subj) must exist for each animal CHECK
#        			   uncompressedReadsFolder must contain UNCOMPRESSED Lynley reads for each animal CHECK

homeFolder="/Users/burtonigenomics/Desktop/Katrina"
SUBJECTS="TGACCA TTAGGC" # "ATCACG CGATGT"
filteromePath=$homeFolder"/pileupRegionIGV_manual_v8.bed.collapsed"
filteredReadsFolder=$homeFolder"/FilteredReads_v8_NoAdapters"
genomePath=$homeFolder"/H_burtoni_v1.assembly"
remoteStorage="/Volumes/fishstudies/Katrina/storage/Filter_v8_NoAdapters"
uncompressedReadsFolder=$homeFolder"/fastq"


###################################################################
## Step 0: Use CutAdapt to trim adapters.                        ##
###################################################################
# This step requires 20-21 gigs per animal, plus about 20 more to use temporarily.
# This step takes approximately 30 minutes per animal.
echo -e "\n\n\n##################### Starting CutAdapt Runs #####################\n\n\n"

for s in $SUBJECTS
	do
		date
		echo "Starting adapter trimming for animal "$s"."
    	cutadapt -O 4 -e0 --too-short-output=$homeFolder"/fastq/"$s"_shortReadsWithAdapter_1" -a "AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC"$s"ATCTCGTATGCCGTCTTCTGCTTG" -m 50 --paired-output $homeFolder"/tmp.2.fastq" -o $homeFolder"/tmp.1.fastq" $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_1_pf.fastq.gz" $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_2_pf.fastq.gz"
    	cutadapt -O 4 -e0 --too-short-output=$homeFolder"/fastq/"$s"_shortReadsWithAdapter_2" -a AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT -m 50 --paired-output $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_1_pf.trimmedAdapters.fastq" -o $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_2_pf.trimmedAdapters.fastq" $homeFolder"/tmp.2.fastq" $homeFolder"/tmp.1.fastq"
    	rm $homeFolder"/tmp.2.fastq" $homeFolder"/tmp.1.fastq"
	done


###################################################################
## Step 1: Use Bowtie2 to filter out rRNA reads.                 ##
###################################################################
# This step requires 5-6 gigs per animal, plus about 11-12 more gigs to use temporarily.
# This step takes approximately 40 minutes per animal without moving files; 80 minutes with moving.
echo -e "\n\n\n##################### Starting Bowtie2 Filtering Runs #####################\n\n\n"
cd /Users/burtonigenomics/Documents/bowtie2-2.1.0

## Filterome index files already exist, so we don't need to make them again.
# ./bowtie2-build -f $filteromePath".fa" $filteromePath
# ./bowtie2-inspect -s $filteromePath > $filteromePath"_inspect"

for s in $SUBJECTS
	do
		date
		echo "Starting filter alignments for animal "$s"."
		outputFolder=$homeFolder"/bowtie2/"$s"Filter_v8_NoAdapters"
		./bowtie2 \
		-q --phred33 --end-to-end -p 4 -i S,1,1.25 -X 300 --fr --no-unal \
		--met-file $outputFolder"/metrics.txt" \
		-x $filteromePath \
		-1 $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_1_pf.trimmedAdapters.fastq" \
		-2 $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_2_pf.trimmedAdapters.fastq" \
		-S $outputFolder"/alignments.sam" \
		--al-conc $outputFolder"/concordantPairs_%.fastq"
		
		samtools view -S -b $outputFolder"/alignments.sam" > $outputFolder"/alignments.bam"
		samtools sort $outputFolder"/alignments.bam" $outputFolder"/alignments.sorted"
		samtools index $outputFolder"/alignments.sorted.bam"
		mv $outputFolder"/alignments.sam" $remoteStorage"/"$s
		mv $outputFolder"/alignments.bam" $remoteStorage"/"$s
		mv $outputFolder"/alignments.sorted.bam" $remoteStorage"/"$s
		mv $outputFolder"/alignments.sorted.bam.bai" $remoteStorage"/"$s
	done


###################################################################
## Step 2: Create filtered fastq files.                          ##
###################################################################
# This step requires 14-17 gigs per animal.
# This step takes approximately 40 minutes per animal (10 minutes to create each fastq file and 20 minutes to run FastQC twice)
echo -e "\n\n\n##################### Starting to create filtered FASTQ files. #####################\n\n\n"

for s in $SUBJECTS
	do
		date
		inputFolder=$homeFolder"/bowtie2/"$s"Filter_v8_NoAdapters"
		echo "Starting creation of unmapped.fastq files for animal "$s"."
		echo -e "\tunmappedReads_1"
		awk 'BEGIN{PRINTLN=1}NR==FNR{if(NR%4==1){geneIDs[$1]};next} NR%4==1{PRINTLN=($1 in geneIDs)} !PRINTLN' $inputFolder"/concordantPairs_1.fastq" $uncompressedReadsFolder"/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_1_pf.trimmedAdapters.fastq" > $filteredReadsFolder"/"$s"Reads_Filtered_1.fastq"
		date
		echo -e "\tunmappedReads_2"
		awk 'BEGIN{PRINTLN=1}NR==FNR{if(NR%4==1){geneIDs[$1]};next} NR%4==1{PRINTLN=($1 in geneIDs)} !PRINTLN' $inputFolder"/concordantPairs_2.fastq" $uncompressedReadsFolder"/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_2_pf.trimmedAdapters.fastq" > $filteredReadsFolder"/"$s"Reads_Filtered_2.fastq"
		
		date
		echo -e "\tGenerating FastQC report."
		/Users/burtonigenomics/Documents/FastQC/fastqc $filteredReadsFolder"/"$s"Reads_Filtered_1.fastq"
		/Users/burtonigenomics/Documents/FastQC/fastqc $filteredReadsFolder"/"$s"Reads_Filtered_2.fastq"
 		python /Volumes/fishstudies/_scripts/condenseOverrepSeq.py $filteredReadsFolder"/"$s"Reads_Filtered_1_fastqc/fastqc_data.txt"
 		python /Volumes/fishstudies/_scripts/condenseOverrepSeq.py $filteredReadsFolder"/"$s"Reads_Filtered_2_fastqc/fastqc_data.txt"
  		mv $inputFolder"/concordantPairs_1.fastq" $remoteStorage"/"$s
  		mv $inputFolder"/concordantPairs_2.fastq" $remoteStorage"/"$s
	done


###################################################################
## Step 3: Align the filtered fastq files to the Burtoni genome. ##
###################################################################
# This step will use 2 gb to create the index files.
# This step will also use 5-7 gb per animal.
# This step takes approximately 6 hours per animal.
echo -e "\n\n\n##################### Starting Tophat alignments. #####################\n\n\n"
cd /Users/burtonigenomics/Documents/bowtie2-2.1.0

## Genome index files already exist, so we don't need to make them again.
# ./bowtie2-build -f $genomePath".fa" $genomePath
# ./bowtie2-inspect -s $genomePath > $genomePath"_inspect"

for s in $SUBJECTS
	do	
		date
		echo "Starting Tophat run for animal "$s"."
		outputFolder=$homeFolder"/tophat/_filteredRuns/"$s
		/Users/burtonigenomics/Documents/tophat-2.0.9.OSX_x86_64/tophat2 \
		-r 0 -p 4 --library-type fr-firststrand \
		-G $homeFolder"/Astatotilapia_burtoni.BROADAB2fix.noexons.gtf" \
		-o $outputFolder \
		$genomePath \
		$filteredReadsFolder"/"$s"Reads_Filtered_1.fastq" \
		$filteredReadsFolder"/"$s"Reads_Filtered_2.fastq"
		samtools index $outputFolder"/accepted_hits.bam"
		/Users/burtonigenomics/Documents/FastQC/fastqc $outputFolder"/accepted_hits.bam"
		/Users/burtonigenomics/Documents/FastQC/fastqc $outputFolder"/unmapped.bam"
 	done
