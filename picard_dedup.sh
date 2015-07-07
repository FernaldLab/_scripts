SUBJECTS="AGTCAA CCGTCC CTTGTA GCCAAT GTGAAA"

for s in $SUBJECTS
do
	echo "========== Dedupping "$s" =========="
	java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/MarkDuplicates.jar \
	INPUT=$s"/accepted_hits.RG.bam" \
	OUTPUT=$s"/accepted_hits.RG.DD.bam" \
	METRICS_FILE=$s"/accepted_hits.RG.DD.bam.DDmetrics" \
	READ_NAME_REGEX="[a-zA-Z0-9-]+:[0-9]+:[a-zA-Z0-9]+:[0-9]+:([0-9]+):([0-9]+):([0-9]+)"
done

