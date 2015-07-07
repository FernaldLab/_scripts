#!/bin/bash

echo "FLAG"
samtools view $1 | cut -f2 | sort | uniq -c | sort -k1,1n
echo "MAPQ"
samtools view $1 | cut -f5 | sort | uniq -c | sort -k1,1n
echo "RNEXT"
samtools view $1 | cut -f7 | sort | uniq -c | sort -k1,1n
echo "TAG"
samtools view $1 | cut -f13 | sort | uniq -c | sort -k1,1n