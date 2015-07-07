bedtools nuc -fi H_burtoni_v1.assembly.fa -bed Astatotilapia_burtoni.BROADAB2fix.noexons.gtf | cut -f1,9,11,18 > Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.GCandLength


awk 'NR==FNR{records[FNR] = $1"\t"$4"\t"$5} records[FNR] == $1"\t"$4"\t"$5' | wc

########################
#Generally Useful Things
########################

# create an index for a bam file
samtools index /Users/burtonigenomics/Desktop/Katrina/tophat/ATCACG/accepted_hits.bam

# take a GTF or BED file, get the sequences for those genes from a fasta file, and make a new fasta file with only those sequences.
bedtools getfasta -fi H_burtoni_v1.assembly.fa -bed Astatotilapia_burtoni.BROADAB2fix.noexons.gtf -fo Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.fa
python /Volumes/fishstudies/_scripts/collapseScaffoldsInFASTA.py Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.fa

#run fastQC
~/Documents/FastQC/fastqc tophat/ATCACGRibosomeWithUTRs_Collapsed/unmapped.bam
python /Volumes/fishstudies/_scripts/condenseOverrepSeq.py tophat/ATCACGRibosomeWithUTRs_Collapsed/unmapped_fastqc/fastqc_data.txt

#count how many reads aligned to each scaffold (in the filter)
cat /Volumes/fishstudies/Katrina/storage/newBowtie/TGACCA/alignments.sam | cut -f3 | sort | uniq -c

# example of file comparison in awk
# this prints the records in file2 where the third field appears in column 1 of filename1
awk 'NR==FNR{arrname[$1]; next} $3 in arrname' filename1 file2
# source: http://stackoverflow.com/questions/15065818/compare-files-with-awk


############################
#Things Related to Filtering
############################

# Takes testReadsToFilter.fastq and removes all the reads that appear in testFilterReads.fastq
awk 'BEGIN{PRINTLN=1}NR==FNR{if(NR%4==1){geneIDs[$1]};next} NR%4==1{PRINTLN=($1 in geneIDs)} !PRINTLN' testFilterReads.fastq testReadsToFilter.fastq

# Take the output of GATK Indel Realigner and extract overrep bed
/Volumes/fishstudies/_scripts/extractOverrepBedFromIndelOutput.py ~/Desktop/Katrina/tophat/_filteredRuns/CGATGT/accepted_hits.IndelOutput.txt

# Compare to known annotations
/Volumes/fishstudies/_scripts/all_overlapsNEWonHD_July2014.sh

# See which sequences hit something
cat ~/Desktop/Katrina/_IndelOverrep/IndelOutput.txt.bed_annotatedCGATGT_unique.txt_overlap | cut -f1,2,3 | sort | uniq -c
# and look at hits
cat ~/Desktop/Katrina/_IndelOverrep/IndelOutput.txt.bed_annotatedCGATGT_unique.txt_overlap | sort

##################################################
#Things I Did Once That Should Maybe Be Documented
##################################################

## Process for finding boundaries:
## 1. make an educated guess
## 2. Run that sequence through BLAST
## 3. Download the sequences from a few closely related species and match those up as a reference
## 4. Line up the guess from Burtoni to this and edit accordingly.

# print records with >= 82% GC content in .bam file
samtools view smalltestbam.bam | awk -v fld=10 'BEGIN{FS="\t"}int(gsub(/([AT])/, "\&", $fld))<19'
samtools view -H tophat/ATCACGPileupIGV_v2/unmapped.bam > unmapped.bam.CGRich.sam
awk 'BEGIN{FS="aaaaaaaaa"}{gsub(" ", "\t"); print}' tophat/ATCACGPileupIGV_v2/unmapped.CGRich.sam >> unmapped.bam.CGRich.sam
cd ~/Documents/_LYNLEY_RNAseq
samtools view -H 130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_Rsubread.sam.bam > /Volumes/fishstudies/Katrina/Rsubread/130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_Rsubread.sam.bam.CGrich.sam
samtools view 130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_Rsubread.sam.bam | awk -v fld=10 'BEGIN{FS="\t"}int(gsub(/([AT])/, "\&", $fld))<19' | awk 'BEGIN{FS="aaaaaaaaa"}{gsub(" ", "\t"); print}' >> /Volumes/fishstudies/Katrina/Rsubread/130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_Rsubread.sam.bam.CGrich.sam
sort -k3,4 /Volumes/fishstudies/Katrina/Rsubread/130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_Rsubread.sam.bam.CGrich.onlymapped.sam | cut -f3 | uniq -c | sort | cut -c1,2,3,4,5 | uniq -c

#######Things that weren't actually useful
# get rid of duplicative exon lines in a GTF file
awk 'BEGIN{FS="\t"}$3=="CDS"' Astatotilapia_burtoni.BROADAB2fix.gtf > Astatotilapia_burtoni.BROADAB2fix.noexons.gtf

# count nucleotide frequencies
jellyfish count -m 1 -o Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.fa_1mers -c 2 -s 120M -t 4 Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.fa 
jellyfish dump -c Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.fa_1mers
# or:
getGCPercentage.sh #this does not give %ages but whatever

# extract gene IDs from a GTF file
awk 'BEGIN{FS="\""}{print $2}' shortGTF.gtf

# get annotations for ribosomal genes only.
grep 'ribosomal\ protein' geneNamesTree_AB | grep -v 'mitochon\|kinase' > geneNamesTree_AB_ribosomalProteins

# extract gene IDs from an annotations file
cut -f1 geneNamesTree_AB_ribosomalProteins > geneNamesTree_AB_ribosomalProteins_geneIDs

# get a list of just s#.# from these genes
awk 'BEGIN{FS="."}$1=="ab"{print $3"."$4}' geneNamesTree_AB_ribosomalProteins_geneIDs

# given a list of gene IDs, find those genes in a GTF file and:
#		print them
awk 'BEGIN{FS="\""}NR==FNR{arr[$1]; next} $2 in arr' geneNamesTree_AB_ribosomalProteins_geneIDs Astatotilapia_burtoni.BROADAB2fix.gtf
#		check that you have the correct ones
awk 'BEGIN{FS="\""}NR==FNR{arr[$1]; next} $2 in arr' geneNamesTree_AB_ribosomalProteins_geneIDs Astatotilapia_burtoni.BROADAB2fix.gtf | cut -f9 | awk 'BEGIN{FS="\""}{print $2}' | sort | uniq | wc
#		save them as a .bed file
awk 'BEGIN{FS="\""}NR==FNR{arr[$1]; next} $2 in arr' geneNamesTree_AB_ribosomalProteins_geneIDs Astatotilapia_burtoni.BROADAB2fix.noexons.gtf | \
awk '{print $1"\t"int($4)-1"\t"$5"\t"$10"\t."}' | sort | uniq > Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.ribosomalProteins.bed

# take this output .bed file and make a single entry for each gene
python /Volumes/fishstudies/_scripts/collapseExonsToGenesBED.py Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.ribosomalProteins.bed

# find ribosomal protein-associated UTRs and print them
awk 'BEGIN{FS="."}NR==FNR{geneIDs[$3"."$4]; next} $5"."$6 in geneIDs' geneNamesTree_AB_ribosomalProteins_geneIDs /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3

#### and save them as a .bed file
awk 'BEGIN{FS="."}NR==FNR{geneIDs[$3"."$4]; next} $5"."$6 in geneIDs' geneNamesTree_AB_ribosomalProteins_geneIDs /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 | awk '{print $1"\t"int($4)-1"\t"$5"\t"$9"\t"$3}' | sort | uniq > Astatotilapia_burtoni.BROADAB1.UTRs.gff3.ribosomalUTRs.bed

# change old .bed file to have 5th field specify "protein_coding"
awk 'BEGIN{FS="\t"}{print $1"\t"$2"\t"$3"\t"$4"\tprotein_coding"}' Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.ribosomalProteins.bed > Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.ribosomalProteins.protein_coding.bed

# make one big .bed file
cat Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.ribosomalProteins.protein_coding.bed Astatotilapia_burtoni.BROADAB1.UTRs.gff3.ribosomalUTRs.bed | sort -k1 > Astatotilapia_burtoni.ribosomalProteinsAndUTRs.bed
python /Volumes/fishstudies/_scripts/cleanMixedBed Astatotilapia_burtoni.ribosomalProteinsAndUTRs.bed



#############################
#AFTER running TopHat       #
#############################
# bio-rdf02:ATCACGRibosomeWithUTRsAndIntrons burtonigenomics$ samtools view -b -s .000001 unmapped.bam > /Volumes/fishstudies/Katrina/smalltestbam.bam
# bio-rdf02:Katrina burtonigenomics$ samtools view -b -s .0001 /Volumes/fishstudies/Katrina/tophat/ATCACGRibosomeWithUTRsAndIntrons/accepted_hits.bam > /Volumes/fishstudies/Katrina/smalltestmappedbam.bam


cd ~/Documents
java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar INPUT=/Volumes/fishstudies/Katrina/smalltestmappedbam.bam OUTPUT=/Volumes/fishstudies/Katrina/smalltestmappedbam.RG.bam RGID=ND RGSM=3157 RGPL=illumina RGLB=lib1 RGPU=ATCACG
#this works for aligned .bam files. For unaligned use:
java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar INPUT=/Volumes/fishstudies/Katrina/smalltestmappedbam.bam OUTPUT=/Volumes/fishstudies/Katrina/smalltestmappedbam.RG.bam RGID=ND RGSM=3157 RGPL=illumina RGLB=lib1 RGPU=ATCACG VALIDATION_STRINGENCY=SILENT
# source: http://seqanswers.com/forums/showpost.php?p=138391&postcount=14
#     this also suggests trying GATK AddOrReplaceReadGroups if this should fail in the future
samtools index smalltestmappedbam.RG.bam 
samtools idxstats smalltestmappedbam.RG.bam > smalltestmappedbam_idxstats.RG.txt
java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/ValidateSamFile.jar INPUT=/Volumes/fishstudies/Katrina/smalltestmappedbam.RG.bam OUTPUT=/Volumes/fishstudies/Katrina/smalltestmappedbam.RG.bam.ValidateSamFile








#############
# compare which genes have diff exp
#####



bio-rdf02:Katrina burtonigenomics$ comm ~/Documents/gatkbp/cuffdiff_postRealign_bqsr_fa/gene_exp.diff.differentiallyExpressedGenes.IDs cuffdiff/cuffdiff_postRealign_bqsr/gene_exp.diff.differentiallyExpressedGenes.IDs | cut -f1 > cuffdiff_diffInOldOnly
bio-rdf02:Katrina burtonigenomics$ comm ~/Documents/gatkbp/cuffdiff_postRealign_bqsr_fa/gene_exp.diff.differentiallyExpressedGenes.IDs cuffdiff/cuffdiff_postRealign_bqsr/gene_exp.diff.differentiallyExpressedGenes.IDs | cut -f2 > cuffdiff_diffInNewOnly
bio-rdf02:Katrina burtonigenomics$ comm ~/Documents/gatkbp/cuffdiff_postRealign_bqsr_fa/gene_exp.diff.differentiallyExpressedGenes.IDs cuffdiff/cuffdiff_postRealign_bqsr/gene_exp.diff.differentiallyExpressedGenes.IDs | cut -f3 > cuffdiff_diffInOldAndNew
bio-rdf02:Katrina burtonigenomics$ awk 'BEGIN{FS="\t"}NR==FNR{if($1!=""){geneIDs[$1]}; next}$1 in geneIDs{print; delete geneIDs[$1]}END{for (x in geneIDs) {print x}}' cuffdiff_diffInOldOnly geneNamesTree_AB > cuffdiff_diffInOldOnly.info
bio-rdf02:Katrina burtonigenomics$ awk 'BEGIN{FS="\t"}NR==FNR{if($1!=""){geneIDs[$1]}; next}$1 in geneIDs{print; delete geneIDs[$1]}END{for (x in geneIDs) {print x}}' cuffdiff_diffInNewOnly geneNamesTree_AB > cuffdiff_diffInNewOnly.info
bio-rdf02:Katrina burtonigenomics$ awk 'BEGIN{FS="\t"}NR==FNR{if($1!=""){geneIDs[$1]}; next}$1 in geneIDs{print; delete geneIDs[$1]}END{for (x in geneIDs) {print x}}' cuffdiff_diffInOldAndNew geneNamesTree_AB > cuffdiff_diffInOldAndNew.info
bio-rdf02:Katrina burtonigenomics$ awk 'BEGIN{FS="\t"}NR==FNR{if($1!=""){geneIDs[$1]}; next}$1 in geneIDs{print; delete geneIDs[$1]}END{for (x in geneIDs) {print x}}' cuffdiff_diffInOldOnly cuffdiff/cuffdiff_postRealign_bqsr/gene_exp.diff > cuffdiff_diffInOldOnly_expNew
bio-rdf02:Katrina burtonigenomics$ awk 'BEGIN{FS="\t"}NR==FNR{if($1!=""){geneIDs[$1]}; next}$1 in geneIDs{print; delete geneIDs[$1]}END{for (x in geneIDs) {print x}}' cuffdiff_diffInNewOnly cuffdiff/cuffdiff_postRealign_bqsr/gene_exp.diff > cuffdiff_diffInNewOnly_expNew
bio-rdf02:Katrina burtonigenomics$ awk 'BEGIN{FS="\t"}NR==FNR{if($1!=""){geneIDs[$1]}; next}$1 in geneIDs{print; delete geneIDs[$1]}END{for (x in geneIDs) {print x}}' cuffdiff_diffInOldAndNew cuffdiff/cuffdiff_postRealign_bqsr/gene_exp.diff > cuffdiff_diffInOldAndNew_expNew
bio-rdf02:Katrina burtonigenomics$ awk 'BEGIN{FS="\t"}NR==FNR{if($1!=""){geneIDs[$1]}; next}$1 in geneIDs{print; delete geneIDs[$1]}END{for (x in geneIDs) {print x}}' cuffdiff_diffInOldOnly ~/Documents/gatkbp/cuffdiff_postRealign_bqsr_fa/gene_exp.diff > cuffdiff_diffInOldOnly_expOld
bio-rdf02:Katrina burtonigenomics$ awk 'BEGIN{FS="\t"}NR==FNR{if($1!=""){geneIDs[$1]}; next}$1 in geneIDs{print; delete geneIDs[$1]}END{for (x in geneIDs) {print x}}' cuffdiff_diffInNewOnly ~/Documents/gatkbp/cuffdiff_postRealign_bqsr_fa/gene_exp.diff > cuffdiff_diffInNewOnly_expOld
bio-rdf02:Katrina burtonigenomics$ awk 'BEGIN{FS="\t"}NR==FNR{if($1!=""){geneIDs[$1]}; next}$1 in geneIDs{print; delete geneIDs[$1]}END{for (x in geneIDs) {print x}}' cuffdiff_diffInOldAndNew ~/Documents/gatkbp/cuffdiff_postRealign_bqsr_fa/gene_exp.diff > cuffdiff_diffInOldAndNew_expOld

#find SNPs common to two files
awk 'NR==FNR{if($1 !~ /^#/){snpsInA[$1"\t"$2] = $4"\t"$5"\t"$6}; next} $1"\t"$2 in snpsInA{print $1"\t"$2"\t"snpsInA[$1"\t"$2]"\t"$4"\t"$5"\t"$6}' ../CGATGT/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf ../TTAGGC/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf | sort > ../SNPsInBothD

awk 'NR==FNR{if($1 !~ /^#/){snpsInA[$1"\t"$2] = $3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8}; next} $1"\t"$2 in snpsInA{print $1"\t"$2"\t"snpsInA[$1"\t"$2]"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8}' ../SNPsInBothD ../SNPsInBothND | sort > ../SNPsInAllFour

awk 'NR==FNR{if($1 !~ /^#/){snpsIn2[$1"\t"$2] = $3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8}; next} $1"\t"$2 in snpsIn2{delete snpsIn2[$1"\t"$2]} END{for(ID in snpsIn2){print ID"\t"snpsIn2[ID]}}' ../SNPsInBothD ../ATCACG/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf | \
awk 'NR==FNR{if($1 !~ /^#/){snpsIn2[$1"\t"$2] = $3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8}; next} $1"\t"$2 in snpsIn2{delete snpsIn2[$1"\t"$2]} END{for(ID in snpsIn2){print ID"\t"snpsIn2[ID]}}' - ../TGACCA/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf | sort > ../SNPsInJustD


awk 'NR==FNR{knownSNPs[$1"\t"$4]; next}{if($1"\t"$2 in knownSNPs){print $0"\tKnown"}else{print $0"\tNew"}}' /Users/burtonigenomics/Documents/_Burtoni_annotations/Assembly_SNPs.noHeader.gff3 "SNP_comparisons/"$s"_SNPs" > "SNP_comparisons/"$s"_SNPs_assemblySNPs"
awk 'NR==FNR{knownSNPs[$1"\t"$4]; next}{if($1"\t"$2 in knownSNPs){print $0"\tKnown"}else{print $0"\tNew"}}' /Users/burtonigenomics/Documents/_Burtoni_annotations/Assembly_SNPs.noHeader.gff3 "SNP_comparisons/"$s"_geneIntersections" > "SNP_comparisons/"$s"_geneIntersections_assemblySNPs"











##########################################
# NEW ANNOTATIONS
##########################################

awk '{if(int($4/100)*100 in counts){counts[int($4/100)*100]=counts[int($4/100)*100]+1}else{counts[int($4/100)*100]=1}}END{for(position in counts){if(counts[position] > 300){print position"\t"counts[position]}}}' scaffold36_nofeature_test.sam | sort


awk '{if(int($4/100)*100 in counts){counts[int($4/100)*100]=counts[int($4/100)*100]+1}else{counts[int($4/100)*100]=1}}END{for(position in counts){if(counts[position] > 300){print position"\t"counts[position]}}}' scaffold36_nofeature_test.sam | \
awk 'NR==FNR{positions[$1]; next}int($4/100)*100 in positions || int($4/100 - 1)*100 in positions || int($4/100 + 1)*100 in positions' - scaffold36_nofeature_test.sam > scaffold36_nofeature_test.sam.readsOfInterest
sort -k3 -k4 -g scaffold36_nofeature_test.sam.readsOfInterest > scaffold36_nofeature_test.sam.readsOfInterest.sorted
cufflinks -p 4 -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 scaffold36_nofeature_test.sam.readsOfInterest.sorted #change output loc



awk '$3=="scaffold_36"'  accepted_hits.namesorted.bam.bam_HTSeqCountAssignments.noFeature.sam > scaffold36_nofeature_test.sam



awk '{if($3"\t"int($4/100)*100 in counts){counts[$3"\t"int($4/100)*100]=counts[$3"\t"int($4/100)*100]+1}else{counts[$3"\t"int($4/100)*100]=1}}END{for(position in counts){if(counts[position] > 300){print position"\t"counts[position]}}}' twoScaffolds.test.sam | \
awk 'NR==FNR{positions[$1"\t"$2]; next}$3"\t"int($4/100)*100 in positions || $3"\t"int($4/100 - 1)*100 in positions || $3"\t"int($4/100 + 1)*100 in positions' - twoScaffolds.test.sam > twoScaffolds.test.sam.readsOfInterest
sort -k3,3 -k4,4n twoScaffolds.test.sam.readsOfInterest > twoScaffolds.test.sam.readsOfInterest.sorted
cufflinks -p 4 -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 twoScaffolds.test.sam.readsOfInterest.sorted
awk '$3=="exon"' transcripts.gtf > twoScaffolds.test.sam.readsOfInterest.sorted.cufflinks
bedtools getfasta -fi ../../../H_burtoni_v1.assembly.fa -bed twoScaffolds.test.sam.readsOfInterest.sorted.cufflinks -fo twoScaffolds.test.sam.readsOfInterest.sorted.cufflinks.fa
#rename transcripts.gtf
#get ONLY exons before getFasta

blastn -query twoScaffolds.test.sam.readsOfInterest.sorted.cufflinks.fa -out twoScaffolds.test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults -subject ../../../ncbiPredictedSequences.fa -outfmt 10


awk 'BEGIN{FS=","; print "qseqid,sseqid,pident,length,mismatch,gapopen,qstart,qend,sstart,send,evalue,bitscore"}NR==FNR{gsub("\\|", ":", $0); lookupTable[$1]=$2; next}{gsub("\\|", ":", $0); gsub($2, lookupTable[$2], $0); print;}' \
../../../ncbiPredictedSequences.fa.IDsTable twoScaffolds.test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults > twoScaffolds.test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated






#post-processing
awk '$NF == "XF:Z:no_feature"' accepted_hits.namesorted.bam.bam_HTSeqCountAssignments > accepted_hits.namesorted.bam.bam_HTSeqCountAssignments.noFeature.sam

wc thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts
cut -f1 thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort | uniq -c | sort | grep -v " 1 cuff.s"
cut -f1 thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} $1 in duplicates' - thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort

awk '$2 != "NO_HIT"' thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} $1 in duplicates' - thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort

awk '$2 != "NO_HIT"' thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | cut -f2 | sort | uniq -c | sort | grep -v " 1 " | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} $2 in duplicates' - thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort


# retrieve duplicates with exactly one hit and exactly one "NO_HIT", then clean to be just the hit and cut
awk '$2 != "NO_HIT"' thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} $1 in duplicates' - thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort | grep -v "NO_HIT" | cut -f1,2

#retrieve unduplicates and cut
cut -f1 thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort | grep -v "NO_HIT" | cut -f1,2

# retrieve pure no-hits and cut
cut -f1 thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort | grep "NO_HIT" | cut -f1,2

# retrieve pure multi-hits - must manually decide what to do with them!!
awk '$2 != "NO_HIT"' $fileName | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} $1 in duplicates' - $fileName | sort






cut -f1 thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort | grep "NO_HIT" | cut -f1,2 > thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts.NoBlastHits

cut -f1 thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts | sort | grep -v "NO_HIT" | cut -f1,2 > thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts.BlastHits

awk '$2 != "NO_HIT"' $fileName | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - $fileName | sort | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
awk 'NR==FNR{duplicates[$1]; next} $1 in duplicates' - $fileName | sort | grep -v "NO_HIT" | cut -f1,2 >> $fileName".uniqueBlastHits"



python /Volumes/fishstudies/_scripts/assembleGTF_NCBI.py thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.fa.BLASTresults.annotated.genecounts.BlastHits thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks
sort -k9 thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.gtf > thirtyScaffolds_test.sam.readsOfInterest.sorted.cufflinks.gtf.sorted
