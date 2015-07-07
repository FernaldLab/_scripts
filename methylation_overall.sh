cd /Volumes/fishstudies/_methylation

# convert wig files to bed
#ls | grep wig$ | \
#awk '{print "wig2bed < "$1" > "$1".bed"}'

### get overlap with different features ###
## exons ##
echo GTF-exons
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.gtf -wao > "$1"-GTF"}' | bash
echo getting_hits
ls | grep bed-GTF$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $NF>0'\'' "$1" > "$1".hit; rm "$1""}' | bash

## UTRs ##
echo GFF-UTRs
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 -wao > "$1"-UTRs"}' | bash
echo getting_hits
ls | grep bed-UTRs$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $NF>0'\'' "$1" > "$1".hit; rm "$1""}' | bash

## lncs ##
echo lncs
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/abur.lnc.final.gtf -wao > "$1"-lncRNAs"}' | bash
echo getting_hits
ls | grep bed-lncRNAs$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $NF>0'\'' "$1" > "$1".hit; rm "$1""}' | bash

## transposons ##
echo TEs
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/Abur_final_TE.bed -wao > "$1"-TEs"}' | bash
echo getting_hits
ls | grep bed-TEs$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $NF>0'\'' "$1" > "$1".hit; rm "$1""}' | bash

## miRNAs ##
echo miRNAs
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/abur_miRNAs-130326.bed -wao > "$1"-miRNAs"}' | bash
echo getting_hits
ls | grep bed-miRNAs$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $NF>0'\'' "$1" > "$1".hit; rm "$1""}' | bash

## CNV ##
echo CNV
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/Burtoni_cnv_final.out.bed -wao > "$1"-CNVs"}' | bash
echo getting_hits
ls | grep bed-CNVs$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $NF>0'\'' "$1" > "$1".hit; rm "$1""}' | bash

## Assembly SNPs ##
echo Assembly_SNPs
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/Assembly_SNPs.noHeader.gff3 -wao > "$1"-SNPs_assembly"}' | bash
echo getting_hits
ls | grep bed-SNPs_assembly$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $NF>0'\'' "$1" > "$1".hit; rm "$1""}' | bash

## microsatellites ##
echo microsatellites
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_Burtoni_annotations/microsatellites.noHeader.gff3 -wao > "$1"-microsatellites"}' | bash
echo getting_hits
ls | grep bed-microsatellites$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $NF>0'\'' "$1" > "$1".hit; rm "$1""}' | bash

## DE ##
echo cuffdiff_postRealign_bqsr_fa
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_gatkbp_backup/cuffdiff_postRealign_bqsr_fa/gene_exp.diff.sig.bed -wao > "$1"-cuffdiff_postRealign_bqsr_fa"}' | bash
echo getting_hits
ls | grep bed-cuffdiff_postRealign_bqsr_fa$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $NF>0'\'' "$1" > "$1".hit; rm "$1""}' | bash

echo cuffdiff_postRealign_bqsr_fa_FDR.1
ls | grep wig.bed$ | \
awk '{print "echo "$1"; bedtools intersect -a "$1" -b ../_gatkbp_backup/cuffdiff_postRealign_bqsr_fa_FDR.1/gene_exp.diff.sig.bed -wao > "$1"-cuffdiff_postRealign_bqsr_fa_FDR.1"}' | bash
echo getting_hits
ls | grep bed-cuffdiff_postRealign_bqsr_fa_FDR.1$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $NF>0'\'' "$1" > "$1".hit; rm "$1""}' | bash

## SNPs ##
echo individual_SNPs

echo 3157
bedtools intersect -a 3157.wig.bed -b ../_gatkbp_backup/tophat/ATCACG/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf -wao > 3157.wig.bed-SNPs_realign_BQSR
echo getting_hits
awk 'BEGIN{FS="\t"} $NF>0' 3157.wig.bed-SNPs_realign_BQSR > 3157.wig.bed-SNPs_realign_BQSR.hit
rm 3157.wig.bed-SNPs_realign_BQSR

echo 3165
bedtools intersect -a 3165.wig.bed -b ../_gatkbp_backup/tophat/CGATGT/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf -wao > 3165.wig.bed-SNPs_realign_BQSR
echo getting_hits
awk 'BEGIN{FS="\t"} $NF>0' 3165.wig.bed-SNPs_realign_BQSR > 3165.wig.bed-SNPs_realign_BQSR.hit
rm 3165.wig.bed-SNPs_realign_BQSR

echo 3677
bedtools intersect -a 3677.wig.bed -b ../_gatkbp_backup/tophat/TGACCA/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf -wao > 3677.wig.bed-SNPs_realign_BQSR
echo getting_hits
awk 'BEGIN{FS="\t"} $NF>0' 3677.wig.bed-SNPs_realign_BQSR > 3677.wig.bed-SNPs_realign_BQSR.hit
rm 3677.wig.bed-SNPs_realign_BQSR

echo 3581
bedtools intersect -a 3581.wig.bed -b ../_gatkbp_backup/tophat/TTAGGC/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf -wao > 3581.wig.bed-SNPs_realign_BQSR
echo getting_hits
awk 'BEGIN{FS="\t"} $NF>0' 3581.wig.bed-SNPs_realign_BQSR > 3581.wig.bed-SNPs_realign_BQSR.hit
rm 3581.wig.bed-SNPs_realign_BQSR

################################
## get overlap with comboGTF
#ls | grep wig.bed$ | \
#awk '{print "bedtools intersect -a "$1" -b ../_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf -wao > "$1".comboGTFoverlap"}'

## filter to hits
#ls | grep comboGTFoverlap$ | awk '{print "awk '\''\$NF>0'\'' "$1" > "$1".hit"}'

## trim columns
#ls | grep hit$ | \
#awk '{print "awk '\''{print \"\"\$1\"\\t\"\$2\"\\t\"\$3\"\\t\"\$5\"\\t\"\$8\"\\t\"\$9\"\\t\"\$10\"\\t\"\$11\"\"}'\'' "$1" > "$1"TrimCols"}'