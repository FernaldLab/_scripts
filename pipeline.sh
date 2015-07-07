# build genome index
#cd ~/Documents/bowtie2-2.1.0
#./bowtie2-build -f ../_Burtoni_genome_files/H_burtoni_v1.assembly.padded.fa ../_Burtoni_genome_files/H_burtoni_v1.assembly.padded

# inspect genome index
#./bowtie2-inspect -s ../_Burtoni_genome_files/H_burtoni_v1.assembly.padded

# align reads with tophat
cd ~/Documents/tophat-2.0.9.OSX_x86_64

#./tophat2 --library-type fr-firststrand -o ../tophatOUT/ATCACG -r 0 -p 4 -G ../Astatotilapia_burtoni.BROADAB2.padded.gtf \
#	../_Burtoni_genome_files/H_burtoni_v1.assembly.padded \
#	/Volumes/OSX/_Fernald_lab/_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_1_pf.fastq.gz,/Volumes/OSX/_Fernald_lab/_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_2_pf.fastq.gz
	
#./tophat2 --library-type fr-firststrand -o ../tophatOUT/CGATGT -r 0 -p 4 -G ../Astatotilapia_burtoni.BROADAB2.padded.gtf \
#	../_Burtoni_genome_files/H_burtoni_v1.assembly.padded \
#	/Volumes/OSX/_Fernald_lab/_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_CGATGT_1_pf.fastq.gz,/Volumes/OSX/_Fernald_lab/_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_CGATGT_2_pf.fastq.gz

#./tophat2 --library-type fr-firststrand -o ../tophatOUT/TGACCA -r 0 -p 4 -G ../Astatotilapia_burtoni.BROADAB2.padded.gtf \
#	../_Burtoni_genome_files/H_burtoni_v1.assembly.padded \
#	/Volumes/OSX/_Fernald_lab/_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_TGACCA_1_pf.fastq.gz,/Volumes/OSX/_Fernald_lab/_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_TGACCA_2_pf.fastq.gz
	
./tophat2 --library-type fr-firststrand -o ../tophatOUT/TTAGGC -r 0 -p 4 -G ../Astatotilapia_burtoni.BROADAB2.padded.gtf \
	../_Burtoni_genome_files/H_burtoni_v1.assembly.padded \
	/Volumes/OSX/_Fernald_lab/_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_TTAGGC_1_pf.fastq.gz,/Volumes/OSX/_Fernald_lab/_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_TTAGGC_2_pf.fastq.gz
	
# get abundances with cufflinks
cd ~/Documents/cufflinks-2.1.1.OSX_x86_64
	
#./cufflinks --library-type fr-firststrand -o ../cufflinksOUT/ATCACG -p 4 -G ../Astatotilapia_burtoni.BROADAB2.padded.gtf ../tophatOUT/ATCACG/accepted_hits.bam

#./cufflinks --library-type fr-firststrand -o ../cufflinksOUT/CGATGT -p 4 -G ../Astatotilapia_burtoni.BROADAB2.padded.gtf ../tophatOUT/CGATGT/accepted_hits.bam

#./cufflinks --library-type fr-firststrand -o ../cufflinksOUT/TGACCA -p 4 -G ../Astatotilapia_burtoni.BROADAB2.padded.gtf ../tophatOUT/TGACCA/accepted_hits.bam

./cufflinks --library-type fr-firststrand -o ../cufflinksOUT/TTAGGC -p 4 -G ../Astatotilapia_burtoni.BROADAB2.padded.gtf ../tophatOUT/TTAGGC/accepted_hits.bam

# index bam files with samtools

# get index stats with samtools

# process cufflinks output with python scripts

# estimate complexity with preseq