cd ~/Documents/picard-tools-1.101/picard-tools-1.101/

# ls /Volumes/fishstudies/_LYNLEY_RNAseq/tophat/orig | \
# awk ' 
# { 
# 	print "java -Xmx2g -jar MarkDuplicates.jar REMOVE_DUPLICATES=TRUE INPUT=/Volumes/fishstudies/_LYNLEY_RNAseq/tophat/orig/"$0"/accepted_hits.bam OUTPUT=/Volumes/fishstudies/_LYNLEY_RNAseq/tophat/orig/"$0"/accepted_hits_MarkDuplicates.bam   METRICS_FILE=/Volumes/fishstudies/_LYNLEY_RNAseq/tophat/orig/"$0"/metrics_MarkDuplicates"
# }' | bash

###### MUST BE COORDINATE SORTED FIRST #######
ls ~/Documents/_LYNLEY_RNAseq/ | grep sorted.bam$ | \
awk ' 
{ 
 	print "java -Xmx2g -jar MarkDuplicates.jar REMOVE_DUPLICATES=TRUE INPUT=~/Documents/_LYNLEY_RNAseq/"$0" OUTPUT=~/Documents/_LYNLEY_RNAseq/"$0"_markDuplicates.bam   METRICS_FILE=~/Documents/_LYNLEY_RNAseq/"$0"_metrics_MarkDuplicates"
}' | bash