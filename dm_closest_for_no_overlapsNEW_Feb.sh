#!/bin/bash

cd /Volumes/fishstudies/_methylation
mkdir dm_all4_20X
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
echo "Getting closest features..."
for f in $FILES
do 
	if `echo $f | grep AT 1>/dev/null 2>&1`
	then 
		str=$(echo $f | awk '{split($0,a,"/"); print a[5]"-"a[6]}')
	else
		str=$(echo $f | awk '{split($0,a,"/"); print a[4]}')
	fi
	echo "  $str"
	bedtools closest -a dm_all4_20X_fromR_minimal.bed -b $f -D ref -s > "dm_all4_20X/"${str}"-closest_Dref_stranded"
	bedtools closest -a dm_all4_20X_fromR_minimal.bed -b $f -D ref > "dm_all4_20X/"${str}"-closest_Dref"
done