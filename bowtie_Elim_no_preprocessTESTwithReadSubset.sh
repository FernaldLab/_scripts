SUBJECTS="AGTCAA CCGTCC CTTGTA GCCAAT GTGAAA"

for s in $SUBJECTS
do
	bowtie2 -q --phred33 --end-to-end -p 4 --fr --no-unal --met-file "metrics_"$s".txt" -x /Users/burtonigenomics/Documents/_Burtoni_genome_files/H_burtoni_v1.assembly \
	-1 "L2_"$s"_L002_R1_001.fastq.gz_first100reads.fastq" -2 "L2_"$s"_L002_R2_001.fastq.gz_first100reads.fastq" \
	2> "test"$s".err" \
	| samtools view -bS - | samtools sort - "aligned_"$s"_first100_sorted"
	#samtools index "aligned_"$s"_sorted.bam"
	#samtools flagstat "aligned_"$s"_sorted.bam" > "aligned_"$s"_sorted.bam_flagstat"
	#echo "Unique reads: " >> "aligned_"$s"_sorted.bam_flagstat"
	#samtools view "aligned_"$s"_sorted.bam" | cut -f1 | sort | uniq | wc -l >> "aligned_"$s"_sorted.bam_flagstat"
	#java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/CollectMultipleMetrics.jar INPUT="aligned_"$s"_sorted.bam" OUTPUT="aligned_"$s"_sorted.bam_"
done

