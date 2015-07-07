#!/bin/bash

GENOME="~/Documents/_Burtoni_genome_files/H_burtoni_v1.assembly.fa"
SNPVCF="~/Documents/_Burtoni_annotations/Assembly_SNPs.newHeader.vcf"
echo -e "\n"===================================================================================
echo === Using genome:
echo $GENOME
echo -e "\n"=== Using SNPs:
echo $SNPVCF

echo -e "\n"===================================================================================
for DIR in "$@"
do
	echo -e "\n"===================================================================================
	echo === Working on "$DIR" samples 
	echo -e ==================================================================================="\n"
	FILES=`ls "$DIR"/*RG.DD.bam`
	for f in $FILES
	do 
		echo ===================================================================================
		echo $f
		echo "Making reordered Sam file..."
		subject=`echo $f | awk '{split($0,s,"_"); print s[1]}'`
		fReordered=`echo $f | awk '{sub("DD.bam","DD.reorderSam.bam",$0); print}'`
		echo "Output in "$fReordered
# 		java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/ReorderSam.jar \
# 		INPUT=$f \
# 		OUTPUT=$fReordered \
# 		REFERENCE=$GENOME
# 		echo "Making index for reordered Sam file..."
# 		java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/BuildBamIndex.jar \
# 		INPUT=$fReordered
		
		#### local realignment around indels
		echo "Generating realignment target regions for local realignment around indels..."
		echo "Output in "$subject"_forIndelRealigner.intervals"
# 		java -Xmx2g -jar ~/Documents/GenomeAnalysisTK.jar \
# 		-T RealignerTargetCreator \
# 		-R $GENOME \
# 		-I $fReordered \
# 		-o $subject"_forIndelRealigner.intervals"
		
		echo "Performing local realignment around indels..."
		fReorderedRealigned=`echo $fReordered | awk '{sub("reorderSam.bam","reorderSam.realign.bam",$0); print}'`
		echo "Output in "$fReorderedRealigned
# 		java -Xmx4g -jar ~/Documents/GenomeAnalysisTK.jar \
# 		-T IndelRealigner -rf NotPrimaryAlignment \
# 		-R $GENOME \
# 		-I $fReordered \
# 		-targetIntervals $subject"_forIndelRealigner.intervals" \
# 		-o $fReorderedRealigned
		
		#### base quality score recalibration
		echo "Generating base quality score recalibration table..."
		echo "Output in "$subject"_bqsr_recal_data.table"
# 		java -Xmx4g -jar ~/Documents/GenomeAnalysisTK.jar \
# 		-T BaseRecalibrator \
# 		-I $fReorderedRealigned \
# 		-R $GENOME \
# 		-knownSites $SNPVCF \
# 		-o $subject"_bqsr_recal_data.table"
		
		echo "Performing BQSR..."
		fReorderedRealignedBQSR=`echo $fReorderedRealigned | awk '{sub("realign.bam","realign.BQSR.bam",$0); print}'`
		echo "Output in "$fReorderedRealignedBQSR
# 		java -Xmx2g -jar ~/Documents/GenomeAnalysisTK.jar \
# 		-T PrintReads \
# 		-R $GENOME \
# 		-I $fReorderedRealigned \
# 		-BQSR $subject"_bqsr_recal_data.table" \
# 		-o $fReorderedRealignedBQSR
		
		echo ===================================================================================
	done
done
echo


####################################################################################################
################# sequence dictionary file and vcf of SNPs had to be made for first run
####################################################################################################
##### Not needed, file already made
### Make sequence dictionary for ReorderSam
# java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/CreateSequenceDictionary.jar \
# REFERENCE=~/Documents/_Burtoni_genome_files/H_burtoni_v1.assembly.fa \
# OUTPUT=~/Documents/_Burtoni_genome_files/H_burtoni_v1.assembly.dict

#### base quality score recalibration
##### Not needed, file already made
## convert gff3 of assembly snps to vcf
# awk 'BEGIN{FS="\t"}!/^#/{split($9,ref,"="); print ""$1"\t"$4"\t.\t"substr(ref[4],1,1)"\t"substr(ref[4],3,1)"\t.\t.\t."}' \
# ~/Documents/_Burtoni_annotations/Assembly_SNPs.gff3 \
# > ~/Documents/_Burtoni_annotations/Assembly_SNPs.noHeader.vcf
## made ../../_Burtoni_annotations/AssemblySNPSvcf_header in TextEdit

### usually vcf files require a lot of specific info in the header but we made the most minimal well-formed vcf possible
### so, in this case the header should be "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER"
### basically just column names delimited by tabs
# cat ../../_Burtoni_annotations/AssemblySNPSvcf_header ../../_Burtoni_annotations/Assembly_SNPs.noHeader.vcf \
# > ../../_Burtoni_annotations/Assembly_SNPs.newHeader.vcf
