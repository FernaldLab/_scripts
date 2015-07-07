#!/bin/bash

cd /Volumes/fishstudies/_methylation

SUBJ="3157 3165 3581 3677"

echo "Computing dinucleotide methylation levels..."
echo "  reverse strand.."
for s in $SUBJ
do
	echo $s".wig.bed.nucs_Gfliprev"
	awk 'BEGIN{FS="\t"}{print $0"\t"substr($8,3,2)}' $s".wig.bed.nucs_Gfliprev" | \
	sort -k9,9 | bedtools groupby -g 9 -c 5,5,5,5 -o min,max,mean,median \
	> $s"_Gflip_rev_di_lvls"
done

echo "  forward strand.."
for s in $SUBJ
do
	echo $s".wig.bed.nucs_Gflipfwd"
	awk 'BEGIN{FS="\t"}{print $0"\t"substr($6,3,2)}' $s".wig.bed.nucs_Gflipfwd" | \
	sort -k9,9 | bedtools groupby -g 9 -c 5,5,5,5 -o min,max,mean,median \
	> $s"_Gflip_fwd_di_lvls"
done

echo "Computing trinucleotide methylation levels..."
echo "  reverse strand.."
for s in $SUBJ
do
	echo $s".wig.bed.nucs_Gfliprev"
	awk 'BEGIN{FS="\t"}{print $0"\t"substr($8,3,3)}' $s".wig.bed.nucs_Gfliprev" | \
	sort -k9,9 | bedtools groupby -g 9 -c 5,5,5,5 -o min,max,mean,median \
	> $s"_Gflip_rev_tri_lvls"
done

echo "  forward strand.."
for s in $SUBJ
do
	echo $s".wig.bed.nucs_Gflipfwd"
	awk 'BEGIN{FS="\t"}{print $0"\t"substr($6,3,3)}' $s".wig.bed.nucs_Gflipfwd" | \
	sort -k9,9 | bedtools groupby -g 9 -c 5,5,5,5 -o min,max,mean,median \
	> $s"_Gflip_fwd_tri_lvls"
done