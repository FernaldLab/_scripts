# original cufflinks!

cd ~/Desktop/Katrina/tophat/_filteredRuns/ATCACG

date
echo "Starting CuffLinks... "
pwd
cufflinks -p 4 -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 unassigned.sam.readsOfInterest.sorted.header
awk '$3=="exon"' transcripts.gtf > unassigned.sam.readsOfInterest.sorted.header.cufflinksUnstranded

date
echo "Getting fasta file for BLAST... "
bedtools getfasta -fi ../../../H_burtoni_v1.assembly.fa -bed unassigned.sam.readsOfInterest.sorted.header.cufflinksUnstranded -fo unassigned.sam.readsOfInterest.sorted.header.cufflinksUnstranded.fa


# stranded cufflinks!

cd ~/Desktop/Katrina/tophat/_filteredRuns/ATCACG

date
echo "Starting CuffLinks... "
cufflinks -p 4 --library-type fr-firststrand -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 unassigned.sam.readsOfInterest.sorted.header
awk '$3=="exon"' transcripts.gtf > unassigned.sam.readsOfInterest.sorted.header.cufflinksStranded

date
echo "Getting fasta file for BLAST... "
bedtools getfasta -fi ../../../H_burtoni_v1.assembly.fa -bed unassigned.sam.readsOfInterest.sorted.header.cufflinksStranded -fo unassigned.sam.readsOfInterest.sorted.header.cufflinksStranded.fa


# unfiltered, stranded cufflinks!

cd ~/Desktop/Katrina/tophat/_filteredRuns

cufflinks -p 4 --library-type fr-firststrand -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.gtf \
-M /Users/burtonigenomics/Documents/_Burtoni_annotations/Abur_final_TE.bed -M ATCACG/microRNAsFix.bed ATCACG/accepted_hits.bam
awk '$3=="exon"' transcripts.gtf > ATCACG/accepted_hits.bam.cufflinksStranded
bedtools getfasta -fi ../../H_burtoni_v1.assembly.fa -bed ATCACG/accepted_hits.bam.cufflinksStranded -fo ATCACG/accepted_hits.bam.cufflinksStranded.fa

# unfiltered, unstranded cufflinks!

# cufflinks -p 4 -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.gtf \
# -M /Users/burtonigenomics/Documents/_Burtoni_annotations/Abur_final_TE.bed -M ATCACG/microRNAsFix.bed ATCACG/accepted_hits.bam
# awk '$3=="exon"' transcripts.gtf > ATCACG/accepted_hits.bam.cufflinksUnstranded
bedtools getfasta -fi ../../H_burtoni_v1.assembly.fa -bed ATCACG/accepted_hits.bam.cufflinksUnstranded -fo ATCACG/accepted_hits.bam.cufflinksUnstranded.fa




#More!!


cd ~/Desktop/Katrina/tophat/_filteredRuns/ATCACG

date
echo "Starting CuffLinks... "
cufflinks -p 4 -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 accepted_hits.namesorted.bam.bam_HTSeqCountAssignments.noFeature.sam.positionsorted.sam
awk '$3=="exon"' transcripts.gtf > accepted_hits.namesorted.bam.bam_HTSeqCountAssignments.noFeature.sam.positionsorted.sam.cufflinksUnstranded

date
echo "Getting fasta file for BLAST... "
bedtools getfasta -fi ../../../H_burtoni_v1.assembly.fa -bed accepted_hits.namesorted.bam.bam_HTSeqCountAssignments.noFeature.sam.positionsorted.sam.cufflinksUnstranded -fo accepted_hits.namesorted.bam.bam_HTSeqCountAssignments.noFeature.sam.positionsorted.sam.cufflinksUnstranded.fa




cd ~/Desktop/Katrina/tophat/_filteredRuns/ATCACG

date
echo "Starting CuffLinks... "
cufflinks -p 4 --library-type fr-firststrand -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 accepted_hits.namesorted.bam.bam_HTSeqCountAssignments.noFeature.sam.positionsorted.sam
awk '$3=="exon"' transcripts.gtf > accepted_hits.namesorted.bam.bam_HTSeqCountAssignments.noFeature.sam.positionsorted.sam.cufflinksStranded

date
echo "Getting fasta file for BLAST... "
bedtools getfasta -fi ../../../H_burtoni_v1.assembly.fa -bed accepted_hits.namesorted.bam.bam_HTSeqCountAssignments.noFeature.sam.positionsorted.sam.cufflinksStranded -fo accepted_hits.namesorted.bam.bam_HTSeqCountAssignments.noFeature.sam.positionsorted.sam.cufflinksStranded.fa










#########




## Version 1!
bedtools intersect -a accepted_hits.bam.cufflinksStranded -b ../../../Astatotilapia_burtoni.BROADAB2fix.noexons.gtf -wo >> accepted_hits.bam.cufflinksStranded.overlapv1
awk 'BEGIN{FS="\""} NR == FNR {genesToExclude[$2]; next} !($2 in genesToExclude)' accepted_hits.bam.cufflinksStranded.overlapv1 accepted_hits.bam.cufflinksStranded > accepted_hits.bam.cufflinksStranded.overlapv1.NOoverlap

bedtools intersect -a accepted_hits.bam.cufflinksStranded.overlapv1.NOoverlap -b /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 -wo >> accepted_hits.bam.cufflinksStranded.overlapv2
awk 'BEGIN{FS="\""} NR == FNR {genesToExclude[$2]; next} !($2 in genesToExclude)' accepted_hits.bam.cufflinksStranded.overlapv2 accepted_hits.bam.cufflinksStranded.overlapv1.NOoverlap > accepted_hits.bam.cufflinksStranded.overlapv2.NOoverlap

bedtools intersect -a accepted_hits.bam.cufflinksStranded.overlapv2.NOoverlap -b /Users/burtonigenomics/Documents/_Burtoni_annotations/Abur_final_TE.bed -wo >> accepted_hits.bam.cufflinksStranded.overlapv3
awk 'BEGIN{FS="\""} NR == FNR {genesToExclude[$2]; next} !($2 in genesToExclude)' accepted_hits.bam.cufflinksStranded.overlapv3 accepted_hits.bam.cufflinksStranded.overlapv2.NOoverlap > accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap

awk '$7 == "."' accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap
awk '$7 != "."' accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap > accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional
samtools view -h accepted_hits.namesorted.bam.bam | htseq-count -m union -s reverse - accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional > accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional.HTSeq_counts

# I did some checking in R.
awk '{print $1"\""$2}' accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional.HTSeq_counts | awk 'BEGIN{FS="\""} NR==FNR{counts[$1]=$2; next} int(counts[$2]) > 30' - accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional > accepted_hits.bam.cufflinksStranded.v4

