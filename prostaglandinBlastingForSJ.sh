#!/bin/bash

cd /Volumes/fishstudies/_Burtoni_annotations/ptg_mammal

FILES=`ls *fasta`
for f in $FILES
do 
	echo $f
	~/Documents/ncbi-blast-2.2.30+/bin/blastp \
	-query $f \
	-db ../db/H_burtoni_protein \
	-out $f"_blastpAgainstBurtoni" \
	-outfmt '7 std' \
	-max_target_seqs 10
	
	grep -v "^#" $f"_blastpAgainstBurtoni" >> allHitsBlastp
	
done

awk '{split($2,a,"|"); print a[4]}' allHitsBlastp | sort | uniq > allHitsBlastpAccessions