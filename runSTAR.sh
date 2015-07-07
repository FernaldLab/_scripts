#!/bin/bash

## Making index
## genomDir must already exist and have write priveleges

# ~/Documents/STAR-STAR_2.4.0k/source/STAR \
# --runThreadN 4 \
# --runMode genomeGenerate \
# --genomeDir  ~/Documents/_Burtoni_genome_files/STARindexesNCBI \
# --genomeFastaFiles ~/Documents/_Burtoni_genome_files/H_burtoni_v1.assembly.fa \
# --sjdbGTFfile ~/Documents/_Burtoni_annotations/ref_AstBur1.0_scaffolds.clean.translate.final.combo.gff3 \
# --sjdbOverhang 100


## Alignment
 ~/Documents/STAR-STAR_2.4.0k/source/STAR \
 --runMode alignReads \
 --runThreadN 4 \
 --genomeDir ~/Documents/_Burtoni_genome_files/STARindexesNCBI \
 --readFilesIn /Users/burtonigenomics/Documents/_Elim_data/Mar2015/L2_ACAGTG_L002_R1_001.fastq.gz.cutAdapters.fastq \
 /Users/burtonigenomics/Documents/_Elim_data/Mar2015/L2_ACAGTG_L002_R2_001.fastq.gz.cutAdapters.fastq \
 --outFilterMultimapNmax 1 \
 --outFileNamePrefix ~/Documents/_Elim_data/Mar2015/ACAGTG_NCBI_ \
 --outSAMtype BAM Unsorted \
 --outSAMattributes MD NH NM

