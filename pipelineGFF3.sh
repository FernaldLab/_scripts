# build genome index
#cd ~/Documents/bowtie2-2.1.0
#./bowtie2-build -f ../_Burtoni_genome_files/H_burtoni_v1.assembly.padded.fa ../_Burtoni_genome_files/H_burtoni_v1.assembly.padded

# inspect genome index
#./bowtie2-inspect -s ../_Burtoni_genome_files/H_burtoni_v1.assembly.padded

# align reads with tophat
cd ~/Documents/tophat-2.0.9.OSX_x86_64

./tophat2 --library-type fr-firststrand -o ../tophatOUT/GFF3/ATCACG -r 0 -p 4 -G ../Astatotilapia_burtoni.BROADAB1.padded.gff3 \
	../_Burtoni_genome_files/H_burtoni_v1.assembly.padded \
	../_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_1_pf.fastq.gz,../_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_2_pf.fastq.gz
	
./tophat2 --library-type fr-firststrand -o ../tophatOUT/GFF3/CGATGT -r 0 -p 4 -G ../Astatotilapia_burtoni.BROADAB1.padded.gff3 \
	../_Burtoni_genome_files/H_burtoni_v1.assembly.padded \
	../_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_CGATGT_1_pf.fastq.gz,../_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_CGATGT_2_pf.fastq.gz

./tophat2 --library-type fr-firststrand -o ../tophatOUT/GFF3/TGACCA -r 0 -p 4 -G ../Astatotilapia_burtoni.BROADAB1.padded.gff3 \
	../_Burtoni_genome_files/H_burtoni_v1.assembly.padded \
	../_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_TGACCA_1_pf.fastq.gz,../_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_TGACCA_2_pf.fastq.gz
	
./tophat2 --library-type fr-firststrand -o ../tophatOUT/GFF3/TTAGGC -r 0 -p 4 -G ../Astatotilapia_burtoni.BROADAB1.padded.gff3 \
	../_Burtoni_genome_files/H_burtoni_v1.assembly.padded \
	../_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_TTAGGC_1_pf.fastq.gz,../_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_TTAGGC_2_pf.fastq.gz

# index bam files and get idxstats with samtools
cd ~/Documents/tophatOUT/GFF3

samtools index ATCACG/accepted_hits.bam
samtools index CGATGT/accepted_hits.bam
samtools index TGACCA/accepted_hits.bam
samtools index TTAGGC/accepted_hits.bam

samtools idxstats ATCACG/accepted_hits.bam > ATCACG/idxstatsATCACG.txt
samtools idxstats CGATGT/accepted_hits.bam > CGATGT/idxstatsCGATGT.txt
samtools idxstats TGACCA/accepted_hits.bam > TGACCA/idxstatsTGACCA.txt
samtools idxstats TTAGGC/accepted_hits.bam > TTAGGC/idxstatsTTAGGC.txt