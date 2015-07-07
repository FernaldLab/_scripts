SUBJECTS="AGTCAA CCGTCC CTTGTA"

for s in $SUBJECTS
do
	bowtie2 -q --phred33 --end-to-end -p 4 --fr --no-unal --met-file "metrics_"$s".txt" -x /Users/burtonigenomics/Documents/_Burtoni_genome_files/H_burtoni_v1.assembly \
	-1 "L2_"$s"_L002_R1_001.fastq.gz" -2 "L2_"$s"_L002_R2_001.fastq.gz" \
	| samtools view -bS - | samtools sort - "aligned_"$s"_sorted"
done

samtools view -bS aligned_GCCAAT.sam | samtools sort - aligned_GCCAAT_sorted
