# pipeline to get base pairs from genome around methylation sites and infer strand

# start with e.g. 3157.wig.bed

bedtools flank -i $FILE -g ../_Burtoni_genome_files/H_burtoni_v1.assembly.fa.fai.genome -b 1 | \
awk 'BEGIN{FS="\t";pid=""}{if($4==pid){print $1"\t"s"\t"$3"\t"pid"\t"$5}else{pid=$4;s=$2;next}}' | \
bedtools getfasta -name -tab -fi ../_Burtoni_genome_files/H_burtoni_v1.assembly.fa -bed - \
-fo $FILE-flanks1bp-fa

awk 'BEGIN{FS="\t"}NR==FNR{a[$1]=$2;next}{print $0"\t"a[$4]}' $FILE-flanks1bp-fa $FILE