cd /Volumes/handsfiler\$/FishStudies/_methylation/

# exons,UTRs,lncRNAs,transposons,miRNAs,assembly SNPs,CNV - comboGTF

bedtools intersect \
-a dm_multiple.bed \
-b ../_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf \
-wao \
> dm_multiple.bed-comboGTF
awk 'BEGIN{FS="\t"}$13>0' dm_multiple.bed-comboGTF > dm_multiple.bed-comboGTFFILT

# microsatellites - microsatellites.noHeader.gff3

bedtools intersect \
-a dm_multiple.bed \
-b ../_Burtoni_annotations/microsatellites.noHeader.gff3 \
-wao \
> dm_multiple.bed-microsat
awk 'BEGIN{FS="\t"}$13>0' dm_multiple.bed-microsat > dm_multiple.bed-microsatFILT

# DE - cuffdiff

bedtools intersect \
-a dm_multiple.bed \
-b ../_gatkbp_backup/cuffdiff_postRealign/gene_exp.diff.sig.bed \
-wao \
> dm_multiple.bed-DE_postRealign
awk 'BEGIN{FS="\t"}$12>0' dm_multiple.bed-DE_postRealign > dm_multiple.bed-DE_postRealignFILT

bedtools intersect \
-a dm_multiple.bed \
-b ../_gatkbp_backup/cuffdiff_postRealign_bqsr_fa/gene_exp.diff.sig.bed \
-wao \
> dm_multiple.bed-DE_postRealign_bqsr_fa
awk 'BEGIN{FS="\t"}$12>0' dm_multiple.bed-DE_postRealign_bqsr_fa > dm_multiple.bed-DE_postRealign_bqsr_faFILT

# SNPs - individual files
ls ../_gatkbp_backup/tophat/ | \
awk '{print "echo "$1";bedtools intersect -a dm_multiple.bed -b ../_gatkbp_backup/tophat/"$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf -wao > dm_multiple.bed-SNP_"$1"_bqsr"}'
ls | grep bqsr$ | awk '{print "awk '\''BEGIN{FS=\"\\t\"} $12>1'\'' "$1" > "$1"Filt"}'

# splice junctions - individual files


