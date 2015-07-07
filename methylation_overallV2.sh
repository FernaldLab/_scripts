cd /Volumes/fishstudies/_methylation

# convert wig files to bed
#ls | grep wig$ | \
#awk '{print "wig2bed < "$1" > "$1".bed"}'

### get overlap with different features ###
## exons ##
echo GTF-exons
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.gtf -wo > "$1"-GTF.hit"}' | bash
ls | grep GTF.hit$ | awk '{print "echo "$1"; awk '\''BEGIN{FS=\"\\t\"} $8==\"exon\"'\'' "$1" > "$1"noCDS"}' | bash

# count number of hits for each unique methylation site
ls | grep noCDS$ | \
while read stdin; do echo $stdin; awk 'BEGIN{FS="\t"} {print $1":"$2"-"$3" "$4}' $stdin | uniq -c > ${stdin}"_uniq_ids"; done

# get info by exon, must be sorted by columns that groupby will use
ls | grep noCDS$ | \
awk '{print "echo "$1"; sort -k6,6 -k9,9 -k10,10 "$1" | bedtools groupby -g 6,9,10 -c 4,4,5,5,5,5,5,4 -o count,count_distinct,min,max,mean,median,stdev,freqdesc > "$1".groupby_6_9_10"}'

# confirm no repeated intervals in output, should be no output if ok
ls | grep noCDS.groupby_6_9_10$ | awk '{print "echo "$1"; awk '\''{print $1$2$3}'\'' "$1" | uniq -d"}' | bash

## introns ##
echo GTF-introns
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.intron.gtf -wo > "$1"-GTF.intron.hit"}'

# count number of hits for each unique methylation site
ls | grep intron.hit$ | \
while read stdin; do echo $stdin; awk 'BEGIN{FS="\t"} {print $1":"$2"-"$3" "$4}' $stdin | uniq -c > ${stdin}"_uniq_ids"; done

# get info by intron, must be sorted by columns that groupby will use
ls | grep intron.hit$ | \
awk '{print "echo "$1"; sort -k6,6 -k9,9 -k10,10 "$1" | bedtools groupby -g 6,9,10 -c 4,4,5,5,5,5,5,4 -o count,count_distinct,min,max,mean,median,stdev,freqdesc > "$1".groupby_6_9_10"}'

## UTRs ##
echo GFF-UTRs
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 -wo > "$1"-UTRs.hit"}' | bash

ls | grep UTRs.hit$ | \
awk '{print "echo "$1"; sort -k6,6 -k9,9 -k10,10 "$1" | bedtools groupby -g 6,9,10 -c 4,4,5,5,5,5,5,4 -o count,count_distinct,min,max,mean,median,stdev,freqdesc > "$1".groupby_6_9_10"}'

## lncs ##
echo lncs
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/abur.lnc.final.gtf -wo > "$1"-lncRNAs.hit"}' | bash

ls | grep lncRNAs.hit$ | \
awk '{print "echo "$1"; sort -k6,6 -k9,9 -k10,10 "$1" | bedtools groupby -g 6,9,10 -c 4,4,5,5,5,5,5,4 -o count,count_distinct,min,max,mean,median,stdev,freqdesc > "$1".groupby_6_9_10"}'

## transposons ##
echo TEs
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/Abur_final_TE.bed -wo > "$1"-TEs.hit"}' | bash

ls | grep TEs.hit$ | \
awk '{print "echo "$1"; sort -k6,6 -k7,7 -k8,8 "$1" | bedtools groupby -g 6,7,8 -c 4,4,5,5,5,5,5,4 -o count,count_distinct,min,max,mean,median,stdev,freqdesc > "$1".groupby_6_7_8"}'

## miRNAs ##    
echo miRNAs
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/abur_miRNAs-130326.fix.bed -wo > "$1"-miRNAs.hit"}' | bash
# needed to fix abur_miRNAs-130326.bed using:
# tr -d '\r' < abur_miRNAs-130326.bed > abur_miRNAs-130326.fix.bed

ls | grep miRNAs.hit$ | \
awk '{print "echo "$1"; sort -k6,6 -k7,7 -k8,8 "$1" | bedtools groupby -g 6,7,8 -c 4,4,5,5,5,5,5,4 -o count,count_distinct,min,max,mean,median,stdev,freqdesc > "$1".groupby_6_7_8"}'

## CNV ##
echo CNV
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/Burtoni_cnv_final.out.bed -wo > "$1"-CNVs.hit"}' | bash

ls | grep CNVs.hit$ | \
awk '{print "echo "$1"; sort -k6,6 -k7,7 -k8,8 "$1" | bedtools groupby -g 6,7,8 -c 4,4,5,5,5,5,5,4 -o count,count_distinct,min,max,mean,median,stdev,freqdesc > "$1".groupby_6_7_8"}'

## Assembly SNPs ##
echo Assembly_SNPs
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/Assembly_SNPs.noHeader.gff3 -wo > "$1"-SNPs_assembly.hit"}' | bash

ls | grep SNPs_assembly.hit$ | \
awk '{print "echo "$1"; sort -k6,6 -k9,9 -k10,10 "$1" | bedtools groupby -g 6,9,10 -c 4,4,5,5,5,5,5,4 -o count,count_distinct,min,max,mean,median,stdev,freqdesc > "$1".groupby_6_9_10"}'

## microsatellites ##
echo microsatellites
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/microsatellites.noHeader.gff3 -wo > "$1"-microsatellites.hit"}' | bash

ls | grep microsatellites.hit$ | \
awk '{print "echo "$1"; sort -k6,6 -k9,9 -k10,10 "$1" | bedtools groupby -g 6,9,10 -c 4,4,5,5,5,5,5,4 -o count,count_distinct,min,max,mean,median,stdev,freqdesc > "$1".groupby_6_9_10"}'

## DE ##
echo cuffdiff_postRealign_bqsr_fa
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_gatkbp_backup/cuffdiff_postRealign_bqsr_fa/gene_exp.diff.sig.bed -wo > "$1"-cuffdiff_postRealign_bqsr_fa.hit"}' | bash

ls | grep cuffdiff_postRealign_bqsr_fa.hit$ | \
awk '{print "echo "$1"; sort -k6,6 -k7,7 -k8,8 "$1" | bedtools groupby -g 6,7,8 -c 4,4,5,5,5,5,5,4 -o count,count_distinct,min,max,mean,median,stdev,freqdesc > "$1".groupby_6_7_8"}'

echo cuffdiff_postRealign_bqsr_fa_FDR.1
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_gatkbp_backup/cuffdiff_postRealign_bqsr_fa_FDR.1/gene_exp.diff.sig.bed -wo > "$1"-cuffdiff_postRealign_bqsr_fa_FDR.1.hit"}' | bash

ls | grep cuffdiff_postRealign_bqsr_fa_FDR.1.hit$ | \
awk '{print "echo "$1"; sort -k6,6 -k7,7 -k8,8 "$1" | bedtools groupby -g 6,7,8 -c 4,4,5,5,5,5,5,4 -o count,count_distinct,min,max,mean,median,stdev,freqdesc > "$1".groupby_6_7_8"}'

## SNPs ##
echo individual_SNPs

echo 3157
bedtools intersect -a 3157.wig.bed -b ../_gatkbp_backup/tophat/ATCACG/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf -wo > 3157.wig.bed-SNPs_realign_BQSR.hit

echo 3165
bedtools intersect -a 3165.wig.bed -b ../_gatkbp_backup/tophat/CGATGT/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf -wo > 3165.wig.bed-SNPs_realign_BQSR.hit

echo 3677
bedtools intersect -a 3677.wig.bed -b ../_gatkbp_backup/tophat/TGACCA/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf -wo > 3677.wig.bed-SNPs_realign_BQSR.hit

echo 3581
bedtools intersect -a 3581.wig.bed -b ../_gatkbp_backup/tophat/TTAGGC/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf -wo > 3581.wig.bed-SNPs_realign_BQSR.hit

################################

ls | grep '3157.*ids$' | while read stdin; do echo $stdin; awk 'BEGIN{FS=" "}{print $3}' $stdin > ${stdin}"_Only"; done
mkfile -n 1b 3157_uniq_ids
ls | grep '3157.*Only$' | while read stdin; do echo $stdin; cat $stdin >> 3157_uniq_ids; done



ls | grep '3165.*ids$' | while read stdin; do echo $stdin; awk 'BEGIN{FS=" "}{print $3}' $stdin > ${stdin}"_Only"; done

### continued in /Volumes/fishstudies/_code/methylation_overlap.R






################################
## get overlap with comboGTF
#ls | grep wig.bed$ | \
#awk '{print "bedtools intersect -a "$1" -b ../_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf -wao > "$1".comboGTFoverlap"}'

## filter to hits
#ls | grep comboGTFoverlap$ | awk '{print "awk '\''\$NF>0'\'' "$1" > "$1".hit"}'

## trim columns
#ls | grep hit$ | \
#awk '{print "awk '\''{print \"\"\$1\"\\t\"\$2\"\\t\"\$3\"\\t\"\$5\"\\t\"\$8\"\\t\"\$9\"\\t\"\$10\"\\t\"\$11\"\"}'\'' "$1" > "$1"TrimCols"}'