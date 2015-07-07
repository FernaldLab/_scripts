# don't write output to server, too slow

ls | grep wig.bed$ | \
while read stdin; \
do echo $stdin; \
sort -k1,1 -k2,2n $stdin | \
bedtools cluster -d 0 \
> ${stdin}".cluster_d0"; done

ls | grep wig.bed$ | \
while read stdin; \
do echo $stdin; \
sort -k1,1 -k2,2n $stdin | \
bedtools cluster -d 10 \
> ${stdin}".cluster_d10"; done