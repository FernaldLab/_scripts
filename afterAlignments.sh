#!/bin/bash

# This part of the pipeline takes a .bam file of aligned reads and neatens it up for GATK by adding
# read groups, dedupping, and reordering the file. Then, it calls variants using GATK's IndelRealigner,
# BaseRecalibrator, and UnifiedGenotyper.

# You need about 20 GB of free space for each animal.
# This script takes about 13 hours per animal to run.

# Before running this: genomePath.fa + index files should be in home folder CHECK
#                      bamPrefix should be correct for each subject
#                      check the read group info to be added in Step 1

homeFolder="/Users/burtonigenomics/Desktop/Katrina"
genomePath=$homeFolder"/H_burtoni_v1.assembly"


SUBJECTS="CGATGT TGACCA TTAGGC"

for s in $SUBJECTS
	do

		bamPrefix=$homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits"
		#The name of the accepted_hits.bam file, minus the .bam at the end
		
		###################################################################
		## Step 1: Get BAM to validate by adding read groups.            ##
		###################################################################
		# This step takes about 15 minutes per animal to run
		echo -e "\n\n\n##################### Starting Step 1 for "$s" #####################\n\n\n"
		date
		
		cd /Users/burtonigenomics/Documents
		# add read group info (may want to check first to see if read group info already exists)
		if [ $s == "ATCACG" ]
			then
				java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar INPUT=$bamPrefix".bam" OUTPUT=$bamPrefix".RG.bam" RGID=ND RGSM=3157 RGPL=illumina RGLB=lib1 RGPU=ATCACG
			fi
		if [ $s == "CGATGT" ]
			then
				java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar INPUT=$bamPrefix".bam" OUTPUT=$bamPrefix".RG.bam" RGID=D RGSM=3165 RGPL=illumina RGLB=lib2 RGPU=CGATGT
			fi
		if [ $s == "TGACCA" ]
			then
				java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar INPUT=$bamPrefix".bam" OUTPUT=$bamPrefix".RG.bam" RGID=ND RGSM=3677 RGPL=illumina RGLB=lib3 RGPU=TGACCA
			fi
		if [ $s == "TTAGGC" ]
			then
				java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/AddOrReplaceReadGroups.jar INPUT=$bamPrefix".bam" OUTPUT=$bamPrefix".RG.bam" RGID=D RGSM=3581 RGPL=illumina RGLB=lib4 RGPU=TTAGGC
			fi
		# this works for aligned .bam files. For unaligned add VALIDATION_STRINGENCY=SILENT to the end of this call
		#    source: http://seqanswers.com/forums/showpost.php?p=138391&postcount=14 (this also suggests trying GATK AddOrReplaceReadGroups if this should fail in the future)
		
		#index bam file
		samtools index $bamPrefix".RG.bam"
		samtools idxstats $bamPrefix".RG.bam" > $bamPrefix"_idxstats.RG.txt"
		
		#validate bam file
		java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/ValidateSamFile.jar INPUT=$bamPrefix".RG.bam" OUTPUT=$bamPrefix".RG.bam.ValidateSamFile"
		# this says no mate found for paired read for several reads in the test files. Indeed, they are unpaired in the test file, but it's unclear whether they were paired in the original file.
		
		
		###################################################################
		## Step 2: Dedupping                                             ##
		###################################################################
		# This step takes about 25 minutes per animal to run
		echo -e "\n\n\n##################### Starting Dedupping for "$s" #####################\n\n\n"
		date
		
		cd /Users/burtonigenomics/Documents
		samtools view -H $bamPrefix".RG.bam" | awk '/^@HD/' #make sure it says SO:coordinate
		od -c -N4 $bamPrefix".RG.bam" # check first few bits - should be 0000000 037 213 \b 004
		
		#READ_NAME_REGEX="[a-zA-Z0-9-]+:[0-9]+:[a-zA-Z0-9]+:[0-9]+:([0-9]+):([0-9]+):([0-9]+)"
		#HWI-ST373:364:C2HRPACXX:6:1105:9298:29400
		# mark duplicates
		java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/MarkDuplicates.jar INPUT=$bamPrefix".RG.bam" OUTPUT=$bamPrefix".RG.DD.bam" METRICS_FILE=$bamPrefix".RG.DD.bam.DDmetrics" READ_NAME_REGEX="[a-zA-Z0-9-]+:[0-9]+:[a-zA-Z0-9]+:[0-9]+:([0-9]+):([0-9]+):([0-9]+)"
		
		# make new index
		java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/BuildBamIndex.jar INPUT=$bamPrefix".RG.DD.bam"
		
		
		###################################################################
		## Step 3: Reorder Bam File                                      ##
		###################################################################
		# This step takes about 15 minutes per animal to run
		echo -e "\n\n\n##################### Starting to Reorder Bam File for "$s" #####################\n\n\n"
		date
		
		cd /Users/burtonigenomics/Documents
		# Create genome dictionary for ReorderSam. Only needs to be done once.
		java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/CreateSequenceDictionary.jar REFERENCE=$genomePath".fa" OUTPUT=$genomePath".dict"
		
		# Run ReorderSam for reasons unknown and reindex file
		java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/ReorderSam.jar INPUT=$bamPrefix".RG.DD.bam" OUTPUT=$bamPrefix".RG.DD.reorderSam.bam" REFERENCE=$genomePath".fa" #this step prints a LOT
		java -Xmx2g -jar picard-tools-1.101/picard-tools-1.101/BuildBamIndex.jar INPUT=$bamPrefix".RG.DD.reorderSam.bam"
		
		
		###################################################################
		## Step 4: Local Realignment Around Indels                       ##
		###################################################################
		# This step takes about 2.5 hours per animal to run
		echo -e "\n\n\n##################### Starting Local Realignment around Indels for "$s" #####################\n\n\n"
		date
		
		cd /Users/burtonigenomics/Documents
		java -Xmx2g -jar GenomeAnalysisTK.jar -T RealignerTargetCreator -R $genomePath".fa" -I $bamPrefix".RG.DD.reorderSam.bam" -o $bamPrefix".forIndelRealigner.intervals"
		#this step will take approximately 10 years, but it at least gives time estimates
		
		java -Xmx4g -jar GenomeAnalysisTK.jar -T IndelRealigner -rf NotPrimaryAlignment -R $genomePath".fa" -I $bamPrefix".RG.DD.reorderSam.bam" -targetIntervals $bamPrefix".forIndelRealigner.intervals" -o $bamPrefix".RG.DD.reorderSam.realign.bam"
		
		
		###################################################################
		## Step 5: Base Quality Score Recalibration                      ##
		###################################################################
		# This step takes about 6.5 hours per animal to run
		echo -e "\n\n\n##################### Starting BQSR for "$s" #####################\n\n\n"
		date
		
#       # Convert gff3 of assembly snps to vcf (This step only needs to be done once.)
# 		awk 'BEGIN{FS="\t"; print "##fileformat=VCFv4.1\n#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO"}!/^#/{split($9,ref,"="); print ""$1"\t"$4"\t.\t"substr(ref[4],1,1)"\t"substr(ref[4],3,1)"\t.\t.\t."}' _Burtoni_annotations/Assembly_SNPs.gff3 > _Burtoni_annotations/Assembly_SNPs.newHeader.vcf
# 		### usually vcf files require a lot of specific info in the header but we made the most minimal well-formed vcf possible
# 		### so, in this case the header should be "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER"
# 			###FIX: The first line must specify format ("##fileformat=VCFv4.1") and there must be a column called "INFO" as well.
# 		### basically just column names delimited by tabs
		
		# This step needs to be done once per animal.
		java -Xmx4g -jar GenomeAnalysisTK.jar -T BaseRecalibrator -I $bamPrefix".RG.DD.reorderSam.realign.bam" -R $genomePath".fa" -knownSites _Burtoni_annotations/Assembly_SNPs.newHeader.vcf -o $bamPrefix".bqsr_recal_data.table"
		java -Xmx2g -jar GenomeAnalysisTK.jar -T PrintReads -R $genomePath".fa" -I $bamPrefix".RG.DD.reorderSam.realign.bam" -BQSR $bamPrefix".bqsr_recal_data.table" -o $bamPrefix".RG.DD.reorderSam.realign.BQSR.bam"
		
		
		###################################################################
		## Step 6: Call Variants                                         ##
		###################################################################
		# This step takes about 3 hours per animal to run
		echo -e "\n\n\n##################### Starting to Call Variants for "$s" #####################\n\n\n"
		date
		
		# with UnifiedGenotyper (3 hours)
		java -Xmx4g -jar GenomeAnalysisTK.jar -T UnifiedGenotyper -R $genomePath".fa" -l INFO -I $bamPrefix".RG.DD.reorderSam.realign.BQSR.bam" -o $bamPrefix".RG.DD.reorderSam.realign.BQSR.bam.SNPs.vcf" -glm SNP -mbq 20 -stand_call_conf 30 -stand_emit_conf 50
		
		# with HaplotypeCaller
		# java -Xmx4g -jar GenomeAnalysisTK.jar -T HaplotypeCaller -R $genomePath".fa" -l INFO -I $bamPrefix".RG.DD.reorderSam.realign.BQSR.bam" -o $bamPrefix".RG.DD.reorderSam.realign.BQSR.bam.SNPsHC.vcf" --genotyping_mode DISCOVERY -stand_call_conf 30 -stand_emit_conf 50 --max_alternate_alleles 5
	done

###################################################################
# Step 6: Cuff Diff                                              ##
###################################################################

# cuffdiffOutputDir="/Users/burtonigenomics/Desktop/Katrina/cuffdiff"
# cd $homeFolder"/tophat/_filteredRuns/"
# 
# echo "CuffDiff 1"
# date
# cuffdiff --library-type fr-firststrand -o $cuffdiffOutputDir"/cuffdiff" -p 4 \
# $homeFolder"/Astatotilapia_burtoni.BROADAB2fix.noexons.gtf" \
# ATCACG/accepted_hits.RG.DD.bam,TGACCA/accepted_hits.RG.DD.bam \
# CGATGT/accepted_hits.RG.DD.bam,TTAGGC/accepted_hits.RG.DD.bam
# 
# echo "CuffDiff 2"
# date
# cuffdiff --library-type fr-firststrand -o $cuffdiffOutputDir"/cuffdiff_postRealign" -p 4 \
# $homeFolder"/Astatotilapia_burtoni.BROADAB2fix.noexons.gtf" \
# ATCACG/accepted_hits.RG.DD.reorderSam.realign.bam,TGACCA/accepted_hits.RG.DD.reorderSam.realign.bam \
# CGATGT/accepted_hits.RG.DD.reorderSam.realign.bam,TTAGGC/accepted_hits.RG.DD.reorderSam.realign.bam
# 
# echo "CuffDiff 3"
# date
# cuffdiff --library-type fr-firststrand -o $cuffdiffOutputDir"/cuffdiff_postRealign_bqsr" -p 4 \
# $homeFolder"/Astatotilapia_burtoni.BROADAB2fix.noexons.gtf" \
# ATCACG/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam,TGACCA/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam \
# CGATGT/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam,TTAGGC/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam
# 
# echo "CuffDiff 4"
# date
# cuffdiff --library-type fr-firststrand -p 4 -u --FDR 0.05 \
# -b $genomePath".fa" \
# -o $cuffdiffOutputDir"/cuffdiff_postRealign_bqsrV2" \
# $homeFolder"/Astatotilapia_burtoni.BROADAB2fix.noexons.gtf" \
# ATCACG/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam,TGACCA/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam \
# CGATGT/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam,TTAGGC/accepted_hits.RG.DD.reorderSam.realign.BQSR.bam



