#!/bin/bash

cd /Users/burtonigenomics/Desktop/Katrina/SNP_comparisons/

SUBJECTS="ATCACG CGATGT TGACCA TTAGGC"

for s in $SUBJECTS
do
bedtools closest -a $s"_SNPs_assemblySNPs_qualFiltered" -b ../Astatotilapia_burtoni.BROADAB2fix.noexons.gtf -d -id -D b -header | \
awk 'BEGIN{FS="\""}{print $1"\t"$2"\t"$NF}' - | awk 'int($23)>=-5000{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$10"\t"$11"\t"$12"\t"$15"\t"$16"\t"$18"\t"$19"\t"$21"\t"$23}' | sort | uniq > $s"_SNPs_assemblySNPs_qualFiltered_closestGenes"
echo "Finished "$s
done



# awk 'BEGIN{print "#\t\t\t\tATCACG\t\t\t\tTGACCA\t\t\t\t"}NR==FNR{if($1 !~ /^#/){snpsInA[$1"\t"$2] = $4"\t"$5"\t"$6"\t"$10}; next} $1"\t"$2 in snpsInA{print $1"\t"$2"\t.\t"$11"\t"snpsInA[$1"\t"$2]"\t"$4"\t"$5"\t"$6"\t"$10}' ATCACG_SNPs_assemblySNPs_qualFiltered TGACCA_SNPs_assemblySNPs_qualFiltered > SNPsInBothND
# awk 'BEGIN{print "#\t\t\t\tCGATGT\t\t\t\tTTAGGC\t\t\t\t"}NR==FNR{if($1 !~ /^#/){snpsInA[$1"\t"$2] = $4"\t"$5"\t"$6"\t"$10}; next} $1"\t"$2 in snpsInA{print $1"\t"$2"\t.\t"$11"\t"snpsInA[$1"\t"$2]"\t"$4"\t"$5"\t"$6"\t"$10}' CGATGT_SNPs_assemblySNPs_qualFiltered TTAGGC_SNPs_assemblySNPs_qualFiltered > SNPsInBothD
# 
# awk 'BEGIN{print "\t\t\t\tCGATGT\t\t\t\tTTAGGC\t\t\t\tATCACG\t\t\t\tTGACCA\t\t\t\t"}NR==FNR{if($1 !~ /^#/){snpsInA[$1"\t"$2] = $5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12}; next} \
# $1"\t"$2 in snpsInA{print $1"\t"$2"\t"$3"\t"$4"\t"snpsInA[$1"\t"$2]"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12}' SNPsInBothD SNPsInBothND > SNPsInAllFour
# 
# awk 'NR==FNR{if($1 !~ /^#/){snpsIn2[$1"\t"$2] = $0}; next} $1"\t"$2 in snpsIn2{delete snpsIn2[$1"\t"$2]} END{for(ID in snpsIn2){print snpsIn2[ID]}}' SNPsInBothND CGATGT_SNPs | \
# awk 'BEGIN{print "#\t\t\t\tATCACG\t\t\t\tTGACCA\t\t\t\t"}NR==FNR{if($1 !~ /^#/){snpsIn2[$1"\t"$2] = $0}; next} $1"\t"$2 in snpsIn2{delete snpsIn2[$1"\t"$2]} END{for(ID in snpsIn2){print snpsIn2[ID]}}' - TTAGGC_SNPs | sort > SNPsInJustND
# 
# awk 'NR==FNR{if($1 !~ /^#/){snpsIn2[$1"\t"$2] = $0}; next} $1"\t"$2 in snpsIn2{delete snpsIn2[$1"\t"$2]} END{for(ID in snpsIn2){print snpsIn2[ID]}}' SNPsInBothD ATCACG_SNPs | \
# awk 'BEGIN{print "#\t\t\t\tCGATGT\t\t\t\tTTAGGC\t\t\t\t"}NR==FNR{if($1 !~ /^#/){snpsIn2[$1"\t"$2] = $0}; next} $1"\t"$2 in snpsIn2{delete snpsIn2[$1"\t"$2]} END{for(ID in snpsIn2){print snpsIn2[ID]}}' - TGACCA_SNPs | sort > SNPsInJustD
# 
# echo "Combined Files created."

# bedtools closest -a SNPsInJustND -b ../Astatotilapia_burtoni.BROADAB2fix.noexons.gtf -d -id -D b -header | \
# awk 'BEGIN{FS="\""}{print $1"\t"$2"\t"$NF}' - | awk 'NR==1{print; next}int($24)>=-5000{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$16"\t"$17"\t"$19"\t"$20"\t"$22"\t"$24}' | sort | uniq > SNPsInJustND_closestGenes
# 
# echo "Bedtools done with ND animals."
# 
# bedtools closest -a SNPsInJustD -b ../Astatotilapia_burtoni.BROADAB2fix.noexons.gtf -d -id -D b -header | \
# awk 'BEGIN{FS="\""}{print $1"\t"$2"\t"$NF}' - | awk 'NR==1{print; next}int($24)>=-5000{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$16"\t"$17"\t"$19"\t"$20"\t"$22"\t"$24}' | sort | uniq > SNPsInJustD_closestGenes
# 
# echo "Bedtools done with D animals."

# awk '$4=="New"' SNPsInJustD_closestGenes > SNPsInJustD_closestGenes_onlyUnannotated
# awk '$4=="New"' SNPsInJustND_closestGenes > SNPsInJustND_closestGenes_onlyUnannotated

# awk 'BEGIN{print "#\t\t\t\tATCACG\t\t\t\tTTAGGC\t\t\t\t"}NR==FNR{if($1 !~ /^#/){snpsInA[$1"\t"$2] = $4"\t"$5"\t"$6"\t"$10}; next} $1"\t"$2 in snpsInA{print $1"\t"$2"\t.\t"$11"\t"snpsInA[$1"\t"$2]"\t"$4"\t"$5"\t"$6"\t"$10}' ATCACG_SNPs_assemblySNPs_qualFiltered TTAGGC_SNPs_assemblySNPs_qualFiltered | \
# awk 'NR==FNR{if($1 !~ /^#/){snpsIn2[$1"\t"$2] = $0}; next} $1"\t"$2 in snpsIn2{delete snpsIn2[$1"\t"$2]} END{for(ID in snpsIn2){print snpsIn2[ID]}}' - CGATGT_SNPs | \
# awk 'BEGIN{print "#\t\t\t\tATCACG\t\t\t\tTTAGGC\t\t\t\t"}NR==FNR{if($1 !~ /^#/){snpsIn2[$1"\t"$2] = $0}; next} $1"\t"$2 in snpsIn2{delete snpsIn2[$1"\t"$2]} END{for(ID in snpsIn2){print snpsIn2[ID]}}' - TGACCA_SNPs | sort > UniqueSNPsCrossGroup1
# 
# awk 'BEGIN{print "#\t\t\t\tATCACG\t\t\t\tCGATGT\t\t\t\t"}NR==FNR{if($1 !~ /^#/){snpsInA[$1"\t"$2] = $4"\t"$5"\t"$6"\t"$10}; next} $1"\t"$2 in snpsInA{print $1"\t"$2"\t.\t"$11"\t"snpsInA[$1"\t"$2]"\t"$4"\t"$5"\t"$6"\t"$10}' ATCACG_SNPs_assemblySNPs_qualFiltered CGATGT_SNPs_assemblySNPs_qualFiltered | \
# awk 'NR==FNR{if($1 !~ /^#/){snpsIn2[$1"\t"$2] = $0}; next} $1"\t"$2 in snpsIn2{delete snpsIn2[$1"\t"$2]} END{for(ID in snpsIn2){print snpsIn2[ID]}}' - TGACCA_SNPs | \
# awk 'BEGIN{print "#\t\t\t\tATCACG\t\t\t\tCGATGT\t\t\t\t"}NR==FNR{if($1 !~ /^#/){snpsIn2[$1"\t"$2] = $0}; next} $1"\t"$2 in snpsIn2{delete snpsIn2[$1"\t"$2]} END{for(ID in snpsIn2){print snpsIn2[ID]}}' - TTAGGC_SNPs | sort > UniqueSNPsCrossGroup2
# 
# awk 'BEGIN{print "#\t\t\t\tTGACCA\t\t\t\tTTAGGC\t\t\t\t"}NR==FNR{if($1 !~ /^#/){snpsInA[$1"\t"$2] = $4"\t"$5"\t"$6"\t"$10}; next} $1"\t"$2 in snpsInA{print $1"\t"$2"\t.\t"$11"\t"snpsInA[$1"\t"$2]"\t"$4"\t"$5"\t"$6"\t"$10}' TGACCA_SNPs_assemblySNPs_qualFiltered TTAGGC_SNPs_assemblySNPs_qualFiltered | \
# awk 'NR==FNR{if($1 !~ /^#/){snpsIn2[$1"\t"$2] = $0}; next} $1"\t"$2 in snpsIn2{delete snpsIn2[$1"\t"$2]} END{for(ID in snpsIn2){print snpsIn2[ID]}}' - CGATGT_SNPs | \
# awk 'BEGIN{print "#\t\t\t\tTGACCA\t\t\t\tTTAGGC\t\t\t\t"}NR==FNR{if($1 !~ /^#/){snpsIn2[$1"\t"$2] = $0}; next} $1"\t"$2 in snpsIn2{delete snpsIn2[$1"\t"$2]} END{for(ID in snpsIn2){print snpsIn2[ID]}}' - ATCACG_SNPs | sort > UniqueSNPsCrossGroup3
# 
# awk 'BEGIN{print "#\t\t\t\tTGACCA\t\t\t\tCGATGT\t\t\t\t"}NR==FNR{if($1 !~ /^#/){snpsInA[$1"\t"$2] = $4"\t"$5"\t"$6"\t"$10}; next} $1"\t"$2 in snpsInA{print $1"\t"$2"\t.\t"$11"\t"snpsInA[$1"\t"$2]"\t"$4"\t"$5"\t"$6"\t"$10}' TGACCA_SNPs_assemblySNPs_qualFiltered CGATGT_SNPs_assemblySNPs_qualFiltered | \
# awk 'NR==FNR{if($1 !~ /^#/){snpsIn2[$1"\t"$2] = $0}; next} $1"\t"$2 in snpsIn2{delete snpsIn2[$1"\t"$2]} END{for(ID in snpsIn2){print snpsIn2[ID]}}' - ATCACG_SNPs | \
# awk 'BEGIN{print "#\t\t\t\tTGACCA\t\t\t\tCGATGT\t\t\t\t"}NR==FNR{if($1 !~ /^#/){snpsIn2[$1"\t"$2] = $0}; next} $1"\t"$2 in snpsIn2{delete snpsIn2[$1"\t"$2]} END{for(ID in snpsIn2){print snpsIn2[ID]}}' - TTAGGC_SNPs | sort > UniqueSNPsCrossGroup4
# 
# echo "Control pairings created."

# bedtools closest -a UniqueSNPsCrossGroup1 -b ../Astatotilapia_burtoni.BROADAB2fix.noexons.gtf -d -id -D b -header | \
# awk 'BEGIN{FS="\""}{print $1"\t"$2"\t"$NF}' - | awk 'NR==1{print; next}int($24)>=-5000{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$16"\t"$17"\t"$19"\t"$20"\t"$22"\t"$24}' | sort | uniq > UniqueSNPsCrossGroup1_closestGenes
# echo "Bedtools done with control pair 1."
# 
# bedtools closest -a UniqueSNPsCrossGroup2 -b ../Astatotilapia_burtoni.BROADAB2fix.noexons.gtf -d -id -D b -header | \
# awk 'BEGIN{FS="\""}{print $1"\t"$2"\t"$NF}' - | awk 'NR==1{print; next}int($24)>=-5000{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$16"\t"$17"\t"$19"\t"$20"\t"$22"\t"$24}' | sort | uniq > UniqueSNPsCrossGroup2_closestGenes
# echo "Bedtools done with control pair 2."
# 
# bedtools closest -a UniqueSNPsCrossGroup3 -b ../Astatotilapia_burtoni.BROADAB2fix.noexons.gtf -d -id -D b -header | \
# awk 'BEGIN{FS="\""}{print $1"\t"$2"\t"$NF}' - | awk 'NR==1{print; next}int($24)>=-5000{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$16"\t"$17"\t"$19"\t"$20"\t"$22"\t"$24}' | sort | uniq > UniqueSNPsCrossGroup3_closestGenes
# echo "Bedtools done with control pair 3."
# 
# bedtools closest -a UniqueSNPsCrossGroup4 -b ../Astatotilapia_burtoni.BROADAB2fix.noexons.gtf -d -id -D b -header | \
# awk 'BEGIN{FS="\""}{print $1"\t"$2"\t"$NF}' - | awk 'NR==1{print; next}int($24)>=-5000{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$16"\t"$17"\t"$19"\t"$20"\t"$22"\t"$24}' | sort | uniq > UniqueSNPsCrossGroup4_closestGenes
# echo "Bedtools done with control pair 4."

