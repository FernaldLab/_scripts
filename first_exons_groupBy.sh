#!/bin/bash
cd ~/Documents/_methylation
SUBJECTS="3157 3165 3581 3677"

for s in $SUBJECTS
	do
		file=$s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap"	
		echo "Working on "$file"..."
		
		echo "  creating "${file}"_exon1s"
		awk '/exon_number "1"/' $file > ${file}"_exon1s"
		
		echo "    grouping "${file}"_exon1s by CDS"
		awk 'BEGIN{FS="\t"}{{for (f=1;f<11;f++) {printf $f":"}}{printf "\t"}{for (f=11;f<NF;f++) {printf $f"\t"}}{printf "\n"}}' \
		${file}"_exon1s" | sort -k2,2 -k5,5 -k6,6 | bedtools groupby -g 2,5,6 -c 1,1,8,9,10 -o count_distinct,freqdesc,collapse,collapse,collapse \
		> ${file}"_exon1s_grouped"
		
		echo "      running studyExonMethylation.py"
		/Volumes/fishstudies/_scripts/studyExonMethylation.py ${file}"_exon1s_grouped"
		echo "        running studyExonMethylation-parseForR.py"
		/Volumes/fishstudies/_scripts/studyExonMethylation-parseForR.py ${file}"_exon1s_groupedV2"
	done
