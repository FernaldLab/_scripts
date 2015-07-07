#!/bin/bash
cd ~/Documents/_methylation

SUBJECTS="3157 3165 3581 3677"

for s in $SUBJECTS
	do
		echo "Working on "$s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits-common..."
		awk 'BEGIN{FS="\t"}{{for (f=1;f<11;f++) {printf $f":"}}{printf "\t"}{for (f=11;f<NF;f++) {printf $f"\t"}}{printf "\n"}}' \
		$s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits-common" | \
		sort -k2,2 -k5,5 -k6,6 | \
		bedtools groupby -g 2,5,6 -c 1,1,8,9,10 -o count_distinct,freqdesc,collapse,collapse,collapse \
		> $s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits-common_grouped"
		echo "  running studyExonMethylation.py"
		/Volumes/fishstudies/_scripts/studyExonMethylation.py $s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits-common_grouped"
		echo "    running studyExonMethylation-parseForR.py"
		/Volumes/fishstudies/_scripts/studyExonMethylation-parseForR.py $s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits-common_groupedV2"
	done