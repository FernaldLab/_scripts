#cd ~/Documents/_Fernald_lab/_methylation/

#ls | awk '{print "wig2bed < "$0" > "$0".bed"}'

ls | grep bed$ | awk '{print "awk '\''{print $1 \"\\t\" int($2)-1 \"\\t\" int($3)+1 \"\\t\" $4 \"\\t\" $5}'\'' "$0" > "$0"INT.bed"}'

ls | grep INT | awk '{print "fastaFrombed -tab -fi ../H_burtoni_v1.assembly.fa -bed "$0" -fo "$0".nuc"}'
