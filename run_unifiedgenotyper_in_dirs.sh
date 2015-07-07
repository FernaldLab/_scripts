#!/bin/bash

GENOME="~/Documents/_Burtoni_genome_files/H_burtoni_v1.assembly.fa"

echo -e "\n"===================================================================================
echo === 
echo ===================================================================================

for DIR in "$@"
do
	echo -e "\n"===================================================================================
	echo === Working on "$DIR" samples 
	echo -e ==================================================================================="\n"
	FILES=`ls "$DIR"/*BQSR.bam`
	for f in $FILES
	do 
		echo $f
# 		java -Xmx4g -jar ~/Documents/GenomeAnalysisTK.jar \
# 		-T UnifiedGenotyper \
# 		-R $GENOME \
# 		-l INFO \
# 		-I $f \
# 		-o $f"SNPs.vcf" \
# 		-glm SNP \
# 		-mbq 20 \
# 		-stand_call_conf 30 \
# 		-stand_emit_conf 50
		
		echo -e ==================================================================================="\n"
	done
done

