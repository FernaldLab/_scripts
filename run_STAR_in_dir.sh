#!/bin/bash

### Command line arg $1 should be name of directory containing fastq files named with format:
###  L[0-9]_AGTCAA_*_R1_*.fastq
###	 L[0-9]_AGTCAA_*_R2_*.fastq
###  where "AGTCAA" is index for a subject 
### Fastq files should be only files in $1
###
### Will write output bam and log files to $1

STARPATH="/Users/burtonigenomics/Documents/STAR-STAR_2.4.0k/source/STAR"
GENOMEDIR="/Users/burtonigenomics/Documents/_Burtoni_genome_files/STARindexesNCBI"
echo -e "\nUsing STAR:"
echo "  "$STARPATH
echo "Using STAR indexes:"
echo -e "  "$GENOMEDIR"\n"

cd $1
SUBJECTS=`ls | awk '{split($1,a,"_");print a[2]}' | uniq`
for s in $SUBJECTS
do
	R1=`ls *$s*R1*fastq`
	R2=`ls *$s*R2*fastq`
	echo "----------------------------------------------------------------------------"
 	echo "-------------- Working on "$s" ------------------------------------------"
 	echo "----------------------------------------------------------------------------"
 	echo "---------------------- "$R1
 	echo "---------------------- "$R2
 	$STARPATH \
 	--runMode alignReads \
 	--runThreadN 4 \
 	--genomeDir $GENOMEDIR \
 	--readFilesIn $R1 $R2 \
 	--outFilterMultimapNmax 1 \
 	--outFileNamePrefix $s"_NCBI_" \
 	--outSAMtype BAM SortedByCoordinate \
 	--outSAMattributes MD NH NM
done
