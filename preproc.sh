### Pre-processing

# fastqc quality control
cd /Volumes/fishstudies/_LYNLEY_RNAseq/data
ls | grep q$ | awk ‘{print “~/Documents/Fastqc/fastqc “$0””}’ | bash

# PCR duplicate removal
cd ~/Documents/picard-tools-1.101/picard-tools-1.101/

ls /Volumes/fishstudies/_LYNLEY_RNAseq/tophat/orig | \
awk ' 
{ 
	print "java -Xmx2g -jar MarkDuplicates.jar REMOVE_DUPLICATES=TRUE INPUT=/Volumes/fishstudies/_LYNLEY_RNAseq/tophat/orig/"$0"/accepted_hits.bam OUTPUT=/Volumes/fishstudies/_LYNLEY_RNAseq/tophat/orig/"$0"/accepted_hits_MarkDuplicates.bam   METRICS_FILE=/Volumes/fishstudies/_LYNLEY_RNAseq/tophat/orig/"$0"/metrics_MarkDuplicates"
}' | bash


# cuffdiff
cd /Volumes/fishstudies/_LYNLEY_RNAseq/tophat/orig
cuffdiff --library-type fr-firststrand -o cuffdiffOUT_markedDuplicates -p 4 \
../../../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2.gtf \
tophat_outATCACG/accepted_hits_MarkDuplicates.bam,tophat_outTGACCA/accepted_hits_MarkDuplicates.bam \
tophat_outCGATGT/accepted_hits_MarkDuplicates.bam,tophat_outTTAGGC/accepted_hits_MarkDuplicates.bam