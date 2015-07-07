#!/bin/bash

cd /Volumes/fishstudies/_methylation

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
SUBJECTS="3157 3165 3581 3677"	  

for s in $SUBJECTS
do
	echo "Working on "$s".wig.bed.nucs_Gflip_CH..."
	for f in $FILES
	do 
		if `echo $f | grep AT 1>/dev/null 2>&1`
		then 
			str=$(echo $f | awk '{split($0,a,"/"); print a[4]"-"a[5]}')
		else
			str=$(echo $f | awk '{split($0,a,"/"); print a[3]}')
		fi
		echo "    $str"
		bedtools intersect -a $s".wig.bed.nucs_Gflip_CH" -b $f -wo > "newoverlap_all/"$s"_"${str}"-overlap"
	done
done