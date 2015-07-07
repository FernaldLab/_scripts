#!/bin/bash

# $1 is output from parseBestHitBlastxResultsWithComments.py

fastaFile="Drer_Olat_Onil_Trub_ENS_pep.fa"
topHitsFile=$1
tmpFile="tmpOut0"
outFile=$fastaFile"_ForReciprocal_"$topHitsFile

echo "" > $tmpFile
ids=`cut -f3 $topHitsFile | sort | uniq`
echo -e "Getting IDs from:\n  "$1
for ID in $ids
do
	awk 'BEGIN{RS=">"}/'"$ID"'/{print ">"$0}' $fastaFile >> $tmpFile
done
echo "Writing output..."
echo "  "$outFile
awk 'NF!=0' $tmpFile > $outFile
rm $tmpFile