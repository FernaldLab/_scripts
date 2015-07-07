# cd ~/Documents
# 
#  use picardtools AddOrReplaceReadGroups
# echo adding RG
# echo ATCACG
# java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar \
# INPUT=gatkbp/tophat/ATCACG/accepted_hits.bam \
# OUTPUT=gatkbp/tophat/ATCACG/accepted_hits.RG.bam \
# RGID=ND RGSM=3157 RGPL=illumina RGLB=lib1 RGPU=ATCACG
# 
# echo CGATGT
# java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar \
# INPUT=gatkbp/tophat/CGATGT/accepted_hits.bam \
# OUTPUT=gatkbp/tophat/CGATGT/accepted_hits.RG.bam \
# RGID=D RGSM=3165 RGPL=illumina RGLB=lib2 RGPU=CGATGT
# 
# echo TGACCA
# java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar \
# INPUT=gatkbp/tophat/TGACCA/accepted_hits.bam \
# OUTPUT=gatkbp/tophat/TGACCA/accepted_hits.RG.bam \
# RGID=ND RGSM=3677 RGPL=illumina RGLB=lib3 RGPU=TGACCA
# 
# echo TTAGGC
# java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar \
# INPUT=gatkbp/tophat/TTAGGC/accepted_hits.bam \
# OUTPUT=gatkbp/tophat/TTAGGC/accepted_hits.RG.bam \
# RGID=D RGSM=3581 RGPL=illumina RGLB=lib4 RGPU=TTAGGC

# make index files
echo making index files
ls gatkbp/tophat | awk '{print "echo "$1"; samtools index gatkbp/tophat/"$1"/accepted_hits.RG.bam"}' | bash
ls gatkbp/tophat | awk '{print "samtools idxstats gatkbp/tophat/"$1"/accepted_hits.RG.bam > gatkbp/tophat/"$1"/idxstats"$1".txt"}' | bash

# validate bams
echo validating bam files
ls gatkbp/tophat/ | awk '{print "echo "$1"; java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/ValidateSamFile.jar INPUT=gatkbp/tophat/"$1"/accepted_hits.RG.bam OUTPUT= gatkbp/tophat/"$1"/accepted_hits.RG.bam.ValidateSamFile"}' | bash
	