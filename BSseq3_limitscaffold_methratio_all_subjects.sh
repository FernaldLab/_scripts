#!/bin/bash

cd ~/Documents/_BSeq_data
SUBJECTS="3157_TENNISON 3165_BRISCOE 3581_LYNLEY 3677_MONK"
for s in $SUBJECTS
do 
	echo "==================================================================="
	echo "==================== Working on "$s" ===================="
	echo "==================================================================="
	echo ""
	FILES=`ls $s | grep "methratio.CG.clean$"`
	echo "============= files to limit:"
	echo $FILES
	echo "============="
	for f in $FILES
	do
		echo "===== Writing..."
		/Volumes/fishstudies/_scripts/methratio_limit_scaffold.py $s"/"$f $1
	done
done