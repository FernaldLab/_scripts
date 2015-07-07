#!/bin/bash

### Command line args are names of directories containing bam files for processing

echo -e "\n"===================================================================================
echo === Current info is ~/Documents/_Elim_data/readGroups.txt
echo ===================================================================================
echo "Will run..."
echo "java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar"
for DIR in "$@"
do
	echo -e "\n"===================================================================================
	echo === Working on "$DIR" samples 
	echo -e ==================================================================================="\n"
	FILES=`ls "$DIR"/*.bam`
	for f in $FILES
	do 
		echo $f
		#echo ===================================================================================
		#echo ========== Printing any existing @RG tags within "$f"...
		#samtools view -H "$f" | awk '/^@RG/'
		#echo ===================================================================================
		
		index=`echo $f | awk '{split($1,a,"/"); split(a[2],aa,"_"); print aa[1]}'`
		info=`grep -E $DIR.*$index ~/Documents/_Elim_data/readGroups.txt`
		echo $info
		lane=`echo $info | awk '{print $3}'`		###CHECK FIELD NUMBERS SINCE ADDED TO readGroups.txt
		samp=`echo $info | awk '{print $4}'`
		cond=`echo $info | awk '{print $5}'`
		RGID=$DIR"-LANE"$lane
		RGSM=$samp
		RGLB=$samp"-1"
		RGDS=$cond
		RGPU=$index
		outfile=`echo $f | awk '{sub("bam","RG.bam",$0); print}'`
		
		echo -e RGID: $RGID"\n"RGSM: $RGSM"\n"RGLB: $RGLB"\n"RGDS: $RGDS"\n"RGPU: $RGPU
		echo outfile: $outfile
		
# 		java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar \
# 		INPUT=$f \
# 		OUTPUT=$outfile \
# 		RGID=$RGID \
# 		RGSM=$RGSM \
# 		RGPL=Illumina \
# 		RGLB=$RGLB \
# 		RGDS=$RGDS \
# 		RGPU=$RGPU
		
		echo -e ==================================================================================="\n"
	done
done

