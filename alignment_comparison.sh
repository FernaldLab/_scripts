bamPrefix="/Users/burtonigenomics/Desktop/Katrina/tophat/_filteredRuns/ATCACG/accepted_hits"
samPrefix="/Volumes/fishstudies/Katrina/storage/Filter_v8_NoAdapters/ATCACG/alignments.sam"

scaffoldNum="9"
begRange=4614511
endRange=4614833

echo "Scaffold "$scaffoldNum
date
samtools view $bamPrefix".bam" | awk -v scafNum=$scaffoldNum -v max=$endRange -v min=$begRange 'BEGIN{FS="\t"}$3=="scaffold_"scafNum&&int($4)>=min&&int($4)<=max{print $1}' |
awk 'BEGIN{FS="\t"}NR==FNR{arr[$1]; next}{if(!($1 in arr)){print $1"\tInFilterButNotPileup"}; printed[$1]}END{for(ID in arr) if(!(ID in printed)){print ID"\tInPileupButNotFilter"}}' - $samPrefix > $samPrefix".alignmentDiscrepancies_"$scaffoldNum".txt"
open -a TextEdit.app $samPrefix".alignmentDiscrepancies_"$scaffoldNum".txt"
cat $samPrefix".alignmentDiscrepancies_"$scaffoldNum".txt" | cut -f2 | sort | uniq -c


samtools view $bamPrefix".bam" | awk -v scafNum=$scaffoldNum -v max=$endRange -v min=$begRange 'BEGIN{FS="\t"}NR==FNR{if($3=="scaffold_"scafNum&&int($4)>=min&&int($4)<=max){print $1}; next}{if(!($1 in arr)){print $1"\tInFilterButNotPileup"}; printed[$1]}END{for(ID in arr) if(!(ID in printed)){print ID"\tInPileupButNotFilter"}}' - $samPrefix > $samPrefix".alignmentDiscrepancies_"$scaffoldNum".txt"
open -a TextEdit.app $samPrefix".alignmentDiscrepancies_"$scaffoldNum".txt"
cat $samPrefix".alignmentDiscrepancies_"$scaffoldNum".txt" | cut -f2 | sort | uniq -c

# scaffoldNum="83"
# begRange=654838
# endRange=655150
# 
# echo "Scaffold "$scaffoldNum
# date
# samtools view $bamPrefix".bam" | awk -v scafNum=$scaffoldNum -v max=$endRange -v min=$begRange 'BEGIN{FS="\t"}$3=="scaffold_"scafNum&&int($4)>=min&&int($4)<=max{print $1}' > $bamPrefix".readsInPileup_"$scaffoldNum"_IDs"
# 
# scaffoldNum="236"
# begRange=836174
# endRange=836399
# 
# echo "Scaffold "$scaffoldNum"_1"
# date
# samtools view $bamPrefix".bam" | awk -v scafNum=$scaffoldNum -v max=$endRange -v min=$begRange 'BEGIN{FS="\t"}$3=="scaffold_"scafNum&&int($4)>=min&&int($4)<=max{print $1}' > $bamPrefix".readsInPileup_"$scaffoldNum"_1_IDs"
# 
# scaffoldNum="236"
# begRange=839319
# endRange=839319
# 
# echo "Scaffold "$scaffoldNum"_2"
# date
# samtools view $bamPrefix".bam" | awk -v scafNum=$scaffoldNum -v max=$endRange -v min=$begRange 'BEGIN{FS="\t"}$3=="scaffold_"scafNum&&int($4)>=min&&int($4)<=max{print $1}' > $bamPrefix".readsInPileup_"$scaffoldNum"_2_IDs"