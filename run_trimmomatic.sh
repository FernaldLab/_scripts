SUBJECTS="AGTCAA CCGTCC CTTGTA GCCAAT GTGAAA"

for s in $SUBJECTS
do
	echo "Working on "$s"..."
	java -jar ~/Documents/Trimmomatic-0.32/trimmomatic-0.32.jar PE \
	"L2_"$s"_L002_R1_001.fastq.gz" "L2_"$s"_L002_R2_001.fastq.gz" \
	"fwdpaired_L2_"$s"_L002_R1_001.fastq.gz" "fwdunpaired_L2_"$s"_L002_R1_001.fastq.gz" \
	"fwdpaired_L2_"$s"_L002_R2_001.fastq.gz" "fwdunpaired_L2_"$s"_L002_R2_001.fastq.gz" \
	ILLUMINACLIP:/Users/burtonigenomics/Documents/Trimmomatic-0.32/adapters/TruSeq3-PE-2.fa:2:30:10:8:TRUE \
	LEADING:30 TRAILING:30 SLIDINGWINDOW:4:30 HEADCROP:20 MINLEN:50 AVGQUAL:30
done


