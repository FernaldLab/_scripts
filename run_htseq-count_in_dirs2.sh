#!/bin/bash

### Command line args are names of directories containing bam files for processing
### All files ending in "RG.DD.bam" will be counted

GTF="/Users/burtonigenomics/Documents/_Burtoni_annotations/ref_AstBur1.0_scaffolds.clean.translate.final.combo.gff3"
echo -e "\nUsing feature file:"
echo "  "$GTF
echo -e "\n"===================================================================================
#echo "Will run..."

for DIR in "$@"
do
	echo ===================================================================================
	echo === Working on "$DIR" samples 
	echo ===================================================================================
	FILES=`ls "$DIR"/*bam`
	for f in $FILES
	do 
		echo $f
		samtools sort -on $f $DIR"/tmp" | samtools view - | htseq-count -m union -s reverse -i gene - $GTF > $f".counts"
		echo
	done
done
echo
