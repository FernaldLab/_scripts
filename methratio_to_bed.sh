#!/bin/bash

# input files must be output from bsmap methratio.py script

echo "Writing..."
for f in "$@"
do
	echo "  "$f".bed"
	awk '/^scaffold/ {print $1"\t"int($2)-1"\t"$2"\t.\t"$5}' $f > $f".bed"
done