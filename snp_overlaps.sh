cd /Volumes/handsfiler$/FishStudies/_gatkbp_backup/tophat

ls | awk '{print "echo "$1"; awk '\''BEGIN{FS=\"\\t\"} !/^#/ {s=$2-1; print \"\"$1\"\\t\"s\"\\t\"$2\"\\t.\\t\"$6\"\"}'\'' "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.bed "}'

# exons,UTRs,lncRNAs,transposons,miRNAs,assembly SNPs,CNV - comboGTF

ls | awk '{print "echo "$1"; bedtools intersect -a "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.bed -b ../../_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf -wao > "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.bed-overlap"}'


bedtools intersect \
-a .bed \
-b ../_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf \
-wao \
> .bed-comboGTF
awk 'BEGIN{FS="\t"}$13>0' .bed-comboGTF > .bed-comboGTFFILT

## microsatellites - microsatellites.noHeader.gff3
# 
# bedtools intersect \
# -a .bed \
# -b ../_Burtoni_annotations/microsatellites.noHeader.gff3 \
# -wao \
# > .bed-microsat
# awk 'BEGIN{FS="\t"}$13>0' .bed-microsat > .bed-microsatFILT
# 
## DE - cuffdiff
# 
# bedtools intersect \
# -a .bed \
# -b ../_gatkbp_backup/cuffdiff_postRealign/gene_exp.diff.sig.bed \
# -wao \
# > .bed-DE_postRealign
# awk 'BEGIN{FS="\t"}$12>0' .bed-DE_postRealign > .bed-DE_postRealignFILT
# 
# bedtools intersect \
# -a .bed \
# -b ../_gatkbp_backup/cuffdiff_postRealign_bqsr_fa/gene_exp.diff.sig.bed \
# -wao \
# > .bed-DE_postRealign_bqsr_fa
# awk 'BEGIN{FS="\t"}$12>0' .bed-DE_postRealign_bqsr_fa > .bed-DE_postRealign_bqsr_faFILT
# 
## SNPs - individual files
# ls ../_gatkbp_backup/tophat/ | \
# awk '{print "echo "$1";bedtools intersect -a .bed -b ../_gatkbp_backup/tophat/"$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf -wao > .bed-SNP_"$1"_bqsr"}'
# ls | grep bqsr$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $12>1'\'' "$1" > "$1"Filt"}'
