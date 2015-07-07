cd /Users/burtonigenomics/Downloads/bsmooth-align-0.8.1
# 
# bin/bswc_bowtie2_index.pl \
# --bowtie2-build=~/Documents/bowtie2-2.1.0/bowtie2-build  \
# --name=H_burtoni_v1.assembly \
# /Users/burtonigenomics/Desktop/Katrina/Rosa_miRNA_rRNA_filtering/H_burtoni_v1.assembly.fasta

bin/bswc_bowtie2_align.pl \
--bowtie2=/Users/burtonigenomics/Documents/bowtie2-2.1.0/bowtie2 \
--metrics=/Users/burtonigenomics/Documents/_BSeq_data \
--bsc --fr --fastq --out=/Users/burtonigenomics/Documents/_BSeq_data --bam=bsm \
-- /Users/burtonigenomics/Downloads/bsmooth-align-0.8.1/H_burtoni_v1.assembly \
-- /Users/burtonigenomics/Desktop/Katrina/Rosa_miRNA_rRNA_filtering/H_burtoni_v1.assembly.fasta \
-- -p4 \
-- /Users/burtonigenomics/Documents/_BSeq_data/130917_TENNISON_0250_AD2H9VACXX_L4_1_pf.fastq.gz \
-- /Users/burtonigenomics/Documents/_BSeq_data/130917_TENNISON_0250_AD2H9VACXX_L4_2_pf.fastq.gz


#--samtools=/Users/burtonigenomics/Documents/samtools-0.1.19 \