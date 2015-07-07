#! /bin/bash

# This script will use seqtk to trim an indicated number of bases from the left and right of reads then run fastqc
# 2 command line arguments: first ($1) indicates number to remove on left, second ($2) is number to remove from right

# move to dir with all raw data files
# this dir should contain only gzipped data files
cd ~/Documents/_Elim_data/_data
echo "Raw files:"
ls
echo ""
echo "Will remove: "$1" bases from left and "$2" bases from right"
echo ""
# get filenames
RAW_FILES=`ls`

# make dir for trimmed data
# do this way now because will likely try different trim amounts, but could do in pipe to fastqc
TRIM_DIR="trim_"$1"L_"$2"R"
mkdir $TRIM_DIR

# loop through files and trim
# seqtk trimfq seems to only output uncompressed fastq files
echo "TRIMMING..."
for f in $RAW_FILES
do
	echo "  "$f
	seqtk trimfq -b $1 -e $2 $f > $TRIM_DIR"/"$f"_TRIM"$1"L"$2"R.fastq"	
done

# move to trimmed files dir and get their names
cd $TRIM_DIR
TRIMMED_FILES=`ls`

for f in $TRIMMED_FILES
do
	~/Documents/FastQC/fastqc $f
done
