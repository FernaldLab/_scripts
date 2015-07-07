#!/bin/bash

### Command line args are names of directories containing bam files for processing
### All files ending in "RG.bam" will have duplicates marked

echo -e "\n"===================================================================================
echo "Will run..."
echo "java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/MarkDuplicates.jar"
echo "Using READ_NAME_REGEX=\"[a-zA-Z0-9-]+:[0-9]+:[a-zA-Z0-9]+:[0-9]+:([0-9]+):([0-9]+):([0-9]+)\""

for DIR in "$@"
do
	echo -e "\n"===================================================================================
	echo === Working on "$DIR" samples 
	echo ===================================================================================
	FILES=`ls "$DIR"/*RG.bam`
	for f in $FILES
	do 
		echo $f
		echo "Is coordinate sorted?"
		samtools view -H $f | awk '/^@HD/{if($3=="SO:coordinate"){print "Yes"}else{print "No"}}'
		echo "First 4 bytes:"
		od -c -N4 $f
		
		outfile=`echo $f | awk '{sub("RG.bam","RG.DD.bam",$0); print}'`

		echo -e "\nMarking duplicates..."
		java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/MarkDuplicates.jar \
		INPUT=$f \
		OUTPUT=$outfile \
		METRICS_FILE=$outfile".DDmetrics" \
		READ_NAME_REGEX="[a-zA-Z0-9-]+:[0-9]+:[a-zA-Z0-9]+:[0-9]+:([0-9]+):([0-9]+):([0-9]+)"

		echo -e "\nBuilding new index file..."
		java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/BuildBamIndex.jar \
		INPUT=$outfile
		echo ===================================================================================
	done
done
echo
