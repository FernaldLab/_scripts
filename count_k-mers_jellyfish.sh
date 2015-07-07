#! /bin/bash
cd ~/Documents/_Burtoni_genome_files
echo "jellyfish options: -c2 -s841M -t4"
for mer in "$@"
do 
	echo counting ${mer}"-mers..."; 
	jellyfish count -m $mer -o ${mer}"mer_counts.jf" -c 2 -s 841M -t 4 H_burtoni_v1.assembly.fa; 
	jellyfish dump -c ${mer}"mer_counts.jf" > ${mer}"mer_counts.jf.dump"; 
done
