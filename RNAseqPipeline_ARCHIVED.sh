#!/bin/bash

homeFolder="/Users/burtonigenomics/Desktop/Katrina"
# The path to the folder with the reads, genome, GTF file, etc.

genomePath=$homeFolder"/pileupRegionIGV_manual_v7.bed.collapsed"
# The path to the genome FASTA file, minus the .fa at the end. This will also be the prefix for the genome index files.

## Make genome index files, then check index validity and save inspection.
# cd /Users/burtonigenomics/Documents/bowtie2-2.1.0
# ./bowtie2-build -f $genomePath".fa" $genomePath
# ./bowtie2-inspect -s $genomePath > $genomePath"_inspect"

#The unmapped.fastq file will also contain reads that mapped, but not in a concordant pair.

#Next step: use concordantPairs_1 and _2.fastq to filter original lynley reads. That awk program - read in concPairs, then compare.

## Run Bowtie
SUBJECTS="ATCACG CGATGT TGACCA TTAGGC"

for s in $SUBJECTS
	do
		date
		echo "Starting alignments for animal "$s"."
		outputFolder=$homeFolder"/bowtie2/"$s"Filter"
		./bowtie2 \
		-q --phred33 --end-to-end -p 4 -i S,1,1.25 -X 300 --fr --no-unal \
		--met-file $outputFolder"/metrics.txt" \
		-x $genomePath \
		-1 $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_1_pf.fastq.gz" \
		-2 $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_2_pf.fastq.gz" \
		-S $outputFolder"/alignments.sam" \
		--al-conc $outputFolder"/concordantPairs_%.fastq"
		##############
		samtools view -S -b $outputFolder"/alignments.sam" > $outputFolder"/alignments.bam"
		samtools sort $outputFolder"/alignments.bam" $outputFolder"/alignments.sorted"
		samtools index $outputFolder"/alignments.sorted.bam"
# 		/Users/burtonigenomics/Documents/FastQC/fastqc $outputFolder"/unmapped.bam"
# 		python /Volumes/fishstudies/_scripts/condenseOverrepSeq.py $outputFolder"/unmapped_fastqc/fastqc_data.txt"
	done
	
	
# echo "This run is using our normal settings, but with all files on fishstudies."
# echo "Start time: "
# date
# homeFolder="/Volumes/fishstudies/Katrina"
# genomePath=$homeFolder"/pileupRegionIGV_manual_v7.bed.collapsed"
# outputFolder=$homeFolder"/bowtie2/"$SUBJECTS"Filter1"
# ./bowtie2 \
# -q --phred33 --end-to-end -p 4 -i S,1,1.25 -X 300 --fr --no-unal \
# -x $genomePath \
# -1 $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$SUBJECTS"_1_pf.fastq.gz" \
# -2 $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$SUBJECTS"_2_pf.fastq.gz" \
# -S $outputFolder"/alignments.sam" \
# --un-conc $outputFolder"/unmapped.fastq" 
# echo "End time: "
# date


##########

# echo "This run is using a fragment length range of 100-250 (-I 100 -X 250) with all files on the local disk."
# echo "Start time: "
# date
# homeFolder="/Users/burtonigenomics/Desktop/Katrina"
# genomePath=$homeFolder"/pileupRegionIGV_manual_v7.bed.collapsed"
# outputFolder=$homeFolder"/bowtie2/"$SUBJECTS"Filter2"
# ./bowtie2 \
# -q --phred33 --end-to-end -p 4 -i S,1,1.25 -I 100 -X 250 --fr --no-unal \
# -x $genomePath \
# -1 $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$SUBJECTS"_1_pf.fastq.gz" \
# -2 $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$SUBJECTS"_2_pf.fastq.gz" \
# -S $outputFolder"/alignments.sam" \
# --un-conc $outputFolder"/unmapped.fastq" 
# echo "End time: "
# date
# 
# ##########
# 
# echo "This run is using fewer seed extension attempts (-D 10) with all files on the local disk."
# echo "Start time: "
# date
# homeFolder="/Users/burtonigenomics/Desktop/Katrina"
# genomePath=$homeFolder"/pileupRegionIGV_manual_v7.bed.collapsed"
# outputFolder=$homeFolder"/bowtie2/"$SUBJECTS"Filter3"
# ./bowtie2 \
# -q --phred33 --end-to-end -p 4 -i S,1,1.25 -X 300 --fr -D 10 --no-unal \
# -x $genomePath \
# -1 $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$SUBJECTS"_1_pf.fastq.gz" \
# -2 $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$SUBJECTS"_2_pf.fastq.gz" \
# -S $outputFolder"/alignments.sam" \
# --un-conc $outputFolder"/unmapped.fastq" 
# echo "End time: "
# date
# 
# ##########
# 
# echo "This run is using very few seed extension attempts (-D 5) with all files on the local disk."
# echo "Start time: "
# date
# homeFolder="/Users/burtonigenomics/Desktop/Katrina"
# genomePath=$homeFolder"/pileupRegionIGV_manual_v7.bed.collapsed"
# outputFolder=$homeFolder"/bowtie2/"$SUBJECTS"Filter4"
# ./bowtie2 \
# -q --phred33 --end-to-end -p 4 -i S,1,1.25 -X 300 --fr -D 5 --no-unal \
# -x $genomePath \
# -1 $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$SUBJECTS"_1_pf.fastq.gz" \
# -2 $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$SUBJECTS"_2_pf.fastq.gz" \
# -S $outputFolder"/alignments.sam" \
# --un-conc $outputFolder"/unmapped.fastq" 
# echo "End time: "
# date

#######


