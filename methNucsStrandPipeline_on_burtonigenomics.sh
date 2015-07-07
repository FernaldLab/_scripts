cd ~/Documents/_methylation

echo Getting nucleotides around methylation sites...
ls | grep wig.bed$ | while read stdin; do echo $stdin; \
bedtools flank -i $stdin -g ../_Burtoni_genome_files/H_burtoni_v1.assembly.fa.fai.genome -b 1 | \
awk 'BEGIN{FS="\t";pid=""}{if($4==pid){print $1"\t"s"\t"$3"\t"pid"\t"$5}else{pid=$4;s=$2;next}}' | \
bedtools getfasta -name -tab -fi ../_Burtoni_genome_files/H_burtoni_v1.assembly.fa -bed - -fo ${stdin}"-flanks1bp-fa"; done

echo Adding nucleotides to wig.bed files...
for f in 3157 3165 3581 3677; do echo $f; \
awk 'BEGIN{FS="\t"}NR==FNR{a[$1]=$2;next}{print $0"\t"a[$4]}' $f".wig.bed-flanks1bp-fa" $f".wig.bed" > $f".wig.bed.nucs"; done

echo Getting complement of minus strand nucleotides...
for f in 3157 3165 3581 3677; do echo $f; ../_scripts/flipMethylationStrand.py $f".wig.bed.nucs"; done