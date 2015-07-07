SUBJECTS="AGTCAA CCGTCC CTTGTA GCCAAT GTGAAA"
# assume in ~/Documents/_Elim_data/_data
for s in $SUBJECTS
do
	echo "----------------  Working on "$s" ----------------"
	tophat2 --library-type fr-firststrand -o "tophat_post-cutadapt_O3.e0.1.m50/"$s \
	-r 0 -p 4 -G ~/Documents/_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf \
	~/Documents/_Burtoni_genome_files/H_burtoni_v1.assembly \
	"L2_"$s"_L002_R1_001.trimmedAdapters.fastq" "L2_"$s"_L002_R2_001.trimmedAdapters.fastq"
done

for s in $SUBJECTS
do
	echo "----------------  Working on "$s" ----------------"
	tophat2 --library-type fr-firststrand -o "tophat_no_preprocess/"$s \
	-r 0 -p 4 -G ~/Documents/_Burtoni_annotations/Astatotilapia_burtoni.BROADcombo.gtf \
	~/Documents/_Burtoni_genome_files/H_burtoni_v1.assembly \
	"L2_"$s"_L002_R1_001.fastq.gz" "L2_"$s"_L002_R2_001.fastq.gz"
done

