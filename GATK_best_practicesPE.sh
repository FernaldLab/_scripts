# build genome index
#cd ~/Documents/bowtie2-2.1.0
#./bowtie2-build -f ../_Burtoni_genome_files/H_burtoni_v1.assembly.padded.fa ../_Burtoni_genome_files/H_burtoni_v1.assembly.padded

# inspect genome index
#./bowtie2-inspect -s ../_Burtoni_genome_files/H_burtoni_v1.assembly.padded



# modified GATK best practices workflow


##### mapping with tophat/bowtie2 #####
### assume in ~/Documents on burtonigenomics and folders exist for each subject in ~/Documents/gatkbp/tophat
### Astatotilapia_burtoni.BROADcombo.gtf made in /Volumes/FishStudies/_scripts/combine_ABannoFiles.txt

ls gatkbp/tophat/ | \
awk '{print "tophat2 --library-type fr-firststrand -o gatkbp/tophat/"$1" -r 0 -p 4 -G _Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf _Burtoni_genome_files/H_burtoni_v1.assembly _LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$1"_1_pf.fastq.gz _LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$1"_2_pf.fastq.gz" \}'

## add read group info
# read group info, format: @RG\tID:group1\tSM:sample1\tPL:illumina\tLB:lib1\tPU:unit1
# check if @RG tag exists
#samtools view -H accepted_hits.bam | awk '/^@RG/'
#ls *.bam | awk '{print "echo "$1"; samtools view -H "$1" | awk '\''/^@RG/'\''"}' | bash

# use picardtools AddOrReplaceReadGroups
# java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar \
# INPUT=gatkbp/tophat/ATCACG/accepted_hits.bam \
# OUTPUT=gatkbp/tophat/ATCACG/accepted_hits.RG.bam \
# RGID=ND RGSM=3157 RGPL=illumina RGLB=lib1 RGPU=ATCACG
# 
# java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar \
# INPUT=gatkbp/tophat/CGATGT/accepted_hits.bam \
# OUTPUT=gatkbp/tophat/CGATGT/accepted_hits.RG.bam \
# RGID=D RGSM=3165 RGPL=illumina RGLB=lib2 RGPU=CGATGT
# 
# java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar \
# INPUT=gatkbp/tophat/TGACCA/accepted_hits.bam \
# OUTPUT=gatkbp/tophat/TGACCA/accepted_hits.RG.bam \
# RGID=ND RGSM=3677 RGPL=illumina RGLB=lib3 RGPU=TGACCA
# 
# java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar \
# INPUT=gatkbp/tophat/TTAGGC/accepted_hits.bam \
# OUTPUT=gatkbp/tophat/TTAGGC/accepted_hits.RG.bam \
# RGID=D RGSM=3581 RGPL=illumina RGLB=lib4 RGPU=TTAGGC

# make index files
# ls gatkbp/tophat | awk '{print "samtools index gatkbp/tophat/"$1"/accepted_hits.RG.bam"}' | bash
# ls gatkbp/tophat | awk '{print "samtools idxstats gatkbp/tophat/"$1"/accepted_hits.RG.bam > gatkbp/tophat/"$1"/idxstats.RG.txt"}' | bash

# validate bams
#ls gatkbp/tophat/ | \
#awk '{print "java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/ValidateSamFile.jar INPUT=gatkbp/tophat/"$1"/accepted_hits.RG.bam OUTPUT=gatkbp/tophat/"$1"/accepted_hits.RG.bam.ValidateSamFile"}' | bash

##### 
## dedupping

# make sure bams are coordinate sorted and check first few bytes
cd ~/Documents/gatkbp/tophat
#ls | awk '{print "echo "$1"; samtools view -H "$1"/accepted_hits.RG.bam | awk '\''/^@HD/'\''"}' | bash
# should be 0000000 037 213 \b 004
#ls | awk '{print "od -c -N4 "$1"/accepted_hits.RG.bam"}' | bash


#READ_NAME_REGEX="[a-zA-Z0-9-]+:[0-9]+:[a-zA-Z0-9]+:[0-9]+:([0-9]+):([0-9]+):([0-9]+)"
#HWI-ST373:364:C2HRPACXX:6:1105:9298:29400
# mark duplicates
ls | awk '{print "java -Xmx2g -jar ../../picard-tools-1.101/picard-tools-1.101/MarkDuplicates.jar INPUT="$1"/accepted_hits.RG.bam OUTPUT="$1"/accepted_hits.RG.DD.bam METRICS_FILE="$1"/accepted_hits.RG.DD.bam.DDmetrics READ_NAME_REGEX=\"[a-zA-Z0-9-]+:[0-9]+:[a-zA-Z0-9]+:[0-9]+:([0-9]+):([0-9]+):([0-9]+)\""}' | bash

# make new index
ls | awk '{print "java -Xmx2g -jar ../../picard-tools-1.101/picard-tools-1.101/BuildBamIndex.jar INPUT="$1"/accepted_hits.RG.DD.bam"}' | bash

#####
## prep for gatk
#make sequence dictionary for ReorderSam
java -Xmx2g -jar ../../picard-tools-1.101/picard-tools-1.101/CreateSequenceDictionary.jar REFERENCE=../../_Burtoni_genome_files/H_burtoni_v1.assembly.fa OUTPUT=../../_Burtoni_genome_files/H_burtoni_v1.assembly.dict

ls | grep ^[ACTG] | awk '{print "java -Xmx2g -jar ../../picard-tools-1.101/picard-tools-1.101/ReorderSam.jar INPUT="$1"/accepted_hits.RG.DD.bam OUTPUT="$1"/accepted_hits.RG.DD.reorderSam.bam REFERENCE=../../_Burtoni_genome_files/H_burtoni_v1.assembly.fa"}'
# make new index
ls | awk '{print "java -Xmx2g -jar ../../picard-tools-1.101/picard-tools-1.101/BuildBamIndex.jar INPUT="$1"/accepted_hits.RG.DD.reorderSam.bam"}' | bash

## local realignment around indels
# generate realignment target regions
ls | awk '{print "java -Xmx2g -jar ../../GenomeAnalysisTK.jar -T RealignerTargetCreator -R ../../_Burtoni_genome_files/H_burtoni_v1.assembly.fa -I "$1"/accepted_hits.RG.DD.reorderSam.bam -o "$1"/forIndelRealigner.intervals"}'

ls | grep ^[ACTG] | awk '{print "java -Xmx4g -jar ../../GenomeAnalysisTK.jar -T IndelRealigner -rf NotPrimaryAlignment -R ../../_Burtoni_genome_files/H_burtoni_v1.assembly.fa -I "$1"/accepted_hits.RG.DD.reorderSam.bam -targetIntervals "$1"/forIndelRealigner.intervals -o "$1"/accepted_hits.RG.DD.reorderSam.realign.bam"}'

#### base quality score recalibration
# convert gff3 of assembly snps to vcf
awk 'BEGIN{FS="\t"}!/^#/{split($9,ref,"="); print ""$1"\t"$4"\t.\t"substr(ref[4],1,1)"\t"substr(ref[4],3,1)"\t.\t.\t."}' ~/Documents/_Burtoni_annotations/Assembly_SNPs.gff3 > ~/Documents/_Burtoni_annotations/Assembly_SNPs.noHeader.vcf
# made ../../_Burtoni_annotations/AssemblySNPSvcf_header in TextEdit

### usually vcf files require a lot of specific info in the header but we made the most minimal well-formed vcf possible
### so, in this case the header should be "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER"
### basically just column names delimited by tabs

cat ../../_Burtoni_annotations/AssemblySNPSvcf_header ../../_Burtoni_annotations/Assembly_SNPs.noHeader.vcf > ../../_Burtoni_annotations/Assembly_SNPs.newHeader.vcf
ls | grep ^[ACTG] | awk '{print "java -Xmx4g -jar ../../GenomeAnalysisTK.jar -T BaseRecalibrator -I "$1"/accepted_hits.RG.DD.reorderSam.realign.bam -R ../../_Burtoni_genome_files/H_burtoni_v1.assembly.fa -knownSites ../../_Burtoni_annotations/Assembly_SNPs.newHeader.vcf -o "$1"/bqsr_recal_data.table"}'

ls | grep ^[ACTG] | awk '{print "java -Xmx2g -jar ../../GenomeAnalysisTK.jar -T PrintReads -R ../../_Burtoni_genome_files/H_burtoni_v1.assembly.fa -I "$1"/accepted_hits.RG.DD.reorderSam.realign.bam -BQSR "$1"/bqsr_recal_data.table -o "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam"}'

#### call SNPs

# try UnifiedGenotyper
ls | grep ^[ACTG] | awk '{print "java -Xmx4g -jar ../../GenomeAnalysisTK.jar -T UnifiedGenotyper -R ../../_Burtoni_genome_files/H_burtoni_v1.assembly.fa -l INFO -I "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam -o "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf -glm SNP -mbq 20 -stand_call_conf 30 -stand_emit_conf 50"}'

# try HaplotypeCaller
ls | grep ^[ACTG] | awk '{print "java -Xmx4g -jar ../../GenomeAnalysisTK.jar -T HaplotypeCaller -R ../../_Burtoni_genome_files/H_burtoni_v1.assembly.fa -l INFO -I "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam -o "$1"/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam.SNPsHC.vcf --genotyping_mode DISCOVERY -stand_call_conf 30 -stand_emit_conf 50"}'

#####
## cuffdiff
cuffdiff --library-type fr-firststrand -o ../cuffdiff -p 4 \
../../_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf \
ATCACG/accepted_hits.RG.DD.bam,TGACCA/accepted_hits.RG.DD.bam \
CGATGT/accepted_hits.RG.DD.bam,TTAGGC/accepted_hits.RG.DD.bam

cuffdiff --library-type fr-firststrand -o ../cuffdiff_postRealign -p 4 \
../../_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf \
ATCACG/accepted_hits.RG.DD.reorderSam.realign.bam,TGACCA/accepted_hits.RG.DD.reorderSam.realign.bam \
CGATGT/accepted_hits.RG.DD.reorderSam.realign.bam,TTAGGC/accepted_hits.RG.DD.reorderSam.realign.bam

cuffdiff --library-type fr-firststrand -o ../cuffdiff_postRealign_bqsr -p 4 \
../../_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf \
ATCACG/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam,TGACCA/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam \
CGATGT/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam,TTAGGC/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam

cuffdiff --library-type fr-firststrand -p 4 -u --FDR 0.05 \
-b ../../_Burtoni_genome_files/H_burtoni_v1.assembly.fa \
-o ../cuffdiff_postRealign_bqsrV2 \
../../_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf \
ATCACG/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam,TGACCA/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam \
CGATGT/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam,TTAGGC/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam

##########
tophat2 --library-type fr-firststrand -o gatkbp/tophat/"$1" \
-r 0 -p 4 -G _Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf \
_Burtoni_genome_files/H_burtoni_v1.assembly \
_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$1"_1_pf.fastq.gz _LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$1"_2_pf.fastq.gz