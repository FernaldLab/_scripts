#!/bin/bash

### Command line args are directories (with no trailing /) containing bam files for processing
### bam filenames must end with "RG.bam"

echo -e "\n"===================================================================================
echo "Will run..."
echo "samtools index"
for DIR in "$@"
do
	echo ===================================================================================
	echo === Working on "$DIR" samples 
	echo ===================================================================================
	FILES=`ls "$DIR"/*bam`
	for f in $FILES
	do 
		echo $f
		samtools index $f
	done
done
echo