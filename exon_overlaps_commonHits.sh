#!/bin/bash

SUBJECTS="3157 3165 3581 3677"

echo "Getting CDS methylation hits from..."
for s in $SUBJECTS
	do 
		echo "  "$s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap"
		cut -f1-3 $s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap" > $s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits"
	done

echo "Finding common hits..."
echo "  3157 v 3165"
comm -1 -2 3157_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits 3165_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits \
> 3157-3165_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits-common

echo "  3157-3165 v 3581"
comm -1 -2 3581_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits 3157-3165_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits-common \
> 3157-3165-3581_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits-common

echo "  3157-3165-3581 v 3677"
comm -1 -2 3677_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits 3157-3165-3581_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits-common \
> 3157-3165-3581-3677_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits-common

echo "Filtering to common hits..."
for s in $SUBJECTS
	do 
		echo "  "$s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap"
		awk 'BEGIN{FS="\t"}NR==FNR{a[$1$2$3];next}$1$2$3 in a' 3157-3165-3581-3677_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits-common $s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap" \
		> $s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_hits-common"
	done