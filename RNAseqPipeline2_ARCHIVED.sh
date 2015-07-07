#!/bin/bash

homeFolder="/Volumes/fishstudies/Katrina"
# The path to the folder with the reads, genome, GTF file, etc.

genomePath=$homeFolder"/Astatotilapia_burtoni.ribosomalProteinsAndUTRs.pileupRegionIGV_manual.bed.collapsed"
# The path to the genome FASTA file, minus the .fa at the end. This will also be the prefix for the genome index files.




## Make genome index file
# cd /Users/burtonigenomics/Documents/bowtie2-2.1.0
# ./bowtie2-build -f $genomePath".fa" $genomePath

####cd ~/Documents/bowtie2-2.1.0
####./bowtie2-build -f ~/Desktop/Katrina/Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.ribosomalProteins.bed.fa ~/Desktop/Katrina/Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.ribosomalProteins.bed

## Check index validity and save inspection to a file
# ./bowtie2-inspect -s $genomePath > $genomePath"_inspect"
####./bowtie2-inspect -s ~/Desktop/Katrina/Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.ribosomalProteins.bed > ~/Desktop/Katrina/Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.ribosomalProteins.bed_inspect

## Run TopHat. The output folder(s) must exist already.
# SUBJECTS="ATCACG"
# 
# for s in $SUBJECTS
# 	do	
# 		/Users/burtonigenomics/Documents/tophat-2.0.9.OSX_x86_64/tophat2 \
# 		-r 0 -p 4 --library-type fr-firststrand \
# 		-o $homeFolder"/tophat/"$s"RibosomeWithUTRs_Collapsed" \
# 		$genomePath \
# 		$homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_1_pf.fastq.gz" \
# 		$homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_2_pf.fastq.gz"
# 	done
	
s="ATCACG"
	

###############

# genomePath=$homeFolder"/pileupRegionIGV_manual_v2.bed.collapsed"
# 
#  cd /Users/burtonigenomics/Documents/bowtie2-2.1.0
#  ./bowtie2-build -f $genomePath".fa" $genomePath
# # 
#  ./bowtie2-inspect -s $genomePath > $genomePath"_inspect"
# 
# /Users/burtonigenomics/Documents/tophat-2.0.9.OSX_x86_64/tophat2 \
# -r 0 -p 4 --library-type fr-firststrand \
# -o $homeFolder"/tophat/"$s"PileupIGV_v2" \
# $genomePath \
# $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_1_pf.fastq.gz" \
# $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_2_pf.fastq.gz"

#############

genomePath=$homeFolder"/pileupRegionIGV_manual_v8.bed.collapsed"

cd /Users/burtonigenomics/Documents/bowtie2-2.1.0
./bowtie2-build -f $genomePath".fa" $genomePath

./bowtie2-inspect -s $genomePath > $genomePath"_inspect"

/Users/burtonigenomics/Documents/tophat-2.0.9.OSX_x86_64/tophat2 \
-r 0 -p 4 --library-type fr-firststrand \
-o $homeFolder"/tophat/"$s"PileupIGV_v8" \
$genomePath \
$homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_1_pf.fastq.gz" \
$homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_2_pf.fastq.gz"

##########

# /Users/burtonigenomics/Documents/FastQC/fastqc $homeFolder"/tophat/"$s"PileupIGV_v2/unmapped.bam"
# python /Volumes/fishstudies/_scripts/condenseOverrepSeq.py $homeFolder"/tophat/"$s"PileupIGV_v2/unmapped_fastqc/fastqc_data.txt"

/Users/burtonigenomics/Documents/FastQC/fastqc $homeFolder"/tophat/"$s"PileupIGV_v8/unmapped.bam"
python /Volumes/fishstudies/_scripts/condenseOverrepSeq.py $homeFolder"/tophat/"$s"PileupIGV_v8/unmapped_fastqc/fastqc_data.txt"


###########


homeFolder="/Users/burtonigenomics/Desktop/Katrina"
# The path to the folder with the reads, genome, GTF file, etc.

genomePath=$homeFolder"/pileupRegionIGV_manual_v8.bed.collapsed"
# The path to the genome FASTA file, minus the .fa at the end. This will also be the prefix for the genome index files.

## Make genome index files, then check index validity and save inspection.
cd /Users/burtonigenomics/Documents/bowtie2-2.1.0
./bowtie2-build -f $genomePath".fa" $genomePath
./bowtie2-inspect -s $genomePath > $genomePath"_inspect"

#The unmapped.fastq file will also contain reads that mapped, but not in a concordant pair.

#Next step: use concordantPairs_1 and _2.fastq to filter original lynley reads. That awk program - read in concPairs, then compare.

## Run Bowtie
SUBJECTS="ATCACG"

for s in $SUBJECTS
	do
		date
		echo "Starting alignments for animal "$s"."
		outputFolder=$homeFolder"/bowtie2/"$s"Filter_1"
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
	
homeFolder="/Users/burtonigenomics/Desktop/Katrina"
# The path to the folder with the reads, genome, GTF file, etc.


SUBJECTS="ATCACG"

for s in $SUBJECTS
	do
		date
		outputFolder=$homeFolder"/bowtie2/"$s"Filter"
		echo "Starting creation of unmapped.fastq files for animal "$s"."
		echo "\tunmappedReads_1"
		awk 'BEGIN{PRINTLN=1}NR==FNR{if(NR%4==1){geneIDs[$1]};next} NR%4==1{PRINTLN=($1 in geneIDs)} !PRINTLN' $outputFolder"/concordantPairs_1.fastq" "/Volumes/fishstudies/_LYNLEY_RNAseq/data/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_1_pf.fastq" > $outputFolder"/unmappedReads_1.fastq"
		date
		echo "\tunmappedReads_2"
		awk 'BEGIN{PRINTLN=1}NR==FNR{if(NR%4==1){geneIDs[$1]};next} NR%4==1{PRINTLN=($1 in geneIDs)} !PRINTLN' $outputFolder"/concordantPairs_2.fastq" "/Volumes/fishstudies/_LYNLEY_RNAseq/data/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_2_pf.fastq" > $outputFolder"/unmappedReads_2.fastq"
	done

 for s in $SUBJECTS
 	do
 		date
 		outputFolder=$homeFolder"/bowtie2/"$s"Filter"
 		#echo "Generating FastQC report for unfiltered files from animal "$s"."
 		/Users/burtonigenomics/Documents/FastQC/fastqc $outputFolder"/unmappedReads_1.fastq"
 		/Users/burtonigenomics/Documents/FastQC/fastqc $outputFolder"/unmappedReads_2.fastq"
  		python /Volumes/fishstudies/_scripts/condenseOverrepSeq.py $outputFolder"/unmappedReads_1_fastqc/fastqc_data.txt"		# typo: was "/unmapped_(1,2)_fastqc/fastqc_data.txt"
  		python /Volumes/fishstudies/_scripts/condenseOverrepSeq.py $outputFolder"/unmappedReads_2_fastqc/fastqc_data.txt"		
 	done



##########


# genomePath=$homeFolder"/pileupRegionIGV_manual_v7.bed.collapsed"
# 
# /Users/burtonigenomics/Documents/tophat-2.0.9.OSX_x86_64/tophat2 \
# -r 50 -p 4 -N 3 --no-coverage-search --read-edit-dist 3 --library-type fr-firststrand \
# -o $homeFolder"/tophat/"$s"PileupIGV_v7_Halves" \
# $genomePath \
# $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_1_pf.fastq_firstHalfTrimmed",$homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_1_pf.fastq_secondHalfTrimmed" \
# $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_2_pf.fastq_secondHalfTrimmed",$homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_2_pf.fastq_firstHalfTrimmed"

################

# genomePath=$homeFolder"/pileupRegionIGV_manual_v3.bed.collapsed"
# 
# 
# /Users/burtonigenomics/Documents/tophat-2.0.9.OSX_x86_64/tophat2 \
# -r 50 -p 4 -N 3 --no-coverage-search --read-edit-dist 3 --library-type fr-firststrand \
# -o $homeFolder"/tophat/"$s"PileupIGV_v3_Halves" \
# $genomePath \
# $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_1_pf.fastq_firstHalfTrimmed",$homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_1_pf.fastq_secondHalfTrimmed" \
# $homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_2_pf.fastq_secondHalfTrimmed",$homeFolder"/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_2_pf.fastq_firstHalfTrimmed"

#############

# /Users/burtonigenomics/Documents/FastQC/fastqc $homeFolder"/tophat/"$s"PileupIGV_v2_Halves/unmapped.bam"
# python /Volumes/fishstudies/_scripts/condenseOverrepSeq.py $homeFolder"/tophat/"$s"PileupIGV_v2_Halves/unmapped_fastqc/fastqc_data.txt"

# /Users/burtonigenomics/Documents/FastQC/fastqc $homeFolder"/tophat/"$s"PileupIGV_v3_Halves/unmapped.bam"
# python /Volumes/fishstudies/_scripts/condenseOverrepSeq.py $homeFolder"/tophat/"$s"PileupIGV_v3_Halves/unmapped_fastqc/fastqc_data.txt"
#-G $homeFolder"/Astatotilapia_burtoni.BROADAB2fix.gtf" \


# s="ATCACG"
# /Users/burtonigenomics/Documents/tophat-2.0.9.OSX_x86_64/tophat2 \
# -r 0 -p 4 --library-type fr-firststrand \
# -o "/Users/burtonigenomics/Desktop/Katrina/tophat/"$s"RibosomeCollapsedScaffolds" \
# /Users/burtonigenomics/Desktop/Katrina/Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.ribosomalProteins.bed \
# "/Users/burtonigenomics/Desktop/Katrina/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_1_pf.fastq.gz" \
# "/Users/burtonigenomics/Desktop/Katrina/fastq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$s"_2_pf.fastq.gz"
# 	

#-G /Users/burtonigenomics/Desktop/Katrina/Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.ribosomalProteins \