#!/bin/bash

# Counts the number of each base in a fasta file, and prints this number.

homeFolder="/Users/burtonigenomics/Desktop/Katrina/"
# The path to the folder with the genome files

GENOMES=$homeFolder"Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.ribosomalProteins.bed.collapsed.fa "\
$homeFolder"Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.ribosomalProteins.genes.bed.collapsed.fa "\
$homeFolder"Astatotilapia_burtoni.ribosomalProteinsAndUTRs.bed.collapsed.fa "\
$homeFolder"Astatotilapia_burtoni.ribosomalProteinsAndUTRs.clean4.genes.bed.collapsed.fa"

for g in $GENOMES
	do	
		echo $g
		jellyfish count -m 1 -o $g"_1mers" -c 2 -s 120M -t 4 $g 
		jellyfish dump -c $g"_1mers"
	done