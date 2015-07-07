#!/bin/bash

cd ~/Documents/_BSeq_data
SUBJECTS="3157_TENNISON 3165_BRISCOE 3581_LYNLEY 3677_MONK"
for s in $SUBJECTS
do 
	echo "==================================================================="
	echo "==================== Working on "$s" ===================="
	echo "==================================================================="
	echo ""
	FILES=`ls $s | grep "ratio$\|CG$\|CpGcombined$"`
	echo "============= files to clean:"
	echo $FILES
	echo "============="
	for f in $FILES
	do
		echo "===== Writing... "$s"/"$f".clean"
		/Volumes/fishstudies/_scripts/methratio_clean.py $s"/"$f
	done
done

############################
##### terminal output
# 
# bio-rdf02:_BSeq_data burtonigenomics$ /Volumes/fishstudies/_scripts/BSseq2_clean_methratio_all_subjects.sh 
# ===================================================================
# ==================== Working on 3157_TENNISON ====================
# ===================================================================
# 
# ============= files to clean:
# aligned.adapters.q30.m0.methratio aligned.adapters.q30.m0.methratio.CG aligned.adapters.q30.m0.methratio_CpGcombined aligned.adapters.q30.m0.methratio_CpGcombined.CG
# =============
# ===== Writing... 3157_TENNISON/aligned.adapters.q30.m0.methratio.clean
# Skipping first line since appears to be header
# 
# 35956 lines had eff_CT_count rounded up to C_count because ratio==1 (0.08%)
# 48935 total lines removed (0.11%)
#   48935 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===== Writing... 3157_TENNISON/aligned.adapters.q30.m0.methratio.CG.clean
# 35628 lines had eff_CT_count rounded up to C_count because ratio==1 (0.55%)
# 16748 total lines removed (0.26%)
#   16748 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===== Writing... 3157_TENNISON/aligned.adapters.q30.m0.methratio_CpGcombined.clean
# Skipping first line since appears to be header
# 
# 12879 lines had eff_CT_count rounded up to C_count because ratio==1 (0.03%)
# 46032 total lines removed (0.1%)
#   46032 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===== Writing... 3157_TENNISON/aligned.adapters.q30.m0.methratio_CpGcombined.CG.clean
# 12551 lines had eff_CT_count rounded up to C_count because ratio==1 (0.23%)
# 13845 total lines removed (0.25%)
#   13845 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===================================================================
# ==================== Working on 3165_BRISCOE ====================
# ===================================================================
# 
# ============= files to clean:
# aligned.adapters.q30.m0.methratio aligned.adapters.q30.m0.methratio.CG aligned.adapters.q30.m0.methratio_CpGcombined aligned.adapters.q30.m0.methratio_CpGcombined.CG
# =============
# ===== Writing... 3165_BRISCOE/aligned.adapters.q30.m0.methratio.clean
# Skipping first line since appears to be header
# 
# 31703 lines had eff_CT_count rounded up to C_count because ratio==1 (0.08%)
# 38080 total lines removed (0.1%)
#   38080 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===== Writing... 3165_BRISCOE/aligned.adapters.q30.m0.methratio.CG.clean
# 31386 lines had eff_CT_count rounded up to C_count because ratio==1 (0.56%)
# 12553 total lines removed (0.22%)
#   12553 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===== Writing... 3165_BRISCOE/aligned.adapters.q30.m0.methratio_CpGcombined.clean
# Skipping first line since appears to be header
# 
# 13030 lines had eff_CT_count rounded up to C_count because ratio==1 (0.03%)
# 37360 total lines removed (0.1%)
#   37360 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===== Writing... 3165_BRISCOE/aligned.adapters.q30.m0.methratio_CpGcombined.CG.clean
# 12713 lines had eff_CT_count rounded up to C_count because ratio==1 (0.26%)
# 11833 total lines removed (0.25%)
#   11833 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===================================================================
# ==================== Working on 3581_LYNLEY ====================
# ===================================================================
# 
# ============= files to clean:
# aligned.adapters.q30.m0.methratio aligned.adapters.q30.m0.methratio.CG aligned.adapters.q30.m0.methratio_CpGcombined aligned.adapters.q30.m0.methratio_CpGcombined.CG
# =============
# ===== Writing... 3581_LYNLEY/aligned.adapters.q30.m0.methratio.clean
# Skipping first line since appears to be header
# 
# 27987 lines had eff_CT_count rounded up to C_count because ratio==1 (0.08%)
# 33905 total lines removed (0.09%)
#   33905 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===== Writing... 3581_LYNLEY/aligned.adapters.q30.m0.methratio.CG.clean
# 27688 lines had eff_CT_count rounded up to C_count because ratio==1 (0.52%)
# 11552 total lines removed (0.22%)
#   11552 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===== Writing... 3581_LYNLEY/aligned.adapters.q30.m0.methratio_CpGcombined.clean
# Skipping first line since appears to be header
# 
# 11277 lines had eff_CT_count rounded up to C_count because ratio==1 (0.03%)
# 33453 total lines removed (0.09%)
#   33453 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===== Writing... 3581_LYNLEY/aligned.adapters.q30.m0.methratio_CpGcombined.CG.clean
# 10978 lines had eff_CT_count rounded up to C_count because ratio==1 (0.24%)
# 11100 total lines removed (0.24%)
#   11100 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===================================================================
# ==================== Working on 3677_MONK ====================
# ===================================================================
# 
# ============= files to clean:
# aligned.adapters.q30.m0.methratio aligned.adapters.q30.m0.methratio.CG aligned.adapters.q30.m0.methratio_CpGcombined aligned.adapters.q30.m0.methratio_CpGcombined.CG
# =============
# ===== Writing... 3677_MONK/aligned.adapters.q30.m0.methratio.clean
# Skipping first line since appears to be header
# 
# 27841 lines had eff_CT_count rounded up to C_count because ratio==1 (0.07%)
# 33147 total lines removed (0.09%)
#   33147 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===== Writing... 3677_MONK/aligned.adapters.q30.m0.methratio.CG.clean
# 27572 lines had eff_CT_count rounded up to C_count because ratio==1 (0.51%)
# 11221 total lines removed (0.21%)
#   11221 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===== Writing... 3677_MONK/aligned.adapters.q30.m0.methratio_CpGcombined.clean
# Skipping first line since appears to be header
# 
# 11153 lines had eff_CT_count rounded up to C_count because ratio==1 (0.03%)
# 33016 total lines removed (0.09%)
#   33016 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
# 
# ===== Writing... 3677_MONK/aligned.adapters.q30.m0.methratio_CpGcombined.CG.clean
# 10884 lines had eff_CT_count rounded up to C_count because ratio==1 (0.23%)
# 11090 total lines removed (0.24%)
#   11090 because eff_CT_count<5
#   0 because ratio was NA
#   0 because eff_CT_count<CT_count but ratio!=1
