# rsem pipeline

# prepare reference sequences
cd ~/Documents
# rsem-prepare-reference \
# 	--gtf Astatotilapia_burtoni.BROADAB2.padded.gtf --no-polyA \
# 	--bowtie-path bowtie-1.0.0 \
# 	_Burtoni_genome_files/H_burtoni_v1.assembly.padded.fa \
# 	_Burtoni_genome_files/rsem/H_burtoni_v1.assembly.padded
	
# rsem-calculate-expression \
# 	--strand-specific --bam --output-genome-bam --time --num-threads 4 \
# 	--bowtie-path bowtie-1.0.0 \
# 	--paired-end \
# 	_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_1_pf.fastq.gz \
# 	_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_2_pf.fastq.gz \
# 	tophatOUT/ATCACG/accepted_hits.nsort.bam \
# 	_Burtoni_genome_files/rsem/H_burtoni_v1.assembly.padded \
# 	ATCACG \
	
	
rsem-calculate-expression \
	--strand-specific --forward-prob 1 --output-genome-bam --time --num-threads 4 --bowtie-path bowtie-1.0.0 --seed-length 5 \
	--paired-end _LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_1_pf.fastq.gz _LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_2_pf.fastq.gz \
	_Burtoni_genome_files/rsem/H_burtoni_v1.assembly.padded \
	ATCACG \