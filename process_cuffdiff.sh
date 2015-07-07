# process cuffdiff output 

ls | awk '{print "echo "$1"; awk '\''END{print NR}'\'' "$1""}' | bash

awk 'BEGIN{FS="\t"}$14=="yes"' gene_exp.diff > gene_exp.diff.sig
awk 'BEGIN{FS="\t"}$14=="yes"' isoform_exp.diff > isoform_exp.diff.sig

awk 'BEGIN{FS="\t"}{split($4,a,":"); split(a[2],aa,"-"); print ""a[1]"\t"aa[1]"\t"aa[2]"\t"$1"\t"$8"\t"$9"\t"$12"\t"$13""}' gene_exp.diff.sig > gene_exp.diff.sig.bed

# compare overlap with previous cuffdiff run
awk 'BEGIN{FS="\t"} {print $4}' gene_exp.diff.sig.bed > blahnew
comm blahnew /Volumes/handsfiler\$/FishStudies/_LYNLEY_RNAseq/cuffdiff/blahd > overlap
awk 'BEGIN{FS="\t"}NF==3{print $3}' overlap > genes.both

#awk 'BEGIN{FS="\t"}NF==1{print ""$1"\tnew"}NF==2{print ""$2"\told"}NF==3{print ""$3"\tboth"}' overlap > overlap2
#awk 'BEGIN{old=0;new=0;both=0} $2=="new"{new++} $2=="old"{old++} $2=="both"{both++} END{print new, old, both}' overlap2

awk '$12<.001' gene_exp.diff > gene_exp.diff.001
awk 'BEGIN{FS="\t"}{split($4,a,":"); split(a[2],aa,"-"); print ""a[1]"\t"aa[1]"\t"aa[2]"\t"$1"\t"$8"\t"$9"\t"$12"\t"$13""}' gene_exp.diff.001 > gene_exp.diff.001.bed




#### get annotations

awk 'BEGIN{FS="\t"} FNR==NR {a[$1]=$0;next} $1 in a {print a[$1]"\t"$0}' gene_exp.diff.sig ../../_Burtoni_annotations/geneNamesTree_AB_noNONE > gene_exp.diff.sig.GeneNames
awk 'BEGIN{FS="\t"} FNR==NR {a[$1]=$0;next} $1 in a {print $0}' gene_exp.diff.sig ../../_Burtoni_annotations/geneNamesTree_AB_noNONE > gene_exp.diff.sig.GeneNamesOnly
awk 'BEGIN{FS="\t"} FNR==NR {a[$1]=$0; next} !($1 in a) {print $0}' ../../_Burtoni_annotations/geneNamesTree_AB_noNONE gene_exp.diff.sig > gene_exp.diff.sig.NoGeneNames