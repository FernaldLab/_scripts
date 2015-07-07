#!/bin/bash

### Command line arg $1 is name of directory to store results files

cd ~/Documents/_BSeq_data
mkdir $1
echo "Writing output files to 
# FILES="../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix_CDS.gtf
# 		../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.intron.gtf
# 		../_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3
# 		../_Burtoni_annotations/abur.lnc.final.gtf
# 		../_Burtoni_annotations/Abur_final_TE.bed
# 		../_Burtoni_annotations/abur_miRNAs-130326.fix.bed
# 		../_Burtoni_annotations/Burtoni_cnv_final.out.bed
# 		../_Burtoni_annotations/Assembly_SNPs.noHeader.gff3
# 		../_Burtoni_annotations/microsatellites.noHeader.gff3
# 	    /Volumes/fishstudies/_gatkbp_backup/tophat/ATCACG/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf
# 		/Volumes/fishstudies/_gatkbp_backup/tophat/CGATGT/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf
# 		/Volumes/fishstudies/_gatkbp_backup/tophat/TTAGGC/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf
# 		/Volumes/fishstudies/_gatkbp_backup/tophat/TGACCA/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf
# 	  "

FILES=" ../_Burtoni_annotations/ref_AstBur1.0_scaffolds.clean.translate.final.genesOnly.gff3
		../_Burtoni_annotations/abur.lnc.final.gtf
		../_Burtoni_annotations/Abur_final_TE.bed
		../_Burtoni_annotations/abur_miRNAs-130326.fix.bed
	  "


echo "Getting intersections and closest features..."
for f in $FILES
do 
	if `echo $f | grep BQSR 1>/dev/null 2>&1`
	then 
		str=$(echo $f | awk '{split($0,a,"/"); print a[4]"-"a[5]}')
	else
		str=$(echo $f | awk '{split($0,a,"/"); print a[3]}')
	fi
	echo "  $str"
	echo "    closest..."
	#bedtools closest -a test2 -b $f -D ref -s > $1"/"${str}"-closest_Dref_stranded"
	bedtools closest -a aligned.adapters.q30.m0.methratio.CG.clean.Combined_n20Smoothed.ns20h200mg500_5x_n20_tstat_dmrs_n3_md.1.txt_noHead -b $f -D ref > $1"/"${str}"-closest"
done