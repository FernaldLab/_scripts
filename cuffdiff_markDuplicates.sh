cd /Volumes/fishstudies/_LYNLEY_RNAseq/tophat/orig
cuffdiff --library-type fr-firststrand -o cuffdiffOUT_markedDuplicates -p 4 \
../../../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2.gtf \
tophat_outATCACG/accepted_hits_MarkDuplicates.bam,tophat_outTGACCA/accepted_hits_MarkDuplicates.bam \
tophat_outCGATGT/accepted_hits_MarkDuplicates.bam,tophat_outTTAGGC/accepted_hits_MarkDuplicates.bam