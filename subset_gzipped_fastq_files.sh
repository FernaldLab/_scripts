#!/bin/bash

# will take command line arg for number of reads to take from beginning of gzipped fastq files in a directory
# no guarantee read pairs will be preserved, only if original files have reads in same order

GZIPPED_FASTQ_FILES=`ls | grep fastq.gz$`
NUMREADS=$1
NUMLINES=`expr $NUMREADS \* 4`
echo "Getting first "$NUMREADS" reads from..."

for f in $GZIPPED_FASTQ_FILES
do
	echo " "$f
	zcat $f | head -$NUMLINES > $f"_first"$NUMREADS"reads.fastq"
done