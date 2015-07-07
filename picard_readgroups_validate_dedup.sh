## add read group info
# read group info, format: @RG\tID:group1\tSM:sample1\tPL:illumina\tLB:lib1\tPU:unit1

SUBJECTS="AGTCAA CCGTCC CTTGTA GCCAAT GTGAAA"
for s in $SUBJECTS
do
	echo "========== "$s" =========="
	echo "========== Printing any existing @RG tags =========="
	samtools view -H $s"/accepted_hits-f2-F256.bam" | awk '/^@RG/'
	
	echo "========== Adding read group info to "$s" =========="
	if [ $s == "AGTCAA" ]; then
		RGID="ASC"
		RGSM="91914.1"
		RGLB="lib1"
	elif [ $s == "CCGTCC" ]; then
		RGID="ND"
		RGSM="102914.3"
		RGLB="lib2"
	elif [ $s == "CTTGTA" ]; then
		RGID="F"
		RGSM="91114.1"
		RGLB="lib3"
	elif [ $s == "GCCAAT" ]; then
		RGID="D"
		RGSM="91014.2"
		RGLB="lib4"
	elif [ $s == "GTGAAA" ]; then
		RGID="F"
		RGSM="112114.1"
		RGLB="lib5"
	fi
	java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar \
	INPUT=$s"/accepted_hits-f2-F256.bam" \
	OUTPUT=$s"/accepted_hits-f2-F256.RG.bam" \
	RGID=$RGID RGSM=$RGSM RGPL=illumina RGLB=$RGLB RGPU=$s
	
	echo "========== Building index =========="
	samtools index $s"/accepted_hits-f2-F256.RG.bam"
	samtools idxstats $s"/accepted_hits-f2-F256.RG.bam" > $s"/idxstats.RG.txt"
	
	echo "========== Validating bam files =========="
	java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/ValidateSamFile.jar \
	INPUT=$s"/accepted_hits-f2-F256.RG.bam" \
	OUTPUT=$s"/accepted_hits-f2-F256.RG.bam.ValidateSamFile"
done



##### 
## dedupping

# make sure bams are coordinate sorted and check first few bytes
#cd ~/Documents/gatkbp/tophat
#ls | awk '{print "echo "$1"; samtools view -H "$1"/accepted_hits-f2-F256.RG.bam | awk '\''/^@HD/'\''"}' | bash
# should be 0000000 037 213 \b 004
#ls | awk '{print "od -c -N4 "$1"/accepted_hits-f2-F256.RG.bam"}' | bash


#READ_NAME_REGEX="[a-zA-Z0-9-]+:[0-9]+:[a-zA-Z0-9]+:[0-9]+:([0-9]+):([0-9]+):([0-9]+)"
#HWI-ST373:364:C2HRPACXX:6:1105:9298:29400
# mark duplicates
#ls | awk '{print "java -Xmx2g -jar ../../picard-tools-1.101/picard-tools-1.101/MarkDuplicates.jar INPUT="$1"/accepted_hits-f2-F256.RG.bam OUTPUT="$1"/accepted_hits-f2-F256.RG.DD.bam METRICS_FILE="$1"/accepted_hits-f2-F256.RG.DD.bam.DDmetrics READ_NAME_REGEX=\"[a-zA-Z0-9-]+:[0-9]+:[a-zA-Z0-9]+:[0-9]+:([0-9]+):([0-9]+):([0-9]+)\""}' | bash

# make new index
#ls | awk '{print "java -Xmx2g -jar ../../picard-tools-1.101/picard-tools-1.101/BuildBamIndex.jar INPUT="$1"/accepted_hits-f2-F256.RG.DD.bam"}' | bash