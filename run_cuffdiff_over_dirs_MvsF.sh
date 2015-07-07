#!/bin/bash

GTF="/Users/burtonigenomics/Documents/_Burtoni_annotations/Astatotilapia_burtoni.BROADAB2.gtf"
RGFILE="/Users/burtonigenomics/Documents/_Elim_data/readGroups.txt"
OUTDIR="./cuffdiff"

echo -e "\n"===================================================================================
echo "Using gtf file:" 
echo -e $GTF"\n"
echo "Using read groups file:" 
echo -e $RGFILE"\n"
echo "Output will write to:" 
echo $OUTDIR

MALE=""
FEMALE=""
for DIR in "$@"
do
	FILES=`ls "$DIR"/*RG.DD.bam`
	for f in $FILES
	do 
		#echo $f
		index=`echo $f | awk '{split($1,a,"/"); split(a[2],aa,"_"); print aa[1]}'`
		info=`grep -E $DIR.*$index $RGFILE`
		cond=`echo $info | awk '{print $5}'`
		if [[ $cond == "D" || $cond == "ND" || $cond == "ASC" ]]; then
			MALE=$MALE","$f
		else
			FEMALE=$FEMALE","$f
		fi
	done
done
mkdir $OUTDIR
MALE=${MALE:1}
FEMALE=${FEMALE:1}
echo -e ==================================================================================="\n"
echo -e "Files for males:\n"$MALE
echo
echo -e "Files for females:\n"$MALE
echo
echo "Running cuffdiff..."
cuffdiff --library-type fr-firststrand -o ./cuffdiff -p 4 $GTF $MALE $FEMALE