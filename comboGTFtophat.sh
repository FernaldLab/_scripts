tophat2 --library-type fr-firststrand -o gatkbp/tophat/ATCACG -r 0 -p 4 -G _Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf _Burtoni_genome_files/H_burtoni_v1.assembly _LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_1_pf.fastq.gz,_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_ATCACG_2_pf.fastq.gz

tophat2 --library-type fr-firststrand -o gatkbp/tophat/CGATGT -r 0 -p 4 -G _Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf _Burtoni_genome_files/H_burtoni_v1.assembly _LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_CGATGT_1_pf.fastq.gz,_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_CGATGT_2_pf.fastq.gz

tophat2 --library-type fr-firststrand -o gatkbp/tophat/TTAGGC -r 0 -p 4 -G _Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf _Burtoni_genome_files/H_burtoni_v1.assembly _LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_TTAGGC_1_pf.fastq.gz,_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_TTAGGC_2_pf.fastq.gz

tophat2 --library-type fr-firststrand -o gatkbp/tophat/TGACCA -r 0 -p 4 -G _Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf _Burtoni_genome_files/H_burtoni_v1.assembly _LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_TGACCA_1_pf.fastq.gz,_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_TGACCA_2_pf.fastq.gz






#ls gatkbp/tophat/ | awk '{print "echo "$1"; tophat2 --library-type fr-firststrand -o gatkbp/tophat/"$1" -r 0 -p 4 -G _Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf _Burtoni_genome_files/H_burtoni_v1.assembly _LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$1"_1_pf.fastq.gz,_LYNLEY_RNAseq/130913_LYNLEY_0364_AC2HRPACXX_L6_"$1"_2_pf.fastq.gz"}'
