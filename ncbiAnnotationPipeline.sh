#!/bin/bash

homeFolder="/Users/burtonigenomics/Desktop/Katrina"
SUBJECTS="TGACCA TTAGGC"

# Steps:
#    1. Run Section 1 (get and identify new genes)
#    2. Look through "Genes To Decide About" - select the most relevant annotation for each gene and add it to the bottom of $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"
#       >  open -a TextEdit.app $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"
#    3. Run Section 2 (combine redundant annotations)
#    4. Open up $preface".newGeneNumbers.deDupped". For each pair/triplet/quadruplet of genes in "Gene pairs: ", find those gene IDs in $preface".newGeneNumbers" and give them the same number. Change all
#       numbers after the pair so that no number is skipped. Also, if this is suspicious at all (ie other genes in between the members of the pair/triplet/quadruplet) check it out in IGV.
#       Also obviously do NOT combine genes that are on opposite strands - consult the list printed by Python.
#       >  open -a TextEdit.app $preface".newGeneNumbers.deDupped".
#       In case of ambiguity:
#       >  open -a TextEdit.app $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits.duplicates.sameScaffold.gtf"
#	 4. Run Section 3 (standardizing gene IDs and running HT-Seq)
#	 5. R - DE
#	 5. get .fa and BLAST online
#    "ncharacterized"


# Files that exist at the end:
#    accepted_hits.bam.cufflinksStranded.v4.sorted.gtf -> GTF of all new genes.
#    accepted_hits.bam.cufflinksStranded.v4.fa -> sequences of EVERYTHING in the GTF file
#    accepted_hits.bam.cufflinksStranded.v4.geneDescriptions -> identity (as determined by NCBI) of all new genes. .NoBlastHits only contains genes with no hit and .UniqueBlastHits has the rest.

#################################################################################################################################################
##                                                                  SECTION 1                                                                  ##
#################################################################################################################################################

# for s in $SUBJECTS
# 	do
# 		cd $homeFolder"/tophat/_filteredRuns/"$s
# 		
# 		#############################
# 		## 1. Get GTF of new genes ##
# 		#############################
# 		date
# 		echo "Running Cufflinks on "$s"... "
# 		cufflinks -p 4 --library-type fr-firststrand accepted_hits.bam
# 		awk '$3=="exon"' transcripts.gtf > accepted_hits.bam.cufflinksStranded
# 		# -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.gtf \
# 		# -M /Users/burtonigenomics/Documents/_Burtoni_annotations/Abur_final_TE.bed -M ../ATCACG/microRNAsFix.bed 
# 		
# 		##########################################
# 		## 2. Eliminate known/artifactual genes ##
# 		##########################################
# 		date
# 		echo "Filtering down to unknown exons... "
# 		bedtools intersect -a accepted_hits.bam.cufflinksStranded -b ../../../Astatotilapia_burtoni.BROADAB2fix.noexons.gtf -wo > accepted_hits.bam.cufflinksStranded.overlapv1
# 		awk 'BEGIN{FS="\""} NR == FNR {genesToExclude[$2]; next} !($2 in genesToExclude)' accepted_hits.bam.cufflinksStranded.overlapv1 accepted_hits.bam.cufflinksStranded > accepted_hits.bam.cufflinksStranded.overlapv1.NOoverlap
# 		bedtools intersect -a accepted_hits.bam.cufflinksStranded.overlapv1.NOoverlap -b /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 -wo > accepted_hits.bam.cufflinksStranded.overlapv2
# 		awk 'BEGIN{FS="\""} NR == FNR {genesToExclude[$2]; next} !($2 in genesToExclude)' accepted_hits.bam.cufflinksStranded.overlapv2 accepted_hits.bam.cufflinksStranded.overlapv1.NOoverlap > accepted_hits.bam.cufflinksStranded.overlapv2.NOoverlap
# 		bedtools intersect -a accepted_hits.bam.cufflinksStranded.overlapv2.NOoverlap -b /Users/burtonigenomics/Documents/_Burtoni_annotations/Abur_final_TE.bed -wo > accepted_hits.bam.cufflinksStranded.overlapv3
# 		awk 'BEGIN{FS="\""} NR == FNR {genesToExclude[$2]; next} !($2 in genesToExclude)' accepted_hits.bam.cufflinksStranded.overlapv3 accepted_hits.bam.cufflinksStranded.overlapv2.NOoverlap > accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap
# 		
# 		echo -e "\n\n\n==========================\nGenes Without a Direction\n==========================\n"
# 		awk '$7 == "."' accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap
# 		echo -e "\n==========================\nEND\n==========================\n\n\n"
# 		
# 		date
# 		echo "Eliminating directionless genes."
# 		awk '$7 != "."' accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap > accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional
# 		
# 		date
# 		echo "Running HT-Seq..."
# 		samtools view -h accepted_hits.namesorted.bam | htseq-count -m union -s reverse - accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional > accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional.HTSeq_counts
# 		
# 		# I did some checking in R to get 30 as the magic number.
# 		date
# 		echo "Filtering by counts..."
# 		awk '{print $1"\""$2}' accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional.HTSeq_counts | awk 'BEGIN{FS="\""} NR==FNR{counts[$1]=$2; next} int(counts[$2]) > 30' - accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional > accepted_hits.bam.cufflinksStranded.v4
# 		
# 		rm accepted_hits.bam.cufflinksStranded.overlap*
# 		
# 		##OPTIONAL STEP##
# 		# Remove more unwanted genes following this pattern.
# 		# Be sure to change variable "preface" below.
# 			# bedtools intersect -a CGATGT/accepted_hits.bam.cufflinksStranded.v4 -b ATCACG/accepted_hits.bam.cufflinksStranded.v4 -wo > newGenes_ATCACG_CGATGT.gtf
# 			# awk 'BEGIN{FS="\""} NR == FNR {genesToExclude[$2]; next} !($2 in genesToExclude)' newGenes_ATCACG_CGATGT.gtf CGATGT/accepted_hits.bam.cufflinksStranded.v4 > CGATGT/accepted_hits.bam.cufflinksStranded.v4.notATCACG
# 		
# 		
# 		##################
# 		## 3. Run BLAST ##
# 		##################
# 		preface=$homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits.bam.cufflinksStranded.v4"
# 		
# 		date
# 		echo "Getting fasta file for BLAST... "
# 		bedtools getfasta -fi ../../../H_burtoni_v1.assembly.fa -bed $preface -fo $preface".fa"
# 		
# 		# WARNING: BLAST uses a LOT of memory. Have at least 30gb of swap space available and be prepared to just let
# 		#     the computer work for a while, uninterrupted.
# 		date
# 		echo "Starting BLAST runs... "
# 		
# 		COUNTER=1
# 		while [  $COUNTER -lt 16  ] #####IS THIS THE RIGHT NUMBER
# 			do
# 				date
# 				echo -e "\tCreating subfile #"$COUNTER"..."
# 				awk -v num=$COUNTER 'NR > (int(num) - 1) * 1000 && NR <= int(num) * 1000' $preface".fa" > $preface".fa_"$COUNTER
# 				date
# 				echo -e "\tRunning BLAST..."
# 				blastn -query $preface".fa_"$COUNTER -out $preface".fa_"$COUNTER".BLASTresults" -subject $homeFolder"/ncbiPredictedSequences.fa" -outfmt 10
# 				# BLAST database source: http://www.ncbi.nlm.nih.gov/nuccore?linkname=bioproject_nuccore_transcript&from_uid=220165
# 				# Send to: > File > FASTA > Default order > Create File
# 				let COUNTER=COUNTER+1
# 			done
# 		
# 		date
# 		echo "Concatenating files..."
# 		cat $preface".fa_1.BLASTresults" $preface".fa_2.BLASTresults" $preface".fa_3.BLASTresults" $preface".fa_4.BLASTresults" $preface".fa_5.BLASTresults" $preface".fa_6.BLASTresults" $preface".fa_7.BLASTresults" $preface".fa_8.BLASTresults" $preface".fa_9.BLASTresults" $preface".fa_10.BLASTresults" $preface".fa_11.BLASTresults" $preface".fa_12.BLASTresults" $preface".fa_13.BLASTresults" $preface".fa_14.BLASTresults" $preface".fa_15.BLASTresults" >  $preface".fa.BLASTresults"
# 		rm $preface".fa_"*
# 		
# 		# grep "^>" ncbiPredictedSequences.fa | awk 'BEGIN{FS="|"}{gsub(",",":",$5); print"gi|"$2"|ref|"$4"|,"$5}' > ncbiPredictedSequences.fa.IDsTable
# 		date
# 		echo "Fetching gene descriptions... "
# 		awk 'BEGIN{FS=","; print "qseqid,sseqid,pident,length,mismatch,gapopen,qstart,qend,sstart,send,evalue,bitscore"}NR==FNR{gsub("\\|", ":", $0); lookupTable[$1]=$2; next}{gsub("\\|", ":", $0); gsub($2, lookupTable[$2], $0); print;}' \
# 		$homeFolder"/ncbiPredictedSequences.fa.IDsTable"  $preface".fa.BLASTresults" > $preface".fa.BLASTresults.annotated"
# 		
# 		date
# 		echo "Parsing annotations... "
# 		python /Volumes/fishstudies/_scripts/parseNCBIAnnotations.py $preface $preface".fa.BLASTresults.annotated"
# 		
# 		###########################
# 		## 4. Sort BLAST results ##
# 		###########################
# 		date
# 		echo "Subsetting BLAST hits... "
# 		cut -f1 $preface".fa.BLASTresults.annotated.genecounts" | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# 		awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - $preface".fa.BLASTresults.annotated.genecounts" | sort | grep "NO_HIT" | cut -f1,2 > $preface".fa.BLASTresults.annotated.genecounts.NoBlastHits"
# 		
# 		cut -f1 $preface".fa.BLASTresults.annotated.genecounts" | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# 		awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - $preface".fa.BLASTresults.annotated.genecounts" | sort | grep -v "NO_HIT" | cut -f1,2 > $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"
# 		
# 		awk '$2 != "NO_HIT"' $preface".fa.BLASTresults.annotated.genecounts" | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# 		awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - $preface".fa.BLASTresults.annotated.genecounts" | sort | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# 		awk 'NR==FNR{duplicates[$1]; next} $1 in duplicates' - $preface".fa.BLASTresults.annotated.genecounts" | sort | grep -v "NO_HIT" | cut -f1,2 >> $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"
# 		
# 		echo -e "\n\n\n\n\n==========================\nGenes To Decide About\n==========================\n"
# 		awk '$2 != "NO_HIT"' $preface".fa.BLASTresults.annotated.genecounts" | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# 		awk 'NR==FNR{duplicates[$1]; next} $1 in duplicates' - $preface".fa.BLASTresults.annotated.genecounts" | sort
# 		echo -e "\n==========================\nEND\n==========================\n\n\n"
# 			
# 		echo "Word counts:"
# 		wc $preface".fa.BLASTresults.annotated.genecounts.NoBlastHits"
# 		wc $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"
# 		echo -e "\n\n\n"
# 	done


## Look through "Genes To Decide About" - select the most relevant annotation for each gene and add it to the bottom of $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"
#       open -a TextEdit.app $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"

#################################################################################################################################################
##                                                                  SECTION 2                                                                  ##
#################################################################################################################################################

for s in $SUBJECTS
	do
		cd $homeFolder"/tophat/_filteredRuns/"$s
		preface=$homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits.bam.cufflinksStranded.v4"
		
		date
 		echo "Combining erroneously separated genes for animal "$s"... "
		
		awk 'BEGIN{FS="\t"}{print $1"."$2}' $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits" | \
		awk 'BEGIN{FS="."} $2"."$4 in seen {print $1"."$2"."$3"\t"$4; if (seen[$2"."$4] != ""){print seen[$2"."$4]}; seen[$2"."$4] = ""} {seen[$2"."$4] = $1"."$2"."$3"\t"$4}' > $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits.duplicates.sameScaffold"
		
		# awk 'BEGIN{FS="\t"}{print $1"."$2}' $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits" | cut -f2,4 -d "." | sort | uniq -c | grep -v "  1 " | cut -f2 -d "." | \
# 		awk 'BEGIN{FS="\t"} NR == FNR {descriptions[$0]; next} $2 in descriptions' - $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits" > $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits.duplicates"
# 		
# 		awk 'BEGIN{FS="\t"}{print $1"."$2}' $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits.duplicates" | cut -f2,4 -d "." | sort | uniq -c | grep "  1 " | awk 'BEGIN{FS="  1 "}{gsub(/\./, "\t", $2); print $2}' | \
# 		awk 'BEGIN{FS="\t"} NR == FNR {descriptions[$2] = $1; next} $2 in descriptions && $1 !~ descriptions[$2]' - $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits.duplicates" > \
# 		$preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits.duplicates.sameScaffold"
# 		
# 		echo -e "\n\n\n\n\n==========================\nNot Real Duplicates (check that there are no duplicate scaffolds) \n==========================\n"
# 		awk 'BEGIN{FS="\t"}{print $1"."$2}' $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits.duplicates" | cut -f2,4 -d "." | sort | uniq -c | grep "  1 " | awk 'BEGIN{FS="  1 "}{gsub(/\./, "\t", $2); print $2}' | \
# 		awk 'BEGIN{FS="\t"} NR == FNR {descriptions[$2] = $1; next} $2 in descriptions && $1 ~ descriptions[$2]' - $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits.duplicates"
# 		echo -e "\n==========================\nEND\n==========================\n\n\n"
		
		python /Volumes/fishstudies/_scripts/newAnnotationsFindDuplicates.py $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits.duplicates.sameScaffold" $preface $preface".newGeneNumbers"
		echo
		echo "Gene pairs: (REMEMBER TO IGNORE OPPOSITE-STRAND GENES LISTED ABOVE)"
		awk 'BEGIN{FS="\""}NF == 1 {print; next}{print $2}' $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits.duplicates.sameScaffold.gtf" | uniq
		
		cp $preface".newGeneNumbers" $preface".newGeneNumbers.deDupped"
	done


## Open up $preface".newGeneNumbers.deDupped". For each pair/triplet/quadruplet of genes in "Gene pairs: ", find those gene IDs in $preface".newGeneNumbers" and give them the same number. Change all
## numbers after the pair so that no number is skipped. Also, if this is suspicious at all (ie other genes in between the members of the pair/triplet/quadruplet) check it out in IGV.
## Also obviously do NOT combine genes that are on opposite strands - consult the list printed by Python. This would be a good step to write a script for but I haven't yet.
#       open -a TextEdit.app $preface".newGeneNumbers.deDupped".
## In case of ambiguity:
#       open -a TextEdit.app $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits.duplicates.sameScaffold.gtf"



#################################################################################################################################################
##                                                                  SECTION 3                                                                  ##
#################################################################################################################################################

# animalsCompleted=""
# filesToCat=""
# for s in $SUBJECTS
# 	do
# 		cd $homeFolder"/tophat/_filteredRuns/"$s
# 		preface=$homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits.bam.cufflinksStranded.v4"
# 		
# 		date
#  		echo "Creating final files for "$s"... "
#  		
#  		python /Volumes/fishstudies/assembleGTF_NCBI.py $preface".fa.BLASTresults.annotated.genecounts" $preface $preface".newGeneNumbers.deDupped" $s
#  		sort -k9 $preface".gtf" > $preface".sorted.gtf"
#  		
#  		awk 'BEGIN {FS="\""} {print $2"\t"$4"\t"$6}' $preface".sorted.gtf" | cut -d "." -f1,2,3,4,5,6,7 | sort | uniq > $preface".geneIDsTable"
#  		awk 'BEGIN{FS = "\t"}NR==FNR{newID[$2]=$1; next} {print newID[$1]"\t"$2}' $preface".geneIDsTable" $preface".fa.BLASTresults.annotated.genecounts" | sort > $preface".geneDescriptions"
#  		awk 'BEGIN{FS = "\t"}NR==FNR{newID[$2]=$1; next} {print newID[$1]"\t"$2}' $preface".geneIDsTable" $preface".fa.BLASTresults.annotated.genecounts.NoBlastHits" | sort > $preface".geneDescriptions.NoBlastHits"
#  		awk 'BEGIN{FS = "\t"}NR==FNR{newID[$2]=$1; next} {print newID[$1]"\t"$2}' $preface".geneIDsTable" $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits" | sort | uniq > $preface".geneDescriptions.UniqueBlastHits"
#  		grep -v "ncharacterized" $preface".geneDescriptions.UniqueBlastHits" > $preface".geneDescriptions.UniqueBlastHits.noUncharacterized"
# 
# 
#  		for other in animalsCompleted
#  			do
# 				bedtools intersect -a $preface -b $other"/accepted_hits.bam.cufflinksStranded.v4.sorted.gtf" -wo | \
# 				awk 'BEGIN{FS="\""} NR == FNR {genesToExclude[$2]; next} !($2 in genesToExclude)' - $preface > $preface".not"$other
# 				preface=$preface".not"$other
#  			done
#  		filesToCat=$filesToCat" "$preface
#  		animalsCompleted=$animalsCompleted" "$s
#  	done
#  	
# date
# echo "Creating unified GTF file ... "
# cat $filesToCat > $homeFolder"/newAnnotations_allAnimals_ncbi"
# 
# 
# 
# # This loop takes a while to run.
# 
# date
# echo "Starting HTSeq runs ... "
# for s in $SUBJECTS
# 	do
# 		cd $homeFolder"/tophat/_filteredRuns/"$s
# 		echo -e "\n\n\n\n\n\n\n\n############ "$s" ############ \n\n\n\n\n\n\n\n"
# 		date
# 		samtools view -h $homeFolder"/tophat/_filteredRuns/"$s"/accepted_hits.namesorted.bam" |
# 		htseq-count -m union -s reverse - $homeFolder"/newAnnotations_allAnimals_ncbi" > \
# 		$s"_newannotationsNCBI_HTSeqcounts.txt"
# 	done
# 
# date


#################################################################################################################################################
##                                                                  OLD STUFF                                                                  ##
#################################################################################################################################################


# homeFolder="/Users/burtonigenomics/Desktop/Katrina"
# preface=$homeFolder"/tophat/_filteredRuns/ATCACG/accepted_hits.bam.cufflinksStranded.v4"
# 
# cd $homeFolder"/tophat/_filteredRuns/ATCACG"
# 
# 
# # date
# # echo "Getting fasta file for BLAST... "
# # bedtools getfasta -fi ../../../H_burtoni_v1.assembly.fa -bed $preface -fo $preface".fa"
# 
# # WARNING: BLAST uses a LOT of memory. Have at least 30gb of swap space available and be prepared to just let
# #     the computer work for a while, uninterrupted.
# # date
# # echo "Starting BLAST runs... "
# # 
# # COUNTER=1
# # while [  $COUNTER -lt 16  ]
# # 	do
# # 		date
# # 		echo -e "\tCreating subfile #"$COUNTER"..."
# # 		awk -v num=$COUNTER 'NR > (int(num) - 1) * 1000 && NR <= int(num) * 1000' $preface".fa" > $preface".fa_"$COUNTER
# # 		date
# # 		echo -e "\tRunning BLAST..."
# # 		blastn -query $preface".fa_"$COUNTER -out $preface".fa_"$COUNTER".BLASTresults" -subject $homeFolder"/ncbiPredictedSequences.fa" -outfmt 10
# # 		# BLAST database source: http://www.ncbi.nlm.nih.gov/nuccore?linkname=bioproject_nuccore_transcript&from_uid=220165
# # 		# Send to: > File > FASTA > Default order > Create File
# # 		let COUNTER=COUNTER+1
# # 	done
# # 
# # date
# # echo "Concatenating files..."
# # cat $preface".fa_1.BLASTresults" $preface".fa_2.BLASTresults" $preface".fa_3.BLASTresults" $preface".fa_4.BLASTresults" $preface".fa_5.BLASTresults" $preface".fa_6.BLASTresults" $preface".fa_7.BLASTresults" $preface".fa_8.BLASTresults" $preface".fa_9.BLASTresults" $preface".fa_10.BLASTresults" $preface".fa_11.BLASTresults" $preface".fa_12.BLASTresults" $preface".fa_13.BLASTresults" $preface".fa_14.BLASTresults" $preface".fa_15.BLASTresults" >  $preface".fa.BLASTresults"
# # 
# # # grep "^>" ncbiPredictedSequences.fa | awk 'BEGIN{FS="|"}{gsub(",",":",$5); print"gi|"$2"|ref|"$4"|,"$5}' > ncbiPredictedSequences.fa.IDsTable
# # 
# # date
# # echo "Fetching gene descriptions... "
# # awk 'BEGIN{FS=","; print "qseqid,sseqid,pident,length,mismatch,gapopen,qstart,qend,sstart,send,evalue,bitscore"}NR==FNR{gsub("\\|", ":", $0); lookupTable[$1]=$2; next}{gsub("\\|", ":", $0); gsub($2, lookupTable[$2], $0); print;}' \
# # $homeFolder"/ncbiPredictedSequences.fa.IDsTable"  $preface".fa.BLASTresults" > $preface".fa.BLASTresults.annotated"
# # 
# # 
# # date
# # echo "Parsing annotations... "
# # python /Volumes/fishstudies/_scripts/parseNCBIAnnotations.py $preface $preface".fa.BLASTresults.annotated"
# # 
# # 
# # date
# # echo "Subsetting BLAST hits... "
# # cut -f1 $preface".fa.BLASTresults.annotated.genecounts" | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# # awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - $preface".fa.BLASTresults.annotated.genecounts" | sort | grep "NO_HIT" | cut -f1,2 > $preface".fa.BLASTresults.annotated.genecounts.NoBlastHits"
# # 
# # cut -f1 $preface".fa.BLASTresults.annotated.genecounts" | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# # awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - $preface".fa.BLASTresults.annotated.genecounts" | sort | grep -v "NO_HIT" | cut -f1,2 > $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"
# # 
# # awk '$2 != "NO_HIT"' $preface".fa.BLASTresults.annotated.genecounts" | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# # awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - $preface".fa.BLASTresults.annotated.genecounts" | sort | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# # awk 'NR==FNR{duplicates[$1]; next} $1 in duplicates' - $preface".fa.BLASTresults.annotated.genecounts" | sort | grep -v "NO_HIT" | cut -f1,2 >> $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"
# # 
# # echo -e "\n\n\n\n\n==========================\nGenes To Decide About\n==========================\n"
# # awk '$2 != "NO_HIT"' $preface".fa.BLASTresults.annotated.genecounts" | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# # awk 'NR==FNR{duplicates[$1]; next} $1 in duplicates' - $preface".fa.BLASTresults.annotated.genecounts" | sort
# # echo -e "\n==========================\nEND\n==========================\n\n\n"
# # 
# # echo "Word counts:"
# # wc $preface".fa.BLASTresults.annotated.genecounts.NoBlastHits"
# # wc $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"
# # echo -e "\n\n\n"
# # 
# #
# #
# 
# 
# # grep -v "ncharacterized" $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits" > $preface".fa.BLASTresults.annotated.genecounts.goodBlastHits"
# # 
# # awk 'BEGIN{FS="\t"}{print $2}' $preface".fa.BLASTresults.annotated.genecounts.goodBlastHits" | sort | uniq -c | sort | grep -v "  1 " | \
# # cut -f5,6,7,8,9,10,11,12,13,14 -d " " | awk 'BEGIN{FS="\t"}NR==FNR{duplicates[$1]; next} $2 in duplicates' - $preface".fa.BLASTresults.annotated.genecounts.goodBlastHits" | \
# # sort -k2 > $preface".fa.BLASTresults.annotated.genecounts.goodBlastHits.duplicates"
# 
# 
# # #
# # # python /Volumes/fishstudies/_scripts/assembleGTF_NCBI.py $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits" $preface
# # # sort -k9 $preface".gtf" > $preface".gtf.sorted"
# 
# # RENUMBER GENES. they're gross.
# # Get rid of uncharacterized locs??
# 
# # HTSeq-count
# 
# 
# 
# 
# ###################################################################################################
# ## CGATGT for comparison                                                                          #
# ###################################################################################################
# 
# homeFolder="/Users/burtonigenomics/Desktop/Katrina"
# preface=$homeFolder"/NOTAFILE"
# 
# cd $homeFolder"/tophat/_filteredRuns/CGATGT"
# 
# # date
# # echo "Running Cufflinks on CGATGT... "
# # cufflinks -p 4 --library-type fr-firststrand -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.gtf \
# # -M /Users/burtonigenomics/Documents/_Burtoni_annotations/Abur_final_TE.bed -M ../ATCACG/microRNAsFix.bed accepted_hits.bam
# # awk '$3=="exon"' transcripts.gtf > accepted_hits.bam.cufflinksStranded
# # 
# # date
# # echo "Filtering down to unknown exons... "
# # bedtools intersect -a accepted_hits.bam.cufflinksStranded -b ../../../Astatotilapia_burtoni.BROADAB2fix.noexons.gtf -wo > accepted_hits.bam.cufflinksStranded.overlapv1
# # awk 'BEGIN{FS="\""} NR == FNR {genesToExclude[$2]; next} !($2 in genesToExclude)' accepted_hits.bam.cufflinksStranded.overlapv1 accepted_hits.bam.cufflinksStranded > accepted_hits.bam.cufflinksStranded.overlapv1.NOoverlap
# # 
# # bedtools intersect -a accepted_hits.bam.cufflinksStranded.overlapv1.NOoverlap -b /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 -wo > accepted_hits.bam.cufflinksStranded.overlapv2
# # awk 'BEGIN{FS="\""} NR == FNR {genesToExclude[$2]; next} !($2 in genesToExclude)' accepted_hits.bam.cufflinksStranded.overlapv2 accepted_hits.bam.cufflinksStranded.overlapv1.NOoverlap > accepted_hits.bam.cufflinksStranded.overlapv2.NOoverlap
# # 
# # bedtools intersect -a accepted_hits.bam.cufflinksStranded.overlapv2.NOoverlap -b /Users/burtonigenomics/Documents/_Burtoni_annotations/Abur_final_TE.bed -wo > accepted_hits.bam.cufflinksStranded.overlapv3
# # awk 'BEGIN{FS="\""} NR == FNR {genesToExclude[$2]; next} !($2 in genesToExclude)' accepted_hits.bam.cufflinksStranded.overlapv3 accepted_hits.bam.cufflinksStranded.overlapv2.NOoverlap > accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap
# # 
# # echo -e "\n\n\n==========================\nGenes Without a Direction\n==========================\n"
# # awk '$7 == "."' accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap
# # echo -e "\n==========================\nEND\n==========================\n\n\n"
# # 
# # date
# # echo "Eliminating directionless genes."
# # awk '$7 != "."' accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap > accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional
# # 
# # date
# # echo "Running HT-Seq..."
# # samtools view -h accepted_hits.namesorted.bam | htseq-count -m union -s reverse - accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional > accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional.HTSeq_counts
# # 
# # # I did some checking in R.
# # date
# # echo "Filtering by counts..."
# # awk '{print $1"\""$2}' accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional.HTSeq_counts | awk 'BEGIN{FS="\""} NR==FNR{counts[$1]=$2; next} int(counts[$2]) > 30' - accepted_hits.bam.cufflinksStranded.overlapv3.NOoverlap.directional > accepted_hits.bam.cufflinksStranded.v4
# 
# 
# preface=$homeFolder"/tophat/_filteredRuns/CGATGT/accepted_hits.bam.cufflinksStranded.v4.notATCACG"
# 
# date
# echo "Getting fasta file for BLAST... "
# bedtools getfasta -fi ../../../H_burtoni_v1.assembly.fa -bed $preface -fo $preface".fa"
# 
# # WARNING: BLAST uses a LOT of memory. Have at least 30gb of swap space available and be prepared to just let
# #     the computer work for a while, uninterrupted.
# date
# echo "Starting BLAST runs... "
# 
# COUNTER=1
# while [  $COUNTER -lt 16  ] #####IS THIS THE RIGHT NUMBER
# 	do
# 		date
# 		echo -e "\tCreating subfile #"$COUNTER"..."
# 		awk -v num=$COUNTER 'NR > (int(num) - 1) * 1000 && NR <= int(num) * 1000' $preface".fa" > $preface".fa_"$COUNTER
# 		date
# 		echo -e "\tRunning BLAST..."
# 		blastn -query $preface".fa_"$COUNTER -out $preface".fa_"$COUNTER".BLASTresults" -subject $homeFolder"/ncbiPredictedSequences.fa" -outfmt 10
# 		# BLAST database source: http://www.ncbi.nlm.nih.gov/nuccore?linkname=bioproject_nuccore_transcript&from_uid=220165
# 		# Send to: > File > FASTA > Default order > Create File
# 		let COUNTER=COUNTER+1
# 	done
# 
# date
# echo "Concatenating files..."
# cat $preface".fa_1.BLASTresults" $preface".fa_2.BLASTresults" $preface".fa_3.BLASTresults" $preface".fa_4.BLASTresults" $preface".fa_5.BLASTresults" $preface".fa_6.BLASTresults" $preface".fa_7.BLASTresults" $preface".fa_8.BLASTresults" $preface".fa_9.BLASTresults" $preface".fa_10.BLASTresults" $preface".fa_11.BLASTresults" $preface".fa_12.BLASTresults" $preface".fa_13.BLASTresults" $preface".fa_14.BLASTresults" $preface".fa_15.BLASTresults" >  $preface".fa.BLASTresults"
# 
# # grep "^>" ncbiPredictedSequences.fa | awk 'BEGIN{FS="|"}{gsub(",",":",$5); print"gi|"$2"|ref|"$4"|,"$5}' > ncbiPredictedSequences.fa.IDsTable
# 
# date
# echo "Fetching gene descriptions... "
# awk 'BEGIN{FS=","; print "qseqid,sseqid,pident,length,mismatch,gapopen,qstart,qend,sstart,send,evalue,bitscore"}NR==FNR{gsub("\\|", ":", $0); lookupTable[$1]=$2; next}{gsub("\\|", ":", $0); gsub($2, lookupTable[$2], $0); print;}' \
# $homeFolder"/ncbiPredictedSequences.fa.IDsTable"  $preface".fa.BLASTresults" > $preface".fa.BLASTresults.annotated"
# 
# 
# date
# echo "Parsing annotations... "
# python /Volumes/fishstudies/_scripts/parseNCBIAnnotations.py $preface $preface".fa.BLASTresults.annotated"
# 
# 
# date
# echo "Subsetting BLAST hits... "
# cut -f1 $preface".fa.BLASTresults.annotated.genecounts" | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - $preface".fa.BLASTresults.annotated.genecounts" | sort | grep "NO_HIT" | cut -f1,2 > $preface".fa.BLASTresults.annotated.genecounts.NoBlastHits"
# 
# cut -f1 $preface".fa.BLASTresults.annotated.genecounts" | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - $preface".fa.BLASTresults.annotated.genecounts" | sort | grep -v "NO_HIT" | cut -f1,2 > $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"
# 
# awk '$2 != "NO_HIT"' $preface".fa.BLASTresults.annotated.genecounts" | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# awk 'NR==FNR{duplicates[$1]; next} !($1 in duplicates)' - $preface".fa.BLASTresults.annotated.genecounts" | sort | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# awk 'NR==FNR{duplicates[$1]; next} $1 in duplicates' - $preface".fa.BLASTresults.annotated.genecounts" | sort | grep -v "NO_HIT" | cut -f1,2 >> $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"
# 
# echo -e "\n\n\n\n\n==========================\nGenes To Decide About\n==========================\n"
# awk '$2 != "NO_HIT"' $preface".fa.BLASTresults.annotated.genecounts" | cut -f1 | sort | uniq -c | sort | grep -v " 1 cuff.s" | cut -f5 -d " " | \
# awk 'NR==FNR{duplicates[$1]; next} $1 in duplicates' - $preface".fa.BLASTresults.annotated.genecounts" | sort
# echo -e "\n==========================\nEND\n==========================\n\n\n"
# 
# echo "Word counts:"
# wc $preface".fa.BLASTresults.annotated.genecounts.NoBlastHits"
# wc $preface".fa.BLASTresults.annotated.genecounts.UniqueBlastHits"
# echo -e "\n\n\n"
# 
# 
# 
# #################
# 
# # 
# # cufflinks -p 4 -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.gtf \
# # -M /Users/burtonigenomics/Documents/_Burtoni_annotations/Abur_final_TE.bed -M microRNAsFix.bed accepted_hits.bam
# # awk '$3=="exon"' transcripts.gtf > $preface".readsOfInterest.sorted.cufflinks"
# # 
# # cufflinks -p 4 -M "/Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3", "/Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2fix.gtf", "/Users/burtonigenomics/Documents/_Burtoni_annotations/Abur_final_TE.bed", "microRNAsFix.bed" accepted_hits.bam
# # awk '$3=="exon"' transcripts.gtf > $preface".readsOfInterest.sorted.cufflinks"
# 
# ###################
# 
# # date
# # echo "Creating subsample file... "
# # awk 'int(substr($3, 10, 10)) >= 36 && int(substr($3, 10, 10)) < 600' accepted_hits.namesorted.bam.bam_HTSeqCountAssignments.noFeature.sam > $preface
# # 
# # date
# # echo "Finding reads of interest... "
# # awk '{if($3"\t"int($4/100)*100 in counts){counts[$3"\t"int($4/100)*100]=counts[$3"\t"int($4/100)*100]+1}else{counts[$3"\t"int($4/100)*100]=1}}END{for(position in counts){if(counts[position] > 300){print position"\t"counts[position]}}}' $preface | \
# # awk 'NR==FNR{positions[$1"\t"$2]; next}$3"\t"int($4/100)*100 in positions || $3"\t"int($4/100 - 1)*100 in positions || $3"\t"int($4/100 + 1)*100 in positions' - $preface > $preface".readsOfInterest"
# # 
# # date
# # echo "Sorting sam file... "
# # sort -k3,3 -k4,4n $preface".readsOfInterest" > $preface".readsOfInterest.sorted"
# 
# #samtools view -H accepted_hits.namesorted.bam.bam | cat - unassigned.sam.readsOfInterest.sorted > unassigned.sam.readsOfInterest.sorted.header
# 
# # date
# # echo "Starting CuffLinks... "
# # cufflinks -p 4 --library-type fr-firststrand -M /Volumes/fishstudies/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB1.UTRs.gff3 $preface".readsOfInterest.sorted.header"
# # awk '$3=="exon"' transcripts.gtf > $preface".readsOfInterest.sorted.header.cufflinks.new"
# 
# 
# 
# # bedtools intersect -a CGATGT/accepted_hits.bam.cufflinksStranded.v4 -b ATCACG/accepted_hits.bam.cufflinksStranded.v4 -wo > newGenes_ATCACG_CGATGT.gtf
# # awk 'BEGIN{FS="\""} NR == FNR {genesToExclude[$2]; next} !($2 in genesToExclude)' newGenes_ATCACG_CGATGT.gtf CGATGT/accepted_hits.bam.cufflinksStranded.v4 > CGATGT/accepted_hits.bam.cufflinksStranded.v4.notATCACG

