java -Xmx2g -jar ../picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar \
INPUT=130913_LYNLEY_0364_AC2HRPACXX_L6_TGACCA_Rsubread.sam.bam.sorted.bam \
OUTPUT=130913_LYNLEY_0364_AC2HRPACXX_L6_TGACCA_Rsubread.sam.bam.sorted.bam.RG.bam \
RGLB=TGACCA RGPL=Illumina RGPU=TGACCA RGSM=TGACCA

samtools index 130913_LYNLEY_0364_AC2HRPACXX_L6_TGACCA_Rsubread.sam.bam.sorted.bam.RG.bam

java -jar /Volumes/fishstudies/GenomeAnalysisTK.jar -T UnifiedGenotyper \
-R ../_Burtoni_genome_files/H_burtoni_v1.assembly.fa \
-l INFO -I 130913_LYNLEY_0364_AC2HRPACXX_L6_TGACCA_Rsubread.sam.bam.sorted.bam.RG.bam \
-o 130913_LYNLEY_0364_AC2HRPACXX_L6_TGACCA_Rsubread.sam.bam.sorted.bam.snps.raw.vcf \
-glm SNP -mbq 20 -stand_call_conf 30 -stand_emit_conf 50



java -Xmx2g -jar ../picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar \
INPUT=130913_LYNLEY_0364_AC2HRPACXX_L6_TTAGGC_Rsubread.sam.bam.sorted.bam \
OUTPUT=130913_LYNLEY_0364_AC2HRPACXX_L6_TTAGGC_Rsubread.sam.bam.sorted.bam.RG.bam \
RGLB=TTAGGC RGPL=Illumina RGPU=TTAGGC RGSM=TTAGGC

samtools index 130913_LYNLEY_0364_AC2HRPACXX_L6_TTAGGC_Rsubread.sam.bam.sorted.bam.RG.bam

java -jar /Volumes/fishstudies/GenomeAnalysisTK.jar -T UnifiedGenotyper \
-R ../_Burtoni_genome_files/H_burtoni_v1.assembly.fa \
-l INFO -I 130913_LYNLEY_0364_AC2HRPACXX_L6_TTAGGC_Rsubread.sam.bam.sorted.bam.RG.bam \
-o 130913_LYNLEY_0364_AC2HRPACXX_L6_TTAGGC_Rsubread.sam.bam.sorted.bam.snps.raw.vcf \
-glm SNP -mbq 20 -stand_call_conf 30 -stand_emit_conf 50
