#!/bin/bash

SUBJECTS=`ls L2* | awk '{split($1,a,"_");print a[2]}' | uniq`
for s in $SUBJECTS
do
	case $s in
		ACAGTG) echo $s;;
		AGTCAA) echo $s;;
	esac
done

 
	
	
