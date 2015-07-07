#!/bin/bash

cd ~/Documents/_BSeq_data
SUBJECTS="3157_TENNISON 3165_BRISCOE 3581_LYNLEY 3677_MONK"
for s in $SUBJECTS
do
	echo "========================================================================"
	echo "==================== Working on "$s" ===================="
	echo "========================================================================"
	bsmap \
	-a $s"/reads_1.fastq.gz" \
	-b $s"/reads_2.fastq.gz" \
	-d /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta \
	-o $s"/aligned.adapters.q30.m0.sam" \
	-A GAGCCGTAAGGACGACTTGG -A ACACTCTTTCCCTACACGAC \
	-q 30 -m 0 \
	-S 1
	
	echo "================================================================"
	echo "===== Converting sam file to sorted bam and creating index ====="
	echo "================================================================"
	samtools view -bS $s"/aligned.adapters.q30.m0.sam" | samtools sort - $s"/aligned.adapters.q30.m0"
	samtools index $s"/aligned.adapters.q30.m0.bam"
	rm $s"/aligned.adapters.q30.m0.sam"
	
	echo "=============================================="
	echo "===== Running methratio.py, no -g option ====="
	echo "=============================================="
	../bsmap-2.74/methratio.py \
	-o $s"/aligned.adapters.q30.m0.methratio" \
	-d /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta \
	-u -p -z -r -m 5 \
	$s"/aligned.adapters.q30.m0.bam"
	
	echo "==============================================="
	echo "===== Running methratio.py, yes -g option ====="
	echo "==============================================="
	../bsmap-2.74/methratio.py \
	-o $s"/aligned.adapters.q30.m0.methratio_CpGcombined" \
	-d /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta \
	-u -p -z -r -g -m 5 \
	$s"/aligned.adapters.q30.m0.bam"
	
	echo "================================================================"
	echo "===== Make versions of methratio.py results with only CpGs ====="
	echo "================================================================"
	awk '($3=="-" && $4~/^.{1}CG/ ) || ($3=="+" &&  $4~/^.{2}CG/)' \
	$s"/aligned.adapters.q30.m0.methratio" > $s"/aligned.adapters.q30.m0.methratio.CG"
	awk '($3=="-" && $4~/^.{1}CG/ ) || ($3=="+" &&  $4~/^.{2}CG/)' \
	$s"/aligned.adapters.q30.m0.methratio_CpGcombined" > $s"/aligned.adapters.q30.m0.methratio_CpGcombined.CG"
done

############################
##### terminal output

# bio-rdf02:_BSeq_data burtonigenomics$ /Volumes/fishstudies/_scripts/bsmap_methratio_all_subjects.sh 
# ========================================================================
# ==================== Working on 3157_TENNISON ====================
# ========================================================================
# 
# BSMAP v2.74
# Start at:  Tue Mar 31 16:47:15 2015
# 
# Input reference file: /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta 	(format: FASTA)
# Load in 8001 db seqs, total size 831411547 bp. 15 secs passed
# total_kmers: 43046721
# Create seed table. 54 secs passed
# max number of mismatches: read_length * 8% 	max gap size: 0
# kmer cut-off ratio: 5e-07
# max multi-hits: 100	max Ns: 5	seed size: 16	index interval: 4
# quality cutoff: 30	base quality char: '!'
# min fragment size:0	max fragemt size:500
# start from read #1	end at read #4294967295
# additional alignment: T in reads => C in reference
# mapping strand (read_1): ++,-+
# mapping strand (read_2): +-,--
# adapter sequence1: GAGCCGTAAGGACGACTTGG
# adapter sequence2: ACACTCTTTCCCTACACGAC
# Pair-end alignment(4 threads)
# Input read file #1: 3157_TENNISON/reads_1.fastq.gz 	(format: gzipped FASTQ)
# Input read file #2: 3157_TENNISON/reads_2.fastq.gz 	(format: gzipped FASTQ)
# Output file: 3157_TENNISON/aligned.adapters.q30.m0.sam	 (format: SAM)
# Thread #2: 	50000 read pairs finished. 105 secs passed
# Thread #1: 	100000 read pairs finished. 106 secs passed
# Thread #0: 	150000 read pairs finished. 107 secs passed
# Thread #3: 	200000 read pairs finished. 108 secs passed
# Thread #2: 	250000 read pairs finished. 157 secs passed
# Thread #1: 	300000 read pairs finished. 158 secs passed
# Thread #0: 	350000 read pairs finished. 159 secs passed
# Thread #3: 	400000 read pairs finished. 161 secs passed
# Thread #2: 	450000 read pairs finished. 209 secs passed
# Thread #1: 	500000 read pairs finished. 210 secs passed
# .
# .
# .
# Thread #2: 	114800000 read pairs finished. 30184 secs passed
# Thread #1: 	114891459 read pairs finished. 30192 secs passed
# Thread #3: 	114850000 read pairs finished. 30192 secs passed
# Total number of aligned reads: 
# pairs:       66224992 (58%)
# single a:    12459977 (11%)
# single b:    12364707 (11%)
# Done.
# Finished at Wed Apr  1 01:10:27 2015
# Total time consumed:  30192 secs
# ================================================================
# ===== Converting sam file to sorted bam and creating index =====
# ================================================================
# [bam_header_read] EOF marker is absent. The input is probably truncated.
# [samopen] SAM header is present: 8001 sequences.
# [bam_sort_core] merging from 65 files...
# ==============================================
# ===== Running methratio.py, no -g option =====
# ==============================================
# @ Wed Apr  1 04:09:50 2015: reading reference /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta ...
# @ Wed Apr  1 04:10:24 2015: reading 3157_TENNISON/aligned.adapters.q30.m0.bam ...
# 	@ Wed Apr  1 04:15:02 2015: read 10000000 lines
# 	@ Wed Apr  1 04:19:39 2015: read 20000000 lines
# 	@ Wed Apr  1 04:24:00 2015: read 30000000 lines
# 	@ Wed Apr  1 04:28:28 2015: read 40000000 lines
# 	@ Wed Apr  1 04:32:51 2015: read 50000000 lines
# 	@ Wed Apr  1 04:37:11 2015: read 60000000 lines
# 	@ Wed Apr  1 04:41:26 2015: read 70000000 lines
# 	@ Wed Apr  1 04:45:40 2015: read 80000000 lines
# 	@ Wed Apr  1 04:49:46 2015: read 90000000 lines
# 	@ Wed Apr  1 04:53:38 2015: read 100000000 lines
# 	@ Wed Apr  1 04:57:34 2015: read 110000000 lines
# 	@ Wed Apr  1 05:01:25 2015: read 120000000 lines
# 	@ Wed Apr  1 05:05:08 2015: read 130000000 lines
# 	@ Wed Apr  1 05:08:17 2015: read 140000000 lines
# 	@ Wed Apr  1 05:10:57 2015: read 150000000 lines
# @ Wed Apr  1 05:12:38 2015: writing 3157_TENNISON/aligned.adapters.q30.m0.methratio ...
# @ Wed Apr  1 05:24:05 2015: done.
# total 49380103 valid mappings, 45959043 covered cytosines, average coverage: 19.08 fold.
# ===============================================
# ===== Running methratio.py, yes -g option =====
# ===============================================
# @ Wed Apr  1 05:24:08 2015: reading reference /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta ...
# @ Wed Apr  1 05:24:42 2015: reading 3157_TENNISON/aligned.adapters.q30.m0.bam ...
# 	@ Wed Apr  1 05:29:22 2015: read 10000000 lines
# 	@ Wed Apr  1 05:34:00 2015: read 20000000 lines
# 	@ Wed Apr  1 05:38:23 2015: read 30000000 lines
# 	@ Wed Apr  1 05:42:52 2015: read 40000000 lines
# 	@ Wed Apr  1 05:47:16 2015: read 50000000 lines
# 	@ Wed Apr  1 05:51:37 2015: read 60000000 lines
# 	@ Wed Apr  1 05:55:54 2015: read 70000000 lines
# 	@ Wed Apr  1 06:00:09 2015: read 80000000 lines
# 	@ Wed Apr  1 06:04:16 2015: read 90000000 lines
# 	@ Wed Apr  1 06:08:10 2015: read 100000000 lines
# 	@ Wed Apr  1 06:12:07 2015: read 110000000 lines
# 	@ Wed Apr  1 06:15:59 2015: read 120000000 lines
# 	@ Wed Apr  1 06:19:44 2015: read 130000000 lines
# 	@ Wed Apr  1 06:22:54 2015: read 140000000 lines
# 	@ Wed Apr  1 06:25:34 2015: read 150000000 lines
# @ Wed Apr  1 06:27:17 2015: combining CpG methylation from both strands ...
# @ Wed Apr  1 06:27:47 2015: writing 3157_TENNISON/aligned.adapters.q30.m0.methratio_CpGcombined ...
# @ Wed Apr  1 06:38:59 2015: done.
# total 49380103 valid mappings, 45056678 covered cytosines, average coverage: 19.53 fold.
# ================================================================
# ===== Make versions of methratio.py results with only CpGs =====
# ================================================================
# ========================================================================
# ==================== Working on 3165_BRISCOE ====================
# ========================================================================
# 
# BSMAP v2.74
# Start at:  Wed Apr  1 06:41:45 2015
# 
# Input reference file: /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta 	(format: FASTA)
# Load in 8001 db seqs, total size 831411547 bp. 15 secs passed
# total_kmers: 43046721
# Create seed table. 55 secs passed
# max number of mismatches: read_length * 8% 	max gap size: 0
# kmer cut-off ratio: 5e-07
# max multi-hits: 100	max Ns: 5	seed size: 16	index interval: 4
# quality cutoff: 30	base quality char: '!'
# min fragment size:0	max fragemt size:500
# start from read #1	end at read #4294967295
# additional alignment: T in reads => C in reference
# mapping strand (read_1): ++,-+
# mapping strand (read_2): +-,--
# adapter sequence1: GAGCCGTAAGGACGACTTGG
# adapter sequence2: ACACTCTTTCCCTACACGAC
# Pair-end alignment(4 threads)
# Input read file #1: 3165_BRISCOE/reads_1.fastq.gz 	(format: gzipped FASTQ)
# Input read file #2: 3165_BRISCOE/reads_2.fastq.gz 	(format: gzipped FASTQ)
# Output file: 3165_BRISCOE/aligned.adapters.q30.m0.sam	 (format: SAM)
# Thread #2: 	50000 read pairs finished. 107 secs passed
# Thread #3: 	100000 read pairs finished. 108 secs passed
# Thread #1: 	150000 read pairs finished. 108 secs passed
# Thread #0: 	200000 read pairs finished. 110 secs passed
# Thread #2: 	250000 read pairs finished. 159 secs passed
# Thread #3: 	300000 read pairs finished. 160 secs passed
# Thread #1: 	350000 read pairs finished. 161 secs passed
# Thread #0: 	400000 read pairs finished. 163 secs passed
# Thread #2: 	450000 read pairs finished. 211 secs passed
# Thread #3: 	500000 read pairs finished. 212 secs passed
# .
# .
# .
# Thread #0: 	137600000 read pairs finished. 36366 secs passed
# Thread #3: 	137675454 read pairs finished. 36366 secs passed
# Thread #2: 	137650000 read pairs finished. 36368 secs passed
# Total number of aligned reads: 
# pairs:       73497948 (53%)
# single a:    16723658 (12%)
# single b:    17138837 (12%)
# Done.
# Finished at Wed Apr  1 16:47:53 2015
# Total time consumed:  36368 secs
# ================================================================
# ===== Converting sam file to sorted bam and creating index =====
# ================================================================
# [bam_header_read] EOF marker is absent. The input is probably truncated.
# [samopen] SAM header is present: 8001 sequences.
# [bam_sort_core] merging from 74 files...
# ==============================================
# ===== Running methratio.py, no -g option =====
# ==============================================
# @ Wed Apr  1 18:58:24 2015: reading reference /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta ...
# @ Wed Apr  1 18:58:58 2015: reading 3165_BRISCOE/aligned.adapters.q30.m0.bam ...
# 	@ Wed Apr  1 19:03:29 2015: read 10000000 lines
# 	@ Wed Apr  1 19:07:57 2015: read 20000000 lines
# 	@ Wed Apr  1 19:12:10 2015: read 30000000 lines
# 	@ Wed Apr  1 19:16:34 2015: read 40000000 lines
# 	@ Wed Apr  1 19:21:03 2015: read 50000000 lines
# 	@ Wed Apr  1 19:25:14 2015: read 60000000 lines
# 	@ Wed Apr  1 19:29:30 2015: read 70000000 lines
# 	@ Wed Apr  1 19:33:41 2015: read 80000000 lines
# 	@ Wed Apr  1 19:37:42 2015: read 90000000 lines
# 	@ Wed Apr  1 19:41:45 2015: read 100000000 lines
# 	@ Wed Apr  1 19:45:36 2015: read 110000000 lines
# 	@ Wed Apr  1 19:49:16 2015: read 120000000 lines
# 	@ Wed Apr  1 19:53:06 2015: read 130000000 lines
# 	@ Wed Apr  1 19:56:52 2015: read 140000000 lines
# 	@ Wed Apr  1 20:00:04 2015: read 150000000 lines
# 	@ Wed Apr  1 20:03:02 2015: read 160000000 lines
# 	@ Wed Apr  1 20:05:38 2015: read 170000000 lines
# 	@ Wed Apr  1 20:07:41 2015: read 180000000 lines
# @ Wed Apr  1 20:07:49 2015: writing 3165_BRISCOE/aligned.adapters.q30.m0.methratio ...
# @ Wed Apr  1 20:18:09 2015: done.
# total 52165463 valid mappings, 38693249 covered cytosines, average coverage: 24.60 fold.
# ===============================================
# ===== Running methratio.py, yes -g option =====
# ===============================================
# @ Wed Apr  1 20:18:12 2015: reading reference /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta ...
# @ Wed Apr  1 20:18:49 2015: reading 3165_BRISCOE/aligned.adapters.q30.m0.bam ...
# 	@ Wed Apr  1 20:23:26 2015: read 10000000 lines
# 	@ Wed Apr  1 20:27:59 2015: read 20000000 lines
# 	@ Wed Apr  1 20:32:11 2015: read 30000000 lines
# 	@ Wed Apr  1 20:36:36 2015: read 40000000 lines
# 	@ Wed Apr  1 20:41:04 2015: read 50000000 lines
# 	@ Wed Apr  1 20:45:16 2015: read 60000000 lines
# 	@ Wed Apr  1 20:49:32 2015: read 70000000 lines
# 	@ Wed Apr  1 20:53:45 2015: read 80000000 lines
# 	@ Wed Apr  1 20:57:45 2015: read 90000000 lines
# 	@ Wed Apr  1 21:01:47 2015: read 100000000 lines
# 	@ Wed Apr  1 21:05:39 2015: read 110000000 lines
# 	@ Wed Apr  1 21:09:20 2015: read 120000000 lines
# 	@ Wed Apr  1 21:13:10 2015: read 130000000 lines
# 	@ Wed Apr  1 21:16:57 2015: read 140000000 lines
# 	@ Wed Apr  1 21:20:09 2015: read 150000000 lines
# 	@ Wed Apr  1 21:23:09 2015: read 160000000 lines
# 	@ Wed Apr  1 21:25:45 2015: read 170000000 lines
# 	@ Wed Apr  1 21:27:48 2015: read 180000000 lines
# @ Wed Apr  1 21:27:56 2015: combining CpG methylation from both strands ...
# @ Wed Apr  1 21:28:27 2015: writing 3165_BRISCOE/aligned.adapters.q30.m0.methratio_CpGcombined ...
# @ Wed Apr  1 21:38:26 2015: done.
# total 52165463 valid mappings, 37935320 covered cytosines, average coverage: 25.14 fold.
# ================================================================
# ===== Make versions of methratio.py results with only CpGs =====
# ================================================================
# ========================================================================
# ==================== Working on 3581_LYNLEY ====================
# ========================================================================
# 
# BSMAP v2.74
# Start at:  Wed Apr  1 21:40:53 2015
# 
# Input reference file: /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta 	(format: FASTA)
# Load in 8001 db seqs, total size 831411547 bp. 15 secs passed
# total_kmers: 43046721
# Create seed table. 55 secs passed
# max number of mismatches: read_length * 8% 	max gap size: 0
# kmer cut-off ratio: 5e-07
# max multi-hits: 100	max Ns: 5	seed size: 16	index interval: 4
# quality cutoff: 30	base quality char: '!'
# min fragment size:0	max fragemt size:500
# start from read #1	end at read #4294967295
# additional alignment: T in reads => C in reference
# mapping strand (read_1): ++,-+
# mapping strand (read_2): +-,--
# adapter sequence1: GAGCCGTAAGGACGACTTGG
# adapter sequence2: ACACTCTTTCCCTACACGAC
# Pair-end alignment(4 threads)
# Input read file #1: 3581_LYNLEY/reads_1.fastq.gz 	(format: gzipped FASTQ)
# Input read file #2: 3581_LYNLEY/reads_2.fastq.gz 	(format: gzipped FASTQ)
# Output file: 3581_LYNLEY/aligned.adapters.q30.m0.sam	 (format: SAM)
# Thread #2: 	50000 read pairs finished. 108 secs passed
# Thread #1: 	100000 read pairs finished. 109 secs passed
# Thread #0: 	150000 read pairs finished. 111 secs passed
# Thread #3: 	200000 read pairs finished. 112 secs passed
# Thread #2: 	250000 read pairs finished. 162 secs passed
# Thread #1: 	300000 read pairs finished. 163 secs passed
# Thread #0: 	350000 read pairs finished. 165 secs passed
# Thread #3: 	400000 read pairs finished. 166 secs passed
# Thread #2: 	450000 read pairs finished. 216 secs passed
# Thread #1: 	500000 read pairs finished. 217 secs passed
# .
# .
# .
# Thread #0: 	123614639 read pairs finished. 33445 secs passed
# Thread #3: 	123550000 read pairs finished. 33448 secs passed
# Thread #1: 	123600000 read pairs finished. 33455 secs passed
# Total number of aligned reads: 
# pairs:       69412082 (56%)
# single a:    15706169 (13%)
# single b:    15508751 (13%)
# Done.
# Finished at Thu Apr  2 06:58:28 2015
# Total time consumed:  33455 secs
# ================================================================
# ===== Converting sam file to sorted bam and creating index =====
# ================================================================
# [bam_header_read] EOF marker is absent. The input is probably truncated.
# [samopen] SAM header is present: 8001 sequences.
# [bam_sort_core] merging from 70 files...
# ==============================================
# ===== Running methratio.py, no -g option =====
# ==============================================
# @ Thu Apr  2 08:42:16 2015: reading reference /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta ...
# @ Thu Apr  2 08:42:50 2015: reading 3581_LYNLEY/aligned.adapters.q30.m0.bam ...
# 	@ Thu Apr  2 08:47:27 2015: read 10000000 lines
# 	@ Thu Apr  2 08:52:02 2015: read 20000000 lines
# 	@ Thu Apr  2 08:56:19 2015: read 30000000 lines
# 	@ Thu Apr  2 09:00:45 2015: read 40000000 lines
# 	@ Thu Apr  2 09:05:14 2015: read 50000000 lines
# 	@ Thu Apr  2 09:09:17 2015: read 60000000 lines
# 	@ Thu Apr  2 09:13:32 2015: read 70000000 lines
# 	@ Thu Apr  2 09:17:48 2015: read 80000000 lines
# 	@ Thu Apr  2 09:21:38 2015: read 90000000 lines
# 	@ Thu Apr  2 09:25:47 2015: read 100000000 lines
# 	@ Thu Apr  2 09:29:21 2015: read 110000000 lines
# 	@ Thu Apr  2 09:33:12 2015: read 120000000 lines
# 	@ Thu Apr  2 09:36:58 2015: read 130000000 lines
# 	@ Thu Apr  2 09:40:22 2015: read 140000000 lines
# 	@ Thu Apr  2 09:43:23 2015: read 150000000 lines
# 	@ Thu Apr  2 09:46:02 2015: read 160000000 lines
# 	@ Thu Apr  2 09:48:05 2015: read 170000000 lines
# @ Thu Apr  2 09:48:05 2015: writing 3581_LYNLEY/aligned.adapters.q30.m0.methratio ...
# @ Thu Apr  2 09:57:55 2015: done.
# total 49494050 valid mappings, 36829278 covered cytosines, average coverage: 24.46 fold.
# ===============================================
# ===== Running methratio.py, yes -g option =====
# ===============================================
# @ Thu Apr  2 09:57:59 2015: reading reference /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta ...
# @ Thu Apr  2 09:58:35 2015: reading 3581_LYNLEY/aligned.adapters.q30.m0.bam ...
# 	@ Thu Apr  2 10:03:12 2015: read 10000000 lines
# 	@ Thu Apr  2 10:07:48 2015: read 20000000 lines
# 	@ Thu Apr  2 10:12:04 2015: read 30000000 lines
# 	@ Thu Apr  2 10:16:32 2015: read 40000000 lines
# 	@ Thu Apr  2 10:21:01 2015: read 50000000 lines
# 	@ Thu Apr  2 10:25:04 2015: read 60000000 lines
# 	@ Thu Apr  2 10:29:20 2015: read 70000000 lines
# 	@ Thu Apr  2 10:33:36 2015: read 80000000 lines
# 	@ Thu Apr  2 10:37:27 2015: read 90000000 lines
# 	@ Thu Apr  2 10:41:36 2015: read 100000000 lines
# 	@ Thu Apr  2 10:45:11 2015: read 110000000 lines
# 	@ Thu Apr  2 10:49:02 2015: read 120000000 lines
# 	@ Thu Apr  2 10:52:48 2015: read 130000000 lines
# 	@ Thu Apr  2 10:56:13 2015: read 140000000 lines
# 	@ Thu Apr  2 10:59:14 2015: read 150000000 lines
# 	@ Thu Apr  2 11:01:55 2015: read 160000000 lines
# 	@ Thu Apr  2 11:03:57 2015: read 170000000 lines
# @ Thu Apr  2 11:03:58 2015: combining CpG methylation from both strands ...
# @ Thu Apr  2 11:04:29 2015: writing 3581_LYNLEY/aligned.adapters.q30.m0.methratio_CpGcombined ...
# @ Thu Apr  2 11:14:12 2015: done. 
# total 49494050 valid mappings, 36129397 covered cytosines, average coverage: 24.98 fold.
# ================================================================
# ===== Make versions of methratio.py results with only CpGs =====
# ================================================================
# ========================================================================
# ==================== Working on 3677_MONK ====================
# ========================================================================
# 
# BSMAP v2.74
# Start at:  Thu Apr  2 11:16:25 2015
# 
# Input reference file: /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta 	(format: FASTA)
# Load in 8001 db seqs, total size 831411547 bp. 15 secs passed
# total_kmers: 43046721
# Create seed table. 53 secs passed
# max number of mismatches: read_length * 8% 	max gap size: 0
# kmer cut-off ratio: 5e-07
# max multi-hits: 100	max Ns: 5	seed size: 16	index interval: 4
# quality cutoff: 30	base quality char: '!'
# min fragment size:0	max fragemt size:500
# start from read #1	end at read #4294967295
# additional alignment: T in reads => C in reference
# mapping strand (read_1): ++,-+
# mapping strand (read_2): +-,--
# adapter sequence1: GAGCCGTAAGGACGACTTGG
# adapter sequence2: ACACTCTTTCCCTACACGAC
# Pair-end alignment(4 threads)
# Input read file #1: 3677_MONK/reads_1.fastq.gz 	(format: gzipped FASTQ)
# Input read file #2: 3677_MONK/reads_2.fastq.gz 	(format: gzipped FASTQ)
# Output file: 3677_MONK/aligned.adapters.q30.m0.sam	 (format: SAM)
# Thread #0: 	50000 read pairs finished. 104 secs passed
# Thread #1: 	100000 read pairs finished. 105 secs passed
# Thread #3: 	150000 read pairs finished. 106 secs passed
# Thread #2: 	200000 read pairs finished. 108 secs passed
# Thread #0: 	250000 read pairs finished. 156 secs passed
# Thread #1: 	300000 read pairs finished. 158 secs passed
# Thread #3: 	350000 read pairs finished. 159 secs passed
# Thread #2: 	400000 read pairs finished. 161 secs passed
# Thread #0: 	450000 read pairs finished. 208 secs passed
# Thread #1: 	500000 read pairs finished. 211 secs passed
# .
# .
# .
# Thread #2: 	122350000 read pairs finished. 32850 secs passed
# Thread #0: 	122400000 read pairs finished. 32851 secs passed
# Thread #3: 	122414964 read pairs finished. 32853 secs passed
# Total number of aligned reads: 
# pairs:       67690673 (55%)
# single a:    14989198 (12%)
# single b:    15060882 (12%)
# Done.
# Finished at Thu Apr  2 20:23:58 2015
# Total time consumed:  32853 secs
# ================================================================
# ===== Converting sam file to sorted bam and creating index =====
# ================================================================
# [bam_header_read] EOF marker is absent. The input is probably truncated.
# [samopen] SAM header is present: 8001 sequences.
# [bam_sort_core] merging from 68 files...
# ==============================================
# ===== Running methratio.py, no -g option =====
# ==============================================
# @ Fri Apr  3 00:21:37 2015: reading reference /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta ...
# @ Fri Apr  3 00:22:12 2015: reading 3677_MONK/aligned.adapters.q30.m0.bam ...
# 	@ Fri Apr  3 00:26:53 2015: read 10000000 lines
# 	@ Fri Apr  3 00:31:36 2015: read 20000000 lines
# 	@ Fri Apr  3 00:36:02 2015: read 30000000 lines
# 	@ Fri Apr  3 00:40:36 2015: read 40000000 lines
# 	@ Fri Apr  3 00:45:01 2015: read 50000000 lines
# 	@ Fri Apr  3 00:49:20 2015: read 60000000 lines
# 	@ Fri Apr  3 00:53:44 2015: read 70000000 lines
# 	@ Fri Apr  3 00:57:57 2015: read 80000000 lines
# 	@ Fri Apr  3 01:02:03 2015: read 90000000 lines
# 	@ Fri Apr  3 01:06:13 2015: read 100000000 lines
# 	@ Fri Apr  3 01:09:56 2015: read 110000000 lines
# 	@ Fri Apr  3 01:13:58 2015: read 120000000 lines
# 	@ Fri Apr  3 01:17:54 2015: read 130000000 lines
# 	@ Fri Apr  3 01:21:11 2015: read 140000000 lines
# 	@ Fri Apr  3 01:24:11 2015: read 150000000 lines
# 	@ Fri Apr  3 01:26:44 2015: read 160000000 lines
# @ Fri Apr  3 01:27:51 2015: writing 3677_MONK/aligned.adapters.q30.m0.methratio ...
# @ Fri Apr  3 01:37:56 2015: done.
# total 49912436 valid mappings, 37218408 covered cytosines, average coverage: 24.38 fold.
# ===============================================
# ===== Running methratio.py, yes -g option =====
# ===============================================
# @ Fri Apr  3 01:37:59 2015: reading reference /Users/burtonigenomics/Documents/H_burtoni_v1.assembly.fasta ...
# @ Fri Apr  3 01:38:35 2015: reading 3677_MONK/aligned.adapters.q30.m0.bam ...
# 	@ Fri Apr  3 01:43:17 2015: read 10000000 lines
# 	@ Fri Apr  3 01:48:00 2015: read 20000000 lines
# 	@ Fri Apr  3 01:52:27 2015: read 30000000 lines
# 	@ Fri Apr  3 01:57:01 2015: read 40000000 lines
# 	@ Fri Apr  3 02:01:27 2015: read 50000000 lines
# 	@ Fri Apr  3 02:05:46 2015: read 60000000 lines
# 	@ Fri Apr  3 02:10:11 2015: read 70000000 lines
# 	@ Fri Apr  3 02:14:25 2015: read 80000000 lines
# 	@ Fri Apr  3 02:18:30 2015: read 90000000 lines
# 	@ Fri Apr  3 02:22:42 2015: read 100000000 lines
# 	@ Fri Apr  3 02:26:25 2015: read 110000000 lines
# 	@ Fri Apr  3 02:30:28 2015: read 120000000 lines
# 	@ Fri Apr  3 02:34:25 2015: read 130000000 lines
# 	@ Fri Apr  3 02:37:42 2015: read 140000000 lines
# 	@ Fri Apr  3 02:40:43 2015: read 150000000 lines
# 	@ Fri Apr  3 02:43:15 2015: read 160000000 lines
# @ Fri Apr  3 02:44:22 2015: combining CpG methylation from both strands ...
# @ Fri Apr  3 02:44:53 2015: writing 3677_MONK/aligned.adapters.q30.m0.methratio_CpGcombined ...
# @ Fri Apr  3 02:54:42 2015: done.
# total 49912436 valid mappings, 36523889 covered cytosines, average coverage: 24.89 fold.
# ================================================================
# ===== Make versions of methratio.py results with only CpGs =====
# ================================================================
