ls | grep noCDS$ | \
awk '{print "echo "$1"; sort -k6,6 -k9,9 -k10,10 "$1" | bedtools groupby -g 6,9,10 -c 4,4,5,5,5,5,5,4 -o count,count_distinct,min,max,mean,median,stdev,freqdesc > "$1".groupby_6_9_10"}' | bash

ls | grep intron.hit$ | \
awk '{print "echo "$1"; sort -k6,6 -k9,9 -k10,10 "$1" | bedtools groupby -g 6,9,10 -c 4,4,5,5,5,5,5,4 -o count,count_distinct,min,max,mean,median,stdev,freqdesc > "$1".groupby_6_9_10"}' | bash