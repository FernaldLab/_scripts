
awk 'BEGIN{FS="\t";SCAFFOLDID="scaffold_9"}$3==SCAFFOLDID&&int($4)<30&&$6~/^[0-9]M[0-9]+I/' ~/Desktop/Katrina/bowtie2/TGACCAFilter/alignments.sam
awk 'BEGIN{FS="\t";SCAFFOLDID="scaffold_9"}$3==SCAFFOLDID&&int($4)<30&&$6~/^[0-9]M[0-9]+I/' ~/Desktop/Katrina/bowtie2/TGACCAFilter/alignments.sam > ~/Desktop/Katrina/bowtie2/TGACCAFilter/scaff9earlyinsertions.sam
cat ~/Desktop/Katrina/bowtie2/TGACCAFilter/scaff9earlyinsertions.sam | sort -k4 | cut -f4,6,10 | uniq -c > ~/Desktop/Katrina/bowtie2/TGACCAFilter/scaff9earlyinsertions.condensed.txt
open -a TextEdit.app ~/Desktop/Katrina/bowtie2/TGACCAFilter/scaff9earlyinsertions.condensed.txt 


awk 'BEGIN{FS="\t";SCAFFOLDID="scaffold_9"}$3==SCAFFOLDID&&int($4)>168&&$6~/[0-9]+I[0-9]M$/' ~/Desktop/Katrina/bowtie2/TGACCAFilter/alignments.sam | sort -k4 | cut -f4,6,10 | uniq -c > ~/Desktop/Katrina/bowtie2/TGACCAFilter/scaff9lateinsertions.condensed.txt
open -a TextEdit.app ~/Desktop/Katrina/bowtie2/TGACCAFilter/scaff9lateinsertions.condensed.txt

awk 'BEGIN{FS="\t";SCAFFOLDID="scaffold_236"}$3==SCAFFOLDID&&int($4)<30&&$6~/^[0-9]M[0-9]+I/' ~/Desktop/Katrina/bowtie2/TGACCAFilter/alignments.sam | sort -k4 | cut -f4,6,10 | uniq -c > ~/Desktop/Katrina/bowtie2/TGACCAFilter/scaff236earlyinsertions.condensed.txt
open -a TextEdit.app ~/Desktop/Katrina/bowtie2/TGACCAFilter/scaff9lateinsertions.condensed.txt 

awk 'BEGIN{FS="\t";SCAFFOLDID="scaffold_83"}$3==SCAFFOLDID&&int($4)>168&&$6~/[0-9]+I[0-9]M$/' ~/Desktop/Katrina/bowtie2/TGACCAFilter/alignments.sam | sort -k4 | cut -f4,6,10 | uniq -c > ~/Desktop/Katrina/bowtie2/TGACCAFilter/scaff83lateinsertions.condensed.txt
awk 'BEGIN{FS="\t";SCAFFOLDID="scaffold_236"}$3==SCAFFOLDID&&int($4)>233&&$6~/[0-9]+I[0-9]M$/' ~/Desktop/Katrina/bowtie2/TGACCAFilter/alignments.sam | sort -k4 | cut -f4,6,10 | uniq -c > ~/Desktop/Katrina/bowtie2/TGACCAFilter/scaff236lateinsertions.condensed.txt

awk 'BEGIN{FS="\t";SCAFFOLDID="scaffold_236"}$3==SCAFFOLDID&&int($4)>100&&int($4)<200&&$6~/[0-9]+I[0-9]M$/' ~/Desktop/Katrina/bowtie2/TGACCAFilter/alignments.sam | sort -k4 | cut -f4,6,10 | uniq -c > ~/Desktop/Katrina/bowtie2/TGACCAFilter/scaff236_1lateinsertions.condensed.txt
awk 'BEGIN{FS="\t";SCAFFOLDID="scaffold_236"}$3==SCAFFOLDID&&int($4)<240&&int($4)>190&&$6~/^[0-9]M[0-9]+I/' ~/Desktop/Katrina/bowtie2/TGACCAFilter/alignments.sam | sort -k4 | cut -f4,6,10 | uniq -c > ~/Desktop/Katrina/bowtie2/TGACCAFilter/scaff236_2earlyinsertions.condensed.txt

awk 'BEGIN{FS="\t";SCAFFOLDID="scaffold_236"}$3==SCAFFOLDID&&int($4)<211&&int($4)>160' ~/Desktop/Katrina/bowtie2/TGACCAFilter/alignments.sam | sort -k4 | cut -f4,6,10 | uniq -c > ~/Desktop/Katrina/bowtie2/TGACCAFilter/scaff236_2earlyinsertions.condensed.txt
awk 'BEGIN{FS="\t";SCAFFOLDID="scaffold_236"}$3==SCAFFOLDID&&int($4)>105&&int($4)<170' ~/Desktop/Katrina/bowtie2/TGACCAFilter/alignments.sam | sort -k4 | cut -f4,6,10 | uniq -c > ~/Desktop/Katrina/bowtie2/TGACCAFilter/scaff236_1lateinsertions.condensed.txt


 awk 'BEGIN{FS="\t";SCAFFOLDID="scaffold_83"}$3==SCAFFOLDID&&int($4)>168&&$6~/[0-9]+I[0-9]M$/' | sort -k4 | cut -f4,6,10 | uniq -c > scaff83lateinsertions.condensed.txt
 
 awk 'BEGIN{FS="\t";SCAFFOLDID="scaffold_236"}$3==SCAFFOLDID&&int($4)>119&&int($4)<170' | sort -k4 | cut -f4,6,10 | uniq -c > scaff236_1lateinsertions.condensed.txt


awk 'BEGIN{FS="\t";SCAFFOLDID="scaffold_236"}$3==SCAFFOLDID&&int($4)>320&&$6~/[0-9]+I[0-9]M$/' | sort -k4 | cut -f4,6,10 | uniq -c > scaff236lateinsertions.condensed.txt




mv ~/Desktop/Katrina/Astatotilapia_burtoni.r* storage/RibosomeGTFs_etc/
mv ~/Desktop/Katrina/Astatotilapia_burtoni.BROADAB2fix.noexons.gtf.* storage/RibosomeGTFs_etc/


