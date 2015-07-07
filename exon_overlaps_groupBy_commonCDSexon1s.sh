#!/bin/bash

SUBJECTS="3157 3165 3581 3677"

echo "Getting CDS from..."
for s in $SUBJECTS
	do 
		echo "  "$s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR"
		cut -f1 $s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR" > $s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR_CDS"
	done

echo "Finding overlaps..."
echo "  3157 v 3165"
comm -1 -2 3157_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR_CDS 3165_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR_CDS \
> 3157-3165_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR_CDScommon

echo "  3157-3165 v 3581"
comm -1 -2 3581_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR_CDS 3157-3165_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR_CDScommon \
> 3157-3165-3581_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR_CDScommon

echo "  3157-3165-3581 v 3677"
comm -1 -2 3677_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR_CDS 3157-3165-3581_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR_CDScommon \
> 3157-3165-3581-3677_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR_CDScommon

echo "Filtering to common CDSs..."
for s in $SUBJECTS
	do 
		echo "  "$s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR"
		awk 'BEGIN{FS="\t"}NR==FNR{a[$1];next}$1 in a' 3157-3165-3581-3677_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR_CDScommon $s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR" \
		> $s"_Astatotilapia_burtoni.BROADAB2fix_CDS.gtf-overlap_exon1s_groupedV2_forR_CDScommon"
	done