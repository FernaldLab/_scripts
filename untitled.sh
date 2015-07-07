# cd ~/Desktop/Katrina/tophat/_filteredRuns/CGATGT
# 
# cufflinks -p 4 --library-type fr-firststrand -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 \
# -M /Users/burtonigenomics/Documents/_Burtoni_annotations/Abur_final_TE.bed -M ../ATCACG/microRNAsFix.bed -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.gtf ../ATCACG/accepted_hits.bam
# awk '$3=="exon"' transcripts.gtf > ../ATCACG/accepted_hits.bam.cufflinksStrandedTest
# bedtools getfasta -fi ../../../H_burtoni_v1.assembly.fa -bed ../ATCACG/accepted_hits.bam.cufflinksStrandedTest -fo ../ATCACG/accepted_hits.bam.cufflinksStrandedTest.fa
# 
# 
# 
# 
# cat /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 /Users/burtonigenomics/Documents/_Burtoni_annotations/Abur_final_TE.bed microRNAsFix.bed /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.gtf > gtfCombo.gtf
# 
# cd ~/Desktop/Katrina/tophat/_filteredRuns/ATCACG
# 
# date
# blastn -query testForBlast.fa -out testForBlast.fa.BLASTresults -subject ../../../ncbiPredictedSequences.fa -outfmt 10
# date

homeFolder="/Users/burtonigenomics/Desktop/Katrina"
preface=$homeFolder"/tophat/_filteredRuns/ATCACG/accepted_hits.bam.cufflinksStranded.v4"

cd $homeFolder"/tophat/_filteredRuns/ATCACG"


date
echo "Subsetting BLAST hits... "
cut -f1 $preface".fa.BLASTresults.annotated.genecounts" | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - $preface".fa.BLASTresults.annotated.genecounts" | sort | grep "NO_HIT" | cut -f1,2 > $preface".fa.BLASTresults.annotated.genecounts.NoBlastHits"

cut -f1 $preface".fa.BLASTresults.annotated.genecounts" | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - $preface".fa.BLASTresults.annotated.genecounts" | sort | grep -v "NO_HIT" | cut -f1,2 > $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"

awk '$2 != "NO_HIT"' $preface".fa.BLASTresults.annotated.genecounts" | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - $preface".fa.BLASTresults.annotated.genecounts" | sort | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} $1 in duplicates' - $preface".fa.BLASTresults.annotated.genecounts" | sort | grep -v "NO_HIT" | cut -f1,2 >> $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"

echo -e "\n\n\n\n\n==========================\nGenes To Decide About\n==========================\n"
awk '$2 != "NO_HIT"' $preface".fa.BLASTresults.annotated.genecounts" | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} $1 in duplicates' - $preface".fa.BLASTresults.annotated.genecounts" | sort
echo -e "\n==========================\nEND\n==========================\n\n\n"

echo "Word counts:"
wc $preface".fa.BLASTresults.annotated.genecounts.NoBlastHits"
wc $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"
echo -e "\n\n\n"