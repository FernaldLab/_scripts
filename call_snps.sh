#!/bin/bash

cd ~/Documents

# add read groups with picard tools
java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar \
INPUT=tophatOUT/orig/ATCACG/accepted_hits.bam \
OUTPUT=tophatOUT/orig/ATCACG/accepted_hits.bam.RG.bam \
RGLB=ATCACG RGPL=Illumina RGPU=ATCACG RGSM=ATCACG

# make index for new bam file
samtools index tophatOUT/orig/ATCACG/accepted_hits.bam.RG.bam

# call snps
java -jar GenomeAnalysisTK-2.8-1-g932cd3a/GenomeAnalysisTK.jar -T UnifiedGenotyper \
-R _Burtoni_genome_files/H_burtoni_v1.assembly.fa \
-l INFO -I tophatOUT/orig/ATCACG/accepted_hits.bam.RG.bam \
-o tophatOUT/orig/ATCACG/accepted_hits.bam.RG.bam.SNPs.vcf \
-glm SNP -mbq 20 -stand_call_conf 30 -stand_emit_conf 50


# add read groups with picard tools
java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar \
INPUT=tophatOUT/orig/CGATGT/accepted_hits.bam \
OUTPUT=tophatOUT/orig/CGATGT/accepted_hits.bam.RG.bam \
RGLB=CGATGT RGPL=Illumina RGPU=CGATGT RGSM=CGATGT

# make index for new bam file
samtools index tophatOUT/orig/CGATGT/accepted_hits.bam.RG.bam

# call snps
java -jar GenomeAnalysisTK-2.8-1-g932cd3a/GenomeAnalysisTK.jar -T UnifiedGenotyper \
-R _Burtoni_genome_files/H_burtoni_v1.assembly.fa \
-l INFO -I tophatOUT/orig/CGATGT/accepted_hits.bam.RG.bam \
-o tophatOUT/orig/CGATGT/accepted_hits.bam.RG.bam.SNPs.vcf \
-glm SNP -mbq 20 -stand_call_conf 30 -stand_emit_conf 50