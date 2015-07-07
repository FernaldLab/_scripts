#!/bin/bash

awk 'BEGIN{FS="\t"} {
	 split($9, a, ";"); 
	 split(a[1], utr, "="); 
	 split(a[2], mrna, "=");
	 split(mrna[2], gene, ".")
	 split(utr[2], utr_num, ".")
	 for (i=1; i<=8; i++) {
	 	printf($i"\t")
	 }
	 printf ("gene_id \"ab.gene."gene[3]"."gene[4]"\"; transcript_id \""mrna[2]"\"; utr_number \""utr_num[6]"\";\n")
} ' $1