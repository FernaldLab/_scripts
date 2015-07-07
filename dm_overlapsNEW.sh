#!/bin/bash

cd /Volumes/fishstudies/_methylation
#mkdir new3157v3165overlaps
FILES=" ../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix_CDS.gtf 
		../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.intron.gtf 
		../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3
		../_Burtoni_annotations/abur.lnc.final.gtf
		../_Burtoni_annotations/Abur_final_TE.bed
		../_Burtoni_annotations/abur_miRNAs-130326.fix.bed
		../_Burtoni_annotations/Burtoni_cnv_final.out.bed
		../_Burtoni_annotations/Assembly_SNPs.noHeader.gff3
		../_Burtoni_annotations/microsatellites.noHeader.gff3
		../_gatkbp_backup/tophat/ATCACG/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf
		../_gatkbp_backup/tophat/CGATGT/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf
	  "
echo "Getting overlaps for 3157_vs_3165.filtered.50percent.significant.bed_Gflip2_R ..."
for f in $FILES
do 
	if `echo $f | grep AT 1>/dev/null 2>&1`
	then 
		str=$(echo $f | awk '{split($0,a,"/"); print a[4]"-"a[5]}')
	else
		str=$(echo $f | awk '{split($0,a,"/"); print a[3]}')
	fi
	echo "  $str"
	bedtools intersect -a 3157_vs_3165.filtered.50percent.significant.bed_Gflip2_R -b $f -wo > "new3157v3165overlapsCH/"${str}"-overlap"
done