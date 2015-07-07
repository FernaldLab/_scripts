#!/bin/bash

### Command line args are names of directories containing bam files for processing
### All files ending in "RG.bam" will be validated

echo -e "\n"===================================================================================
echo "Will run..."
echo "java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/ValidateSamFile.jar"
for DIR in "$@"
do
	echo ===================================================================================
	echo === Working on "$DIR" samples 
	echo ===================================================================================
	FILES=`ls "$DIR"/*RG.bam`
	for f in $FILES
	do 
		echo $f
		java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/ValidateSamFile.jar \
		INPUT=$f \
		OUTPUT=$f".Validate"
		echo
	done
done
echo

	
