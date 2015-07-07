### This script was ran from within the dir that contained the raw unprocessed fastq.gz files
### It aligned to the Burtoni genome with bowtie2 and piped results through samtools to create a sorted bam file for each animal
### The results were moved into the current dir with this script, /Volumes/fishstudies-1/_Elim_RNAseq/alignments/bowtie2/no_preprocess
### Another copy of this script is in the normal scripts dir, /Volumes/fishstudies/_scripts

SUBJECTS="AGTCAA CCGTCC CTTGTA GCCAAT GTGAAA"

for s in $SUBJECTS
do
	echo "Aligning and sorting "$s" into bam file..."
	bowtie2 -q --phred33 --end-to-end -p 4 --fr --no-unal --met-file "metrics_"$s".txt" -x /Users/burtonigenomics/Documents/_Burtoni_genome_files/H_burtoni_v1.assembly \
	-1 "L2_"$s"_L002_R1_001.fastq.gz" -2 "L2_"$s"_L002_R2_001.fastq.gz" \
	2> "aligned_"$s"_summary.txt" \
	| samtools view -bS - | samtools sort - "aligned_"$s"_sorted"
	echo "  Making bam index, getting metrics from flagstat and picard"
	samtools index "aligned_"$s"_sorted.bam"
	samtools flagstat "aligned_"$s"_sorted.bam" > "aligned_"$s"_sorted.bam_flagstat"
	echo "Unique reads: " >> "aligned_"$s"_sorted.bam_flagstat"
	samtools view "aligned_"$s"_sorted.bam" | cut -f1 | sort | uniq | wc -l >> "aligned_"$s"_sorted.bam_flagstat"
	java -Xmx2g -jar ~/Documents/picard-tools-1.101/picard-tools-1.101/CollectMultipleMetrics.jar INPUT="aligned_"$s"_sorted.bam" OUTPUT="aligned_"$s"_sorted.bam_"
done

