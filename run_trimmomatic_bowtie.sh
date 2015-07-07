SUBJECTS="AGTCAA CCGTCC CTTGTA GCCAAT GTGAAA"

for s in $SUBJECTS
do
	echo "Working on "$s"..."
	java -jar ~/Documents/Trimmomatic-0.32/trimmomatic-0.32.jar PE \
	"L2_"$s"_L002_R1_001.fastq.gz" "L2_"$s"_L002_R2_001.fastq.gz" \
	"trimmomatic/fwdpaired_L2_"$s"_L002_R1_001.fastq.gz" "trimmomatic/fwdunpaired_L2_"$s"_L002_R1_001.fastq.gz" \
	"trimmomatic/fwdpaired_L2_"$s"_L002_R2_001.fastq.gz" "trimmomatic/fwdunpaired_L2_"$s"_L002_R2_001.fastq.gz" \
	ILLUMINACLIP:/Users/burtonigenomics/Documents/Trimmomatic-0.32/adapters/TruSeq3-PE.fa:2:30:10:8:TRUE \
	LEADING:30 TRAILING:30 SLIDINGWINDOW:4:30 HEADCROP:5 MINLEN:50 AVGQUAL:30
done

for s in $SUBJECTS
do
	bowtie2 -q --phred33 --end-to-end -p 4 --fr --no-unal --met-file "trimmomatic/fwdpaired_metrics_"$s".txt" -x /Users/burtonigenomics/Documents/_Burtoni_genome_files/H_burtoni_v1.assembly \
	-1 "trimmomatic/fwdpaired_L2_"$s"_L002_R1_001.fastq.gz" -2 "trimmomatic/fwdpaired_L2_"$s"_L002_R2_001.fastq.gz" \
	| samtools view -bS - | samtools sort - "trimmomatic/fwdpaired_aligned_"$s"_sorted"
	samtools index "trimmomatic/fwdpaired_aligned_"$s"_sorted.bam"  
done

