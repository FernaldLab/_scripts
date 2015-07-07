SUBJECTS="AGTCAA CCGTCC CTTGTA GCCAAT GTGAAA"

for s in $SUBJECTS
do
	echo "----------------  Working on "$s" ----------------"
	cutadapt -O 3 -e0.1 --too-short-output=$s"_shortReadsWithAdapter_1" \
	-a "AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC"$s"ATCTCGTATGCCGTCTTCTGCTTG" -m 50 --paired-output "tmp.2.fastq" \
	-o "tmp.1.fastq" "L2_"$s"_L002_R1_001.fastq.gz" "L2_"$s"_L002_R2_001.fastq.gz"
	
	cutadapt -O 3 -e0.1 --too-short-output=$s"_shortReadsWithAdapter_2" \
	-a AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT -m 50 --paired-output "L2_"$s"_L002_R1_001.trimmedAdapters.fastq" \
	-o "L2_"$s"_L002_R2_001.trimmedAdapters.fastq" "tmp.2.fastq" "tmp.1.fastq"
done

for s in $SUBJECTS
do
	echo "----------------  Working on "$s" ----------------"
	bowtie2 -q --phred33 --end-to-end -p 4 --fr --no-unal --met-file "aligned_"$s"_metrics.txt" -x /Users/burtonigenomics/Documents/_Burtoni_genome_files/H_burtoni_v1.assembly \
	-1 "L2_"$s"_L002_R1_001.trimmedAdapters.fastq" -2 "L2_"$s"_L002_R2_001.trimmedAdapters.fastq" \
	| samtools view -bS - | samtools sort - "aligned_"$s"_cutadapt_sorted"
	samtools index "aligned_"$s"_cutadapt_sorted.bam"
done